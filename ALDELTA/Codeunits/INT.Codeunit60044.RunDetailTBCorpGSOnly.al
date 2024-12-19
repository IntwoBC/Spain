codeunit 60044 "Run Detail TB - Corp. G/S Only"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(true, true, false);
    end;
}

