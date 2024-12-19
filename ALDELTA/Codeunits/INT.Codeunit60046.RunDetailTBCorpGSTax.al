codeunit 60046 "Run Detail TB - Corp. G/S&Tax"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(true, true, true);
    end;
}

