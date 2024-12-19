xmlport 60011 "Payroll Import Tool Ireland"
{
    // YA 02/02/2018
    // Creation Payroll import tool
    // YA 02/02/2018
    // Skip first line

    Direction = Import;
    //Encoding = UTF16;
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
                XmlName = 'Gljnl';
                textelement(PostingDate)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        Evaluate(Day, CopyStr(PostingDate, 1, 2));
                        Evaluate(Month, CopyStr(PostingDate, 4, 2));
                        Evaluate(Year, CopyStr(PostingDate, 7, 4));
                        "Gen. Journal Line"."Posting Date" := DMY2Date(Day, Month, Year);
                    end;
                }
                fieldelement(DocNo; "Gen. Journal Line"."Document No.")
                {
                    MaxOccurs = Unbounded;
                    MinOccurs = Once;
                }
                fieldelement(DocType; "Gen. Journal Line"."Account Type")
                {
                }
                textelement(AccountNo)
                {
                }
                textelement(Description)
                {
                }
                fieldelement(Amount; "Gen. Journal Line".Amount)
                {
                }
                fieldelement(BalAccType; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                textelement(BalAccNo)
                {
                }
                fieldelement(CostCenter; "Gen. Journal Line"."Shortcut Dimension 2 Code")
                {
                }

                trigger OnAfterInitRecord()
                begin
                    if Firstline then begin
                        Firstline := false;
                        currXMLport.Skip();
                    end
                end;

                trigger OnBeforeInsertRecord()
                begin
                    NextLineNo += 10000;
                    "Gen. Journal Line"."Journal Template Name" := GenJnlLine."Journal Template Name";
                    "Gen. Journal Line"."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                    "Gen. Journal Line"."Line No." := NextLineNo;
                    "Gen. Journal Line"."Source Code" := GenJnlTemplate."Source Code";
                    "Gen. Journal Line"."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    "Gen. Journal Line"."Bal. Account Type" := "Gen. Journal Line"."Bal. Account Type"::"G/L Account";
                    "Gen. Journal Line".Validate("Bal. Account No.", BalAccNo);
                    "Gen. Journal Line"."Account Type" := "Gen. Journal Line"."Account Type"::"G/L Account";
                    "Gen. Journal Line".Validate("Account No.", AccountNo);
                    "Gen. Journal Line".Validate(Description, Description);
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
                group(Options)
                {
                    Caption = 'Options';
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

    trigger OnPostXmlPort()
    begin
        Message('Import Successfully!');
    end;

    trigger OnPreXmlPort()
    begin
        Firstline := true;
        GenJnlLine.TestField("Journal Template Name");
        GenJnlLine.TestField("Journal Batch Name");
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        TemplateName: Code[10];
        BatchName: Code[10];
        Day: Integer;
        Month: Integer;
        Year: Integer;
        Firstline: Boolean;
        vDecimal: Text;
        tDecimal: Text;
        DimensionValueCode: Code[20];
}

