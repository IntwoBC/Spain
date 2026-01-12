report 70099 "Trans. Bank Rec. to Gen. Origi"
{
    // #MyTaxi.W1.EDD.AR01.001 01/02/2017 CCFR.SDE : MyTaxi CRM Interface
    //   Report Creation
    // #MyTaxi.W1.CRE.AR01.001 31/05/2017 CCFR.SDE : MyTaxi CRM Interface
    //   Map account imported from statement file to NAV G/L Account
    // #MyTaxi.W1.CRE.AR02.002 04/07/2017 CCFR.SDE : MyTaxi CRM Interface
    //   Apply statement line to sales invoice posted using General Journals (opening balance entries)
    // #MyTaxi.W1.CRE.AR01.003 06/07/2017 CCFR.SDE : MyTaxi CRM Interface
    //   Apply statement line to payment entries

    Caption = 'Trans. Bank Rec. to Gen. Jnl. - MyTaxi';
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = SORTING("Bank Account No.", "Statement No.") WHERE("Statement Type" = CONST("Bank Reconciliation"));
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."), "Statement No." = FIELD("Statement No.");
                DataItemTableView = SORTING("Bank Account No.", "Statement No.", "Statement Line No.");

                trigger OnAfterGetRecord()
                var
                    NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
                    SourceCodeSetup: Record "Source Code Setup";
                begin
                    // if (Difference = 0) or (Type > Type::"Bank Account Ledger Entry") then
                    CurrReport.Skip();

                    GenJnlLine.Init();
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine.Validate("Posting Date", "Transaction Date");
                    SourceCodeSetup.Get();
                    GenJnlLine."Source Code" := SourceCodeSetup."Trans. Bank Rec. to Gen. Jnl.";
                    if GenJnlBatch."No. Series" <> '' then
                        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(
                            GenJnlBatch."No. Series", "Transaction Date", false)
                    else
                        GenJnlLine."Document No." := "Document No.";
                    GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    GenJnlLine."External Document No." := "Bank Acc. Reconciliation Line"."Document No.";
                    // MyTaxi.W1.CRE.AR01.001 <<
                    if ("Bank Acc. Reconciliation Line"."Transaction Text" <> '') and
                    (StrLen("Bank Acc. Reconciliation Line"."Transaction Text") <= MaxStrLen(CorporateGLAccount."Local G/L Account No.")) then
                        if CorporateGLAccount.Get("Bank Acc. Reconciliation Line"."Transaction Text") then begin
                            GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::"G/L Account");
                            GenJnlLine.Validate(GenJnlLine."Account No.", CorporateGLAccount."Local G/L Account No.");
                        end;
                    // MyTaxi.W1.CRE.AR01.001 >>
                    if "Bank Acc. Reconciliation Line"."Document No." <> '' then
                        if SalesInvoiceHeader.Get("Bank Acc. Reconciliation Line"."Document No.") then begin
                            GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Customer);
                            GenJnlLine.Validate(GenJnlLine."Account No.", SalesInvoiceHeader."Bill-to Customer No.");
                            CustLedgerEntry.Reset();
                            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Payment);
                            CustLedgerEntry.SetRange("External Document No.", "Bank Acc. Reconciliation Line"."Document No.");
                            CustLedgerEntry.SetRange(Open, true);
                            if CustLedgerEntry.FindFirst() then begin
                                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Payment);
                                GenJnlLine.Validate("Applies-to Doc. No.", CustLedgerEntry."Document No.");
                            end;
                            if Difference > 0 then
                                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                            else
                                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                        end
                        // MyTaxi.W1.CRE.AR01.002 <<
                        else begin
                            CustLedgerEntry.Reset();
                            // MyTaxi.W1.CRE.AR01.003 <<
                            //CustLedgerEntry.SETFILTER("Document Type",'%1|%2',CustLedgerEntry."Document Type"::" ",CustLedgerEntry."Document Type"::Invoice);
                            CustLedgerEntry.SetFilter("Document Type", '%1|%2|%3', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::Payment);
                            // MyTaxi.W1.CRE.AR01.003 >>
                            CustLedgerEntry.SetRange("External Document No.", "Bank Acc. Reconciliation Line"."Document No.");
                            CustLedgerEntry.SetRange(Open, true);
                            if CustLedgerEntry.FindFirst() then begin
                                GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Customer);
                                GenJnlLine.Validate(GenJnlLine."Account No.", CustLedgerEntry."Customer No.");
                                GenJnlLine.Validate("Applies-to Doc. Type", CustLedgerEntry."Document Type");
                                GenJnlLine.Validate("Applies-to Doc. No.", CustLedgerEntry."Document No.");
                                if Difference > 0 then
                                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                                else
                                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                            end;
                        end;
                    // MyTaxi.W1.CRE.AR01.002 >>
                    if GenJnlBatch."Bal. Account No." <> '' then begin
                        GenJnlLine.Validate("Bal. Account Type", GenJnlBatch."Bal. Account Type");
                        GenJnlLine.Validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
                    end else begin
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.Validate("Bal. Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                    end;

                    GenJnlLine.Validate(Amount, -Difference);
                    GenJnlLine.Description := Description;
                    GenJnlLine.Insert();
                end;

                trigger OnPreDataItem()
                begin
                    GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                    GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                    GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
                    if GenJnlBatch.Name <> '' then
                        GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name)
                    else
                        GenJnlLine.SetRange("Journal Batch Name", '');

                    GenJnlLine.LockTable();
                    if GenJnlLine.FindLast() then;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetRange("Statement Type", BankAccRecon."Statement Type");
                SetRange("Bank Account No.", BankAccRecon."Bank Account No.");
                SetRange("Statement No.", BankAccRecon."Statement No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
                    field("GenJnlLine.""Journal Batch Name"""; GenJnlLine."Journal Batch Name")
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

    labels
    {
    }

    trigger OnPostReport()
    begin
        GenJnlManagement.TemplateSelectionFromBatch(GenJnlBatch);
    end;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        GenJnlManagement: Codeunit GenJnlManagement;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CorporateGLAccount: Record "Corporate G/L Account";


    procedure SetBankAccRecon(var UseBankAccRecon: Record "Bank Acc. Reconciliation")
    begin
        BankAccRecon := UseBankAccRecon;
    end;


    procedure InitializeRequest(GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10])
    begin
        GenJnlLine."Journal Template Name" := GenJnlTemplateName;
        GenJnlLine."Journal Batch Name" := GenJnlBatchName;
    end;
}

