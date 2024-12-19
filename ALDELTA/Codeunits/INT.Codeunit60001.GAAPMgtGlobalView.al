codeunit 60001 "GAAP Mgt. - Global View"
{
    // MP 04-12-12
    // Fixed issue with Corporate Amount not being Balance at Date
    // 
    // MP 15-01-13
    // Amended so P&L entries for S and T Adjustments are included under retained earnings, if prior period has been closed
    // 
    // MP 21-01-13
    // Changed calculation and drilldown for S and T adjustments posted against balance sheet accounts, so they now include
    // all entries posted, not just current year
    // 
    // MP 14-02-13
    // Changed variable lrecAccPeriod in function gfcnGetAccPeriodFilter from "Accounting Period" to "Corporate Accounting Period"
    // 
    // MP 15-05-13
    // Removed functionality developed to calc. Retained Earnings on the fly (Case 13851)
    // Deleted functions lfcnCalcRetainedEarnings and lfcnCalcRetainedEarningsPeriod
    // 
    // MP 03-12-13
    // Amended to support bottom-up companies (CR 30)
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup
    // 
    // MP 08-05-14
    // Now does not exlude reclassification entries for prior years
    // 
    // MP 01-12-14
    // NAV 2013 R2 Upgrade
    // 
    // MP 25-11-15
    // Changes to support new column view "GAAP Adjustment Reason". Added functions gfcnDrillDownAdjmts, lfcnFilterGLEntryAdmjts,
    // lfcnCheckIfZeroMovementBlocked and gfcnFilterZeroMovementBlocked (CB1 Enhancements)
    // 
    // MP 18-02-16
    // Updated FS Description to use English one
    // 
    // MP 31-03-16
    // FS Codes now taken from Local G/L Account, i.e. not using the one on the Corp. G/L Account


    trigger OnRun()
    begin
    end;

    var
        grecGenJnlTemplate: array[3] of Record "Gen. Journal Template";
        gmdlCompanyTypeMgt: Codeunit "Company Type Management";
        goptColumnView: Option "Adjustment Role","GAAP Adjustment Reason";
        gdatStartCurrPeriod: Date;
        gdatEndCurrPeriod: Date;
        gdatStartLastYear: Date;
        gdatEndLastYear: Date;
        gdatStartPriorLastYear: Date;
        gdatEndPriorLastYear: Date;
        gblnIncludePrepostedEntries: Boolean;
        gblnIncludeTax: Boolean;
        gblnIncludePreviousYear: Boolean;
        txt60000: Label 'Posted Statutory Adjustments';
        txt60001: Label 'Statutory TB';
        txt60002: Label 'Posted Group Adjustments';
        txt60003: Label 'Local Statutory TB';
        txt60004: Label ' (PY)';
        txt60005: Label 'Un-posted Statutory Amount';
        txt60006: Label 'Un-posted Group Amount';
        gblnBottomUp: Boolean;
        gblnCorpAccInUse: Boolean;
        gblnShowLocalGLAcc: Boolean;


    procedure gfcnShow()
    var
        lpagGlobalCOAView: Page "Global View";
    begin
        repeat
            Clear(lpagGlobalCOAView); // MP 01-12-14
            lpagGlobalCOAView.RunModal();
        until not lpagGlobalCOAView.gfcnReopen();
    end;


    procedure gfcnInit(var pdatStart: Date; var pdatEnd: Date; var pblnIncludePrepostedEntries: Boolean; var pblnIncludeTax: Boolean; pblnIncludePreviousYear: Boolean; var pblnShowLocalGLAcc: Boolean; poptColumnView: Option "Adjustment Role","GAAP Adjustment Reason")
    begin
        // MP 25-11-15 Added parameters poptColumnView >>
        goptColumnView := poptColumnView;
        // MP 25-11-15 <<

        gdatStartCurrPeriod := pdatStart;
        gdatEndCurrPeriod := pdatEnd;

        // IF pblnIncludePreviousYear THEN // MP 15-01-13 Always calculate this
        gfcnGetAccPeriodFilter(CalcDate('<-6M>', pdatStart), gdatStartLastYear, gdatEndLastYear);

        // MP 15-05-13 >>

        if pblnIncludePreviousYear then
            gfcnGetAccPeriodFilter(CalcDate('<-6M>', gdatStartLastYear), gdatStartPriorLastYear, gdatEndPriorLastYear);

        // MP 15-05-13 <<

        gblnIncludePrepostedEntries := pblnIncludePrepostedEntries;
        gblnIncludeTax := pblnIncludeTax;
        gblnIncludePreviousYear := pblnIncludePreviousYear;
        gblnShowLocalGLAcc := pblnShowLocalGLAcc; // MP 23-04-14

        // MP 03-12-13 >>
        gblnBottomUp := gmdlCompanyTypeMgt.gfcnIsBottomUp();
        // MP 23-04-14 >>
        if gblnShowLocalGLAcc then
            gblnCorpAccInUse := false
        else
            // MP 23-04-14 <<
            gblnCorpAccInUse := gmdlCompanyTypeMgt.gfcnCorpAccInUse();
        if gblnBottomUp then begin
            grecGenJnlTemplate[3].SetRange(Type, grecGenJnlTemplate[3].Type::"19");
            grecGenJnlTemplate[3].FindFirst();
        end else begin
            // MP 03-12-13 <<
            grecGenJnlTemplate[1].SetRange(Type, grecGenJnlTemplate[1].Type::"Tax Adjustments");
            grecGenJnlTemplate[1].FindFirst();
        end; // MP 03-12-13

        grecGenJnlTemplate[2].SetRange(Type, grecGenJnlTemplate[2].Type::"Group Adjustments");
        grecGenJnlTemplate[2].FindFirst();

        //lfcnCalcRetainedEarnings; // MP 15-01-13 // MP 15-05-13 Removed
    end;


    procedure gfcnCalc(var precCorpGLAcc: Record "Corporate G/L Account"; var pdecCorpAmt: array[2] of Decimal; var pdecStatPrepostAmt: array[2] of Decimal; var pdecStatAdjmtAmt: array[2] of Decimal; var pdecAuditorAdjmtAmt: array[2] of Decimal; var pdecStatTBAmt: array[2] of Decimal; var pdecTaxPrepostAmt: array[2] of Decimal; var pdecTaxAdjmtAmt: array[2] of Decimal; var pdecTaxTBAmt: array[2] of Decimal; var pdecPriorYearAdjmtAmt: Decimal; var pdecCurrYearAdjmtAmt: Decimal; var pdecCurrYearReclassAmt: Decimal; var pcodFSCode: array[2] of Code[10]; var ptxtFSDescription: array[2] of Text[100])
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecFinancialStatementCode: Record "Financial Statement Code";
        lrecGLAcc: Record "G/L Account";
        lmdlTGLAccount: Codeunit "T:G/L Account";
        ldecDummy: Decimal;
    begin
        Clear(pdecCorpAmt);
        Clear(pdecStatPrepostAmt);
        Clear(pdecStatAdjmtAmt);
        Clear(pdecAuditorAdjmtAmt);
        Clear(pdecStatTBAmt);
        Clear(pdecTaxPrepostAmt);
        Clear(pdecTaxAdjmtAmt);
        Clear(pdecTaxTBAmt);
        // MP 25-11-15 New parameters >>
        Clear(pdecPriorYearAdjmtAmt);
        Clear(pdecCurrYearAdjmtAmt);
        Clear(pdecCurrYearReclassAmt);
        Clear(pcodFSCode);
        Clear(ptxtFSDescription);

        // Get Financial Statement Code and Description >>
        // MP 31-03-16 >>
        if lrecGLAcc.Get(precCorpGLAcc."Local G/L Account No.") then
            pcodFSCode[1] := lmdlTGLAccount.gfcnGetFinancialStatementCode(lrecGLAcc, gdatStartCurrPeriod) // MP 24-May-16 Replaced with Codeunit call
        else
            // MP 31-03-16 <<
            pcodFSCode[1] := precCorpGLAcc.gfcnGetFinancialStatementCode(gdatStartCurrPeriod);

        if lrecFinancialStatementCode.Get(pcodFSCode[1]) then
            //ptxtFSDescription[1] := lrecFinancialStatementCode.Description;
            ptxtFSDescription[1] := lrecFinancialStatementCode."Description (English)"; // MP 18-02-16 Replaces above line

        if gblnIncludePreviousYear or (goptColumnView = goptColumnView::"GAAP Adjustment Reason") then begin
            // MP 31-03-16 >>
            if lrecGLAcc."No." <> '' then
                pcodFSCode[2] := lmdlTGLAccount.gfcnGetFinancialStatementCode(lrecGLAcc, gdatStartLastYear) // MP 24-May-16 Replaced with Codeunit call
            else
                // MP 31-03-16 <<
                pcodFSCode[2] := precCorpGLAcc.gfcnGetFinancialStatementCode(gdatStartLastYear);

            if pcodFSCode[2] = pcodFSCode[1] then
                Clear(pcodFSCode[2])
            else
                if lrecFinancialStatementCode.Get(pcodFSCode[2]) then
                    //ptxtFSDescription[2] := lrecFinancialStatementCode.Description;
                    ptxtFSDescription[2] := lrecFinancialStatementCode."Description (English)"; // MP 18-02-16 Replaces above line
        end;
        // MP 25-11-15 <<

        lrecCorpGLAcc.Copy(precCorpGLAcc);

        // Calc. Current Year
        // MP 03-12-13 >>
        if gblnBottomUp then
            if gblnCorpAccInUse then
                lfcnCalcPeriodBottomUp(lrecCorpGLAcc, pdecCorpAmt[1], pdecStatPrepostAmt[1], pdecStatAdjmtAmt[1],
                  pdecStatTBAmt[1], pdecTaxPrepostAmt[1], pdecTaxAdjmtAmt[1], pdecTaxTBAmt[1], false)
            else
                lfcnCalcPeriodBottomUpLocal(lrecCorpGLAcc, pdecStatTBAmt[1], pdecTaxPrepostAmt[1], pdecTaxAdjmtAmt[1], pdecTaxTBAmt[1], false,
                  pdecCorpAmt[1], pdecStatPrepostAmt[1], pdecStatAdjmtAmt[1]) // MP 23-04-14 Added three parameters
        else
            // MP 03-12-13 <<
            lfcnCalcPeriod(lrecCorpGLAcc, pdecCorpAmt[1], pdecStatPrepostAmt[1], pdecStatAdjmtAmt[1], pdecAuditorAdjmtAmt[1],
            pdecStatTBAmt[1], pdecTaxPrepostAmt[1], pdecTaxAdjmtAmt[1], pdecTaxTBAmt[1], false,
            pdecPriorYearAdjmtAmt, pdecCurrYearAdjmtAmt, pdecCurrYearReclassAmt); // MP 25-11-15 New parameters

        // Calc. Previous Year
        if gblnIncludePreviousYear then begin
            lrecCorpGLAcc.SetRange("Date Filter", gdatStartLastYear, gdatEndLastYear);

            // MP 03-12-13 >>
            if gblnBottomUp then
                if gblnCorpAccInUse then
                    lfcnCalcPeriodBottomUp(lrecCorpGLAcc, pdecCorpAmt[2], pdecStatPrepostAmt[2], pdecStatAdjmtAmt[2],
                    pdecStatTBAmt[2], pdecTaxPrepostAmt[2], pdecTaxAdjmtAmt[2], pdecTaxTBAmt[2], true)
                else
                    lfcnCalcPeriodBottomUpLocal(lrecCorpGLAcc, pdecStatTBAmt[2], pdecTaxPrepostAmt[2], pdecTaxAdjmtAmt[2], pdecTaxTBAmt[2], true,
                      pdecCorpAmt[2], pdecStatPrepostAmt[2], pdecStatAdjmtAmt[2]) // MP 23-04-14 Added three parameters
            else
                // MP 03-12-13 <<
                lfcnCalcPeriod(lrecCorpGLAcc, pdecCorpAmt[2], pdecStatPrepostAmt[2], pdecStatAdjmtAmt[2], pdecAuditorAdjmtAmt[2],
            pdecStatTBAmt[2], pdecTaxPrepostAmt[2], pdecTaxAdjmtAmt[2], pdecTaxTBAmt[2], true,
              ldecDummy, ldecDummy, ldecDummy); // MP 25-11-15 New parameters N/A for previous year
        end;
    end;

    local procedure lfcnCalcPeriod(var precCorpGLAcc: Record "Corporate G/L Account"; var pdecCorpAmt: Decimal; var pdecStatPrepostAmt: Decimal; var pdecStatAdjmtAmt: Decimal; var pdecAuditorAdjmtAmt: Decimal; var pdecStatTBAmt: Decimal; var pdecTaxPrepostAmt: Decimal; var pdecTaxAdjmtAmt: Decimal; var pdecTaxTBAmt: Decimal; pblnPrevYear: Boolean; var pdecPriorYearAdjmtAmt: Decimal; var pdecCurrYearAdjmtAmt: Decimal; var pdecCurrYearReclassAmt: Decimal)
    var
        lrecGLEntryReclass: Record "G/L Entry";
        lrecGLEntry: Record "G/L Entry";
        lrecGenJnlLine: Record "Gen. Journal Line";
        lmdlAdjmtsMgt: Codeunit "Adjustments Management";
    begin
        // Calc. Non-Adjustment Net Change
        precCorpGLAcc.SetRange("Global Dimension 1 Filter", '');

        // MP 04-12-12 >>
        //precCorpGLAcc.CALCFIELDS("Net Change");
        //pdecCorpAmt := precCorpGLAcc."Net Change";

        precCorpGLAcc.CalcFields("Balance at Date");
        pdecCorpAmt := precCorpGLAcc."Balance at Date";

        // MP 04-12-12 <<

        // Calc. Statutory
        precCorpGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[1]."Shortcut Dimension 1 Code");


        // MP 25-11-15 Calculation for GAAP Adjustment Reason >>
        if goptColumnView = goptColumnView::"GAAP Adjustment Reason" then begin
            // Calc. Current Year Adjustments
            precCorpGLAcc.SetFilter("GAAP Adjustment Reason Filter", '<>%1', precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
            if gblnIncludePrepostedEntries then begin
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                pdecCurrYearAdjmtAmt := precCorpGLAcc."Net Change" + precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
            end else begin
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                pdecCurrYearAdjmtAmt := precCorpGLAcc."Net Change";
            end;

            // Calc. Prior Year Adjustments
            pdecPriorYearAdjmtAmt := precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";

            // Calc. the current year Reclassifications that are not related to previous years revisible entries
            precCorpGLAcc.SetRange("Date Filter", gdatStartCurrPeriod + 1, gdatEndCurrPeriod); // Exclude entries on the first date = reversal entries
            precCorpGLAcc.SetFilter("GAAP Adjustment Reason Filter", '%1', precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
            if gblnIncludePrepostedEntries then begin
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                pdecCurrYearReclassAmt := precCorpGLAcc."Net Change" + precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
            end else begin
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                pdecCurrYearReclassAmt := precCorpGLAcc."Net Change";
            end;

            // Add prior year Reclassifications to Prior Year Adjustments for P&L Accounts
            if precCorpGLAcc."Account Class" = precCorpGLAcc."Account Class"::"P&L" then
                pdecPriorYearAdjmtAmt += precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";

            precCorpGLAcc.SetRange("Date Filter", gdatStartCurrPeriod, gdatEndCurrPeriod);

            pdecStatTBAmt := pdecCorpAmt + pdecPriorYearAdjmtAmt + pdecCurrYearAdjmtAmt + pdecCurrYearReclassAmt;
        end else begin // Below is the calculation for Adjustment Role (original Global View)
                       // MP 25-11-15 <<

            if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
                //precCorpGLAcc.SETRANGE("Gen. Jnl. Template Name Filter",grecGenJnlTemplate[1].Name); // MP 23-04-14 Include from all templates
                precCorpGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)");
                pdecStatPrepostAmt := precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
            end;

            precCorpGLAcc.SetFilter("Adjustment Role Filter", '<>%1', precCorpGLAcc."Adjustment Role Filter"::Auditor);
            precCorpGLAcc.CalcFields("Net Change");
            pdecStatAdjmtAmt := precCorpGLAcc."Net Change";

            // MP 21-01-13 Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason Filter")

            if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
                //precCorpGLAcc.SETFILTER("GAAP Adjustment Reason Filter",'<>%1',precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                //precCorpGLAcc.SETRANGE("GAAP Adjustment Reason Filter");

                pdecStatAdjmtAmt += precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";
            end;

            // MP 21-01-13 <<

            precCorpGLAcc.SetRange("Adjustment Role Filter", precCorpGLAcc."Adjustment Role Filter"::Auditor);
            precCorpGLAcc.CalcFields("Net Change");
            pdecAuditorAdjmtAmt := precCorpGLAcc."Net Change";

            // MP 21-01-13 Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason Filter")

            if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
                //precCorpGLAcc.SETFILTER("GAAP Adjustment Reason Filter",'<>%1',precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                //precCorpGLAcc.SETRANGE("GAAP Adjustment Reason Filter");

                pdecAuditorAdjmtAmt += precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";
            end;

            // MP 21-01-13 <<

            precCorpGLAcc.SetRange("Adjustment Role Filter");

            // MP 15-05-13 Removed >>
            // MP 15-01-13 >>

            //IF (gblnUseCalcRetainedEarnings OR pblnPrevYear) AND // MP 21-01-13 Removed condition
            //IF (precCorpGLAcc."No." = grecEYCoreSetup."Corp. Retained Earnings Acc.")
            //THEN BEGIN
            //  IF pblnPrevYear THEN
            //    lintPeriodArrayNo := 2
            //  ELSE
            //    lintPeriodArrayNo := 1;

            //  pdecStatAdjmtAmt += gdecRetainedEarnings[lintPeriodArrayNo,1];
            //  pdecAuditorAdjmtAmt += gdecRetainedEarnings[lintPeriodArrayNo,2];
            //END;

            // MP 15-01-13 <<
            // MP 15-05-13 Removed <<

            pdecStatTBAmt := pdecCorpAmt + pdecStatPrepostAmt + pdecStatAdjmtAmt + pdecAuditorAdjmtAmt;
        end; // MP 25-11-15

        // Calc. Tax
        if gblnIncludeTax then begin
            precCorpGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[2]."Shortcut Dimension 1 Code");
            if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
                //precCorpGLAcc.SETRANGE("Gen. Jnl. Template Name Filter",grecGenJnlTemplate[2].Name); // MP 23-04-14 Include from all templates
                precCorpGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)", "Net Change");
                pdecTaxPrepostAmt := precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
            end else
                precCorpGLAcc.CalcFields("Net Change");

            pdecTaxAdjmtAmt := precCorpGLAcc."Net Change";

            // MP 21-01-13 Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason Filter")

            if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
                //precCorpGLAcc.SETFILTER("GAAP Adjustment Reason Filter",'<>%1',precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                //  precCorpGLAcc.SETRANGE("GAAP Adjustment Reason Filter");

                pdecTaxAdjmtAmt += precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";
            end;

            // MP 21-01-13 <<

            // MP 15-05-13 Removed >>
            // MP 15-01-13 >>

            //IF (gblnUseCalcRetainedEarnings OR pblnPrevYear) AND // MP 21-01-13 Removed condition
            //IF (precCorpGLAcc."No." = grecEYCoreSetup."Corp. Retained Earnings Acc.")
            //THEN
            //  pdecTaxAdjmtAmt += gdecRetainedEarnings[lintPeriodArrayNo,3];

            // MP 15-01-13 <<
            // MP 15-05-13 Removed <<

            pdecTaxTBAmt := pdecStatTBAmt + pdecTaxPrepostAmt + pdecTaxAdjmtAmt;
        end;
    end;


    procedure gfcnGetAccPeriodFilter(pdatAsOfDate: Date; var pdatStart: Date; var pdatEnd: Date)
    var
        lrrfAccPeriod: RecordRef;
        lfrfFieldNewFiscalYear: FieldRef;
        lfrfFieldStartingDate: FieldRef;
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
        ldatStartingDate: Date;
    begin
        // MP 14-02-13 Changed variable lrecAccPeriod from "Accounting Period" to "Corporate Accounting Period"

        // MP 03-12-13 Redone to use Recordref in order to support both "Accounting Period" and "Corporate Accounting Period" >>
        lrrfAccPeriod.Open(lmdlCompanyTypeMgt.gfcnGetAccPeriodTableID());

        lfrfFieldNewFiscalYear := lrrfAccPeriod.Field(3); // "New Fiscal Year"
        lfrfFieldStartingDate := lrrfAccPeriod.Field(1); // "Starting Date"

        lfrfFieldNewFiscalYear.SetRange(true);
        lfrfFieldStartingDate.SetRange(0D, pdatAsOfDate);

        if not lrrfAccPeriod.FindLast() then begin
            lfrfFieldStartingDate.SetRange();
            lrrfAccPeriod.FindFirst();

            pdatStart := lfrfFieldStartingDate.Value;
            pdatEnd := lfrfFieldStartingDate.Value;
            exit;
        end;

        pdatStart := lfrfFieldStartingDate.Value;

        lfrfFieldStartingDate.SetRange();
        if lrrfAccPeriod.Next() <> 0 then begin
            ldatStartingDate := lfrfFieldStartingDate.Value;
            pdatEnd := CalcDate('<-1D>', ldatStartingDate)
        end else begin
            lfrfFieldNewFiscalYear.SetRange();
            lrrfAccPeriod.FindLast();
            ldatStartingDate := lfrfFieldStartingDate.Value;
            pdatEnd := CalcDate('<CY>', ldatStartingDate);
        end;

        //lrecAccPeriod.SETRANGE("New Fiscal Year",TRUE);
        //lrecAccPeriod.SETRANGE("Starting Date",0D,pdatAsOfDate);
        //IF NOT lrecAccPeriod.FINDLAST THEN BEGIN
        //  lrecAccPeriod.SETRANGE("Starting Date");
        //  lrecAccPeriod.FINDFIRST;
        //
        //  // MP 14-02-13 Changed>>
        //  // MP 15-01-13 If period cannot be found, then set this as the year prior to first period set up >>
        //
        //  //pdatStart := CALCDATE('<-1Y>',lrecAccPeriod."Starting Date");
        //  //pdatEnd := lrecAccPeriod."Starting Date" - 1;
        //
        //  pdatStart := lrecAccPeriod."Starting Date";
        //  pdatEnd := lrecAccPeriod."Starting Date";
        //  EXIT;
        //
        //  // MP 15-01-13 <<
        //  // MP 14-02-13 <<
        //END;
        //
        //pdatStart := lrecAccPeriod."Starting Date";
        //
        //lrecAccPeriod.SETRANGE("Starting Date");
        //IF lrecAccPeriod.NEXT <> 0 THEN
        //  pdatEnd := CALCDATE('<-1D>',lrecAccPeriod."Starting Date")
        //ELSE BEGIN
        //  lrecAccPeriod.SETRANGE("New Fiscal Year");
        //  lrecAccPeriod.FINDLAST;
        //  pdatEnd := CALCDATE('<CY>',lrecAccPeriod."Starting Date");
        //END;
        // MP 03-12-13 <<
    end;


    procedure gfcnDrillDown(var precCorpGLAcc: Record "Corporate G/L Account"; pintTableID: Integer; ptxtStatutoryFilter: Text[30]; ptxtAuditorFilter: Text[30]; pblnCurrYear: Boolean; pblnBalanceAtDate: Boolean)
    var
        lrecGLEntry: Record "G/L Entry";
        lrecGenJnlLine: Record "Gen. Journal Line";
        lmdlTGenJournalLine: Codeunit "T:Gen. Journal Line";
        lpagGLEntriesinclUnposted: Page "G/L Entries (incl. Un-posted)";
    begin
        // MP 04-12-12 Added parameter pblnBalanceAtDate

        if pintTableID in [0, DATABASE::"G/L Entry"] then begin
            // MP 03-12-13 >>
            if not gblnCorpAccInUse then begin
                lrecGLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code",
                  "GAAP Adjustment Reason", "Posting Date");

                //lrecGLEntry.SETRANGE("G/L Account No.",precCorpGLAcc."No.");
                lrecGLEntry.SetRange("G/L Account No.", precCorpGLAcc."Local G/L Account No."); // MP 23-04-14 Replaces above
            end else begin
                // MP 03-12-13 <<
                lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role");

                lrecGLEntry.SetRange("Corporate G/L Account No.", precCorpGLAcc."No.");
            end; // MP 03-12-13
            lrecGLEntry.SetFilter("Global Dimension 1 Code", ptxtStatutoryFilter);
            lrecGLEntry.SetFilter("Adjustment Role", ptxtAuditorFilter);
            if pblnCurrYear then

                // MP 04-12-12 >>

                if pblnBalanceAtDate then
                    lrecGLEntry.SetRange("Posting Date", 0D, gdatEndCurrPeriod)
                else

                    // MP 04-12-12 <<

                    lrecGLEntry.SetRange("Posting Date", gdatStartCurrPeriod, gdatEndCurrPeriod)
            else

                // MP 04-12-12 >>

                if pblnBalanceAtDate then
                    lrecGLEntry.SetRange("Posting Date", 0D, gdatEndLastYear)
                else

                    // MP 04-12-12 <<

                    lrecGLEntry.SetRange("Posting Date", gdatStartLastYear, gdatEndLastYear);

            precCorpGLAcc.CopyFilter("Global Dimension 2 Filter", lrecGLEntry."Global Dimension 2 Code");
            precCorpGLAcc.CopyFilter("Business Unit Filter", lrecGLEntry."Business Unit Code");
            precCorpGLAcc.CopyFilter("GAAP Adjustment Reason Filter", lrecGLEntry."GAAP Adjustment Reason");

            // MP 21-01-13 >>

            if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
                // Mark the entries posted to the account for this period
                if lrecGLEntry.FindSet() then
                    repeat
                        lrecGLEntry.Mark(true);
                    until lrecGLEntry.Next() = 0;

                // Mark the non-Reclasification entries for prior periods
                // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason")
                //lrecGLEntry.SETFILTER("GAAP Adjustment Reason",'<>%1',lrecGLEntry."GAAP Adjustment Reason"::Reclassification);

                if pblnCurrYear then
                    lrecGLEntry.SetRange("Posting Date", 0D, ClosingDate(gdatEndLastYear)) // MP 16-05-13 CLOSINGDATE
                else
                    lrecGLEntry.SetRange("Posting Date", 0D, ClosingDate(gdatEndPriorLastYear)); // MP 16-05-13 CLOSINGDATE

                lrecGLEntry.FilterGroup(2);
                lrecGLEntry.SetFilter("Global Dimension 1 Code", '<>%1', '');
                lrecGLEntry.FilterGroup(0);

                if lrecGLEntry.FindSet() then
                    repeat
                        lrecGLEntry.Mark(true);
                    until lrecGLEntry.Next() = 0;

                lrecGLEntry.SetRange("Posting Date");
                lrecGLEntry.SetRange("GAAP Adjustment Reason");

                lrecGLEntry.FilterGroup(2);
                lrecGLEntry.SetRange("Global Dimension 1 Code");
                lrecGLEntry.FilterGroup(0);

                lrecGLEntry.MarkedOnly(true);
            end;

            // MP 21-01-13 <<

            // MP 15-05-13 Removed >>
            // MP 15-01-13 >>

            //IF (gblnUseCalcRetainedEarnings OR (NOT pblnCurrYear)) AND // MP 21-01-13 Removed condition
            //IF ((precCorpGLAcc."No." = grecEYCoreSetup."Corp. Retained Earnings Acc.") AND (ptxtStatutoryFilter <> ''''''))
            //THEN BEGIN
            //  // MP 21-01-13
            //  { Handled under Balance Sheet accounts above
            //  // Mark the entries posted to retained earnings for this period
            //  IF lrecGLEntry.FINDSET THEN
            //    REPEAT
            //      lrecGLEntry.MARK(TRUE);
            //    UNTIL lrecGLEntry.NEXT = 0;
            //  }

            //  lrecGLEntry.MARKEDONLY(FALSE);

            // MP 21-01-13 <<

            // Mark the entries posted to P&L accounts for prior period, only S and/or T
            //  lrecGLEntry.SETFILTER("Corporate G/L Account No.",gtxtGLAccountFilterPL);

            //  IF pblnCurrYear THEN
            // MP 21-01-13 >>
            //    lrecGLEntry.SETRANGE("Posting Date",gdatStartLastYear,gdatEndLastYear)
            //    IF grecCorpAccountingPeriod[1].Closed THEN
            //      lrecGLEntry.SETRANGE("Posting Date",0D,gdatEndLastYear)
            //    ELSE
            //      lrecGLEntry.SETRANGE("Posting Date",0D,CALCDATE('<-1D>',gdatStartLastYear))
            // MP 21-01-13 <<
            //   ELSE
            // MP 21-01-13 >>
            //    lrecGLEntry.SETRANGE("Posting Date",gdatStartPriorLastYear,gdatEndPriorLastYear);
            //    IF grecCorpAccountingPeriod[2].Closed THEN
            //      lrecGLEntry.SETRANGE("Posting Date",0D,gdatEndPriorLastYear)
            //    ELSE
            //      lrecGLEntry.SETRANGE("Posting Date",0D,CALCDATE('<-1D>',gdatStartPriorLastYear));
            // MP 21-01-13 <<

            //  lrecGLEntry.FILTERGROUP(2);
            //  lrecGLEntry.SETFILTER("Global Dimension 1 Code",'<>%1','');
            //  lrecGLEntry.FILTERGROUP(0);

            //  IF lrecGLEntry.FINDSET THEN
            //    REPEAT
            //      lrecGLEntry.MARK(TRUE);
            //    UNTIL lrecGLEntry.NEXT = 0;

            //  lrecGLEntry.SETFILTER("Corporate G/L Account No.",gtxtGLAccountFilterPL + '|' + precCorpGLAcc."No.");
            //  lrecGLEntry.SETRANGE("Posting Date");

            //  lrecGLEntry.FILTERGROUP(2);
            //  lrecGLEntry.SETRANGE("Global Dimension 1 Code");
            //  lrecGLEntry.FILTERGROUP(0);

            //  lrecGLEntry.MARKEDONLY(TRUE);
            //END;

            // MP 15-01-13 <<

            if pintTableID = 0 then
                PAGE.Run(PAGE::"G/L Entries (incl. Un-posted)", lrecGLEntry) // Include un-posted entries
            else
                PAGE.Run(0, lrecGLEntry);
        end else begin // Un-posted
            lrecGenJnlLine.SetFilter("Shortcut Dimension 1 Code", ptxtStatutoryFilter);
            if pblnCurrYear then
                lrecGenJnlLine.SetRange("Posting Date", gdatStartCurrPeriod, gdatEndCurrPeriod)
            else
                lrecGenJnlLine.SetRange("Posting Date", gdatStartLastYear, gdatEndLastYear);

            precCorpGLAcc.CopyFilter("Global Dimension 2 Filter", lrecGenJnlLine."Shortcut Dimension 2 Code");
            precCorpGLAcc.CopyFilter("Business Unit Filter", lrecGenJnlLine."Business Unit Code");
            precCorpGLAcc.CopyFilter("GAAP Adjustment Reason Filter", lrecGenJnlLine."GAAP Adjustment Reason");

            // MP 03-12-13 >>
            if not gblnCorpAccInUse then
                //lrecGenJnlLine.gfcnMarkLocalAccLines(precCorpGLAcc."No.")
                lmdlTGenJournalLine.gfcnMarkLocalAccLines(lrecGenJnlLine, precCorpGLAcc."Local G/L Account No.") // MP 23-04-14 Replaces above // MP 24-May-16 Replaced with Codeunit call
            else
                // MP 03-12-13 <<
                lmdlTGenJournalLine.gfcnMarkCorpAccLines(lrecGenJnlLine, precCorpGLAcc."No."); // MP 24-May-16 Replaced with Codeunit call

            PAGE.Run(PAGE::"Gen. Journal Line List", lrecGenJnlLine);
        end;
    end;


    procedure gfcnGetCaptions(var ptxtPostedStatGrAdjmtCaption: Text[50]; var ptxtPostedStatGrAdjmtPYCaption: Text[50]; var ptxtStatTBCaption: Text[50]; var ptxtStatTBPYCaption: Text[50]; var gtxtUnpostedStatAmount: Text[50])
    begin
        // MP 03-12-13

        if gmdlCompanyTypeMgt.gfcnIsBottomUp() then begin
            ptxtPostedStatGrAdjmtCaption := txt60002;
            ptxtPostedStatGrAdjmtPYCaption := txt60002 + txt60004;
            ptxtStatTBCaption := txt60003;
            ptxtStatTBPYCaption := txt60003 + txt60004;
            gtxtUnpostedStatAmount := txt60006;
        end else begin
            ptxtPostedStatGrAdjmtCaption := txt60000;
            ptxtPostedStatGrAdjmtPYCaption := txt60000 + txt60004;
            ptxtStatTBCaption := txt60001;
            ptxtStatTBPYCaption := txt60001 + txt60004;
            gtxtUnpostedStatAmount := txt60005;
        end;
    end;

    local procedure lfcnCalcPeriodBottomUp(var precCorpGLAcc: Record "Corporate G/L Account"; var pdecCorpAmt: Decimal; var pdecStatPrepostAmt: Decimal; var pdecStatAdjmtAmt: Decimal; var pdecStatTBAmt: Decimal; var pdecTaxPrepostAmt: Decimal; var pdecTaxAdjmtAmt: Decimal; var pdecTaxTBAmt: Decimal; pblnPrevYear: Boolean)
    begin
        // MP 03-12-13

        // Calc. Non-Adjustment Net Change
        precCorpGLAcc.SetFilter("Global Dimension 1 Filter", '''''|' + grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");

        precCorpGLAcc.CalcFields("Balance at Date");
        pdecCorpAmt := precCorpGLAcc."Balance at Date";

        // Calc. Group
        precCorpGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");

        if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
            //precCorpGLAcc.SETRANGE("Gen. Jnl. Template Name Filter",grecGenJnlTemplate[3].Name); // MP 23-04-14 Include from all templates
            precCorpGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)");
            pdecStatPrepostAmt := -precCorpGLAcc."Preposted Net Change" - precCorpGLAcc."Preposted Net Change (Bal.)";
            pdecCorpAmt -= pdecStatPrepostAmt;
        end;

        precCorpGLAcc.CalcFields("Net Change");
        pdecStatAdjmtAmt := -precCorpGLAcc."Net Change";

        // Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
        // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason Filter")
        if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
            //precCorpGLAcc.SETFILTER("GAAP Adjustment Reason Filter",'<>%1',precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
            precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
            //precCorpGLAcc.SETRANGE("GAAP Adjustment Reason Filter");

            pdecStatAdjmtAmt -= precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";
        end;

        pdecStatTBAmt := pdecCorpAmt + pdecStatPrepostAmt + pdecStatAdjmtAmt;

        // Calc. Tax
        if gblnIncludeTax then begin
            precCorpGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[2]."Shortcut Dimension 1 Code");
            if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
                //precCorpGLAcc.SETRANGE("Gen. Jnl. Template Name Filter",grecGenJnlTemplate[2].Name); // MP 23-04-14 Include from all templates
                precCorpGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)", "Net Change");
                pdecTaxPrepostAmt := precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
            end else
                precCorpGLAcc.CalcFields("Net Change");

            pdecTaxAdjmtAmt := precCorpGLAcc."Net Change";

            // Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason")
            if precCorpGLAcc."Income/Balance" = precCorpGLAcc."Income/Balance"::"Balance Sheet" then begin
                //precCorpGLAcc.SETFILTER("GAAP Adjustment Reason Filter",'<>%1',
                //  precCorpGLAcc."GAAP Adjustment Reason Filter"::Reclassification);
                precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                //precCorpGLAcc.SETRANGE("GAAP Adjustment Reason Filter");

                pdecTaxAdjmtAmt += precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change";
            end;

            pdecTaxTBAmt := pdecStatTBAmt + pdecTaxPrepostAmt + pdecTaxAdjmtAmt;
        end;
    end;

    local procedure lfcnCalcPeriodBottomUpLocal(var precCorpGLAcc: Record "Corporate G/L Account"; var pdecStatTBAmt: Decimal; var pdecTaxPrepostAmt: Decimal; var pdecTaxAdjmtAmt: Decimal; var pdecTaxTBAmt: Decimal; pblnPrevYear: Boolean; var pdecCorpAmt: Decimal; var pdecStatPrepostAmt: Decimal; var pdecStatAdjmtAmt: Decimal)
    var
        lrecGLAcc: Record "G/L Account";
        lrecGLEntry: Record "G/L Entry";
    begin
        // MP 03-12-13
        // MP 23-04-14 Added parameters pdecCorpAmt, pdecStatPrepostAmt and pdecStatAdjmtAmt

        lrecGLAcc.TransferFields(precCorpGLAcc);
        lrecGLAcc."No." := precCorpGLAcc."Local G/L Account No."; // MP 23-04-14
        precCorpGLAcc.CopyFilter("Business Unit Filter", lrecGLAcc."Business Unit Filter");
        precCorpGLAcc.CopyFilter("Date Filter", lrecGLAcc."Date Filter");

        // MP 23-04-14 >>
        if gblnShowLocalGLAcc then begin
            // Calc. Non-Adjustment Net Change
            lrecGLAcc.SetFilter("Global Dimension 1 Filter", '''''|' + grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");

            lrecGLAcc.CalcFields("Balance at Date");
            pdecCorpAmt := lrecGLAcc."Balance at Date";

            // Calc. Group
            lrecGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");

            if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
                lrecGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)");
                pdecStatPrepostAmt := -lrecGLAcc."Preposted Net Change" - lrecGLAcc."Preposted Net Change (Bal.)";
                pdecCorpAmt -= pdecStatPrepostAmt;
            end;

            lrecGLAcc.CalcFields("Net Change");
            pdecStatAdjmtAmt := -lrecGLAcc."Net Change";

            // Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason")
            if lrecGLAcc."Income/Balance" = lrecGLAcc."Income/Balance"::"Balance Sheet" then begin
                lrecGLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code",
                  "GAAP Adjustment Reason", "Posting Date");
                lrecGLEntry.SetRange("G/L Account No.", lrecGLAcc."No.");
                lrecGLAcc.CopyFilter("Business Unit Filter", lrecGLEntry."Business Unit Code");
                lrecGLAcc.CopyFilter("Global Dimension 1 Filter", lrecGLEntry."Global Dimension 1 Code");
                //lrecGLEntry.SETFILTER("GAAP Adjustment Reason",'<>%1',lrecGLEntry."GAAP Adjustment Reason"::Reclassification);
                lrecGLEntry.SetFilter("Posting Date", '<%1', lrecGLAcc.GetRangeMin("Date Filter"));
                lrecGLEntry.CalcSums(Amount); // MP 23-04-14

                pdecStatAdjmtAmt -= lrecGLEntry.Amount;
            end;
        end;
        // MP 23-04-14 <<

        // Calc. Local Statutory TB
        lrecGLAcc.SetFilter("Global Dimension 1 Filter", '''''');

        lrecGLAcc.CalcFields("Balance at Date");
        pdecStatTBAmt := lrecGLAcc."Balance at Date";

        // Calc. Tax
        if gblnIncludeTax then begin
            lrecGLAcc.SetFilter("Global Dimension 1 Filter", grecGenJnlTemplate[2]."Shortcut Dimension 1 Code");
            if gblnIncludePrepostedEntries and not (pblnPrevYear) then begin
                lrecGLAcc.CalcFields("Preposted Net Change", "Preposted Net Change (Bal.)", "Net Change");
                pdecTaxPrepostAmt := lrecGLAcc."Preposted Net Change" + lrecGLAcc."Preposted Net Change (Bal.)";
            end else
                lrecGLAcc.CalcFields("Net Change");

            pdecTaxAdjmtAmt := lrecGLAcc."Net Change";

            // Calculate and add balance at start of period for non-Reclassification entries (BS accounts only) >>
            // MP 08-05-14 Amended below to not exclude Reclassification entries (not filtering on "GAAP Adjustment Reason")
            if lrecGLAcc."Income/Balance" = lrecGLAcc."Income/Balance"::"Balance Sheet" then begin
                lrecGLEntry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code",
                  "GAAP Adjustment Reason", "Posting Date");
                lrecGLEntry.SetRange("G/L Account No.", lrecGLAcc."No.");
                lrecGLAcc.CopyFilter("Business Unit Filter", lrecGLEntry."Business Unit Code");
                lrecGLAcc.CopyFilter("Global Dimension 1 Filter", lrecGLEntry."Global Dimension 1 Code");
                //lrecGLEntry.SETFILTER("GAAP Adjustment Reason",'<>%1',lrecGLEntry."GAAP Adjustment Reason"::Reclassification);
                lrecGLEntry.SetFilter("Posting Date", '<%1', lrecGLAcc.GetRangeMin("Date Filter"));
                lrecGLEntry.CalcSums(Amount); // MP 23-04-14

                pdecTaxAdjmtAmt += lrecGLEntry.Amount;
            end;

            pdecTaxTBAmt := pdecStatTBAmt + pdecTaxPrepostAmt + pdecTaxAdjmtAmt;
        end;
    end;


    procedure gfcnPopulateAccounts(var ptmpCorpGLAcc: Record "Corporate G/L Account" temporary)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
        lcodSequenceNo: Code[20];
        lintSequenceNo: Integer;
    begin
        // MP 03-12-13
        ptmpCorpGLAcc.CopyFilter("Date Filter", lrecCorpGLAcc."Date Filter"); // Retain Date Filter
        ptmpCorpGLAcc.Init();
        ptmpCorpGLAcc.Reset();
        ptmpCorpGLAcc.DeleteAll();
        lrecCorpGLAcc.CopyFilter("Date Filter", ptmpCorpGLAcc."Date Filter");
        //SETCURRENTKEY("Search Name");
        //SETCURRENTKEY("Financial Statement Code"); // MP 23-04-14 Replaces above line
        ptmpCorpGLAcc.SetCurrentKey(Indentation); // MP 25-11-15 Replaces above line

        lcodSequenceNo := '0000000001'; // To ensure correct sorting in temp table

        if not gmdlCompanyTypeMgt.gfcnCorpAccInUse() or gblnShowLocalGLAcc then begin // MP 23-04-14 Added gblnShowLocalGLAcc
                                                                                      // MP 23-04-14 >>
            if gblnShowLocalGLAcc then
                lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
            // MP 23-04-14 <<
            if lrecGLAcc.FindSet() then
                repeat
                    ptmpCorpGLAcc.TransferFields(lrecGLAcc);

                    ptmpCorpGLAcc."Local G/L Account No." := lrecGLAcc."No.";
                    // MP 23-04-14 >>
                    //"Search Name" := lcodSequenceNo;
                    ptmpCorpGLAcc."No." := lcodSequenceNo;
                    ptmpCorpGLAcc."Search Name" := lrecGLAcc."Corporate G/L Account No.";
                    //"Financial Statement Code" := lcodSequenceNo;
                    Evaluate(ptmpCorpGLAcc.Indentation, lcodSequenceNo); // MP 25-11-15 Replaces above line
                                                                         // MP 23-04-14 <<
                    lcodSequenceNo := IncStr(lcodSequenceNo);
                    ptmpCorpGLAcc.Insert();
                until lrecGLAcc.Next() = 0;
        end else begin // MP 25-11-15 Added BEGIN
            if lrecCorpGLAcc.FindSet() then
                repeat
                    if not lrecGLAcc.Get(lrecCorpGLAcc."Local G/L Account No.") then
                        Clear(lrecGLAcc.Blocked);

                    ptmpCorpGLAcc := lrecCorpGLAcc;

                    //"Search Name" := lcodSequenceNo;
                    //"Financial Statement Code" := lcodSequenceNo; // MP 23-04-14 Replaces above line
                    Evaluate(ptmpCorpGLAcc.Indentation, lcodSequenceNo); // MP 03-11-15 Replaces above line
                    lcodSequenceNo := IncStr(lcodSequenceNo);
                    ptmpCorpGLAcc.Insert();
                until lrecCorpGLAcc.Next() = 0;
        end; // MP 25-11-15 Added END

        if ptmpCorpGLAcc.FindFirst() then;
    end;


    procedure gfcnDrillDownAdjmts(var precCorpGLAcc: Record "Corporate G/L Account"; poptField: Option "Prior Year Adjustments","Current Year Adjustments","Current Year Reclassifications")
    var
        lrecGLEntry: Record "G/L Entry";
        lmdlAdjmtsMgt: Codeunit "Adjustments Management";
    begin
        // MP 25-11-15

        case poptField of
            poptField::"Prior Year Adjustments":
                if precCorpGLAcc."Account Class" = precCorpGLAcc."Account Class"::"P&L" then
                    lfcnFilterGLEntryAdmjts(lrecGLEntry, precCorpGLAcc, grecGenJnlTemplate[1]."Shortcut Dimension 1 Code",
                      StrSubstNo('<%1', gdatStartCurrPeriod),
                      '')
                else
                    lfcnFilterGLEntryAdmjts(lrecGLEntry, precCorpGLAcc, grecGenJnlTemplate[1]."Shortcut Dimension 1 Code",
                      StrSubstNo('<%1', gdatStartCurrPeriod),
                      StrSubstNo('<>%1', lrecGLEntry."GAAP Adjustment Reason"::Reclassification));

            poptField::"Current Year Adjustments":
                lfcnFilterGLEntryAdmjts(lrecGLEntry, precCorpGLAcc, grecGenJnlTemplate[1]."Shortcut Dimension 1 Code",
                  StrSubstNo('%1..%2', gdatStartCurrPeriod, gdatEndCurrPeriod),
                  StrSubstNo('<>%1', lrecGLEntry."GAAP Adjustment Reason"::Reclassification));

            poptField::"Current Year Reclassifications":
                lfcnFilterGLEntryAdmjts(lrecGLEntry, precCorpGLAcc, grecGenJnlTemplate[1]."Shortcut Dimension 1 Code",
                  StrSubstNo('%1..%2', gdatStartCurrPeriod + 1, gdatEndCurrPeriod),
                  StrSubstNo('%1', lrecGLEntry."GAAP Adjustment Reason"::Reclassification));
        end;

        lmdlAdjmtsMgt.gfcnShowEntries(lrecGLEntry, gblnIncludePrepostedEntries, true);
    end;

    local procedure lfcnFilterGLEntryAdmjts(var precGLEntry: Record "G/L Entry"; var precCorpGLAcc: Record "Corporate G/L Account"; pcodShortcutDim1Code: Code[20]; ptxtDateFilter: Text; ptxtGAAPAdjmtReasonFilter: Text)
    begin
        // MP 25-11-15
        precGLEntry.SetCurrentKey("Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role", "GAAP Adjustment Reason", "Posting Date");

        precGLEntry.SetRange("Corporate G/L Account No.", precCorpGLAcc."No.");
        precGLEntry.SetRange("Global Dimension 1 Code", pcodShortcutDim1Code);
        precGLEntry.SetFilter("GAAP Adjustment Reason", ptxtGAAPAdjmtReasonFilter);
        precGLEntry.SetFilter("Posting Date", ptxtDateFilter);
        precCorpGLAcc.CopyFilter("Global Dimension 2 Filter", precGLEntry."Global Dimension 2 Code");
        precCorpGLAcc.CopyFilter("Business Unit Filter", precGLEntry."Business Unit Code");
    end;

    local procedure lfcnCheckIfZeroMovementBlocked(var precGLEntry: Record "G/L Entry"; var ptmpCorpGLAcc: Record "Corporate G/L Account" temporary; var precGLAcc: Record "G/L Account")
    var
        lintNoOfRecs: Integer;
    begin
        // MP 25-11-15
        precGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[1]."Shortcut Dimension 1 Code");
        ptmpCorpGLAcc.CopyFilter("Date Filter", precGLEntry."Posting Date");
        if precGLEntry.IsEmpty then begin // No S Adjustments in current period, check if zero balance at end (Corporate GAAP)
            precGLEntry.SetRange("Global Dimension 1 Code", '');
            precGLEntry.SetRange("Posting Date", 0D, gdatEndCurrPeriod);
            precGLEntry.CalcSums(Amount);

            if precGLEntry.Amount = 0 then
                ptmpCorpGLAcc."No. of Blank Lines" := 1
            else
                ptmpCorpGLAcc."No. of Blank Lines" := 0;
        end else begin // Entries exists for current period, check if they are purely reversals of Reclassification entries
            lintNoOfRecs := ptmpCorpGLAcc.Count;
            precGLEntry.SetRange("GAAP Adjustment Reason", precGLEntry."GAAP Adjustment Reason"::Reclassification);
            precGLEntry.SetRange("Posting Date", gdatStartCurrPeriod);
            if ptmpCorpGLAcc.Count = lintNoOfRecs then
                ptmpCorpGLAcc."No. of Blank Lines" := 0
            else
                ptmpCorpGLAcc."No. of Blank Lines" := 1;
            precGLEntry.SetRange("GAAP Adjustment Reason");
        end;

        if precGLAcc.Blocked then
            ptmpCorpGLAcc."No. of Blank Lines" += 10;
    end;


    procedure gfcnFilterZeroMovementBlocked(var precCorpGLAcc: Record "Corporate G/L Account"; poptExcludeAccounts: Option " ","Zero Movement",Blocked,"Zero Movement and Blocked")
    var
        lrecGLAcc: Record "G/L Account";
        lrecGLEntry: Record "G/L Entry";
        ltmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary;
        lmdlAdjustmentsMgt: Codeunit "Adjustments Management";
        ldecCorpAmt: array[2] of Decimal;
        ldecStatPrepostAmt: array[2] of Decimal;
        ldecStatAdjmtAmt: array[2] of Decimal;
        ldecAuditorAdjmtAmt: array[2] of Decimal;
        ldecStatTBAmt: array[2] of Decimal;
        ldecTaxPrepostAmt: array[2] of Decimal;
        ldecTaxAdjmtAmt: array[2] of Decimal;
        ldecTaxTBAmt: array[2] of Decimal;
        ldecPriorYearAdjmtAmt: Decimal;
        ldecCurrYearAdjmtAmt: Decimal;
        ldecCurrYearReclassAmt: Decimal;
        lintPrevValue: Integer;
        lcodFSCode: array[2] of Code[10];
        ltxtFSDescription: array[2] of Text[100];
        lblnExclude: Boolean;
    begin
        // MP 25-11-15
        precCorpGLAcc.ClearMarks();
        precCorpGLAcc.MarkedOnly(false);
        if poptExcludeAccounts <> poptExcludeAccounts::" " then begin
            if poptExcludeAccounts in [poptExcludeAccounts::"Zero Movement", poptExcludeAccounts::"Zero Movement and Blocked"] then begin
                lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role", "GAAP Adjustment Reason", "Posting Date");
                lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[1]."Shortcut Dimension 1 Code");
            end;

            if precCorpGLAcc.FindSet() then begin
                repeat
                    lblnExclude := false;

                    if poptExcludeAccounts in [poptExcludeAccounts::"Zero Movement", poptExcludeAccounts::"Zero Movement and Blocked"] then begin
                        gfcnCalc(precCorpGLAcc, ldecCorpAmt, ldecStatPrepostAmt, ldecStatAdjmtAmt, ldecAuditorAdjmtAmt, ldecStatTBAmt,
                          ldecTaxPrepostAmt, ldecTaxAdjmtAmt, ldecTaxTBAmt, ldecPriorYearAdjmtAmt, ldecCurrYearAdjmtAmt, ldecCurrYearReclassAmt,
                          lcodFSCode, ltxtFSDescription);

                        if (ldecCorpAmt[1] = 0) and (ldecPriorYearAdjmtAmt = 0) and (ldecCurrYearAdjmtAmt = 0) and (ldecCurrYearReclassAmt = 0) then begin
                            // Check if any entries exists, negative/positive of same amount, for non-Reclassification
                            lrecGLEntry.SetRange("Corporate G/L Account No.", precCorpGLAcc."No.");
                            lrecGLEntry.SetRange("Posting Date", gdatStartCurrPeriod, gdatEndCurrPeriod);
                            lrecGLEntry.SetFilter("GAAP Adjustment Reason", '<>%1', lrecGLEntry."GAAP Adjustment Reason"::Reclassification);

                            lmdlAdjustmentsMgt.gfcnGetEntries(ltmpAdjmtEntryBuffer, lrecGLEntry, true, false);
                            if not gblnIncludePrepostedEntries then
                                ltmpAdjmtEntryBuffer.SetFilter("G/L Entry No.", '<>%1', 0);

                            if ltmpAdjmtEntryBuffer.IsEmpty then begin
                                // Check if any entries exists, negative/positive of same amount, for Reclassification
                                lrecGLEntry.SetRange("Posting Date", gdatStartCurrPeriod + 1, gdatEndCurrPeriod);
                                lrecGLEntry.SetFilter("GAAP Adjustment Reason", '%1', lrecGLEntry."GAAP Adjustment Reason"::Reclassification);

                                lmdlAdjustmentsMgt.gfcnGetEntries(ltmpAdjmtEntryBuffer, lrecGLEntry, true, false);
                                if not gblnIncludePrepostedEntries then
                                    ltmpAdjmtEntryBuffer.SetFilter("G/L Entry No.", '<>%1', 0);

                                if ltmpAdjmtEntryBuffer.IsEmpty then
                                    lblnExclude := true;
                            end
                        end;
                    end;

                    if poptExcludeAccounts in [poptExcludeAccounts::Blocked, poptExcludeAccounts::"Zero Movement and Blocked"] then
                        if lrecGLAcc.Get(precCorpGLAcc."Local G/L Account No.") then
                            if lrecGLAcc.Blocked then
                                lblnExclude := true;

                    if not lblnExclude then
                        precCorpGLAcc.Mark(true);

                until precCorpGLAcc.Next() = 0;
                precCorpGLAcc.MarkedOnly(true);
                if precCorpGLAcc.FindFirst() then;
            end;
        end;
    end;
}

