codeunit 60012 "GAAP Mgt. -Financial Statement"
{
    // MP 09-05-12
    // Fixed issue with Expand/Collapse buttons disappearing from corresponding page
    // 
    // MP 10-05-12
    // Changed the population of Description to include G/L Account No.
    // 
    // MP 05-02-13
    // Amended to include simulation of year end for S and T Adjustments into retained earnings and exlude
    // these entries from P&L accounts
    // 
    // MP 27-03-13
    // Fixed issue with calculation of expressions
    // 
    // MP 16-05-13
    // Removed functionality developed 05-02-13, deleted function lfcnCalcCorpRetEarningsAdjmts (case 13851)
    // 
    // MP 03-12-13
    // Amended to support bottom-up companies (CR 30)
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup
    // 
    // MP 21-05-14
    // Fixed issue with Begin/End Totals for bottom-up companies
    // 
    // MP 01-12-14
    // NAV 2013 R2 Upgrade
    // 
    // MP 18-11-15
    // Added functionality to include unposted entries. Changed variables to use temp. G/L Account and Corporate G/L Accounts, in order to support
    // period-driven Financial Statement Codes. Added function lfcnInsertTempAccounts. (CB1 Enhancements)
    // 
    // MP 22-02-16
    // Fixed issue with system not showing previous year FS Code for Local accounts (CB1 Enhancements)


    trigger OnRun()
    begin
    end;

    var
        grecFinStatStructure: Record "Financial Statement Structure";
        gtmpCorpGLAcc: Record "Corporate G/L Account" temporary;
        gtmpGLAcc: Record "G/L Account" temporary;
        gmdlEvaluateExpr: Codeunit "Evaluate Expression";
        gcodFinStatStructureCode: Code[20];
        gtxtAdjmtDimFilter: Text[30];
        gtxtAdjmtDimFilterLocal: Text[30];
        goptViewAccounts: Option "Local",Corporate,Both;
        goptCorpStatementType: Option " ","Group Financial Statement","Statutory Financial Statement","Tax Financial Statement";
        gdatStart: Date;
        gdatEnd: Date;
        txt60000: Label 'Balance %1';
        gdatPriorPeriodEnd: Date;
        gdecRoundingPrecision: Date;
        gintLineNo: Integer;
        txt60001: Label '%1\\Formula: %2\\Error in calculation: %3';
        txt60002: Label 'The maximum number of nested Begin/End-Totals is %1';
        txt60003: Label 'Mismatch in number of Begin/End-Totals';
        gblnBottomUp: Boolean;
        gblnIncludeUnpostedEntries: Boolean;


    procedure gfcnInit(pcodFinStatStructureCode: Code[20]; pdatStart: Date; pdatEnd: Date; poptViewAccounts: Option "Local",Corporate,Both; poptCorpStatementType: Option " ","Group Financial Statement","Statutory Financial Statement","Tax Financial Statement"; pblnIncludeUnpostedEntries: Boolean)
    var
        lmdlGAAPMgtGlobalView: Codeunit "GAAP Mgt. - Global View";
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
        ldatTemp: Date;
    begin
        gcodFinStatStructureCode := pcodFinStatStructureCode;

        grecFinStatStructure.Get(gcodFinStatStructureCode); // MP 03-12-13

        gdatStart := ClosingDate(pdatStart - 1);
        gdatEnd := pdatEnd;

        gblnBottomUp := lmdlCompanyTypeMgt.gfcnIsBottomUp();

        lmdlGAAPMgtGlobalView.gfcnGetAccPeriodFilter(pdatStart - 1, gdatPriorPeriodEnd, ldatTemp);
        gdatPriorPeriodEnd := gdatPriorPeriodEnd - 1;

        goptViewAccounts := poptViewAccounts;
        goptCorpStatementType := poptCorpStatementType;

        // MP 18-11-15 >>
        gblnIncludeUnpostedEntries := pblnIncludeUnpostedEntries;
        lfcnInsertTempAccounts();
        // MP 18-11-15 <<

        lfcnSetCorpAccAdjmtFilter();
        lfcnSetLocalAccAdjmtFilter(); // MP 03-12-13

        // MP 16-05-13 Removed >>
        // MP 05-02-13 >>

        //grecEYCoreSetup.GET;
        //grecEYCoreSetup.TESTFIELD("Corp. Retained Earnings Acc.");
        //
        //grecCorpAccountingPeriodPrev.GET(pdatStart);
        //IF grecCorpAccountingPeriodPrev.NEXT(-1) = 0 THEN
        //  CLEAR(grecCorpAccountingPeriodPrev);

        // MP 05-02-13 <<
        // MP 16-05-13 Removed <<
    end;


    procedure gfcnGetCaptions(var ptxtStartBalanceCaption: Text[30]; var ptxtEndBalanceCaption: Text[30])
    begin
        ptxtStartBalanceCaption := StrSubstNo(txt60000, Format(gdatStart, 0, '<Day,2>-<Month,2>-<Year4>'));
        ptxtEndBalanceCaption := StrSubstNo(txt60000, Format(gdatEnd, 0, '<Day,2>-<Month,2>-<Year4>'));
    end;

    local procedure lfcnSetCorpAccAdjmtFilter()
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
    begin
        if goptCorpStatementType = goptCorpStatementType::" " then
            exit;

        gtxtAdjmtDimFilter := '''''';
        //gtxtAdjmtDimFilterExclBlank := ''; // MP 05-02-13 // MP 16-05-13 Removed

        if goptCorpStatementType > goptCorpStatementType::"Group Financial Statement" then begin
            // MP 03-12-13 >>
            if gblnBottomUp then begin
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"19");
                lrecGenJnlTemplate.FindFirst();
                gtxtAdjmtDimFilter += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code";
            end else begin
                // MP 03-12-13 <<
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Tax Adjustments");
                lrecGenJnlTemplate.FindFirst();
                gtxtAdjmtDimFilter += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code";
                //gtxtAdjmtDimFilterExclBlank := lrecGenJnlTemplate."Shortcut Dimension 1 Code"; // MP 05-02-13  // MP 16-05-13 Removed
            end; // MP 03-12-13

            if goptCorpStatementType = goptCorpStatementType::"Tax Financial Statement" then begin
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
                lrecGenJnlTemplate.FindFirst();
                gtxtAdjmtDimFilter += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code";
                //gtxtAdjmtDimFilterExclBlank += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code"; // MP 05-02-13  // MP 16-05-13 Removed
            end;
        end;
    end;


    procedure gfcnCalc(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary)
    var
        lrecFinancialStatementLine: Record "Financial Statement Line";
        lrecFinStatManualEntry: Record "Financial Stat. Manual Entry";
        ldecStartBalanceSubtotal: Decimal;
        ldecEndBalanceSubtotal: Decimal;
        ldecPriorPeriodSubtotal: Decimal;
        lintLineNoPosting: Integer;
    begin
        ptmpFinancialStatementLine.Reset();
        ptmpFinancialStatementLine.DeleteAll();

        lrecFinancialStatementLine.SetRange("Financial Stat. Structure Code", gcodFinStatStructureCode);
        lrecFinancialStatementLine.FindSet();
        repeat
            ptmpFinancialStatementLine := lrecFinancialStatementLine;
            gintLineNo += 10000;
            ptmpFinancialStatementLine."Line No." := gintLineNo;

            // MP 03-12-13 Add Manual Balances >>
            if ptmpFinancialStatementLine."Line Type" = ptmpFinancialStatementLine."Line Type"::"Manual Entry" then begin
                lrecFinStatManualEntry.SetRange("Financial Stat. Structure Code", lrecFinancialStatementLine."Financial Stat. Structure Code");
                lrecFinStatManualEntry.SetRange("Financial Stat. Line No.", lrecFinancialStatementLine."Line No.");
                lrecFinStatManualEntry.SetRange(Date, gdatStart, gdatEnd);
                lrecFinStatManualEntry.CalcSums("Start Balance", "End Balance");

                lfcnPopulateBalances(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                  lrecFinStatManualEntry."Start Balance", lrecFinStatManualEntry."End Balance", 0);
            end;
            // MP 03-12-13 <<

            ptmpFinancialStatementLine.Insert();

            if (ptmpFinancialStatementLine."Line Type" = ptmpFinancialStatementLine."Line Type"::Posting) and (ptmpFinancialStatementLine.Code <> '') then begin
                lintLineNoPosting := gintLineNo;
                ldecStartBalanceSubtotal := 0;
                ldecEndBalanceSubtotal := 0;
                ldecPriorPeriodSubtotal := 0;

                if ptmpFinancialStatementLine.Type = ptmpFinancialStatementLine.Type::"Financial Statement Code" then
                    case goptViewAccounts of
                        goptViewAccounts::"Local":
                            lfcnCalcPostingLocalAcc(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                              ldecStartBalanceSubtotal, ldecEndBalanceSubtotal, ldecPriorPeriodSubtotal);

                        goptViewAccounts::Corporate:
                            lfcnCalcPostingCorpAcc(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                              ldecStartBalanceSubtotal, ldecEndBalanceSubtotal, ldecPriorPeriodSubtotal);

                        goptViewAccounts::Both:
                            // MP 03-12-13 >>
                            if gblnBottomUp then
                                lfcnCalcPostingBothAccBottomUp(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                                  ldecStartBalanceSubtotal, ldecEndBalanceSubtotal, ldecPriorPeriodSubtotal)
                            else
                                // MP 03-12-13 <<
                                lfcnCalcPostingBothAcc(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                        ldecStartBalanceSubtotal, ldecEndBalanceSubtotal, ldecPriorPeriodSubtotal);
                    end
                else
                    lfcnCalcPostingCorpAccGroup(ptmpFinancialStatementLine, lrecFinancialStatementLine,
                      ldecStartBalanceSubtotal, ldecEndBalanceSubtotal, ldecPriorPeriodSubtotal);

                ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, lintLineNoPosting);
                ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceSubtotal;
                ptmpFinancialStatementLine."End Balance" := ldecEndBalanceSubtotal;
                ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodSubtotal;
                ptmpFinancialStatementLine.Modify();
            end;
        until lrecFinancialStatementLine.Next() = 0;

        lfcnCalcTotals(ptmpFinancialStatementLine);
        lfcnCalcFormulas(ptmpFinancialStatementLine);
        lfcnCalcBeginEndTotals(ptmpFinancialStatementLine);
        lfcnCalcFormulas(ptmpFinancialStatementLine); // Re-calc, in case any formulas refer to End-Totals or other Formulas
        lfcnCalcBeginEndTotals(ptmpFinancialStatementLine); // Re-calc, in case formulas above are part of Begin/End Totals

        ptmpFinancialStatementLine.FindFirst();
    end;

    local procedure lfcnCalcPostingLocalAcc(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal)
    var
        ltmpGLAcc: Record "G/L Account" temporary;
        ltmpGLAccPriorPeriod: Record "G/L Account" temporary;
        ldecUnPostedAmount: Decimal;
        lblnCalcPriorPeriod: Boolean;
    begin
        // MP 18-11-15 >>
        ltmpGLAcc.Copy(gtmpGLAcc, true);
        ltmpGLAccPriorPeriod.Copy(gtmpGLAcc, true);
        // MP 18-11-15 <<

        ltmpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
        // MP 22-02-16 >>
        //ltmpGLAcc.SETCURRENTKEY("Financial Statement Code");
        //ltmpGLAcc.SETRANGE("Financial Statement Code",precFinancialStatementLineCurr.Code);
        ltmpGLAcc.SetCurrentKey("Search Name");
        ltmpGLAcc.SetFilter("Search Name", StrSubstNo('*{%1}*', precFinancialStatementLineCurr.Code));
        // MP 22-02-16 <<

        lblnCalcPriorPeriod := ptmpFinancialStatementLine."Row No." <> '';
        if lblnCalcPriorPeriod then // May be included in formula using previous period figure, i.e. [ROWNO]
            ltmpGLAccPriorPeriod.SetRange("Date Filter", 0D, gdatPriorPeriodEnd);

        ltmpGLAcc.SetFilter("Global Dimension 1 Filter", gtxtAdjmtDimFilterLocal); // MP 02-12-13

        if ltmpGLAcc.FindSet() then begin
            repeat
                ptmpFinancialStatementLine.Init();

                ptmpFinancialStatementLine."Line Type" := ptmpFinancialStatementLine."Line Type"::Posting;
                ptmpFinancialStatementLine."G/L Account No." := ltmpGLAcc."No.";
                ptmpFinancialStatementLine.Code := precFinancialStatementLineCurr.Code;

                ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc.Name; // MP 10-05-12 Added "G/L Account No."
                if ltmpGLAcc."Name (English)" <> '' then  // MP 10-05-12 Added condition and "G/L Account No." below
                    ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc."Name (English)";

                ptmpFinancialStatementLine.Indentation := 1;

                gintLineNo += 10000;
                ptmpFinancialStatementLine."Line No." := gintLineNo;

                // MP 18-11-15 >>
                if gblnIncludeUnpostedEntries then begin
                    ltmpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecUnPostedAmount := ltmpGLAcc."Preposted Net Change" + ltmpGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    ldecUnPostedAmount := 0;
                    // MP 18-11-15 <<

                    ltmpGLAcc.CalcFields("Balance at Date", "Net Change");
                end; // MP 18-11-15

                if lblnCalcPriorPeriod then begin
                    ltmpGLAccPriorPeriod."No." := ltmpGLAcc."No.";
                    ltmpGLAccPriorPeriod.CalcFields("Balance at Date");
                end;

                // MP 18-11-15 >>
                if StrPos(ltmpGLAcc."Search Name", '}{') > 0 then // FS Code is different between periods, i.e. there are two FS Codes in Search Name
                    if precFinancialStatementLineCurr.Code = ltmpGLAcc."Financial Statement Code" then begin
                        ltmpGLAcc."Net Change" := ltmpGLAcc."Balance at Date";
                        ltmpGLAccPriorPeriod."Balance at Date" := 0;
                    end else begin
                        ltmpGLAcc."Net Change" := ltmpGLAcc."Net Change" - ltmpGLAcc."Balance at Date";
                        ltmpGLAcc."Balance at Date" := 0;
                        ldecUnPostedAmount := 0;
                    end;
                // MP 18-11-15 <<

                lfcnPopulateBalances(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
                  ltmpGLAcc."Balance at Date" - ltmpGLAcc."Net Change",
                  //ltmpGLAcc."Balance at Date",
                  ltmpGLAcc."Balance at Date" + ldecUnPostedAmount, // MP 18-11-15 Replaces above line
                  ltmpGLAccPriorPeriod."Balance at Date");

                pdecStartBalanceSubtotal += ptmpFinancialStatementLine."Start Balance";
                pdecEndBalanceSubtotal += ptmpFinancialStatementLine."End Balance";
                pdecPriorPeriodSubtotal += ptmpFinancialStatementLine."Prior Period Balance";

                ptmpFinancialStatementLine.Insert();

            until ltmpGLAcc.Next() = 0;
        end;
    end;

    local procedure lfcnCalcPostingCorpAcc(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal)
    var
        ltmpCorpGLAcc: Record "Corporate G/L Account" temporary;
        ltmpCorpGLAccPriorPeriod: Record "Corporate G/L Account" temporary;
    begin
        // MP 18-11-15 >>
        ltmpCorpGLAcc.Copy(gtmpCorpGLAcc, true);
        ltmpCorpGLAccPriorPeriod.Copy(gtmpCorpGLAcc, true);

        //ltmpCorpGLAcc.SETCURRENTKEY("Financial Statement Code");
        //ltmpCorpGLAcc.SETRANGE("Financial Statement Code",precFinancialStatementLineCurr.Code);

        ltmpCorpGLAcc.SetCurrentKey("Search Name");
        ltmpCorpGLAcc.SetFilter("Search Name", StrSubstNo('*{%1}*', precFinancialStatementLineCurr.Code));

        // MP 18-11-15 <<

        ltmpCorpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
        ltmpCorpGLAcc.SetFilter("Global Dimension 1 Filter", gtxtAdjmtDimFilter);

        if ptmpFinancialStatementLine."Row No." <> '' then // May be included in formula using previous period figure, i.e. [ROWNO]
            ltmpCorpGLAccPriorPeriod.SetRange("Date Filter", 0D, gdatPriorPeriodEnd);

        lfcnInsertCorpAccounts(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
          pdecStartBalanceSubtotal, pdecEndBalanceSubtotal, pdecPriorPeriodSubtotal,
          ltmpCorpGLAcc, ltmpCorpGLAccPriorPeriod);
    end;

    local procedure lfcnCalcPostingBothAcc(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal)
    var
        ltmpCorpGLAcc: Record "Corporate G/L Account" temporary;
        ltmpCorpGLAccPriorPeriod: Record "Corporate G/L Account" temporary;
        ltmpGLAcc: Record "G/L Account" temporary;
        ldecStartBalanceSubtotalLocal: Decimal;
        ldecEndBalanceSubtotalLocal: Decimal;
        ldecPriorPeriodSubtotalLocal: Decimal;
        lcodPrevLocalGLAccNo: Code[20];
        ldecUnPostedAmount: Decimal;
        lintLineNoLocalGLAcc: Integer;
        lblnCalcPriorPeriod: Boolean;
    begin
        // MP 18-11-15 >>
        ltmpCorpGLAcc.Copy(gtmpCorpGLAcc, true);
        ltmpCorpGLAccPriorPeriod.Copy(gtmpCorpGLAcc, true);
        ltmpGLAcc.Copy(gtmpGLAcc, true);
        // MP 18-11-15 <<

        // MP 22-02-16 >>
        //ltmpCorpGLAcc.SETCURRENTKEY("Financial Statement Code","Local G/L Account No.");
        //ltmpCorpGLAcc.SETRANGE("Financial Statement Code",precFinancialStatementLineCurr.Code);

        ltmpCorpGLAcc.SetCurrentKey("Search Name", "Local G/L Account No.");
        ltmpCorpGLAcc.SetFilter("Search Name", StrSubstNo('*{%1}*', precFinancialStatementLineCurr.Code));
        // MP 22-02-16 <<

        ltmpCorpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
        ltmpCorpGLAcc.SetFilter("Global Dimension 1 Filter", gtxtAdjmtDimFilter);

        // MP 16-05-13 Removed >>
        // MP 05-02-13 >>

        //ltmpCorpGLAccPriorPeriodAdjmt.COPY(ltmpCorpGLAcc);
        //IF grecCorpAccountingPeriodPrev.Closed THEN
        //  ltmpCorpGLAccPriorPeriodAdjmt.SETRANGE("Date Filter",gdatPriorPeriodEnd + 1,gdatStart)
        //ELSE
        //  ltmpCorpGLAccPriorPeriodAdjmt.SETRANGE("Date Filter",0D,gdatPriorPeriodEnd);
        //ltmpCorpGLAccPriorPeriodAdjmt.SETFILTER("Global Dimension 1 Filter",gtxtAdjmtDimFilterExclBlank);

        // MP 05-02-13 <<
        // MP 16-05-13 Removed <<

        lblnCalcPriorPeriod := ptmpFinancialStatementLine."Row No." <> '';
        if lblnCalcPriorPeriod then // May be included in formula using previous period figure, i.e. [ROWNO]
            ltmpCorpGLAccPriorPeriod.SetRange("Date Filter", 0D, gdatPriorPeriodEnd);

        if ltmpCorpGLAcc.FindSet() then begin
            repeat
                // Update figures on Local G/L Account
                if (lcodPrevLocalGLAccNo <> ltmpCorpGLAcc."Local G/L Account No.") and (lintLineNoLocalGLAcc <> 0) then begin
                    ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, lintLineNoLocalGLAcc);
                    ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceSubtotalLocal;
                    ptmpFinancialStatementLine."End Balance" := ldecEndBalanceSubtotalLocal;
                    ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodSubtotalLocal;
                    ptmpFinancialStatementLine.Modify();

                    ldecStartBalanceSubtotalLocal := 0;
                    ldecEndBalanceSubtotalLocal := 0;
                    ldecPriorPeriodSubtotalLocal := 0;
                end;

                ptmpFinancialStatementLine.Init();
                ptmpFinancialStatementLine."Line Type" := ptmpFinancialStatementLine."Line Type"::Posting;
                ptmpFinancialStatementLine.Code := precFinancialStatementLineCurr.Code;

                ptmpFinancialStatementLine."G/L Account No." := ltmpCorpGLAcc."Local G/L Account No.";

                if lcodPrevLocalGLAccNo <> ltmpCorpGLAcc."Local G/L Account No." then begin
                    ltmpCorpGLAcc.TestField("Local G/L Account No.");
                    ltmpGLAcc.Get(ltmpCorpGLAcc."Local G/L Account No.");

                    ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc.Name; // MP 10-05-12 Added "G/L Account No."
                    if ltmpGLAcc."Name (English)" <> '' then // MP 10-05-12 Added condition and "G/L Account No." below
                        ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc."Name (English)";

                    ptmpFinancialStatementLine.Indentation := 1;

                    gintLineNo += 10000;
                    ptmpFinancialStatementLine."Line No." := gintLineNo;
                    ptmpFinancialStatementLine.Insert();

                    lintLineNoLocalGLAcc := ptmpFinancialStatementLine."Line No.";
                end;

                ptmpFinancialStatementLine."Corporate G/L Account No." := ltmpCorpGLAcc."No.";

                ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + ltmpCorpGLAcc.Name; // MP 10-05-12 Added "Corporate G/L Account No."
                if ltmpCorpGLAcc."Name (English)" = '' then // MP 10-05-12 Added condition "Corporate G/L Account No."
                    ptmpFinancialStatementLine."Description (English)" := ''
                else
                    ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + ltmpCorpGLAcc."Name (English)";

                ptmpFinancialStatementLine.Indentation := 2;

                gintLineNo += 10000;
                ptmpFinancialStatementLine."Line No." := gintLineNo;

                // MP 18-11-15 >>
                if gblnIncludeUnpostedEntries then begin
                    ltmpCorpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecUnPostedAmount := ltmpCorpGLAcc."Preposted Net Change" + ltmpCorpGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    ldecUnPostedAmount := 0;
                    // MP 18-11-15 <<

                    ltmpCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                end; // MP 18-11-15

                if lblnCalcPriorPeriod then begin
                    ltmpCorpGLAccPriorPeriod."No." := ltmpCorpGLAcc."No.";
                    ltmpCorpGLAccPriorPeriod.CalcFields("Balance at Date");
                end;

                // MP 18-11-15 >>
                if StrPos(ltmpCorpGLAcc."Search Name", '}{') > 0 then // FS Code is different between periods, i.e. there are two FS Codes in Search Name
                    if precFinancialStatementLineCurr.Code = ltmpCorpGLAcc."Financial Statement Code" then begin
                        ltmpCorpGLAcc."Net Change" := ltmpCorpGLAcc."Balance at Date";
                        ltmpCorpGLAccPriorPeriod."Balance at Date" := 0;
                    end else begin
                        ltmpCorpGLAcc."Net Change" := ltmpCorpGLAcc."Net Change" - ltmpCorpGLAcc."Balance at Date";
                        ltmpCorpGLAcc."Balance at Date" := 0;
                        ldecUnPostedAmount := 0;
                    end;
                // MP 18-11-15 <<

                // MP 16-05-13 Removed >>
                // MP 05-02-13 >>

                //IF (ltmpCorpGLAcc."No." = grecEYCoreSetup."Corp. Retained Earnings Acc.") AND
                //  (goptCorpStatementType > goptCorpStatementType::"Group Financial Statement")
                //THEN BEGIN
                //  lfcnCalcCorpRetEarningsAdjmts(ldecRetainedEarningsAdjmts);
                //
                //  lfcnPopulateBalances(ptmpFinancialStatementLine,precFinancialStatementLineCurr,
                //    ltmpCorpGLAcc."Balance at Date" - ltmpCorpGLAcc."Net Change" + ldecRetainedEarningsAdjmts[2],
                //    ltmpCorpGLAcc."Balance at Date" + ldecRetainedEarningsAdjmts[1],
                //    ltmpCorpGLAccPriorPeriod."Balance at Date" + ldecRetainedEarningsAdjmts[2]);
                //END ELSE
                //  IF (ltmpCorpGLAcc."Account Class" = ltmpCorpGLAcc."Account Class"::"P&L") AND
                //    (goptCorpStatementType > goptCorpStatementType::"Group Financial Statement")
                //  THEN BEGIN
                //    ltmpCorpGLAccPriorPeriodAdjmt."No." := ltmpCorpGLAcc."No.";
                //    ltmpCorpGLAccPriorPeriodAdjmt.CALCFIELDS("Balance at Date","Net Change");
                //
                //    IF grecCorpAccountingPeriodPrev.Closed THEN
                //      ldecPLAdjmts := ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date" - ltmpCorpGLAccPriorPeriodAdjmt."Net Change"
                //    ELSE
                //      ldecPLAdjmts := ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date";
                //
                //    lfcnPopulateBalances(ptmpFinancialStatementLine,precFinancialStatementLineCurr,
                //      ltmpCorpGLAcc."Balance at Date" - ltmpCorpGLAcc."Net Change" - ldecPLAdjmts,
                //      ltmpCorpGLAcc."Balance at Date" - ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date",
                //      ltmpCorpGLAccPriorPeriod."Balance at Date");
                //  END ELSE

                // MP 05-02-13 <<
                // MP 16-05-13 Removed <<

                lfcnPopulateBalances(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
                  ltmpCorpGLAcc."Balance at Date" - ltmpCorpGLAcc."Net Change",
                  //ltmpCorpGLAcc."Balance at Date",
                  ltmpCorpGLAcc."Balance at Date" + ldecUnPostedAmount, // MP 18-11-15 Replaces above line
                  ltmpCorpGLAccPriorPeriod."Balance at Date");

                ldecStartBalanceSubtotalLocal += ptmpFinancialStatementLine."Start Balance";
                ldecEndBalanceSubtotalLocal += ptmpFinancialStatementLine."End Balance";
                ldecPriorPeriodSubtotalLocal += ptmpFinancialStatementLine."Prior Period Balance";

                pdecStartBalanceSubtotal += ptmpFinancialStatementLine."Start Balance";
                pdecEndBalanceSubtotal += ptmpFinancialStatementLine."End Balance";
                pdecPriorPeriodSubtotal += ptmpFinancialStatementLine."Prior Period Balance";

                ptmpFinancialStatementLine.Insert();

                lcodPrevLocalGLAccNo := ltmpCorpGLAcc."Local G/L Account No.";
            until ltmpCorpGLAcc.Next() = 0;

            // Update figures on Local G/L Account
            if lintLineNoLocalGLAcc <> 0 then begin
                ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, lintLineNoLocalGLAcc);
                ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceSubtotalLocal;
                ptmpFinancialStatementLine."End Balance" := ldecEndBalanceSubtotalLocal;
                ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodSubtotalLocal;
                ptmpFinancialStatementLine.Modify();
            end;

        end;
    end;

    local procedure lfcnCalcPostingCorpAccGroup(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal)
    var
        ltmpCorpGLAcc: Record "Corporate G/L Account" temporary;
        ltmpCorpGLAccPriorPeriod: Record "Corporate G/L Account" temporary;
        lrecCorpGLAccGrLine: Record "Corporate G/L Account Gr. Line";
    begin
        lrecCorpGLAccGrLine.SetRange("Corp. G/L Account Group Code", ptmpFinancialStatementLine.Code);
        lrecCorpGLAccGrLine.SetFilter("Corporate G/L Account Filter", '<>%1', '');
        if not lrecCorpGLAccGrLine.FindSet() then
            exit;

        ltmpCorpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
        ltmpCorpGLAcc.SetFilter("Global Dimension 1 Filter", gtxtAdjmtDimFilter);

        if ptmpFinancialStatementLine."Row No." <> '' then // May be included in formula using previous period figure, i.e. [ROWNO]
            ltmpCorpGLAccPriorPeriod.SetRange("Date Filter", 0D, gdatPriorPeriodEnd);

        repeat
            ltmpCorpGLAcc.SetFilter("No.", lrecCorpGLAccGrLine."Corporate G/L Account Filter");

            lfcnInsertCorpAccounts(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
              pdecStartBalanceSubtotal, pdecEndBalanceSubtotal, pdecPriorPeriodSubtotal,
              ltmpCorpGLAcc, ltmpCorpGLAccPriorPeriod);

        until lrecCorpGLAccGrLine.Next() = 0;
    end;

    local procedure lfcnInsertCorpAccounts(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal; var precCorpGLAcc: Record "Corporate G/L Account"; var precCorpGLAccPriorPeriod: Record "Corporate G/L Account")
    var
        lblnCalcPriorPeriod: Boolean;
        ldecUnPostedAmount: Decimal;
    begin
        lblnCalcPriorPeriod := precCorpGLAccPriorPeriod.GetFilter("Date Filter") <> '';

        // MP 16-05-13 Removed >>
        // MP 05-02-13 >>

        //ltmpCorpGLAccPriorPeriodAdjmt.COPY(precCorpGLAcc);
        //IF grecCorpAccountingPeriodPrev.Closed THEN
        //  ltmpCorpGLAccPriorPeriodAdjmt.SETRANGE("Date Filter",gdatPriorPeriodEnd + 1,gdatStart)
        //ELSE
        //  ltmpCorpGLAccPriorPeriodAdjmt.SETRANGE("Date Filter",0D,gdatPriorPeriodEnd);
        //ltmpCorpGLAccPriorPeriodAdjmt.SETFILTER("Global Dimension 1 Filter",gtxtAdjmtDimFilterExclBlank);

        // MP 05-02-13 <<
        // MP 16-05-13 Removed <<

        if precCorpGLAcc.FindSet() then
            repeat
                ptmpFinancialStatementLine.Init();

                ptmpFinancialStatementLine."Line Type" := ptmpFinancialStatementLine."Line Type"::Posting;
                ptmpFinancialStatementLine."Corporate G/L Account No." := precCorpGLAcc."No.";
                ptmpFinancialStatementLine."G/L Account No." := precCorpGLAcc."Local G/L Account No.";
                ptmpFinancialStatementLine.Code := precFinancialStatementLineCurr.Code;

                ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + precCorpGLAcc.Name; // MP 10-05-12 Added "Corporate G/L Account No."
                if precCorpGLAcc."Name (English)" <> '' then // MP 10-05-12 Added condition and "Corporate G/L Account No." below
                    ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + precCorpGLAcc."Name (English)";

                ptmpFinancialStatementLine.Indentation := 1;

                gintLineNo += 10000;
                ptmpFinancialStatementLine."Line No." := gintLineNo;

                // MP 18-11-15 >>
                if gblnIncludeUnpostedEntries then begin
                    precCorpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecUnPostedAmount := precCorpGLAcc."Preposted Net Change" + precCorpGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    ldecUnPostedAmount := 0;
                    // MP 18-11-15 <<

                    precCorpGLAcc.CalcFields("Balance at Date", "Net Change");
                end; // MP 18-11-15

                if lblnCalcPriorPeriod then begin
                    precCorpGLAccPriorPeriod."No." := precCorpGLAcc."No.";
                    precCorpGLAccPriorPeriod.CalcFields("Balance at Date");
                end;

                // MP 18-11-15 >>
                if StrPos(precCorpGLAcc."Search Name", '}{') > 0 then // FS Code is different between periods, i.e. there are two FS Codes in Search Name
                    if precFinancialStatementLineCurr.Code = precCorpGLAcc."Financial Statement Code" then begin
                        precCorpGLAcc."Net Change" := precCorpGLAcc."Balance at Date";
                        precCorpGLAccPriorPeriod."Balance at Date" := 0;
                    end else begin
                        precCorpGLAcc."Net Change" := precCorpGLAcc."Net Change" - precCorpGLAcc."Balance at Date";
                        precCorpGLAcc."Balance at Date" := 0;
                        ldecUnPostedAmount := 0;
                    end;
                // MP 18-11-15 <<

                // MP 16-05-13 Removed >>
                // MP 05-02-13 >>

                //IF (precCorpGLAcc."No." = grecEYCoreSetup."Corp. Retained Earnings Acc.") AND
                //  (goptCorpStatementType > goptCorpStatementType::"Group Financial Statement")
                //THEN BEGIN
                //  lfcnCalcCorpRetEarningsAdjmts(ldecRetainedEarningsAdjmts);
                //
                //  lfcnPopulateBalances(ptmpFinancialStatementLine,precFinancialStatementLineCurr,
                //    precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change" + ldecRetainedEarningsAdjmts[2],
                //    precCorpGLAcc."Balance at Date" + ldecRetainedEarningsAdjmts[1],
                //    precCorpGLAccPriorPeriod."Balance at Date" + ldecRetainedEarningsAdjmts[2]);
                //END ELSE
                //  IF (precCorpGLAcc."Account Class" = precCorpGLAcc."Account Class"::"P&L") AND
                //    (goptCorpStatementType > goptCorpStatementType::"Group Financial Statement")
                //  THEN BEGIN
                //    ltmpCorpGLAccPriorPeriodAdjmt."No." := precCorpGLAcc."No.";
                //    ltmpCorpGLAccPriorPeriodAdjmt.CALCFIELDS("Balance at Date","Net Change");
                //
                //    IF grecCorpAccountingPeriodPrev.Closed THEN
                //      ldecPLAdjmts := ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date" - ltmpCorpGLAccPriorPeriodAdjmt."Net Change"
                //    ELSE
                //      ldecPLAdjmts := ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date";
                //
                //    lfcnPopulateBalances(ptmpFinancialStatementLine,precFinancialStatementLineCurr,
                //      precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change" - ldecPLAdjmts,
                //      precCorpGLAcc."Balance at Date" - ltmpCorpGLAccPriorPeriodAdjmt."Balance at Date",
                //      precCorpGLAccPriorPeriod."Balance at Date");
                //  END ELSE

                // MP 05-02-13 <<
                // MP 16-05-13 Removed <<

                lfcnPopulateBalances(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
                  precCorpGLAcc."Balance at Date" - precCorpGLAcc."Net Change",
                  //precCorpGLAcc."Balance at Date",
                  precCorpGLAcc."Balance at Date" + ldecUnPostedAmount, // MP 18-11-15 Replaces above line
                  precCorpGLAccPriorPeriod."Balance at Date");

                pdecStartBalanceSubtotal += ptmpFinancialStatementLine."Start Balance";
                pdecEndBalanceSubtotal += ptmpFinancialStatementLine."End Balance";
                pdecPriorPeriodSubtotal += ptmpFinancialStatementLine."Prior Period Balance";

                ptmpFinancialStatementLine.Insert();

            until precCorpGLAcc.Next() = 0
    end;

    local procedure lfcnCalcTotals(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary)
    var
        ltmpFinancialStatementLineTot: Record "Financial Statement Line" temporary;
        ldecStartBalanceTotal: Decimal;
        ldecEndBalanceTotal: Decimal;
        ldecPriorPeriodTotal: Decimal;
    begin
        ptmpFinancialStatementLine.SetRange("Line Type", ptmpFinancialStatementLine."Line Type"::Totalling);
        if ptmpFinancialStatementLine.FindSet() then begin
            repeat
                ltmpFinancialStatementLineTot := ptmpFinancialStatementLine;
                ltmpFinancialStatementLineTot.Insert();
            until ptmpFinancialStatementLine.Next() = 0;
            ptmpFinancialStatementLine.SetRange("Line Type");

            ptmpFinancialStatementLine.SetCurrentKey(Code, "Corporate G/L Account No.");
            ptmpFinancialStatementLine.SetRange("Corporate G/L Account No.", '');
            ptmpFinancialStatementLine.SetRange("G/L Account No.", '');
            ltmpFinancialStatementLineTot.FindSet();
            repeat
                ptmpFinancialStatementLine.SetRange(Type, ltmpFinancialStatementLineTot.Type);
                ptmpFinancialStatementLine.SetFilter(Code, ltmpFinancialStatementLineTot."Totalling/Formula");

                ptmpFinancialStatementLine.CalcSums("Start Balance", "End Balance", "Prior Period Balance");
                ldecStartBalanceTotal := ptmpFinancialStatementLine."Start Balance";
                ldecEndBalanceTotal := ptmpFinancialStatementLine."End Balance";
                ldecPriorPeriodTotal := ptmpFinancialStatementLine."Prior Period Balance";

                ptmpFinancialStatementLine.SetRange(Code);

                ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, ltmpFinancialStatementLineTot."Line No.");

                lfcnPopulateBalances(ptmpFinancialStatementLine, ptmpFinancialStatementLine,
                  ldecStartBalanceTotal,
                  ldecEndBalanceTotal, ldecPriorPeriodTotal);

                ptmpFinancialStatementLine.Modify();

            until ltmpFinancialStatementLineTot.Next() = 0;
        end;

        ptmpFinancialStatementLine.Reset();
    end;

    local procedure lfcnCalcFormulas(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary)
    var
        ltmpFinancialStatementLineFor: Record "Financial Statement Line" temporary;
        ltxtCurrChar: Text[1];
        ltxtCurrToken: Text[250];
        ltxtFormula: array[2] of Text[1024];
        ldecStartBalanceTotal: Decimal;
        ldecEndBalanceTotal: Decimal;
        lintCharNo: Integer;
        lintFormulaLength: Integer;
        txtOperators: Label '+-/*()';
    begin
        ptmpFinancialStatementLine.SetRange("Line Type", ptmpFinancialStatementLine."Line Type"::Formula);
        if ptmpFinancialStatementLine.FindSet() then begin
            repeat
                ltmpFinancialStatementLineFor := ptmpFinancialStatementLine;
                ltmpFinancialStatementLineFor.Insert();
            until ptmpFinancialStatementLine.Next() = 0;
            ptmpFinancialStatementLine.SetRange("Line Type");

            ptmpFinancialStatementLine.SetCurrentKey("Row No.");

            gmdlEvaluateExpr.gfcnInit();

            ltmpFinancialStatementLineFor.FindSet();
            repeat
                lintCharNo := 1;
                ltxtCurrToken := '';
                lintFormulaLength := StrLen(ltmpFinancialStatementLineFor."Totalling/Formula");
                Clear(ltxtFormula);

                repeat
                    ltxtCurrChar := CopyStr(ltmpFinancialStatementLineFor."Totalling/Formula", lintCharNo, 1);

                    if StrPos(txtOperators, ltxtCurrChar) = 0 then begin
                        ltxtCurrToken += ltxtCurrChar;
                        if lintCharNo = lintFormulaLength then
                            lfcnPopulateTokenValue(ptmpFinancialStatementLine, ltxtCurrToken, ltxtFormula);
                    end else begin
                        if ltxtCurrToken <> '' then begin
                            lfcnPopulateTokenValue(ptmpFinancialStatementLine, ltxtCurrToken, ltxtFormula);
                            ltxtCurrToken := '';
                        end;
                        ltxtFormula[1] += ltxtCurrChar;
                        ltxtFormula[2] += ltxtCurrChar;
                    end;

                    lintCharNo += 1;
                until lintCharNo > lintFormulaLength;

                ldecStartBalanceTotal := lfcnEvaluateExpression(ltmpFinancialStatementLineFor, ltxtFormula[1]);
                ldecEndBalanceTotal := lfcnEvaluateExpression(ltmpFinancialStatementLineFor, ltxtFormula[2]);

                ptmpFinancialStatementLine.Get(ltmpFinancialStatementLineFor."Financial Stat. Structure Code", ltmpFinancialStatementLineFor."Line No.");

                lfcnPopulateBalances(ptmpFinancialStatementLine, ptmpFinancialStatementLine,
                  ldecStartBalanceTotal,
                  ldecEndBalanceTotal, 0);

                ptmpFinancialStatementLine.Modify();

            until ltmpFinancialStatementLineFor.Next() = 0;
        end;
        ptmpFinancialStatementLine.Reset();
    end;


    procedure lfcnCalcBeginEndTotals(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary)
    var
        ldecStartBalanceTotal: array[10] of Decimal;
        ldecEndBalanceTotal: array[10] of Decimal;
        ldecPriorPeriodTotal: array[10] of Decimal;
        lintLevel: Integer;
        lintI: Integer;
    begin
        // MP 21-05-14 >>
        if gblnBottomUp then
            ptmpFinancialStatementLine.SetRange("Corporate G/L Account No.", '');
        // MP 21-05-14 <<
        ptmpFinancialStatementLine.SetRange("G/L Account No.", '');
        ptmpFinancialStatementLine.FindSet();
        repeat
            case ptmpFinancialStatementLine."Line Type" of
                ptmpFinancialStatementLine."Line Type"::"Begin-Total":
                    begin
                        lintLevel += 1;
                        if lintLevel > ArrayLen(ldecStartBalanceTotal) then
                            Error(txt60002, ArrayLen(ldecStartBalanceTotal));

                        ldecStartBalanceTotal[lintLevel] := 0;
                        ldecEndBalanceTotal[lintLevel] := 0;
                        ldecPriorPeriodTotal[lintLevel] := 0;
                    end;

                ptmpFinancialStatementLine."Line Type"::"End-Total":
                    begin
                        ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceTotal[lintLevel];
                        ptmpFinancialStatementLine."End Balance" := ldecEndBalanceTotal[lintLevel];
                        ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodTotal[lintLevel];
                        ptmpFinancialStatementLine.Modify();

                        lintLevel -= 1;

                        if lintLevel < 0 then
                            Error(txt60003);
                    end;

                else
                    if lintLevel > 0 then
                        for lintI := 1 to lintLevel do begin
                            ldecStartBalanceTotal[lintI] += ptmpFinancialStatementLine."Start Balance";
                            ldecEndBalanceTotal[lintI] += ptmpFinancialStatementLine."End Balance";
                            ldecPriorPeriodTotal[lintLevel] += ptmpFinancialStatementLine."Prior Period Balance"
                        end;
            end;
        until ptmpFinancialStatementLine.Next() = 0;

        // MP 21-05-14 >>
        if gblnBottomUp then
            ptmpFinancialStatementLine.SetRange("Corporate G/L Account No.");
        // MP 21-05-14 <<
        ptmpFinancialStatementLine.SetRange("G/L Account No."); // MP 09-05-12 Changed from "Corporate G/L Account No."
    end;

    local procedure lfcnPopulateTokenValue(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; pcodToken: Code[250]; var ptxtFormula: array[2] of Text[1024])
    var
        ltxtFormat: Text[50];
        ldecToken: Decimal;
        lblnUsePrevYear: Boolean;
        lblnTokenFound: Boolean;
    begin
        if StrLen(pcodToken) > 2 then begin
            lblnUsePrevYear := (pcodToken[1] = '[') and (pcodToken[StrLen(pcodToken)] = ']');
            if lblnUsePrevYear then
                pcodToken := CopyStr(pcodToken, 2, StrLen(pcodToken) - 2);
        end;

        if StrLen(pcodToken) <= MaxStrLen(ptmpFinancialStatementLine."Row No.") then begin
            ptmpFinancialStatementLine.SetRange("Row No.", pcodToken);
            lblnTokenFound := ptmpFinancialStatementLine.FindFirst();
            ptmpFinancialStatementLine.SetRange("Row No.");
        end;

        //ltxtFormat := '<Precision,2:3><Standard Format,1>';
        ltxtFormat := '<Precision,2:3><Standard Format,2>'; // MP 27-03-13 Replaces above

        if lblnTokenFound then begin
            if lblnUsePrevYear then begin
                ptxtFormula[1] += Format(ptmpFinancialStatementLine."Prior Period Balance", 0, ltxtFormat);
                ptxtFormula[2] += Format(ptmpFinancialStatementLine."Start Balance", 0, ltxtFormat);
            end else begin
                ptxtFormula[1] += Format(ptmpFinancialStatementLine."Start Balance", 0, ltxtFormat);
                ptxtFormula[2] += Format(ptmpFinancialStatementLine."End Balance", 0, ltxtFormat);
            end;
        end else begin
            if Evaluate(ldecToken, pcodToken) then begin
                ptxtFormula[1] += Format(ldecToken, 0, ltxtFormat);
                ptxtFormula[2] += Format(ldecToken, 0, ltxtFormat);
            end else begin
                ptxtFormula[1] += pcodToken;
                ptxtFormula[2] += pcodToken;
            end;
        end;
    end;

    local procedure lfcnEvaluateExpression(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; ptxtExpression: Text[1024]): Decimal
    var
        ltxtErrorMessage: Text[1024];
    begin
        gmdlEvaluateExpr.gfcnSetExpression(ptxtExpression);
        if gmdlEvaluateExpr.Run() then
            exit(gmdlEvaluateExpr.gfcnGetResult())
        else begin
            ltxtErrorMessage := gmdlEvaluateExpr.gfcnGetErrorMessage();
            if ltxtErrorMessage = '' then // Ignore division by zero error
                exit(0);

            Error(txt60001, ltxtErrorMessage, ptmpFinancialStatementLine."Totalling/Formula", ptxtExpression);
        end;
    end;

    local procedure lfcnPopulateBalances(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; pdecStartBalance: Decimal; pdecEndBalance: Decimal; pdecPriorPeriodBalance: Decimal)
    var
        ldecRoundingPrecision: Decimal;
    begin
        if precFinancialStatementLineCurr."Show Opposite Sign" then begin
            ptmpFinancialStatementLine."Start Balance" := -pdecStartBalance;
            ptmpFinancialStatementLine."End Balance" := -pdecEndBalance;
            ptmpFinancialStatementLine."Prior Period Balance" := -pdecPriorPeriodBalance;
        end else begin
            ptmpFinancialStatementLine."Start Balance" := pdecStartBalance;
            ptmpFinancialStatementLine."End Balance" := pdecEndBalance;
            ptmpFinancialStatementLine."Prior Period Balance" := pdecPriorPeriodBalance;
        end;

        // MP 03-12-13 >>
        if (grecFinStatStructure."Rounding Factor" <> grecFinStatStructure."Rounding Factor"::None) and
          not (ptmpFinancialStatementLine."Line Type" in [ptmpFinancialStatementLine."Line Type"::"End-Total", ptmpFinancialStatementLine."Line Type"::Totalling, ptmpFinancialStatementLine."Line Type"::Formula]) // MP 05-05-14 Added condition
        then begin
            Evaluate(ldecRoundingPrecision, Format(grecFinStatStructure."Rounding Factor"));

            ptmpFinancialStatementLine."Start Balance" := Round(ptmpFinancialStatementLine."Start Balance" / ldecRoundingPrecision, 1);
            ptmpFinancialStatementLine."End Balance" := Round(ptmpFinancialStatementLine."End Balance" / ldecRoundingPrecision, 1);
            ptmpFinancialStatementLine."Prior Period Balance" := Round(ptmpFinancialStatementLine."Prior Period Balance" / ldecRoundingPrecision, 1);
        end;
        // MP 03-12-13 <<
    end;


    procedure gfcnDrillDown(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; pintFieldNo: Integer)
    var
        lrecGLEntry: Record "G/L Entry";
        lmdlAdjmtsMgt: Codeunit "Adjustments Management";
    begin
        if ptmpFinancialStatementLine."Corporate G/L Account No." <> '' then begin
            lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Posting Date");
            lrecGLEntry.SetRange("Corporate G/L Account No.", ptmpFinancialStatementLine."Corporate G/L Account No.");
        end else
            if ptmpFinancialStatementLine."G/L Account No." <> '' then begin
                lrecGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                lrecGLEntry.SetRange("G/L Account No.", ptmpFinancialStatementLine."G/L Account No.");
            end else
                exit;

        if pintFieldNo = ptmpFinancialStatementLine.FieldNo("Start Balance") then
            lrecGLEntry.SetRange("Posting Date", 0D, NormalDate(gdatStart))
        else
            lrecGLEntry.SetRange("Posting Date", 0D, gdatEnd);

        // MP 03-12-13 >>
        if gblnBottomUp and (goptViewAccounts = goptViewAccounts::"Local") then
            lrecGLEntry.SetFilter("Global Dimension 1 Code", gtxtAdjmtDimFilterLocal)
        else
            // MP 03-12-13 <<
            lrecGLEntry.SetFilter("Global Dimension 1 Code", gtxtAdjmtDimFilter);

        // MP 16-05-13 Removed >>
        // MP 05-02-13 >>

        // Retained Earnings Drill-down
        //IF (goptCorpStatementType > goptCorpStatementType::"Group Financial Statement") AND
        //  (goptViewAccounts > goptViewAccounts::"Local")
        //THEN
        //  IF "Corporate G/L Account No." = grecEYCoreSetup."Corp. Retained Earnings Acc." THEN BEGIN
        //    // Mark entries posted directly to retained earnings
        //    IF lrecGLEntry.FINDSET THEN
        //      REPEAT
        //        lrecGLEntry.MARK(TRUE);
        //      UNTIL lrecGLEntry.NEXT = 0;
        //
        //    // Filter and mark S and T Adjustments to P&L accounts for previous periods
        //    IF pintFieldNo = FIELDNO("End Balance") THEN
        //      IF grecCorpAccountingPeriodPrev.Closed THEN
        //        lrecGLEntry.SETRANGE("Posting Date",0D,gdatStart)
        //      ELSE
        //        lrecGLEntry.SETRANGE("Posting Date",0D,gdatPriorPeriodEnd)
        //    ELSE // "Start Balance"
        //      lrecGLEntry.SETRANGE("Posting Date",0D,gdatPriorPeriodEnd);
        //
        //    lrecGLEntry.SETFILTER("Corporate G/L Account No.",gtxtGLAccountFilterPL);
        //    lrecGLEntry.SETFILTER("Global Dimension 1 Code",gtxtAdjmtDimFilterExclBlank); // S+T
        //
        //    IF lrecGLEntry.FINDSET THEN
        //      REPEAT
        //        lrecGLEntry.MARK(TRUE);
        //      UNTIL lrecGLEntry.NEXT = 0;
        //
        //    lrecGLEntry.SETRANGE("Global Dimension 1 Code");
        //    lrecGLEntry.SETRANGE("Posting Date");
        //    lrecGLEntry.SETFILTER("Corporate G/L Account No.",gtxtGLAccountFilterPL + '|' +
        //      grecEYCoreSetup."Corp. Retained Earnings Acc.");
        //
        //    lrecGLEntry.MARKEDONLY(TRUE);
        //  END ELSE // P&L Drill-down
        //    IF ("Corporate G/L Account No." <> '') AND ltmpCorpGLAcc.GET("Corporate G/L Account No.") THEN
        //      IF ltmpCorpGLAcc."Account Class" = ltmpCorpGLAcc."Account Class"::"P&L" THEN
        //        IF lrecGLEntry.FINDSET THEN BEGIN
        //          REPEAT
        //            IF (lrecGLEntry."Posting Date" > gdatStart) OR (lrecGLEntry."Global Dimension 1 Code" = '')
        //              OR ((pintFieldNo = FIELDNO("Start Balance")) AND (lrecGLEntry."Posting Date" > gdatPriorPeriodEnd))
        //            THEN
        //              lrecGLEntry.MARK(TRUE);
        //          UNTIL lrecGLEntry.NEXT = 0;
        //
        //          lrecGLEntry.MARKEDONLY(TRUE);
        //        END;

        // MP 05-02-13 <<
        // MP 16-05-13 Removed <<

        //PAGE.RUN(PAGE::"General Ledger Entries",lrecGLEntry);
        lmdlAdjmtsMgt.gfcnShowEntries(lrecGLEntry, gblnIncludeUnpostedEntries, ptmpFinancialStatementLine."Corporate G/L Account No." <> ''); // MP 18-11-15 Replaces above line
    end;


    procedure gfcnLookupRowNo(var precFinancialStatementLine: Record "Financial Statement Line"): Code[10]
    var
        lrecNVBuf: Record "Name/Value Buffer";
        lrecCurrFinStatLine: Record "Financial Statement Line";
        lpagNVLookup: Page "Name/Value Lookup";
    begin
        lrecCurrFinStatLine.Copy(precFinancialStatementLine);

        precFinancialStatementLine.SetCurrentKey("Row No.");
        precFinancialStatementLine.SetFilter("Row No.", '<>%1', '');
        if precFinancialStatementLine.FindSet() then
            repeat
                lpagNVLookup.AddItem(precFinancialStatementLine."Row No.", precFinancialStatementLine."Description (English)");
            until precFinancialStatementLine.Next() = 0;

        precFinancialStatementLine.Copy(lrecCurrFinStatLine);
        precFinancialStatementLine.Find();

        lpagNVLookup.Editable(false);
        lpagNVLookup.LookupMode(true);
        if lpagNVLookup.RunModal() = ACTION::LookupOK then begin
            lpagNVLookup.GetRecord(lrecNVBuf);
            exit(lrecNVBuf.Name);
        end;
    end;


    procedure gfcnShow(pcodFinStatStructureCode: Code[20])
    var
        lrecFinStatLine: Record "Financial Statement Line";
        lpagFinStatView: Page "Financial Statement View";
    begin
        // MP 03-12-13

        lrecFinStatLine.SetFilter("Financial Stat. Structure Code", pcodFinStatStructureCode);
        repeat
            Clear(lpagFinStatView); // MP 01-12-14
            lpagFinStatView.SetTableView(lrecFinStatLine);
            lpagFinStatView.RunModal();
        until not lpagFinStatView.gfcnReopen();
    end;

    local procedure lfcnSetLocalAccAdjmtFilter()
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
    begin
        // MP 03-12-13

        if (goptCorpStatementType = goptCorpStatementType::" ") or (not gblnBottomUp) then
            exit;

        gtxtAdjmtDimFilterLocal := '''''';

        if goptCorpStatementType = goptCorpStatementType::"Tax Financial Statement" then begin
            lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
            lrecGenJnlTemplate.FindFirst();
            gtxtAdjmtDimFilterLocal += '|' + lrecGenJnlTemplate."Shortcut Dimension 1 Code";
        end;
    end;

    local procedure lfcnCalcPostingBothAccBottomUp(var ptmpFinancialStatementLine: Record "Financial Statement Line" temporary; var precFinancialStatementLineCurr: Record "Financial Statement Line"; var pdecStartBalanceSubtotal: Decimal; var pdecEndBalanceSubtotal: Decimal; var pdecPriorPeriodSubtotal: Decimal)
    var
        ltmpCorpGLAcc: Record "Corporate G/L Account" temporary;
        ltmpGLAccPriorPeriod: Record "Corporate G/L Account" temporary;
        ltmpGLAcc: Record "G/L Account" temporary;
        ldecStartBalanceSubtotalCorp: Decimal;
        ldecEndBalanceSubtotalCorp: Decimal;
        ldecPriorPeriodSubtotalCorp: Decimal;
        ldecUnPostedAmount: Decimal;
        lcodPrevCorpGLAccNo: Code[20];
        lintLineNoCorpGLAcc: Integer;
        lblnCalcPriorPeriod: Boolean;
    begin
        // MP 03-12-13
        // MP 18-11-15 >>
        ltmpCorpGLAcc.Copy(gtmpCorpGLAcc, true);
        ltmpGLAccPriorPeriod.Copy(gtmpCorpGLAcc, true);
        ltmpGLAcc.Copy(gtmpGLAcc, true);
        // MP 18-11-15 <<

        ltmpGLAcc.SetCurrentKey("Financial Statement Code", "Corporate G/L Account No.");
        ltmpGLAcc.SetRange("Financial Statement Code", precFinancialStatementLineCurr.Code);

        ltmpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
        ltmpGLAcc.SetFilter("Global Dimension 1 Filter", gtxtAdjmtDimFilter);

        lblnCalcPriorPeriod := ptmpFinancialStatementLine."Row No." <> '';
        if lblnCalcPriorPeriod then // May be included in formula using previous period figure, i.e. [ROWNO]
            ltmpGLAccPriorPeriod.SetRange("Date Filter", 0D, gdatPriorPeriodEnd);

        if ltmpGLAcc.FindSet() then begin
            repeat
                // Update figures on Corporate G/L Account
                if (lcodPrevCorpGLAccNo <> ltmpGLAcc."Corporate G/L Account No.") and (lintLineNoCorpGLAcc <> 0) then begin
                    ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, lintLineNoCorpGLAcc);
                    ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceSubtotalCorp;
                    ptmpFinancialStatementLine."End Balance" := ldecEndBalanceSubtotalCorp;
                    ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodSubtotalCorp;
                    ptmpFinancialStatementLine.Modify();

                    ldecStartBalanceSubtotalCorp := 0;
                    ldecEndBalanceSubtotalCorp := 0;
                    ldecPriorPeriodSubtotalCorp := 0;
                end;

                ptmpFinancialStatementLine.Init();
                ptmpFinancialStatementLine."Line Type" := ptmpFinancialStatementLine."Line Type"::Posting;
                ptmpFinancialStatementLine.Code := precFinancialStatementLineCurr.Code;

                if lcodPrevCorpGLAccNo <> ltmpGLAcc."Corporate G/L Account No." then begin
                    ltmpGLAcc.TestField("Corporate G/L Account No.");
                    ltmpCorpGLAcc.Get(ltmpGLAcc."Corporate G/L Account No.");
                    ptmpFinancialStatementLine."Corporate G/L Account No." := ltmpGLAcc."Corporate G/L Account No.";

                    ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + ltmpCorpGLAcc.Name;
                    if ltmpCorpGLAcc."Name (English)" <> '' then
                        ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."Corporate G/L Account No." + ' ' + ltmpCorpGLAcc."Name (English)";

                    ptmpFinancialStatementLine.Indentation := 1;

                    gintLineNo += 10000;
                    ptmpFinancialStatementLine."Line No." := gintLineNo;
                    ptmpFinancialStatementLine.Insert();

                    lintLineNoCorpGLAcc := ptmpFinancialStatementLine."Line No.";

                    ptmpFinancialStatementLine."Corporate G/L Account No." := '';
                end;

                ptmpFinancialStatementLine."G/L Account No." := ltmpGLAcc."No.";

                ptmpFinancialStatementLine.Description := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc.Name;
                if ltmpGLAcc."Name (English)" = '' then
                    ptmpFinancialStatementLine."Description (English)" := ''
                else
                    ptmpFinancialStatementLine."Description (English)" := ptmpFinancialStatementLine."G/L Account No." + ' ' + ltmpGLAcc."Name (English)";

                ptmpFinancialStatementLine.Indentation := 2;

                gintLineNo += 10000;
                ptmpFinancialStatementLine."Line No." := gintLineNo;

                // MP 18-11-15 >>
                if gblnIncludeUnpostedEntries then begin
                    ltmpGLAcc.CalcFields("Balance at Date", "Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecUnPostedAmount := ltmpGLAcc."Preposted Net Change" + ltmpGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    ldecUnPostedAmount := 0;
                    // MP 18-11-15 <<

                    ltmpGLAcc.CalcFields("Balance at Date", "Net Change");
                end; // MP 18-11-15

                if lblnCalcPriorPeriod then begin
                    ltmpGLAccPriorPeriod."No." := ltmpGLAcc."No.";
                    ltmpGLAccPriorPeriod.CalcFields("Balance at Date");
                end;

                // MP 18-11-15 >>
                if StrPos(ltmpGLAcc."Search Name", '}{') > 0 then // FS Code is different between periods, i.e. there are two FS Codes in Search Name
                    if precFinancialStatementLineCurr.Code = ltmpGLAcc."Financial Statement Code" then begin
                        ltmpGLAcc."Net Change" := ltmpGLAcc."Balance at Date";
                        ltmpGLAccPriorPeriod."Balance at Date" := 0;
                    end else begin
                        ltmpGLAcc."Net Change" := ltmpGLAcc."Net Change" - ltmpGLAcc."Balance at Date";
                        ltmpGLAcc."Balance at Date" := 0;
                        ldecUnPostedAmount := 0;
                    end;
                // MP 18-11-15 <<

                lfcnPopulateBalances(ptmpFinancialStatementLine, precFinancialStatementLineCurr,
                  ltmpGLAcc."Balance at Date" - ltmpGLAcc."Net Change",
                  //ltmpGLAcc."Balance at Date",
                  ltmpGLAcc."Balance at Date" - ldecUnPostedAmount, // MP 18-11-15 Replaces above line
                  ltmpGLAccPriorPeriod."Balance at Date");

                ldecStartBalanceSubtotalCorp += ptmpFinancialStatementLine."Start Balance";
                ldecEndBalanceSubtotalCorp += ptmpFinancialStatementLine."End Balance";
                ldecPriorPeriodSubtotalCorp += ptmpFinancialStatementLine."Prior Period Balance";

                pdecStartBalanceSubtotal += ptmpFinancialStatementLine."Start Balance";
                pdecEndBalanceSubtotal += ptmpFinancialStatementLine."End Balance";
                pdecPriorPeriodSubtotal += ptmpFinancialStatementLine."Prior Period Balance";

                ptmpFinancialStatementLine.Insert();

                lcodPrevCorpGLAccNo := ltmpGLAcc."Corporate G/L Account No.";
            until ltmpGLAcc.Next() = 0;

            // Update figures on Corporate G/L Account
            if lintLineNoCorpGLAcc <> 0 then begin
                ptmpFinancialStatementLine.Get(gcodFinStatStructureCode, lintLineNoCorpGLAcc);
                ptmpFinancialStatementLine."Start Balance" := ldecStartBalanceSubtotalCorp;
                ptmpFinancialStatementLine."End Balance" := ldecEndBalanceSubtotalCorp;
                ptmpFinancialStatementLine."Prior Period Balance" := ldecPriorPeriodSubtotalCorp;
                ptmpFinancialStatementLine.Modify();
            end;

        end;
    end;

    local procedure lfcnInsertTempAccounts()
    var
        lrecGLAcc: Record "G/L Account";
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lmdlTGLAccount: Codeunit "T:G/L Account";
        lcodFSCodePY: Code[10];
    begin
        // MP 18-11-15

        gtmpCorpGLAcc.Reset();
        gtmpCorpGLAcc.DeleteAll();

        gtmpGLAcc.Reset();
        gtmpGLAcc.DeleteAll();

        if goptViewAccounts in [goptViewAccounts::Corporate, goptViewAccounts::Both] then
            if lrecCorpGLAcc.FindSet() then
                repeat
                    gtmpCorpGLAcc := lrecCorpGLAcc;

                    gtmpCorpGLAcc."Financial Statement Code" := lrecCorpGLAcc.gfcnGetFinancialStatementCode(gdatEnd);
                    lcodFSCodePY := lrecCorpGLAcc.gfcnGetFinancialStatementCode(NormalDate(gdatStart));
                    if lcodFSCodePY = gtmpCorpGLAcc."Financial Statement Code" then
                        gtmpCorpGLAcc."Search Name" := StrSubstNo('%1{%2}', gtmpCorpGLAcc."No.", gtmpCorpGLAcc."Financial Statement Code")
                    else
                        gtmpCorpGLAcc."Search Name" := StrSubstNo('%1{%2}{%3}', gtmpCorpGLAcc."No.", gtmpCorpGLAcc."Financial Statement Code", lcodFSCodePY);

                    gtmpCorpGLAcc.Insert();
                until lrecCorpGLAcc.Next() = 0;

        if goptViewAccounts in [goptViewAccounts::"Local", goptViewAccounts::Both] then
            if lrecGLAcc.FindSet() then
                repeat
                    gtmpGLAcc := lrecGLAcc;

                    gtmpGLAcc."Financial Statement Code" := lmdlTGLAccount.gfcnGetFinancialStatementCode(lrecGLAcc, gdatEnd); // MP 24-May-15 Replaced by codeunit call
                    lcodFSCodePY := lmdlTGLAccount.gfcnGetFinancialStatementCode(lrecGLAcc, NormalDate(gdatStart)); // MP 24-May-15 Replaced by codeunit call
                    if lcodFSCodePY = gtmpGLAcc."Financial Statement Code" then
                        gtmpGLAcc."Search Name" := StrSubstNo('%1{%2}', gtmpGLAcc."No.", gtmpGLAcc."Financial Statement Code")
                    else
                        gtmpGLAcc."Search Name" := StrSubstNo('%1{%2}{%3}', gtmpGLAcc."No.", gtmpGLAcc."Financial Statement Code", lcodFSCodePY);

                    gtmpGLAcc.Insert();
                until lrecGLAcc.Next() = 0;
    end;
}

