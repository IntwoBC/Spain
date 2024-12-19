codeunit 60031 "Fin. Stmt.Code Management"
{
    Permissions = TableData "Gen. Journal Template" = imd,
                  TableData "Gen. Journal Batch" = imd,
                  TableData "Dimension Set ID Filter Line" = imd;

    trigger OnRun()
    begin
    end;


    procedure gfcnUpdateGLAccFSCodeAndHistory(var precGLAccount: Record "G/L Account"; pcodOrgFSCode: Code[10])
    var
        lrrfGLAcc: RecordRef;
    begin
        if (precGLAccount."Financial Statement Code" = pcodOrgFSCode) or (pcodOrgFSCode = '') then
            exit;

        lrrfGLAcc.GetTable(precGLAccount);
        lfcnUpdateAccFSCodeHistory(lrrfGLAcc, pcodOrgFSCode, DATABASE::"Accounting Period");
    end;


    procedure gfcnUpdateCorpGLAccFSCodeAndHistory(var precCorpGLAccount: Record "Corporate G/L Account"; pcodOrgFSCode: Code[10])
    var
        lrrfCorpGLAcc: RecordRef;
    begin
        if (precCorpGLAccount."Financial Statement Code" = pcodOrgFSCode) or (pcodOrgFSCode = '') then
            exit;

        lrrfCorpGLAcc.GetTable(precCorpGLAccount);
        lfcnUpdateAccFSCodeHistory(lrrfCorpGLAcc, pcodOrgFSCode, DATABASE::"Corporate Accounting Period");
    end;

    local procedure lfcnUpdateAccFSCodeHistory(var prrfGLAcc: RecordRef; pcodOrgFSCode: Code[10]; pintAccPeriodTableID: Integer)
    var
        lrecHistAccFinStatmtCode: Record "Hist. Acc. Fin. Statmt. Code";
        ltmpDate: Record Date temporary;
        lrrfAccPeriod: RecordRef;
        lfrfNewFiscalYear: FieldRef;
        lfrfClosed: FieldRef;
        lfrfStartingDate: FieldRef;
        lcodAccNo: Code[20];
        lintGLAccType: Integer;
    begin
        lrrfAccPeriod.Open(pintAccPeriodTableID);

        lfrfStartingDate := lrrfAccPeriod.Field(1);
        lfrfNewFiscalYear := lrrfAccPeriod.Field(3);
        lfrfClosed := lrrfAccPeriod.Field(4);

        lcodAccNo := prrfGLAcc.Field(1).Value;

        lfrfNewFiscalYear.SetRange(true);
        lfrfClosed.SetRange(true);

        if prrfGLAcc.Number = DATABASE::"G/L Account" then
            lintGLAccType := lrecHistAccFinStatmtCode."G/L Account Type"::"G/L Account"
        else
            lintGLAccType := lrecHistAccFinStatmtCode."G/L Account Type"::"Corporate G/L Account";

        if not lrrfAccPeriod.IsEmpty then begin
            lrecHistAccFinStatmtCode.SetRange("G/L Account Type", lintGLAccType);
            lrecHistAccFinStatmtCode.SetRange("G/L Account No.", lcodAccNo);

            if lrecHistAccFinStatmtCode.IsEmpty then begin // No historic entries exists against G/L Account, insert for the full period since day 1
                lrecHistAccFinStatmtCode.Validate("G/L Account Type", lintGLAccType);
                lrecHistAccFinStatmtCode.Validate("G/L Account No.", lcodAccNo);

                lrrfAccPeriod.FindFirst();
                lrecHistAccFinStatmtCode."Starting Date" := lfrfStartingDate.Value;
                lrecHistAccFinStatmtCode.Validate("Starting Date");

                lfrfClosed.SetRange(false);

                lrrfAccPeriod.FindFirst();
                lrecHistAccFinStatmtCode."Ending Date" := lfrfStartingDate.Value;
                lrecHistAccFinStatmtCode.Validate("Ending Date", lrecHistAccFinStatmtCode."Ending Date" - 1);

                lrecHistAccFinStatmtCode.Validate("Financial Statement Code", pcodOrgFSCode);
                lrecHistAccFinStatmtCode.Insert();
            end else begin
                // Find periods already included in historic entries
                lrecHistAccFinStatmtCode.FindSet();
                repeat
                    lfrfStartingDate.SetRange(lrecHistAccFinStatmtCode."Starting Date", lrecHistAccFinStatmtCode."Ending Date");
                    if lrrfAccPeriod.FindSet() then
                        repeat
                            ltmpDate."Period Start" := lfrfStartingDate.Value;
                            if ltmpDate.Insert() then;
                        until lrrfAccPeriod.Next() = 0;
                until lrecHistAccFinStatmtCode.Next() = 0;

                // Insert historic entries for periods not currently set up
                lfrfStartingDate.SetRange();
                if lrrfAccPeriod.FindSet() then
                    repeat
                        if not ltmpDate.Get(ltmpDate."Period Type"::Date, lfrfStartingDate.Value) then begin
                            lrecHistAccFinStatmtCode.Validate("G/L Account Type", lintGLAccType);
                            lrecHistAccFinStatmtCode.Validate("G/L Account No.", lcodAccNo);

                            lrecHistAccFinStatmtCode."Starting Date" := lfrfStartingDate.Value;
                            lrecHistAccFinStatmtCode.Validate("Starting Date");

                            lrecHistAccFinStatmtCode.Validate("Financial Statement Code", pcodOrgFSCode);
                            lrecHistAccFinStatmtCode.Insert();
                        end;
                    until lrrfAccPeriod.Next() = 0;
            end;
        end;
    end;
}

