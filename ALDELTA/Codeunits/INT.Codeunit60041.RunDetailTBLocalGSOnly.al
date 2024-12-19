codeunit 60041 "Run Detail TB - Local G/S Only"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(false, true, false);
    end;
}

