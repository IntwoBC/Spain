xmlport 50003 "Sales - Yooz File - Import"
{
    // SUP:Ticket:#121664  09/05/2021  COSMO.ABT
    //    # Create the XMLport to import "Sales - Yooz File - Import".

    Caption = 'Sales - Yooz File - Import';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            MinOccurs = Zero;
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                AutoSave = true;
                XmlName = 'PurchaseJournal';
                textelement(Doc_type)
                {
                }
                textelement(Document_Type)
                {
                    MinOccurs = Zero;
                    Width = 120;

                    trigger OnAfterAssignVariable()
                    begin
                        if Document_Type = 'Invoice' then
                            "Gen. Journal Line"."Document Type" := "Gen. Journal Line"."Document Type"::Invoice
                        else
                            "Gen. Journal Line"."Document Type" := "Gen. Journal Line"."Document Type"::"Credit Memo";
                    end;
                }
                textelement(Custom_3)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Posting_Date)
                {
                    MinOccurs = Zero;
                }
                textelement(External_Doc_No)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        "Gen. Journal Line"."External Document No." := CopyStr(External_Doc_No, 1, 35);
                    end;
                }
                textelement(Due_Date)
                {
                    MinOccurs = Zero;
                }
                textelement(Custom_7)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_8)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_9)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Currency)
                {
                    MinOccurs = Zero;
                }
                textelement(Custom_11)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_12)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_13)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Total_amount)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Payment_term; "Gen. Journal Line"."Payment Terms Code")
                {
                    MinOccurs = Zero;
                }
                textelement(IBAN)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Bank_Account)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_18)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Description_Line)
                {
                    MinOccurs = Zero;
                    Width = 120;

                    trigger OnAfterAssignVariable()
                    begin
                        "Gen. Journal Line".Description := CopyStr(Description_Line, 1, 50);
                    end;
                }
                textelement(Custom_20)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Sales_order_no)
                {
                    MinOccurs = Zero;
                    Width = 120;

                    trigger OnAfterAssignVariable()
                    begin
                        "Gen. Journal Line"."Sales Order No." := CopyStr(Sales_order_no, 1, 50);
                    end;
                }
                textelement(Custom_22)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_23)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_24)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Payment_Method)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_26)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_27)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_28)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_29)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_30)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_31)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_32)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_33)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_34)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_35)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                fieldelement(URL; "Gen. Journal Line".URL)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Document_date)
                {
                    MinOccurs = Zero;
                }
                textelement(Account_Type)
                {
                    MinOccurs = Zero;
                }
                textelement(Account_No)
                {
                    MinOccurs = Zero;
                }
                textelement(Custom_40)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_41)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_42)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_43)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Debit_amount)
                {
                    MinOccurs = Zero;
                    Width = 120;

                    trigger OnAfterAssignVariable()
                    begin
                        if Debit_amount <> '' then
                            Evaluate("Gen. Journal Line"."Debit Amount", Debit_amount);
                    end;
                }
                textelement(Credit_amount)
                {
                    MinOccurs = Zero;
                    Width = 120;

                    trigger OnAfterAssignVariable()
                    begin
                        if Credit_amount <> '' then
                            Evaluate("Gen. Journal Line"."Credit Amount", Credit_amount);
                    end;
                }
                textelement(VAT_Prod_Posting_Group)
                {
                    MinOccurs = Zero;
                }
                textelement(VAT_Bus_Posting_Group)
                {
                    MinOccurs = Zero;
                }
                textelement(Custom_48)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_49)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Cost_center)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        "Gen. Journal Line"."Shortcut Dimension 2 Code" := Cost_center;
                    end;
                }
                textelement(Custom_51)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_52)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_53)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_54)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_55)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_56)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_57)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_58)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_59)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_60)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_61)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_62)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_63)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_64)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_65)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_66)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                textelement(Custom_67)
                {
                    MinOccurs = Zero;
                    Width = 120;
                }
                fieldelement(Email; "Gen. Journal Line"."E-Mail")
                {
                    MinOccurs = Zero;
                    Width = 120;
                }

                trigger OnAfterInsertRecord()
                begin
                    Commit();
                end;

                trigger OnBeforeInsertRecord()
                begin
                    NextLineNo += 10000;

                    "Gen. Journal Line"."Journal Template Name" := GenJnlLine."Journal Template Name";
                    "Gen. Journal Line"."Journal Batch Name" := GenJnlLine."Journal Batch Name";

                    if PreviousInvoiceNo = '' then begin
                        "Gen. Journal Line"."Document No." := DocumentNo;
                        PreviousInvoiceNo := External_Doc_No;
                    end else begin
                        if PreviousInvoiceNo <> External_Doc_No then begin
                            "Gen. Journal Line"."Document No." := IncStr(DocumentNo);
                            DocumentNo := "Gen. Journal Line"."Document No.";
                            PreviousInvoiceNo := External_Doc_No;
                        end else begin
                            "Gen. Journal Line"."Document No." := DocumentNo;
                        end;
                    end;

                    "Gen. Journal Line"."Line No." := NextLineNo;

                    if Document_Type = 'Invoice' then
                        "Gen. Journal Line"."Document Type" := "Gen. Journal Line"."Document Type"::Invoice
                    else
                        "Gen. Journal Line"."Document Type" := "Gen. Journal Line"."Document Type"::"Credit Memo";

                    "Gen. Journal Line"."Source Code" := GenJnlTemplate."Source Code";
                    "Gen. Journal Line"."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    "Gen. Journal Line".Validate("Posting Date", WorkDate());
                    if Account_No <> '' then begin
                        "Gen. Journal Line"."Account Type" := "Gen. Journal Line"."Account Type"::Customer;
                        "Gen. Journal Line".Validate("Account No.", Account_No);

                        if Debit_amount <> '' then begin
                            Evaluate(TempAmount, Debit_amount);
                            "Gen. Journal Line".Validate("Debit Amount", TempAmount);
                        end else begin
                            Evaluate(TempAmount, Credit_amount);
                            "Gen. Journal Line".Validate("Credit Amount", TempAmount);
                        end;

                    end else begin
                        if GLAccount.Get(Account_Type) then
                            "Gen. Journal Line"."Account Type" := "Gen. Journal Line"."Account Type"::"G/L Account"
                        else
                            "Gen. Journal Line"."Account Type" := "Gen. Journal Line"."Account Type"::"Fixed Asset";

                        "Gen. Journal Line".Validate("Account No.", Account_Type);

                        if Debit_amount <> '' then begin
                            Evaluate(TempAmount, Debit_amount);
                            "Gen. Journal Line".Validate("Debit Amount", TempAmount);
                        end else begin
                            Evaluate(TempAmount, Credit_amount);
                            "Gen. Journal Line".Validate("Credit Amount", TempAmount);
                        end;

                        "Gen. Journal Line"."Gen. Posting Type" := "Gen. Journal Line"."Gen. Posting Type"::Sale;
                    end;

                    "Gen. Journal Line".Validate("VAT Bus. Posting Group", VAT_Bus_Posting_Group);
                    // "Gen. Journal Line".Validate("VAT Prod. Posting Group", VAT_Prod_Posting_Group);

                    if VATPostSetup.Get("Gen. Journal Line"."VAT Bus. Posting Group", "Gen. Journal Line"."VAT Prod. Posting Group") then
                        "Gen. Journal Line".Validate("VAT %", VATPostSetup."VAT+EC %");

                    Evaluate(Year, CopyStr(Due_Date, 7, 4));
                    Evaluate(Month, CopyStr(Due_Date, 1, 2));
                    Evaluate(Day, CopyStr(Due_Date, 4, 2));
                    "Gen. Journal Line"."Due Date" := DMY2Date(Day, Month, Year);

                    Evaluate(Year, CopyStr(Document_date, 7, 4));
                    Evaluate(Month, CopyStr(Document_date, 1, 2));
                    Evaluate(Day, CopyStr(Document_date, 4, 2));
                    "Gen. Journal Line"."Document Date" := DMY2Date(Day, Month, Year);

                    "Gen. Journal Line".Validate("Shortcut Dimension 2 Code", Cost_center);

                    if IBAN <> '' then
                        "Gen. Journal Line"."IBAN / Bank Account" := IBAN
                    else
                        "Gen. Journal Line"."IBAN / Bank Account" := Bank_Account;

                    "Gen. Journal Line".Validate("Currency Code", Currency);

                    "Gen. Journal Line"."Payment Method Code" := Payment_Method;
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

    trigger OnPostXmlPort()
    begin
        Message(Text001);
    end;

    trigger OnPreXmlPort()
    begin
        GenJnlLine.TestField("Journal Template Name");
        GenJnlLine.TestField("Journal Batch Name");
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");

        Commit();
        DocumentNo := GetDocumentNo();

        TempAmount := 0;
        PreviousInvoiceNo := '';

        NextLineNo := 0;
        FirstLine := true;
    end;

    var
        NextLineNo: Integer;
        TemplateName: Code[10];
        BatchName: Code[10];
        Day: Integer;
        Month: Integer;
        Year: Integer;
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        Text001: Label 'File successfully imported.';
        FirstLine: Boolean;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
        DocumentNo: Code[20];
        Increment: Integer;
        VATPostSetup: Record "VAT Posting Setup";
        TempAmount: Decimal;
        PreviousInvoiceNo: Text[50];

    local procedure GetDocumentNo(): Code[20]
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        GenJnlBatch.TestField("No. Series");
        if GenJnlBatch."No. Series" <> '' then begin
            Clear(NoSeriesMgt);
            //FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
            //Previous it was TryGetNextNo and replaced by GetNextNo
            exit(NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WorkDate()));
        end;
        exit('');
    end;
}

