report 60003 "Create Corporate Fiscal Year"
{
    Caption = 'Create Corporate Fiscal Year';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory=ReportsAndAnalysis;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Create Fiscal Year';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FiscalYearStartDate; FiscalYearStartDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Starting Date field.';
                    }
                    field(NoOfPeriods; NoOfPeriods)
                    {
                        Caption = 'No. of Periods';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the No. of Periods field.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Length';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Period Length field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if NoOfPeriods = 0 then begin
                NoOfPeriods := 12;
                Evaluate(PeriodLength, '<1M>');
            end;
            if grecCorpAccountingPeriod.Find('+') then
                FiscalYearStartDate := grecCorpAccountingPeriod."Starting Date";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        grecCorpAccountingPeriod."Starting Date" := FiscalYearStartDate;
        grecCorpAccountingPeriod.TestField("Starting Date");

        if grecCorpAccountingPeriod.Find('-') then begin
            FirstPeriodStartDate := grecCorpAccountingPeriod."Starting Date";
            if grecCorpAccountingPeriod.Find('+') then
                LastPeriodStartDate := grecCorpAccountingPeriod."Starting Date";
        end else
            if not
               Confirm(
                 Text002 +
                 Text003)
            then
                exit;

        FiscalYearStartDate2 := FiscalYearStartDate;

        for i := 1 to NoOfPeriods + 1 do begin
            if (FiscalYearStartDate <= FirstPeriodStartDate) and (i = NoOfPeriods + 1) then
                exit;

            if (FirstPeriodStartDate <> 0D) then
                if (FiscalYearStartDate >= FirstPeriodStartDate) and (FiscalYearStartDate < LastPeriodStartDate) then
                    Error(Text004);
            grecCorpAccountingPeriod.Init();
            grecCorpAccountingPeriod."Starting Date" := FiscalYearStartDate;
            grecCorpAccountingPeriod.Validate("Starting Date");
            if (i = 1) or (i = NoOfPeriods + 1) then begin
                grecCorpAccountingPeriod."New Fiscal Year" := true;
            end;
            if not grecCorpAccountingPeriod.Find('=') then
                grecCorpAccountingPeriod.Insert();
            FiscalYearStartDate := CalcDate(PeriodLength, FiscalYearStartDate);
        end;

        grecCorpAccountingPeriod.Get(FiscalYearStartDate2);
    end;

    var
        Text000: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\';
        Text001: Label 'Do you want to create and close the fiscal year?';
        Text002: Label 'Once you create the new fiscal year you cannot change its starting date.\\';
        Text003: Label 'Do you want to create the fiscal year?';
        Text004: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        grecCorpAccountingPeriod: Record "Corporate Accounting Period";
        NoOfPeriods: Integer;
        PeriodLength: DateFormula;
        FiscalYearStartDate: Date;
        FiscalYearStartDate2: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;
}

