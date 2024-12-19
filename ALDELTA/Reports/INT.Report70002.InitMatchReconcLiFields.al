report 70002 "Init Match Reconc. Li Fields"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Report creation

    Caption = 'Initialize Match Reconciliation Lines Fields';
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
                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Statement Type", "Bank Acc. Reconciliation"."Statement Type");
                BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                BankAccReconciliationLine.SetRange("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                NoOfRecordsReconLine := BankAccReconciliationLine.Count;
                if BankAccReconciliationLine.FindSet() then
                    repeat
                        LineCountReconLine += 1;
                        Window.Update(2, Round(LineCountReconLine / NoOfRecordsReconLine * 10000, 1));
                        BankAccReconciliationLine."Bank Acc. Ledg. Entry No." := 0;
                        BankAccReconciliationLine."Bal. Account Type" := 0;
                        BankAccReconciliationLine."Bal. Account No." := '';
                        BankAccReconciliationLine.Matched := false;
                        BankAccReconciliationLine."Journal Template Name" := '';
                        BankAccReconciliationLine."Journal Batch Name" := '';
                        BankAccReconciliationLine."Line No." := 0;
                        BankAccReconciliationLine."New Bal. Account Type" := 0;
                        BankAccReconciliationLine."New Bal. Account No." := '';
                        BankAccReconciliationLine.Applied := false;
                        BankAccReconciliationLine."Applyment Confidence" := 0;
                        BankAccReconciliationLine.Modify();
                    until BankAccReconciliationLine.Next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(MatchingMsg);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        Window: Dialog;
        MatchingMsg: Label 'Statement No.    #1##########\Matching Lines @2@@@@@@@@@@@@@\Reverse Lines @3@@@@@@@@@@@@@', Comment = 'This is a message for dialog window. Parameters do not require translation.';
        LineCountReconLine: Integer;
        NoOfRecordsReconLine: Integer;
}

