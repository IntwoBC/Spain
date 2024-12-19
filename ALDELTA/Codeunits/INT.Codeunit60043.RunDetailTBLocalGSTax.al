codeunit 60043 "Run Detail TB - Local G/S&Tax"
{

    trigger OnRun()
    var
        lmdlRunDetailTBReport: Codeunit "Run Detail TB Report";
    begin
        lmdlRunDetailTBReport.lfcnRunDetailTBReport(false, true, true);
    end;
}

