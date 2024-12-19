codeunit 60045 "Run Detail TB - Corp. Tax Only"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(true, false, true);
    end;
}

