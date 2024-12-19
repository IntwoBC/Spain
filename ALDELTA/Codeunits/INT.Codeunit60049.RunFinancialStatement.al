codeunit 60049 "Run Financial Statement"
{

    trigger OnRun()
    var
        lmdlGAAPMgtFinancialStatement: Codeunit "GAAP Mgt. -Financial Statement";
    begin
        lmdlGAAPMgtFinancialStatement.gfcnShow('');
    end;
}

