codeunit 60040 "Run Detail TB Report"
{

    trigger OnRun()
    begin
    end;


    procedure lfcnRunDetailTBReport(pblnCorporate: Boolean; pblnGroupStat: Boolean; pblnTax: Boolean)
    var
        lrecGLAccount: Record "G/L Account";
        lrecCorpGLAccount: Record "Corporate G/L Account";
        lrecGenJnlTemplate: Record "Gen. Journal Template";
        lrecEYCoreSetup: Record "EY Core Setup";
        ltxtAdjmtFilter: Text[30];
    begin
        if pblnGroupStat then begin
            lrecEYCoreSetup.Get();
            if lrecEYCoreSetup."Company Type" = lrecEYCoreSetup."Company Type"::"Bottom-up" then
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"19")
            else
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Tax Adjustments");

            lrecGenJnlTemplate.FindFirst();
            ltxtAdjmtFilter := lrecGenJnlTemplate."Shortcut Dimension 1 Code";
        end;

        if pblnTax then begin
            lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
            lrecGenJnlTemplate.FindFirst();
            if ltxtAdjmtFilter <> '' then
                ltxtAdjmtFilter += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code"
            else
                ltxtAdjmtFilter := lrecGenJnlTemplate."Shortcut Dimension 1 Code";
        end;

        if pblnCorporate then begin
            lrecCorpGLAccount.SetFilter("Global Dimension 1 Filter", ltxtAdjmtFilter);
            REPORT.Run(REPORT::"Corporate Detail Trial Balance", true, true, lrecCorpGLAccount);
        end else begin
            lrecGLAccount.SetFilter("Global Dimension 1 Filter", ltxtAdjmtFilter);
            REPORT.Run(REPORT::"Detail Trial Balance", true, true, lrecGLAccount);
        end;
    end;
}

