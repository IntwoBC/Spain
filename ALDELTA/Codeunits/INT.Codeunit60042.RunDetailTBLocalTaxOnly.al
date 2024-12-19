codeunit 60042 "Run Detail TB - Local Tax Only"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(false, false, true);
    end;
}

