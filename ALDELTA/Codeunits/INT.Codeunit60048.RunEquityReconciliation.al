codeunit 60048 "Run Equity Reconciliation"
{

    trigger OnRun()
    begin
        PAGE.RunModal(PAGE::"Equity Reconciliation");
    end;
}

