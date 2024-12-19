codeunit 60047 "Run Global View"
{

    trigger OnRun()
    var
        lmdlGAAPMgtGlobalView: Codeunit "GAAP Mgt. - Global View";
    begin
        lmdlGAAPMgtGlobalView.gfcnShow();
    end;
}

