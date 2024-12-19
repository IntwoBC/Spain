xmlport 60010 "TE Import Tool"
{
    // YA 12/02/2018
    // Creation TE import tool

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            MinOccurs = Zero;
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                AutoSave = true;
                XmlName = 'Pchjnl';
                textelement(Accounting_Date)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(Day, CopyStr(Accounting_Date, 1, 2));
                        Evaluate(Month, CopyStr(Accounting_Date, 4, 2));
                        Evaluate(Year, CopyStr(Accounting_Date, 7, 4));
                        "Gen. Journal Line"."Posting Date" := DMY2Date(Day, Month, Year);
                    end;
                }
                fieldelement(Document_number; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(External_reference_number; "Gen. Journal Line"."External Document No.")
                {
                }
                textelement(GenPostType)
                {
                }
                fieldelement(AccType; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement(AccNo; "Gen. Journal Line"."Account No.")
                {
                }
                textelement(Description)
                {
                }
                textelement(Cost_Center)
                {
                }
                textelement(Cost_Center2)
                {
                }
                textelement(Cost_Objective)
                {
                }
                fieldelement(Currency; "Gen. Journal Line"."Currency Code")
                {
                }
                textelement(Amount)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(Amount, DelChr(Format(Amount), '=', '.'));
                        Evaluate("Gen. Journal Line".Amount, ConvertStr(Format(Amount), ',', tDecimal));
                    end;
                }
                fieldelement(VATBusiness; "Gen. Journal Line"."VAT Bus. Posting Group")
                {
                }
                fieldelement(VATProduct; "Gen. Journal Line"."VAT Prod. Posting Group")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    NextLineNo += 10000;
                    "Gen. Journal Line"."Journal Template Name" := GenJnlLine."Journal Template Name";
                    "Gen. Journal Line"."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                    "Gen. Journal Line"."Line No." := NextLineNo;
                    "Gen. Journal Line"."Source Code" := GenJnlTemplate."Source Code";
                    "Gen. Journal Line"."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    "Gen. Journal Line"."Document Type" := "Gen. Journal Line"."Document Type"::Invoice;
                    "Gen. Journal Line".Validate(Description, Description);

                    if Cost_Center <> '' then begin
                        DimensionValueCode := Cost_Center;
                        "Gen. Journal Line".Validate("Shortcut Dimension 2 Code", DimensionValueCode);
                    end;
                    if Cost_Center2 <> '' then begin
                        DimensionValueCode := Cost_Center2;
                        "Gen. Journal Line".ValidateShortcutDimCode(4, DimensionValueCode);
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    ShowCaption = false;
                    field("GenJnlLine.""Journal Template Name"""; GenJnlLine."Journal Template Name")
                    {
                        Caption = 'Gen. Journal Template';
                        NotBlank = true;
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Template field.';
                    }
                    field("<Control1>"; GenJnlLine."Journal Batch Name")
                    {
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        NotBlank = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Batch field.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(2);
                            GenJnlBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(0);
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            if GenJnlBatch.Find('=><') then;
                            if PAGE.RunModal(0, GenJnlBatch) = ACTION::LookupOK then begin
                                Text := GenJnlBatch.Name;
                                exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        if StrPos(Format(tDecimal), '.') <> 0 then
            tDecimal := '.'
        else
            tDecimal := '.';
    end;

    trigger OnPostXmlPort()
    begin
        Message('Successfully imported!');
    end;

    trigger OnPreXmlPort()
    begin
        GenJnlLine.TestField("Journal Template Name");
        GenJnlLine.TestField("Journal Batch Name");
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
    end;

    var
        NextLineNo: Integer;
        TemplateName: Code[10];
        BatchName: Code[10];
        Day: Integer;
        Month: Integer;
        Year: Integer;
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DimensionValueCode: Code[20];
        tDecimal: Text;
        vDecimal: Text;
}

