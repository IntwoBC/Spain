report 70001 "Match Bank Entries MyTaxi"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Report creation

    Caption = 'Match Bank Entries';
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm,
                  TableData "Bank Account Ledger Entry" = rm,
                  TableData "Check Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = SORTING("Statement Date");
            RequestFilterFields = "Statement No.", "Bank Account No.";

            trigger OnAfterGetRecord()
            begin
                LineCountReconLine := 0;
                Window.Update(1, "Statement No.");
                Window.Update(2, 0);
                Window.Update(3, 0);
                //MatchBankRecLinesMyTaxi.MatchSingle("Bank Acc. Reconciliation",DateRange);
                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Statement Type", "Bank Acc. Reconciliation"."Statement Type");
                BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                BankAccReconciliationLine.SetRange("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                NoOfRecordsReconLine := BankAccReconciliationLine.Count;
                if BankAccReconciliationLine.FindSet() then
                    repeat
                        bBankLedgerFound := false;
                        LineCountReconLine += 1;
                        Window.Update(2, Round(LineCountReconLine / NoOfRecordsReconLine * 10000, 1));
                        BankAccReconciliationLine2.Reset();
                        BankAccReconciliationLine2.SetRange("Statement Type", "Bank Acc. Reconciliation"."Statement Type");
                        BankAccReconciliationLine2.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                        BankAccReconciliationLine2.SetFilter("Statement No.", '<>%1', "Bank Acc. Reconciliation"."Statement No.");
                        BankAccReconciliationLine2.SetRange("Document No.", BankAccReconciliationLine."Document No.");
                        BankAccReconciliationLine2.SetRange("Transaction Date", BankAccReconciliationLine."Transaction Date");
                        BankAccReconciliationLine2.SetRange(Description, BankAccReconciliationLine.Description);
                        BankAccReconciliationLine2.SetRange("Statement Amount", BankAccReconciliationLine."Statement Amount");
                        BankAccReconciliationLine2.SetFilter("Bank Acc. Ledg. Entry No.", '<>0');
                        if BankAccReconciliationLine2.FindFirst() then begin
                            BankAccReconciliationLine."Journal Template Name" := 'STATEMENT' + BankAccReconciliationLine."Statement No.";
                            BankAccReconciliationLine.Modify();
                            CurrReport.Skip();
                        end;
                        BankAccountLedgerEntry.Reset();
                        BankAccountLedgerEntry.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                        BankAccountLedgerEntry.SetRange("Posting Date", CalcDate('<-' + Format(DateRange) + 'D>', BankAccReconciliationLine."Transaction Date"),
                                                                      CalcDate('<+' + Format(DateRange) + 'D>', BankAccReconciliationLine."Transaction Date"));
                        //BankAccountLedgerEntry.SETFILTER("Statement No.",'<>%1','');
                        //BankAccountLedgerEntry.SETFILTER("Statement Line No.",'<>%1',0);
                        BankAccountLedgerEntry.SetRange(Description, BankAccReconciliationLine.Description);
                        BankAccountLedgerEntry.SetRange(Amount, BankAccReconciliationLine."Statement Amount");
                        if BankAccountLedgerEntry.FindFirst() then
                            bBankLedgerFound := true
                        else
                            if BankAccReconciliationLine."Document No." <> '' then begin
                                BankAccountLedgerEntry.SetRange(Description);
                                BankAccountLedgerEntry.SetRange("External Document No.", BankAccReconciliationLine."Document No.");
                                if (BankAccountLedgerEntry.Count = 1) and BankAccountLedgerEntry.FindFirst() then
                                    bBankLedgerFound := true
                                else begin
                                    BankAccountLedgerEntry.SetRange("External Document No.");
                                    if BankAccountLedgerEntry.FindFirst() then
                                        bBankLedgerFound := true
                                end;
                            end
                            else begin
                                BankAccountLedgerEntry.SetRange(Description);
                                if BankAccountLedgerEntry.FindFirst() then
                                    bBankLedgerFound := true
                            end;
                        if bBankLedgerFound then begin
                            BankAccReconciliationLine."Bank Acc. Ledg. Entry No." := BankAccountLedgerEntry."Entry No.";
                            BankAccReconciliationLine."Bal. Account Type" := BankAccountLedgerEntry."Bal. Account Type";
                            BankAccReconciliationLine."Bal. Account No." := BankAccountLedgerEntry."Bal. Account No.";
                            if (BankAccReconciliationLine."Bal. Account Type" <> BankAccountLedgerEntry."Bal. Account Type"::"G/L Account") or
                              ((BankAccReconciliationLine."Bal. Account Type" = BankAccountLedgerEntry."Bal. Account Type"::"G/L Account") and (BankAccReconciliationLine."Bal. Account No." <> GLAccount."No.")) then
                                BankAccReconciliationLine.Matched := true;
                            BankAccReconciliationLine.Modify();
                            ApplyEntries(BankAccReconciliationLine, BankAccountLedgerEntry, 0);
                        end;
                    until BankAccReconciliationLine.Next() = 0;

                LineCountReconLine := 0;
                Clear(DocNoArray);
                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Statement Type", "Bank Acc. Reconciliation"."Statement Type");
                BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                BankAccReconciliationLine.SetRange("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                BankAccReconciliationLine.SetRange("Bal. Account Type", BankAccReconciliationLine."Bal. Account Type"::"G/L Account");
                BankAccReconciliationLine.SetFilter("Bal. Account No.", '%1|%2', '', GLAccount."No.");
                NoOfRecordsReconLine := BankAccReconciliationLine.Count;
                // if BankAccReconciliationLine.FindSet then
                //     repeat
                //         Clear(DocNoArray);
                //         MasterDataId := 0;
                //         BankAccountNo := '';
                //         InvoiceNumber := '';
                //         LineCountReconLine += 1;
                //         Window.Update(3, Round(LineCountReconLine / NoOfRecordsReconLine * 10000, 1));
                //         DataExchField.Reset;
                //         DataExchField.SetRange("Data Exch. No.", BankAccReconciliationLine."Data Exch. Entry No.");
                //         DataExchField.SetRange("Line No.", BankAccReconciliationLine."Data Exch. Line No.");
                //         if DataExchField.FindSet then
                //             repeat
                //                 //MESSAGE('here 1 '+FORMAT(i)+' '+BankAccReconciliationLine.Description);
                //                 Clear(Match);
                //                 i := 1;
                //                 bStopMatching := false;
                //                 //IF BankAccReconciliationLine."Document No."='831-098112, EMMANUEL' THEN
                //                 //MESSAGE(BankAccReconciliationLine."Document No.");
                //                 //MESSAGE('here 1.0 '+FORMAT(i)+' '+DataExchField.Value);
                //                 Match := RegEx.Match(DataExchField.Value, '[0-9]{3}-[0-9]{6}');
                //                 //MESSAGE('here 1.1 '+FORMAT(i)+' '+DataExchField.Value);
                //                 if Match.Success then begin
                //                     //MESSAGE('here 1.2 '+FORMAT(i)+' '+DataExchField.Value);
                //                     //IF BankAccReconciliationLine."Document No."='831-098112, EMMANUEL' THEN
                //                     //MESSAGE('1 : '+Match.Value);
                //                     //BankAccReconciliationLine."Document No." := Match.Value;
                //                     //MESSAGE('here 2.0'+FORMAT(i)+' '+Match.Value);
                //                     DocNoArray[i] := Match.Value;
                //                     //MESSAGE('here 2'+FORMAT(i)+' '+BankAccReconciliationLine.Description);
                //                 end;
                //                 //MESSAGE('here 3 '+FORMAT(i)+' '+DataExchField.Value);
                //                 while (not bStopMatching) do begin
                //                     Match := Match.NextMatch;
                //                     bStopMatching := not Match.Success;
                //                     //MESSAGE('here 3.00 '+FORMAT(i)+' '+DocNoArray[i]);
                //                     if Match.Success and (Match.Value <> DocNoArray[i]) then begin
                //                         i += 1;
                //                         //MESSAGE('here 3.0'+FORMAT(i)+' '+Match.Value);
                //                         //BankAccReconciliationLine."Document No." := '';
                //                         //DocNoArray[i] := Match.Value;
                //                         //MESSAGE('here 3'+FORMAT(i)+' '+BankAccReconciliationLine.Description);
                //                     end;
                //                 end;
                //                 //MESSAGE('here 4'+FORMAT(i)+' '+BankAccReconciliationLine.Description);
                //                 Clear(Match);
                //                 Match := RegEx.Match(DataExchField.Value, '[VWZ\+]([0-9]+)\-');
                //                 if Match.Success then
                //                     if Evaluate(MasterDataId, CopyStr(Match.Value, StrPos(Match.Value, '+') + 1, StrLen(Match.Value) - 2)) then;
                //                 if DataExchField."Column No." in [32, 33] then
                //                     BankAccountNo += DataExchField.Value;
                //IF DataExchField."Column No."=19 THEN
                //InvoiceNumber := COPYSTR(DataExchField.Value,1,MAXSTRLEN(InvoiceNumber));
                //         until DataExchField.Next = 0;
                //     if i = 1 then
                //         if (DocNoArray[i] = '') then
                //             DocNoArray[i] := BankAccReconciliationLine."Document No.";

                //     BankAccReconciliationLine."Related-Party Bank Acc. No." := BankAccountNo;
                //     BankAccReconciliationLine.Modify;
                //     TransferFromGLToCust(BankAccReconciliationLine);
                // until BankAccReconciliationLine.Next = 0;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(MatchingMsg);
                BankAccountLedgerEntry.SetCurrentKey("Bank Account No.", "Posting Date");
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
                group(Control3)
                {
                    ShowCaption = false;
                    field(DateRange; DateRange)
                    {
                        BlankZero = true;
                        Caption = 'Transaction Date Tolerance (Days)';
                        MinValue = 0;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Transaction Date Tolerance (Days) field.';
                    }
                    field("GLAccount.""No."""; GLAccount."No.")
                    {
                        Caption = 'Transit G/L Account No.';
                        TableRelation = "G/L Account";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Transit G/L Account No. field.';
                    }
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Posting Date field.';
                    }
                }
                group("Reverse Matched Statement Lines")
                {
                    Caption = 'Reverse Matched Statement Lines';
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
                group("Reverse Nonmatched Statement Lines")
                {
                    Caption = 'Reverse Nonmatched Statement Lines';
                    field("GenJnlLine2.""Journal Template Name"""; GenJnlLine2."Journal Template Name")
                    {
                        Caption = 'Gen. Journal Template';
                        NotBlank = true;
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Template field.';
                    }
                    field("GenJnlLine2.""Journal Batch Name"""; GenJnlLine2."Journal Batch Name")
                    {
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        NotBlank = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Batch field.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine2.TestField("Journal Template Name");
                            GenJnlTemplate2.Get(GenJnlLine2."Journal Template Name");
                            GenJnlBatch2.FilterGroup(2);
                            GenJnlBatch2.SetRange("Journal Template Name", GenJnlLine2."Journal Template Name");
                            GenJnlBatch2.FilterGroup(0);
                            GenJnlBatch2.Name := GenJnlLine2."Journal Batch Name";
                            if GenJnlBatch2.Find('=><') then;
                            if PAGE.RunModal(0, GenJnlBatch2) = ACTION::LookupOK then begin
                                Text := GenJnlBatch2.Name;
                                exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            GenJnlLine2.TestField("Journal Template Name");
                            GenJnlBatch2.Get(GenJnlLine2."Journal Template Name", GenJnlLine2."Journal Batch Name");
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DateRange := 3;
        end;

        trigger OnOpenPage()
        begin
            DateRange := 3;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Journal Template Name", GenJnlBatch."Journal Template Name");
        if GenJnlBatch.Name <> '' then
            GenJnlLine.SetRange("Journal Batch Name", GenJnlBatch.Name)
        else
            GenJnlLine.SetRange("Journal Batch Name", '');

        MatchedNextLineNo := 10000;
        GenJnlLine.LockTable();
        if GenJnlLine.FindLast() then
            MatchedNextLineNo := GenJnlLine."Line No." + 10000;

        GenJnlBatch2.Get(GenJnlLine2."Journal Template Name", GenJnlLine2."Journal Batch Name");
        GenJnlLine2.SetRange("Journal Template Name", GenJnlBatch2."Journal Template Name");
        if GenJnlBatch2.Name <> '' then
            GenJnlLine2.SetRange("Journal Batch Name", GenJnlBatch2.Name)
        else
            GenJnlLine2.SetRange("Journal Batch Name", '');

        NonmatchedNextLineNo := 10000;
        if GenJnlLine2.FindLast() then
            NonmatchedNextLineNo := GenJnlLine2."Line No." + 10000;
        ApplymentID := 'APPLY00000001';
    end;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlTemplate2: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlBatch2: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        DataExchField: Record "Data Exch. Field";
        GLAccount: Record "G/L Account";
        MatchBankRecLinesMyTaxi: Codeunit "Match Bank Rec. Lines MyTaxi";
        DateRange: Integer;
        PostingDate: Date;
        SourceCode: Code[10];
        Window: Dialog;
        MatchingMsg: Label 'Statement No.    #1##########\Matching Lines @2@@@@@@@@@@@@@\Reverse Lines @3@@@@@@@@@@@@@', Comment = 'This is a message for dialog window. Parameters do not require translation.';
        LineCountReconLine: Integer;
        NoOfRecordsReconLine: Integer;
        //RegEx: DotNet Regex;
        //Match: DotNet Match;
        DocNoArray: array[100] of Code[20];
        bStopMatching: Boolean;
        i: Integer;
        BankAccountNo: Text;
        MatchedNextLineNo: Integer;
        NonmatchedNextLineNo: Integer;
        InvoiceNumber: Code[20];
        bBankLedgerFound: Boolean;
        MasterDataId: Integer;
        ApplymentID: Code[20];

    local procedure TransferFromGLToCust(var pBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Customer: Record Customer;
        Vendor: Record Vendor;
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        VendorBankAccount: Record "Vendor Bank Account";
        CustomerBankAccount: Record "Customer Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        j: Integer;
        bVendorFound: Boolean;
        bCustomerFound: Boolean;
        bVendorLedgerFound: Boolean;
        RemainingStatementAmtToApply: Decimal;
    begin
        if (pBankAccReconciliationLine."Bank Acc. Ledg. Entry No." = 0) or (pBankAccReconciliationLine."Bal. Account Type" <> pBankAccReconciliationLine."Bal. Account Type"::"G/L Account") then
            exit;
        ApplymentID := IncStr(ApplymentID);
        GenJnlLine.Init();
        GenJnlLine.Validate("Posting Date", PostingDate);
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine."External Document No." := pBankAccReconciliationLine."Document No.";

        // Single Document No. founded on the statement line
        /*IF "Document No."<>'' THEN
          BEGIN
            IF SalesInvoiceHeader.GET("Document No.") THEN
              BEGIN
                GenJnlLine.VALIDATE(GenJnlLine."Account Type",GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE(GenJnlLine."Account No.",SalesInvoiceHeader."Bill-to Customer No.");
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Customer No.",SalesInvoiceHeader."Bill-to Customer No.");
                CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Payment);
                CustLedgerEntry.SETRANGE("External Document No.","Document No.");
                CustLedgerEntry.SETRANGE(Open,TRUE);
                CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");
                IF CustLedgerEntry.FINDFIRST THEN
                  BEGIN
                    IF ABS("Statement Amount")<=ABS(CustLedgerEntry."Remaining Amount") THEN BEGIN
                      GenJnlLine.VALIDATE("Applies-to Doc. Type",GenJnlLine."Applies-to Doc. Type"::Payment);
                      GenJnlLine.VALIDATE("Applies-to Doc. No.",CustLedgerEntry."Document No.");
                    END;
                  END
                ELSE BEGIN
                  CustLedgerEntry.RESET;
                  CustLedgerEntry.SETRANGE("Customer No.",SalesInvoiceHeader."Bill-to Customer No.");
                  CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
                  CustLedgerEntry.SETRANGE("Document No.","Document No.");
                  CustLedgerEntry.SETRANGE(Open,TRUE);
                  CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");
                  IF CustLedgerEntry.FINDFIRST THEN
                  BEGIN
                    IF ABS("Statement Amount")<=ABS(CustLedgerEntry."Remaining Amount") THEN BEGIN
                      GenJnlLine.VALIDATE("Applies-to Doc. Type",GenJnlLine."Applies-to Doc. Type"::Invoice);
                      GenJnlLine.VALIDATE("Applies-to Doc. No.",CustLedgerEntry."Document No.");
                    END;
                  END;
                END;
                IF "Statement Amount">0 THEN
                  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                ELSE
                  GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
              END
            ELSE
              BEGIN
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETFILTER("Document Type",'%1|%2|%3|%4',CustLedgerEntry."Document Type"::" ",CustLedgerEntry."Document Type"::Invoice,CustLedgerEntry."Document Type"::Payment,CustLedgerEntry."Document Type"::"Credit Memo");
                IF "Document No."<>'' THEN
                  CustLedgerEntry.SETRANGE("External Document No.","Document No.");
                CustLedgerEntry.SETRANGE(Open,TRUE);
                CustLedgerEntry.SETFILTER("Applies-to ID",'%1','');
                IF "Statement Amount">0 THEN
                  CustLedgerEntry.SETRANGE(Positive,TRUE)
                ELSE
                  CustLedgerEntry.SETRANGE(Positive,FALSE);
                IF CustLedgerEntry.COUNT>1 THEN
                  CustLedgerEntry.SETRANGE("Remaining Amount","Statement Amount");
                CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");
                IF CustLedgerEntry.FINDFIRST THEN
                  BEGIN
                    GenJnlLine.VALIDATE(GenJnlLine."Account Type",GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.",CustLedgerEntry."Customer No.");
                    IF CustLedgerEntry."Remaining Amount"<>0 THEN BEGIN
                      GenJnlLine.VALIDATE("Applies-to ID",ApplymentID);
                      CustLedgerEntry.VALIDATE("Applies-to ID",ApplymentID);
                      CustLedgerEntry.VALIDATE("Amount to Apply",CustLedgerEntry."Remaining Amount");
                      CustLedgerEntry.MODIFY;
                    END;
                    RemainingStatementAmtToApply :=  "Statement Amount"-CustLedgerEntry."Amount to Apply";
                    CustLedgerEntry.SETRANGE("External Document No.");
                    CustLedgerEntry.SETFILTER("Document Type",'%1|%2',CustLedgerEntry."Document Type"::Invoice,CustLedgerEntry."Document Type"::"Credit Memo");
                    CustLedgerEntry.SETRANGE("Document No.","Document No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                      IF ABS(RemainingStatementAmtToApply)<=ABS(CustLedgerEntry."Remaining Amount") THEN
                        BEGIN
                          GenJnlLine.VALIDATE("Applies-to ID",ApplymentID);
                          CustLedgerEntry.VALIDATE("Applies-to ID",ApplymentID);
                          CustLedgerEntry.VALIDATE("Amount to Apply",RemainingStatementAmtToApply);
                          CustLedgerEntry.MODIFY;
                        END;
                    IF "Statement Amount">0 THEN
                      GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                    ELSE
                      GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                  END
                ELSE
                  BEGIN
                    CustLedgerEntry.SETRANGE("External Document No.");
                    CustLedgerEntry.SETFILTER("Document Type",'%1|%2',CustLedgerEntry."Document Type"::Invoice,CustLedgerEntry."Document Type"::"Credit Memo");
                    CustLedgerEntry.SETRANGE("Document No.","Document No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                      BEGIN
                        GenJnlLine.VALIDATE(GenJnlLine."Account Type",GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.",CustLedgerEntry."Customer No.");
                        IF ABS("Statement Amount")<=ABS(CustLedgerEntry."Remaining Amount") THEN BEGIN
                          GenJnlLine.VALIDATE("Applies-to ID",ApplymentID);
                          CustLedgerEntry.VALIDATE("Applies-to ID",ApplymentID);
                          CustLedgerEntry.VALIDATE("Amount to Apply","Statement Amount");
                          CustLedgerEntry.MODIFY;
                        END;
                        IF "Statement Amount">0 THEN
                          GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                        ELSE
                          GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                      END;
                  END;
              //END;
          END
        // Multiple Document No. founded on the statement line
        ELSE
          BEGIN*/
        if i > 0 then
            for j := 1 to i do begin
                CustLedgerEntry.Reset();
                //CustLedgerEntry.SETFILTER("Document Type",'%1|%2|%3',CustLedgerEntry."Document Type"::" ",CustLedgerEntry."Document Type"::Invoice,CustLedgerEntry."Document Type"::Payment);
                CustLedgerEntry.SetRange("External Document No.", DocNoArray[j]);
                CustLedgerEntry.SetRange(Open, true);
                CustLedgerEntry.SetFilter("Applies-to ID", '%1', '');
                if pBankAccReconciliationLine."Statement Amount" > 0 then
                    CustLedgerEntry.SetRange(Positive, true)
                else
                    CustLedgerEntry.SetRange(Positive, false);
                CustLedgerEntry.SetAutoCalcFields("Remaining Amount");
                if CustLedgerEntry.Count > 1 then
                    CustLedgerEntry.SetRange("Remaining Amount", pBankAccReconciliationLine."Statement Amount");
                if CustLedgerEntry.FindFirst() then begin
                    GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate(GenJnlLine."Account No.", CustLedgerEntry."Customer No.");
                    if Abs(pBankAccReconciliationLine."Statement Amount") <= Abs(CustLedgerEntry."Remaining Amount") then begin
                        if Abs(pBankAccReconciliationLine."Statement Amount") = Abs(CustLedgerEntry."Remaining Amount") then
                            pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::High
                        else
                            pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::Medium;
                        GenJnlLine.Validate("Applies-to ID", ApplymentID);
                        CustLedgerEntry.Validate("Applies-to ID", ApplymentID);
                        CustLedgerEntry.Validate("Amount to Apply", pBankAccReconciliationLine."Statement Amount");
                        CustLedgerEntry.Modify();
                    end;
                    if pBankAccReconciliationLine."Statement Amount" > 0 then
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                    else
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                end
                else begin
                    CustLedgerEntry.SetRange("External Document No.");
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                    CustLedgerEntry.SetRange("Document No.", DocNoArray[j]);
                    if CustLedgerEntry.FindFirst() then begin
                        GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.Validate(GenJnlLine."Account No.", CustLedgerEntry."Customer No.");
                        if Abs(pBankAccReconciliationLine."Statement Amount") <= Abs(CustLedgerEntry."Remaining Amount") then begin
                            if Abs(pBankAccReconciliationLine."Statement Amount") = Abs(CustLedgerEntry."Remaining Amount") then
                                pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::High
                            else
                                pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::Medium;
                            GenJnlLine.Validate("Applies-to ID", ApplymentID);
                            CustLedgerEntry.Validate("Applies-to ID", ApplymentID);
                            CustLedgerEntry.Validate("Amount to Apply", pBankAccReconciliationLine."Statement Amount");
                            CustLedgerEntry.Modify();
                        end;
                        if pBankAccReconciliationLine."Statement Amount" > 0 then
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                        else
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    end;
                end;
            end;
        //END;
        if GenJnlLine."Account No." = '' then begin
            //IF pBankAccReconciliationLine."Related-Party Name"='Nuova Italia 2012. Soc. Coo' THEN
            //MESSAGE('here . '+FORMAT(MasterDataId));
            bVendorFound := false;
            bVendorLedgerFound := false;
            if pBankAccReconciliationLine."Related-Party Name" <> '' then begin
                Vendor.Reset();
                Vendor.SetFilter(Name, '%1', '@*' + pBankAccReconciliationLine."Related-Party Name" + '*');
                if Vendor.FindFirst() then
                    bVendorFound := true
                else begin
                    MyTaxiCRMInterfaceRecords.Reset();
                    MyTaxiCRMInterfaceRecords.SetFilter(name, '%1', '@*' + pBankAccReconciliationLine."Related-Party Name" + '*');
                    if not MyTaxiCRMInterfaceRecords.FindLast() and (MasterDataId <> 0) then begin
                        MyTaxiCRMInterfaceRecords.SetRange(name);
                        MyTaxiCRMInterfaceRecords.SetRange(number, MasterDataId);
                    end;
                    if MyTaxiCRMInterfaceRecords.FindLast() then begin
                        Vendor.SetRange(Name);
                        if MyTaxiCRMInterfaceRecords.orgNo <> '' then begin
                            Vendor.SetFilter("VAT Registration No.", MyTaxiCRMInterfaceRecords.orgNo);
                            if Vendor.FindFirst() then
                                bVendorFound := true
                        end;
                    end;
                end;
            end;
            if not bVendorFound and (pBankAccReconciliationLine."Related-Party Bank Acc. No." <> '') then begin
                Vendor.SetRange(Name);
                VendorBankAccount.Reset();
                VendorBankAccount.SetFilter(IBAN, '%1', '*' + pBankAccReconciliationLine."Related-Party Bank Acc. No." + '*');
                if VendorBankAccount.FindFirst() then begin
                    Vendor.SetRange("No.", VendorBankAccount."Vendor No.");
                    if Vendor.FindFirst() then
                        bVendorFound := true;
                end;
            end;
            if bVendorFound then begin
                GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.Validate(GenJnlLine."Account No.", Vendor."No.");
                if pBankAccReconciliationLine."Statement Amount" < 0 then
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                else
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;

                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Vendor No.", Vendor."No.");
                //VendorLedgerEntry.SETFILTER("Document Type",'%1|%2|%3',VendorLedgerEntry."Document Type"::" ",VendorLedgerEntry."Document Type"::Invoice,VendorLedgerEntry."Document Type"::Payment);
                if pBankAccReconciliationLine."Document No." <> '' then begin
                    VendorLedgerEntry.SetRange("External Document No.", pBankAccReconciliationLine."Document No.");
                    if not VendorLedgerEntry.FindFirst() then
                        VendorLedgerEntry.SetRange("External Document No.", DelChr(pBankAccReconciliationLine."Document No.", '<', '0'));
                end;
                VendorLedgerEntry.SetRange(Open, true);
                VendorLedgerEntry.SetFilter("Applies-to ID", '%1', '');
                if pBankAccReconciliationLine."Statement Amount" > 0 then
                    VendorLedgerEntry.SetRange(Positive, true)
                else
                    VendorLedgerEntry.SetRange(Positive, false);
                VendorLedgerEntry.SetAutoCalcFields("Remaining Amount");
                VendorLedgerEntry.SetRange("Remaining Amount", pBankAccReconciliationLine."Statement Amount" - 1, pBankAccReconciliationLine."Statement Amount" + 1);
                if not VendorLedgerEntry.FindFirst() then
                    VendorLedgerEntry.SetRange("External Document No.");
                if VendorLedgerEntry.FindFirst() then
                    if (Abs(pBankAccReconciliationLine."Statement Amount") <= Abs(VendorLedgerEntry."Remaining Amount")) then//AND
                                                                                                                             //(ABS("Statement Amount")>=ABS(VendorLedgerEntry."Remaining Amount")) THEN
                      begin
                        if Abs(pBankAccReconciliationLine."Statement Amount") = Abs(VendorLedgerEntry."Remaining Amount") then
                            pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::High
                        else
                            pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::Medium;
                        GenJnlLine.Validate("Applies-to ID", ApplymentID);
                        VendorLedgerEntry.Validate("Applies-to ID", ApplymentID);
                        VendorLedgerEntry.Validate("Amount to Apply", pBankAccReconciliationLine."Statement Amount");
                        VendorLedgerEntry.Modify();
                    end;
            end
            else begin
                bCustomerFound := false;
                if pBankAccReconciliationLine."Related-Party Name" <> '' then begin
                    Customer.Reset();
                    Customer.SetFilter(Name, '%1', '@*' + pBankAccReconciliationLine."Related-Party Name" + '*');
                    if Customer.FindFirst() then
                        bCustomerFound := true;
                end;
                if not bCustomerFound and (pBankAccReconciliationLine."Related-Party Bank Acc. No." <> '') then begin
                    Customer.SetRange(Name);
                    CustomerBankAccount.Reset();
                    CustomerBankAccount.SetFilter(IBAN, '%1', '*' + pBankAccReconciliationLine."Related-Party Bank Acc. No." + '*');
                    if CustomerBankAccount.FindFirst() then begin
                        Customer.SetRange("No.", CustomerBankAccount."Customer No.");
                        if Customer.FindFirst() then
                            bCustomerFound := true;
                    end;
                end;
                if bCustomerFound then begin
                    GenJnlLine.Validate(GenJnlLine."Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate(GenJnlLine."Account No.", Customer."No.");
                    if pBankAccReconciliationLine."Statement Amount" > 0 then
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment
                    else
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange("Customer No.", Customer."No.");
                    //CustLedgerEntry.SETFILTER("Document Type",'%1|%2|%3',CustLedgerEntry."Document Type"::" ",CustLedgerEntry."Document Type"::Invoice,CustLedgerEntry."Document Type"::Payment);
                    CustLedgerEntry.SetRange(Open, true);
                    CustLedgerEntry.SetFilter("Applies-to ID", '%1', '');
                    if pBankAccReconciliationLine."Statement Amount" > 0 then
                        CustLedgerEntry.SetRange(Positive, true)
                    else
                        CustLedgerEntry.SetRange(Positive, false);
                    CustLedgerEntry.SetAutoCalcFields("Remaining Amount");
                    if CustLedgerEntry.Count > 1 then
                        CustLedgerEntry.SetRange("Remaining Amount", pBankAccReconciliationLine."Statement Amount");
                    if CustLedgerEntry.FindFirst() then begin
                        if Abs(pBankAccReconciliationLine."Statement Amount") <= Abs(CustLedgerEntry."Remaining Amount") then begin
                            if Abs(pBankAccReconciliationLine."Statement Amount") = Abs(CustLedgerEntry."Remaining Amount") then
                                pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::High
                            else
                                pBankAccReconciliationLine."Applyment Confidence" := pBankAccReconciliationLine."Applyment Confidence"::Low;
                            GenJnlLine.Validate("Applies-to ID", ApplymentID);
                            CustLedgerEntry.Validate("Applies-to ID", ApplymentID);
                            CustLedgerEntry.Validate("Amount to Apply", pBankAccReconciliationLine."Statement Amount");
                            CustLedgerEntry.Modify();
                        end;
                    end;
                end;
            end;
        end;

        GenJnlLine.Validate("Bal. Account Type", pBankAccReconciliationLine."Bal. Account Type");
        GenJnlLine.Validate("Bal. Account No.", pBankAccReconciliationLine."Bal. Account No.");
        GenJnlLine.Validate(Amount, -pBankAccReconciliationLine."Statement Amount");
        GenJnlLine.Description := pBankAccReconciliationLine.Description;
        if GenJnlLine."Account No." = '' then begin
            GenJnlLine."Line No." := NonmatchedNextLineNo;
            NonmatchedNextLineNo += 10000;
            GenJnlLine."Journal Template Name" := GenJnlBatch2."Journal Template Name";
            GenJnlLine."Journal Batch Name" := GenJnlBatch2.Name;
            GenJnlLine."Posting No. Series" := GenJnlBatch2."Posting No. Series";
            if GenJnlBatch2."No. Series" <> '' then
                GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(
                    GenJnlBatch2."No. Series", pBankAccReconciliationLine."Transaction Date", false)
            else
                GenJnlLine."Document No." := pBankAccReconciliationLine."Document No.";
            GenJnlLine.Insert();
        end
        else begin
            GenJnlLine."Line No." := MatchedNextLineNo;
            MatchedNextLineNo += 10000;
            GenJnlLine."Journal Template Name" := GenJnlBatch."Journal Template Name";
            GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
            GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
            if GenJnlBatch."No. Series" <> '' then
                GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(
                    GenJnlBatch."No. Series", pBankAccReconciliationLine."Transaction Date", false)
            else
                GenJnlLine."Document No." := pBankAccReconciliationLine."Document No.";
            GenJnlLine.Insert();
            pBankAccReconciliationLine.Matched := true;
        end;
        pBankAccReconciliationLine."Journal Template Name" := GenJnlLine."Journal Template Name";
        pBankAccReconciliationLine."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        pBankAccReconciliationLine."Line No." := GenJnlLine."Line No.";
        pBankAccReconciliationLine."New Bal. Account Type" := GenJnlLine."Account Type";
        pBankAccReconciliationLine."New Bal. Account No." := GenJnlLine."Account No.";
        pBankAccReconciliationLine.Applied := GenJnlLine.IsApplied();
        pBankAccReconciliationLine.Modify();

    end;


    procedure ApplyEntries(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry"; Relation: Option "One-to-One","One-to-Many"): Boolean
    begin
        if BankAccLedgEntry.IsApplied() then
            exit(false);

        if (Relation = Relation::"One-to-One") and (BankAccReconLine."Applied Entries" > 0) then
            exit(false);

        // if BankAccReconLine.Type <> BankAccReconLine.Type::"Bank Account Ledger Entry" then
        //     exit;
        BankAccReconLine."Ready for Application" := true;
        SetReconNo(BankAccLedgEntry, BankAccReconLine);
        BankAccReconLine."Applied Amount" += BankAccLedgEntry."Remaining Amount";
        BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
        BankAccReconLine.Validate("Statement Amount");
        BankAccReconLine.Modify();
        exit(true);
    end;


    procedure SetReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry"; var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
    var
        CheckLedgEntry: Record "Check Ledger Entry";
    begin
        if BankAccLedgEntry.Open and
          (BankAccLedgEntry."Statement Status" = BankAccLedgEntry."Statement Status"::Open) and
          (BankAccLedgEntry."Statement No." = '') and
          (BankAccLedgEntry."Statement Line No." = 0) and
          (BankAccLedgEntry."Bank Account No." = BankAccReconLine."Bank Account No.") then begin
            BankAccLedgEntry."Statement Status" :=
              BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
            BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
            BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
            BankAccLedgEntry.Modify();
        end;
        CheckLedgEntry.Reset();
        CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
        CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SetRange(Open, true);
        if CheckLedgEntry.Find('-') then
            repeat
                if (CheckLedgEntry."Statement Status" = CheckLedgEntry."Statement Status"::Open) and
                   (CheckLedgEntry."Statement No." = '') and
                   (CheckLedgEntry."Statement Line No." = 0) then begin
                    CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
                    CheckLedgEntry."Statement No." := '';
                    CheckLedgEntry."Statement Line No." := 0;
                    CheckLedgEntry.Modify();
                end;
            until CheckLedgEntry.Next() = 0;
    end;
}

