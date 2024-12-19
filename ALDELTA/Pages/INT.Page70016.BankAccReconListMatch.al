page 70016 "Bank Acc. Recon. List Match"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Page creation

    Caption = 'Bank Acc. Reconciliation List Match';
    CardPageID = "Bank Acc. Recon. Match";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = WHERE("Statement Type" = CONST("Bank Reconciliation"));
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                }
                field(StatementNo; Rec."Statement No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field(StatementDate; Rec."Statement Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date on the bank account statement.';
                }
                field(BalanceLastStatement; Rec."Balance Last Statement")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.';
                }
                field(StatementEndingBalance; Rec."Statement Ending Balance")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ending balance shown on the bank''s statement that you want to reconcile with the bank account.';
                }
                field(MatchingProgress; MatchingProgress)
                {
                    Caption = 'Matching Progress';
                    ExtendedDatatype = Ratio;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Matching Progress field.';
                }
                field(RecordsTotal; RecordsTotal)
                {
                    Caption = 'No. All Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. All Lines field.';
                }
                field(MatchedLinesTotal; MatchedLinesTotal)
                {
                    Caption = 'No. Matched Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Matched Lines field.';
                }
                field(NonmatchedLinesTotal; NonmatchedLinesTotal)
                {
                    Caption = 'No. Nonnmatched Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Nonnmatched Lines field.';
                }
                field(ApplymentProgress; ApplymentProgress)
                {
                    Caption = 'Applyment Progress';
                    ExtendedDatatype = Ratio;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applyment Progress field.';
                }
                field(CustVendLinesTotal; CustVendLinesTotal)
                {
                    Caption = 'No. Matched Lines To Reverse';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Matched Lines To Reverse field.';
                }
                field(AppliedLinesTotal; AppliedLinesTotal)
                {
                    Caption = 'No. Applied Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Applied Lines field.';
                }
                field(NotAppliedLinesTotal; NotAppliedLinesTotal)
                {
                    Caption = 'No. Not Applied Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Not Applied Lines field.';
                }
                field(ApplymentConfidenceHighTotal; ApplymentConfidenceHighTotal)
                {
                    Caption = 'No. High Applyment Confidence';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. High Applyment Confidence field.';
                }
                field(Control19; ApplymentConfidenceMediumTotal)
                {
                    Caption = 'No. Medium Applyment Confidence';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Medium Applyment Confidence field.';
                }
                field(ApplymentConfidenceLowTotal; ApplymentConfidenceLowTotal)
                {
                    Caption = 'No. Low Applyment Confidence';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Low Applyment Confidence field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Recon.")
            {
                Caption = '&Recon.';
                Image = BankAccountRec;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Bank Account Card";
                    RunPageLink = "No." = FIELD("Bank Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the &Card action.';
                }
                action("Bank Account Reconciliation")
                {
                    Caption = 'Bank Account Reconciliation';
                    Image = BankAccountRec;
                    Promoted = true;
                    RunObject = Page "Bank Acc. Reconciliation";
                    RunPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                  "Statement No." = FIELD("Statement No.");
                    ToolTip = 'Executes the Bank Account Reconciliation action.';
                    //"Statement Type" = FIELD("Bank Statement");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Match Bank Entries MyTaxi")
                {
                    Caption = 'Match Bank Entries MyTaxi';
                    Ellipsis = true;
                    Image = MapAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Match Bank Entries MyTaxi action.';

                    trigger OnAction()
                    begin
                        BankAccReconciliation.Reset();
                        BankAccReconciliation.SetRange("Statement Type", Rec."Statement Type");
                        BankAccReconciliation.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankAccReconciliation.SetRange("Statement No.", Rec."Statement No.");
                        MatchBankEntriesMyTaxi.SetTableView(BankAccReconciliation);
                        MatchBankEntriesMyTaxi.Run();
                    end;
                }
                action("Payment Journal")
                {
                    Caption = 'Payment Journal';
                    Image = PaymentJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Payment Journal Match";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Payment Journal action.';
                }
                action("Initialize Match Reconciliation Lines Fields")
                {
                    Caption = 'Initialize Match Reconciliation Lines Fields';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Init Match Reconc. Li Fields";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Initialize Match Reconciliation Lines Fields action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MatchingProgress := 0;
        BankAccReconciliationLine.Reset();
        BankAccReconciliationLine.SetRange("Statement Type", Rec."Statement Type");
        BankAccReconciliationLine.SetRange("Bank Account No.", Rec."Bank Account No.");
        BankAccReconciliationLine.SetRange("Statement No.", Rec."Statement No.");
        RecordsTotal := BankAccReconciliationLine.Count;
        BankAccReconciliationLine.SetRange(Matched, true);
        MatchedLinesTotal := BankAccReconciliationLine.Count;
        NonmatchedLinesTotal := RecordsTotal - MatchedLinesTotal;
        if RecordsTotal <> 0 then
            MatchingProgress := 10000 * (MatchedLinesTotal / RecordsTotal);


        ApplymentProgress := 0;
        BankAccReconciliationLine.SetFilter("New Bal. Account Type", '%1|%2', BankAccReconciliationLine."New Bal. Account Type"::Customer, BankAccReconciliationLine."New Bal. Account Type"::Vendor);
        CustVendLinesTotal := BankAccReconciliationLine.Count;
        BankAccReconciliationLine.SetRange(Applied, true);
        AppliedLinesTotal := BankAccReconciliationLine.Count;
        NotAppliedLinesTotal := CustVendLinesTotal - AppliedLinesTotal;
        BankAccReconciliationLine.SetRange("Applyment Confidence", BankAccReconciliationLine."Applyment Confidence"::High);
        ApplymentConfidenceHighTotal := BankAccReconciliationLine.Count;
        BankAccReconciliationLine.SetRange("Applyment Confidence", BankAccReconciliationLine."Applyment Confidence"::Medium);
        ApplymentConfidenceMediumTotal := BankAccReconciliationLine.Count;
        BankAccReconciliationLine.SetRange("Applyment Confidence", BankAccReconciliationLine."Applyment Confidence"::Low);
        ApplymentConfidenceLowTotal := BankAccReconciliationLine.Count;
        if CustVendLinesTotal <> 0 then
            ApplymentProgress := 10000 * (AppliedLinesTotal / CustVendLinesTotal);
    end;

    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MatchBankEntriesMyTaxi: Report "Match Bank Entries MyTaxi";
        RecordsTotal: Integer;
        MatchedLinesTotal: Integer;
        NonmatchedLinesTotal: Integer;
        MatchingProgress: Decimal;
        CustVendLinesTotal: Integer;
        AppliedLinesTotal: Integer;
        NotAppliedLinesTotal: Integer;
        ApplymentConfidenceHighTotal: Integer;
        ApplymentConfidenceMediumTotal: Integer;
        ApplymentConfidenceLowTotal: Integer;
        ApplymentProgress: Decimal;
}

