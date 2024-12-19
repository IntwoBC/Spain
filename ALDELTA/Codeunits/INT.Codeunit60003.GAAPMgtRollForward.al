codeunit 60003 "GAAP Mgt. - Roll Forward"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'You must create a new fiscal year before you can close the old year.';
        Text002: Label 'This function closes the fiscal year from %1 to %2. ';
        Text003: Label 'Once the fiscal year is closed it cannot be opened again, and the periods in the fiscal year cannot be changed.\\';
        Text004: Label 'Do you want to close the fiscal year?';


    procedure gfcnCloseYear(var precCorpAccountingPeriod: Record "Corporate Accounting Period")
    var
        lrecCorpAccountingPeriod: Record "Corporate Accounting Period";
        lrecCorpAccountingPeriod2: Record "Corporate Accounting Period";
        lrecCorpAccountingPeriod3: Record "Corporate Accounting Period";
        ldatFiscalYearStartDate: Date;
        ldatFiscalYearEndDate: Date;
    begin
        lrecCorpAccountingPeriod2.SetRange(Closed, false);
        lrecCorpAccountingPeriod2.Find('-');

        ldatFiscalYearStartDate := lrecCorpAccountingPeriod2."Starting Date";
        lrecCorpAccountingPeriod := lrecCorpAccountingPeriod2;
        precCorpAccountingPeriod.TestField("New Fiscal Year", true);

        lrecCorpAccountingPeriod2.SetRange("New Fiscal Year", true);
        if lrecCorpAccountingPeriod2.Find('>') then begin
            ldatFiscalYearEndDate := CalcDate('<-1D>', lrecCorpAccountingPeriod2."Starting Date");

            lrecCorpAccountingPeriod3 := lrecCorpAccountingPeriod2;
            lrecCorpAccountingPeriod2.SetRange("New Fiscal Year");
            lrecCorpAccountingPeriod2.Find('<');
        end else
            Error(Text001);

        if not
           Confirm(
             Text002 +
             Text003 +
             Text004, false,
             ldatFiscalYearStartDate, ldatFiscalYearEndDate)
        then
            exit;

        precCorpAccountingPeriod.Reset();

        precCorpAccountingPeriod.SetRange("Starting Date", ldatFiscalYearStartDate, lrecCorpAccountingPeriod2."Starting Date");
        precCorpAccountingPeriod.ModifyAll(Closed, true);

        precCorpAccountingPeriod.SetRange("Starting Date", ldatFiscalYearStartDate, lrecCorpAccountingPeriod3."Starting Date");
        precCorpAccountingPeriod.ModifyAll("Date Locked", true);

        precCorpAccountingPeriod.Reset();
    end;
}

