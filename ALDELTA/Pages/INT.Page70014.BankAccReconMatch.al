page 70014 "Bank Acc. Recon. Match"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Page creation

    Caption = 'Bank Acc. Reconciliation';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Bank,Matching';
    SaveValues = false;
    SourceTable = "Bank Acc. Reconciliation";
    SourceTableView = WHERE("Statement Type" = CONST("Bank Reconciliation"));
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the bank account that you want to reconcile with the bank''s statement.';
                }
                field(StatementNo; Rec."Statement No.")
                {
                    Caption = 'Statement No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the bank account statement.';
                }
                field(StatementDate; Rec."Statement Date")
                {
                    Caption = 'Statement Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date on the bank account statement.';
                }
                field(BalanceLastStatement; Rec."Balance Last Statement")
                {
                    Caption = 'Balance Last Statement';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ending balance shown on the last bank statement, which was used in the last posted bank reconciliation for this bank account.';
                }
                field(StatementEndingBalance; Rec."Statement Ending Balance")
                {
                    Caption = 'Statement Ending Balance';
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
                field(MatchedLinesTotal; MatchedLinesTotal)
                {
                    Caption = 'No. Matched Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Matched Lines field.';
                }
                field(RecordsTotal; RecordsTotal)
                {
                    Caption = 'No. All Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. All Lines field.';
                }
                field(NonmatchedLinesTotal; NonmatchedLinesTotal)
                {
                    Caption = 'Nonnmatched Lines';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Nonnmatched Lines field.';
                }
            }
            group(Control8)
            {
                ShowCaption = false;
                part(StmtLine; "Bank Acc. Recon. Lines Match")
                {
                    Caption = 'Bank Statement Lines';
                    SubPageLink = "Bank Account No." = FIELD("Bank Account No."),
                                  "Statement No." = FIELD("Statement No.");
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
                    ApplicationArea = all;
                    ToolTip = 'Executes the &Card action.';
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
            }
            group("M&atching")
            {
                Caption = 'M&atching';
                action(All)
                {
                    Caption = 'Show All';
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Show All action.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.PAGE.ToggleMatchedFilter(false);
                    end;
                }
                action(NotMatched)
                {
                    Caption = 'Show Nonmatched';
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Show Nonmatched action.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.PAGE.ToggleUnMatchedFilter(true);
                    end;
                }
                action(Matched)
                {
                    Caption = 'Show matched';
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Show matched action.';

                    trigger OnAction()
                    begin
                        CurrPage.StmtLine.PAGE.ToggleMatchedFilter(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
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
    end;

    var
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        MatchBankEntriesMyTaxi: Report "Match Bank Entries MyTaxi";
        RecordsTotal: Integer;
        MatchedLinesTotal: Integer;
        NonmatchedLinesTotal: Integer;
        MatchingProgress: Decimal;
}

