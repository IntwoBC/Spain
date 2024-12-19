codeunit 60002 "GAAP Mgt. - Equity Reconcil."
{
    // SB 12-06-12
    // Added code to fix some issues with the Equity reconciliation including the Trial Balance Reversal Entries
    // since they have Closing dates they are causing issues with the Equity section.
    // 
    // MP 22-06-12
    // Further changes to the above
    // 
    // MP 06-12-12
    // Fixed issue with entry not shown in correct column when grouping by Equity Correction Code
    // 
    // MP 10-01-13
    // Further to SB 12-06-12, amended in order to filter differently on periods depending on if this is a TB-to-TB or not
    // 
    // MP 21-01-13
    // Fixed issue where entries were missing from total when grouping by Equity Correction Code
    // 
    // MP 03-12-13
    // Amended to support bottom-up companies (CR 30)
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup
    // 
    // MP 08-04-14
    // Added headin line GROUP ADJUSTMENTS (CR 30)
    // 
    // MP 10-12-15
    // Added functionality to include unposted entries (CB1 Enhancements)
    // Added Spanish (Mexico) captions
    // 
    // MP 18-02-16
    // Changed ENU captions for txt60002 and txt60003 (CB1 Enhancements)
    // Now it does not create subtotals by year
    // 
    // mp 05-04-16
    // Changed wording for "RETAINED EARNINGS" to "RESULT OF THE YEAR" (CB1 CR002)


    trigger OnRun()
    begin
    end;

    var
        grecEYCoreSetup: Record "EY Core Setup";
        grecGenJnlTemplate: array[3] of Record "Gen. Journal Template";
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        gmdlCompanyTypeMgt: Codeunit "Company Type Management";
        goptGroupBy: Option Year,"Equity Correction Code";
        gtxtGLAccountFilterEquity: Text;
        gtxtGLAccountFilterPL: Text;
        gdatStart: Date;
        gdatEnd: Date;
        gdecTotalStartBalance: Decimal;
        gdecTotalNetChangePL: Decimal;
        txt60000: Label 'Equity %1';
        txt60001: Label 'Result %1';
        txt60002: Label 'CORPORATE GAAP EQUITY';
        txt60003: Label 'LOCAL GAAP EQUITY';
        gdecTotalNetChangeEquity: Decimal;
        txt60004: Label 'RESULT OF THE YEAR';
        txt60005: Label 'Delta on Equity %1';
        gblnStatutory: Boolean;
        gblnTax: Boolean;
        txt60006: Label 'LOCAL TAX ACCOUNTS %1';
        gblnPeriodClosed: Boolean;
        gblnBottomUp: Boolean;
        gblnCorpAccInUse: Boolean;
        gblnIncludeUnpostedEntries: Boolean;
        gdatStartWithClosing: Date;
        txt60007: Label 'GROUP ADJUSTMENTS';


    procedure gfcnInit(var pdatStart: Date; var pdatEnd: Date; var poptGroupBy: Option Year,"Equity Correction Code"; pblnIncludeUnpostedEntries: Boolean)
    var
        lrecSourceCodeSetup: Record "Source Code Setup";
        lrecGLRegister: Record "G/L Register";
        lrecGLEntry: Record "G/L Entry";
    begin
        gdatStart := pdatStart;
        gdatEnd := pdatEnd;
        goptGroupBy := poptGroupBy;
        gblnIncludeUnpostedEntries := pblnIncludeUnpostedEntries; // MP 10-12-15 New parameter

        gdatStartWithClosing := ClosingDate(CalcDate('-1d', gdatStart)); // SB 12-06-12

        // MP 03-12-13 >>
        gblnBottomUp := gmdlCompanyTypeMgt.gfcnIsBottomUp();
        gblnCorpAccInUse := gmdlCompanyTypeMgt.gfcnCorpAccInUse();

        if not gblnCorpAccInUse then
            lfcnSetLocalGLAccountFilters()
        else
            // MP 03-12-13 <<
            lfcnSetGLAccountFilters();

        // MP 03-12-13 >>
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

        // MP 08-05-14 No longer required >>
        // MP 10-01-13 Check if this is a TB-to-TB Company in the current period viewed >>
        //gblnTBtoTB := FALSE;
        //lrecSourceCodeSetup.GET;
        //IF lrecSourceCodeSetup."TB Reversal" <> '' THEN BEGIN
        //  lrecGLRegister.SETCURRENTKEY("Source Code");
        //  lrecGLRegister.SETRANGE("Source Code",lrecSourceCodeSetup."TB Reversal");
        //  IF NOT lrecGLRegister.ISEMPTY THEN BEGIN // TB Reversal entries exists, check if anything posted for current period viewed
        //    lrecGLEntry.SETRANGE("Source Code",lrecSourceCodeSetup."TB Reversal");
        //    lrecGLEntry.SETRANGE("Posting Date",gdatStartWithClosing,gdatEnd);
        //    gblnTBtoTB := NOT lrecGLEntry.ISEMPTY;
        //  END;
        //END;
        // MP 10-01-13 <<
        // MP 08-05-14 <<
    end;


    procedure gfcnGetCaptions(var ptxtStartBalanceCaption: Text[30]; var ptxtNetChangePLCaption: Text[30]; var ptxtNetChangeEquityCaption: Text[30]; var ptxtEndBalanceCaption: Text[30])
    begin
        ptxtStartBalanceCaption := StrSubstNo(txt60000, Format(gdatStart - 1, 0, '<Day,2>-<Month,2>-<Year4>'));
        ptxtNetChangePLCaption := StrSubstNo(txt60001, Date2DMY(gdatEnd, 3)); // MP 10-12-15 Changed from gdatStart to gdatEnd
        ptxtNetChangeEquityCaption := StrSubstNo(txt60005, Date2DMY(gdatEnd, 3)); // MP 10-12-15 Changed from gdatStart to gdatEnd
        ptxtEndBalanceCaption := StrSubstNo(txt60000, Format(gdatEnd, 0, '<Day,2>-<Month,2>-<Year4>'));
    end;


    procedure gfcnCalc(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary)
    begin
        ptmpEquityReconLine.Reset();
        ptmpEquityReconLine.DeleteAll();

        gdecTotalStartBalance := 0;
        gdecTotalNetChangePL := 0;
        gdecTotalNetChangeEquity := 0;

        // Statutory
        gblnStatutory := true;
        gblnTax := false;

        // MP 03-13-13 >>
        if not gblnCorpAccInUse then begin
            if not lfcnPopulateLocalAccSumLines(ptmpEquityReconLine) then
                exit
        end else
            // MP 03-13-13 <<
            if not lfcnPopulateCorpAccSumLines(ptmpEquityReconLine) then
                exit;

        lfcnPopulateEntryLines(ptmpEquityReconLine);

        // Tax
        gblnTax := true;
        lfcnInsertLineSubtotal(ptmpEquityReconLine, ptmpEquityReconLine.Type::Total, StrSubstNo(txt60003, Date2DMY(gdatStart, 3)), 0D, 0D);

        gblnStatutory := false;

        lfcnInsertLineBlank(ptmpEquityReconLine);

        lfcnPopulateEntryLines(ptmpEquityReconLine);

        lfcnInsertLineSubtotal(ptmpEquityReconLine, ptmpEquityReconLine.Type::Total, StrSubstNo(txt60006, Date2DMY(gdatStart, 3)), 0D, 0D);
    end;


    procedure gfcnDrillDown(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary; pintFieldNo: Integer)
    var
        lrecGLEntry: Record "G/L Entry";
        lmdlAdjmtsMgt: Codeunit "Adjustments Management";
    begin
        case ptmpEquityReconLine.Type of
            ptmpEquityReconLine.Type::"Corp. Account Summary":
                begin
                    if pintFieldNo in [ptmpEquityReconLine.FieldNo("Document No. (Start Balance)"), ptmpEquityReconLine.FieldNo("Document No. (Net Change)")] then
                        exit;

                    // MP 03-12-13 >>
                    if not gblnCorpAccInUse then
                        lrecGLEntry.SetCurrentKey("G/L Account No.")
                    else
                        // MP 03-12-13 <<
                        lrecGLEntry.SetCurrentKey("Corporate G/L Account No.");

                    // Set "Corporate G/L Account No." filter
                    if ptmpEquityReconLine.Code = '' then begin
                        //          IF (pintFieldNo = FIELDNO("Net Change (P&L)")) AND (NOT grecCorpAccountingPeriod.Closed) THEN // Retained Earnings
                        if pintFieldNo = ptmpEquityReconLine.FieldNo("Net Change (P&L)") then // Retained Earnings MP 22-06-12 Replaces above
                                                                                              // MP 03-12-13 >>
                            if not gblnCorpAccInUse then
                                lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterPL)
                            else
                                // MP 03-12-13 <<
                                lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterPL)
                        else begin
                            //IF (pintFieldNo = FIELDNO("End Balance")) AND (NOT grecCorpAccountingPeriod.Closed) THEN
                            if (pintFieldNo = ptmpEquityReconLine.FieldNo("End Balance")) and (not gblnPeriodClosed) then // MP 03-12-13 Replaces above
                                exit;
                            lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterEquity);
                        end;
                    end else
                        // MP 03-12-13 >>
                        if gblnBottomUp then begin
                            if gblnCorpAccInUse then begin
                                lrecGLEntry.SetRange("Corporate G/L Account No.", ptmpEquityReconLine.Code);
                                lrecGLEntry.SetFilter("Global Dimension 1 Code", '''''|' + grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");
                            end else begin
                                lrecGLEntry.SetRange("G/L Account No.", ptmpEquityReconLine.Code);
                                lrecGLEntry.SetRange("Global Dimension 1 Code", '');
                            end;
                        end else begin
                            // MP 03-12-13 <<
                            lrecGLEntry.SetRange("Corporate G/L Account No.", ptmpEquityReconLine.Code);
                            lrecGLEntry.SetRange("Global Dimension 1 Code", '');
                        end; // MP 03-12-13

                    // Set "Posting Date" filter
                    case pintFieldNo of
                        ptmpEquityReconLine.FieldNo("Start Balance"):
                            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
                            // MP 10-01-13 >>
                            //IF NOT gblnTBtoTB THEN
                            lrecGLEntry.SetFilter("Posting Date", '<%1', gdatStart); // MP 10-01-13 Reinstated line
                                                                                     //ELSE
                                                                                     // MP 10-01-13 <<
                                                                                     //  lrecGLEntry.SETFILTER("Posting Date",'<=%1',CALCDATE('-1D',gdatStart)); // SB 12-06-12 Replaces above
                                                                                     // MP 08-05-14 <<

                        ptmpEquityReconLine.FieldNo("Net Change (P&L)"):
                            //IF grecCorpAccountingPeriod.Closed THEN
                            if gblnPeriodClosed then // MP 03-12-13 Replaces above
                                lrecGLEntry.SetRange("Posting Date", ClosingDate(gdatEnd))
                            else
                                if ptmpEquityReconLine.Code = '' then
                                    lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd)
                                else
                                    exit;

                        ptmpEquityReconLine.FieldNo("Net Change (Equity)"):
                            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
                            // MP 10-01-13 >>
                            //IF NOT gblnTBtoTB THEN
                            lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd); // MP 10-01-13 Reinstated line
                                                                                      //ELSE
                                                                                      // MP 10-01-13 <<
                                                                                      //  lrecGLEntry.SETRANGE("Posting Date",gdatStartWithClosing,gdatEnd); // SB 12-06-12 Replaces above
                                                                                      // MP 08-05-14 <<

                        ptmpEquityReconLine.FieldNo("End Balance"):
                            lrecGLEntry.SetRange("Posting Date", 0D, ClosingDate(gdatEnd));
                    end;
                end;

            ptmpEquityReconLine.Type::Entries:
                begin
                    lrecGLEntry.SetCurrentKey("Global Dimension 1 Code", "Posting Date");

                    if ptmpEquityReconLine.Statutory then
                        // MP 03-12-13 >>
                        if gblnBottomUp then
                            lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[3]."Shortcut Dimension 1 Code")
                        else
                            // MP 03-12-13 <<
                            lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[1]."Shortcut Dimension 1 Code")
                    else
                        lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[2]."Shortcut Dimension 1 Code");

                    // Set "Equity Correction Code" filter
                    if ptmpEquityReconLine.Subtotal then
                        lrecGLEntry.SetFilter("Equity Correction Code", '<>%1', '')
                    else
                        lrecGLEntry.SetRange("Equity Correction Code", ptmpEquityReconLine.Code);

                    // MP 03-12-13 >>
                    if not gblnCorpAccInUse then
                        // Set "G/L Account No." filter
                        case pintFieldNo of
                            ptmpEquityReconLine.FieldNo("Start Balance"), ptmpEquityReconLine.FieldNo("End Balance"),
                    ptmpEquityReconLine.FieldNo("Document No. (Start Balance)"), ptmpEquityReconLine.FieldNo("Document No. (Net Change)"):
                                lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterPL + '|' + gtxtGLAccountFilterEquity);

                            ptmpEquityReconLine.FieldNo("Net Change (P&L)"):
                                lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterPL);

                            ptmpEquityReconLine.FieldNo("Net Change (Equity)"):
                                lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterEquity);
                        end
                    else
                        // MP 03-12-13 <<
                        // Set "Corporate G/L Account No." filter
                        case pintFieldNo of
                            ptmpEquityReconLine.FieldNo("Start Balance"), ptmpEquityReconLine.FieldNo("End Balance"),
                    ptmpEquityReconLine.FieldNo("Document No. (Start Balance)"), ptmpEquityReconLine.FieldNo("Document No. (Net Change)"):
                                lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterPL + '|' + gtxtGLAccountFilterEquity);

                            ptmpEquityReconLine.FieldNo("Net Change (P&L)"):
                                lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterPL);

                            ptmpEquityReconLine.FieldNo("Net Change (Equity)"):
                                lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterEquity);
                        end;

                    // Set "Document No." filter
                    case pintFieldNo of
                        ptmpEquityReconLine.FieldNo("Start Balance"), ptmpEquityReconLine.FieldNo("Document No. (Start Balance)"):
                            lrecGLEntry.SetFilter("Document No.", ptmpEquityReconLine."Document No. (Start Balance)");

                        ptmpEquityReconLine.FieldNo("Net Change (P&L)"), ptmpEquityReconLine.FieldNo("Document No. (Net Change)"):
                            lrecGLEntry.SetFilter("Document No.", ptmpEquityReconLine."Document No. (Net Change)");

                        ptmpEquityReconLine.FieldNo("End Balance"):
                            if ptmpEquityReconLine."Document No. (Start Balance)" <> '' then
                                lrecGLEntry.SetFilter("Document No.", ptmpEquityReconLine."Document No. (Start Balance)")
                            else
                                lrecGLEntry.SetFilter("Document No.", ptmpEquityReconLine."Document No. (Net Change)");
                    end;

                    // Set "Posting Date" filter
                    if ptmpEquityReconLine.Year <> 0 then
                        lrecGLEntry.SetRange("Posting Date", ptmpEquityReconLine."Year Start Date", ptmpEquityReconLine."Year End Date")
                    else
                        case pintFieldNo of
                            ptmpEquityReconLine.FieldNo("Start Balance"), ptmpEquityReconLine.FieldNo("Document No. (Start Balance)"):
                                // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
                                // MP 10-01-13 >>
                                //IF NOT gblnTBtoTB THEN
                                lrecGLEntry.SetFilter("Posting Date", '<%1', gdatStart); // MP 10-01-13 Reinstated line
                                                                                         //ELSE
                                                                                         // MP 10-01-13 <<
                                                                                         //  lrecGLEntry.SETFILTER("Posting Date",'<=%1',CALCDATE('-1D',gdatStart)); // SB 12-06-12 Replaces above
                                                                                         // MP 08-05-14 <<
                            ptmpEquityReconLine.FieldNo("Net Change (P&L)"), ptmpEquityReconLine.FieldNo("Net Change (Equity)"), ptmpEquityReconLine.FieldNo("Document No. (Net Change)"):
                                lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd);

                            ptmpEquityReconLine.FieldNo("End Balance"):
                                lrecGLEntry.SetRange("Posting Date", 0D, gdatEnd);
                        end;
                end;
            else
                exit;
        end;

        //PAGE.RUN(0,lrecGLEntry);
        lmdlAdjmtsMgt.gfcnShowEntries(lrecGLEntry, gblnIncludeUnpostedEntries, gblnCorpAccInUse); // MP 10-12-15 Replaces line above
    end;

    local procedure lfcnInsertLine(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary; pintType: Integer; pcodCode: Code[20]; ptxtDescription: Text[50]; ptxtEntryDescription: Text[50]; pdecStartBalance: Decimal; pdecNetChangePL: Decimal; pdecNetChangeEquity: Decimal; pcodDocNoStartBalance: Code[20]; pcodDocNoNetChange: Code[20]; pintYear: Integer; pdatStartDate: Date; pdatEndDate: Date; pblnSubtotal: Boolean)
    begin
        ptmpEquityReconLine.Init();
        ptmpEquityReconLine."Line No." += 10000;

        ptmpEquityReconLine.Type := pintType;
        ptmpEquityReconLine.Code := pcodCode;
        ptmpEquityReconLine.Description := ptxtDescription;
        ptmpEquityReconLine."Entry Description" := ptxtEntryDescription;
        ptmpEquityReconLine."Start Balance" := pdecStartBalance;
        ptmpEquityReconLine."Net Change (P&L)" := pdecNetChangePL;
        ptmpEquityReconLine."Net Change (Equity)" := pdecNetChangeEquity;
        ptmpEquityReconLine."End Balance" := pdecStartBalance + pdecNetChangePL + pdecNetChangeEquity;
        ptmpEquityReconLine."Document No. (Start Balance)" := pcodDocNoStartBalance;
        ptmpEquityReconLine."Document No. (Net Change)" := pcodDocNoNetChange;
        ptmpEquityReconLine.Year := pintYear;
        ptmpEquityReconLine."Year Start Date" := pdatStartDate;
        ptmpEquityReconLine."Year End Date" := pdatEndDate;
        ptmpEquityReconLine.Subtotal := pblnSubtotal;
        ptmpEquityReconLine.Statutory := gblnStatutory;
        ptmpEquityReconLine.Tax := gblnTax;

        ptmpEquityReconLine.Insert();

        if not ptmpEquityReconLine.Subtotal then begin
            gdecTotalStartBalance += pdecStartBalance;
            gdecTotalNetChangePL += pdecNetChangePL;
            gdecTotalNetChangeEquity += pdecNetChangeEquity;
        end else
            if ptmpEquityReconLine.Type <> ptmpEquityReconLine.Type::Total then
                lfcnInsertLineBlank(ptmpEquityReconLine);
    end;

    local procedure lfcnInsertLineSubtotal(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary; poptType: Option " ","Corp. Account Summary",Entries,Total; ptxtDescription: Text[50]; pdatStartDate: Date; pdatEndDate: Date)
    var
        ldecTotalStartBalance: Decimal;
        ldecTotalNetChangePL: Decimal;
        ldecTotalNetChangeEquity: Decimal;
    begin
        if poptType in [poptType::"Corp. Account Summary", poptType::Total] then begin
            ldecTotalStartBalance := gdecTotalStartBalance;
            ldecTotalNetChangePL := gdecTotalNetChangePL;
            ldecTotalNetChangeEquity := gdecTotalNetChangeEquity;
        end else
            if pdatStartDate = gdatStart then begin
                ldecTotalNetChangePL := gdecTotalNetChangePL;
                ldecTotalNetChangeEquity := gdecTotalNetChangeEquity;
            end else
                ldecTotalStartBalance := gdecTotalStartBalance;

        lfcnInsertLine(ptmpEquityReconLine, poptType, '', ptxtDescription, '',
          ldecTotalStartBalance, ldecTotalNetChangePL, ldecTotalNetChangeEquity, '', '', 0,
          pdatStartDate, pdatEndDate, true);
    end;

    local procedure lfcnInsertLineBlank(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary)
    begin
        lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::" ", '', '', '', 0, 0, 0, '', '', 0, 0D, 0D, false);
    end;

    local procedure lfcnPopulateCorpAccSumLines(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary): Boolean
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLEntry: Record "G/L Entry";
        lrrfAccPeriod: RecordRef;
        lfrfField: FieldRef;
        ldecStartBalance: Decimal;
        ldecNetChangePL: Decimal;
        ldecNetChangeEquity: Decimal;
    begin
        lrecCorpGLAcc.SetRange("Account Class", lrecCorpGLAcc."Account Class"::Equity);
        if not lrecCorpGLAcc.FindSet() then
            exit(false);

        //grecCorpAccountingPeriod.GET(gdatStart); // MP 03-12-13 replaced by lines below
        grecEYCoreSetup.Get();
        grecEYCoreSetup.TestField("Corp. Retained Earnings Acc.");

        // MP 03-12-13 >>
        lrrfAccPeriod.Open(gmdlCompanyTypeMgt.gfcnGetAccPeriodTableID());
        lfrfField := lrrfAccPeriod.Field(1); // "Starting Date"
        lfrfField.SetRange(gdatStart);
        lrrfAccPeriod.FindFirst();

        gblnPeriodClosed := lrrfAccPeriod.Field(4).Value; // Closed
        // MP 03-12-13 <<

        // Corp. Account Summary section
        repeat
            // MP 03-12-13 >>
            if gblnBottomUp then
                lrecCorpGLAcc.SetFilter("Global Dimension 1 Filter", '''''|' + grecGenJnlTemplate[3]."Shortcut Dimension 1 Code")
            else
                // MP 03-13-13 <<
                lrecCorpGLAcc.SetRange("Global Dimension 1 Filter", '');
            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
            // MP 10-01-13 >>
            //IF NOT gblnTBtoTB THEN
            lrecCorpGLAcc.SetFilter("Date Filter", '<%1', gdatStart); // MP 10-01-13 Reinstated line
                                                                      //ELSE
                                                                      // MP 10-01-13 <<
                                                                      //  lrecCorpGLAcc.SETFILTER("Date Filter",'<=%1',CALCDATE('-1D',gdatStart)); // SB 12-06-12 Replaces above
                                                                      // MP 08-05-14

            // MP 10-12-15 >>
            if gblnIncludeUnpostedEntries then begin
                lrecCorpGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                ldecStartBalance := lrecCorpGLAcc."Net Change" + lrecCorpGLAcc."Preposted Net Change" - lrecCorpGLAcc."Preposted Net Change (Bal.)";
            end else begin
                // MP 10-12-15 <<
                lrecCorpGLAcc.CalcFields("Net Change");
                ldecStartBalance := lrecCorpGLAcc."Net Change";
            end; // MP 10-12-15

            //IF NOT grecCorpAccountingPeriod.Closed THEN BEGIN // SB 12-06-12 Added condition
            if not gblnPeriodClosed then begin // MP 03-12-13 Replaces above
                lrecCorpGLAcc.SetRange("Date Filter", ClosingDate(gdatEnd));
                // MP 10-12-15 >>
                if gblnIncludeUnpostedEntries then begin
                    lrecCorpGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecNetChangePL := lrecCorpGLAcc."Net Change" + lrecCorpGLAcc."Preposted Net Change" - lrecCorpGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    // MP 10-12-15 <<
                    lrecCorpGLAcc.CalcFields("Net Change");
                    ldecNetChangePL := lrecCorpGLAcc."Net Change";
                end; // MP 10-12-15
            end;

            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
            // MP 10-01-13 >>
            //IF NOT gblnTBtoTB THEN
            lrecCorpGLAcc.SetRange("Date Filter", gdatStart, gdatEnd); // MP 10-01-13 Reinstated line
                                                                       //ELSE
                                                                       // MP 10-01-13 <<
                                                                       //  lrecCorpGLAcc.SETRANGE("Date Filter",gdatStartWithClosing,gdatEnd); // SB 12-06-12 Replaces above
                                                                       // MP 08-05-14 <<

            // MP 10-12-15 >>
            if gblnIncludeUnpostedEntries then begin
                lrecCorpGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                ldecNetChangeEquity := lrecCorpGLAcc."Net Change" + lrecCorpGLAcc."Preposted Net Change" - lrecCorpGLAcc."Preposted Net Change (Bal.)";
            end else begin
                // MP 10-12-15 <<
                lrecCorpGLAcc.CalcFields("Net Change");
                ldecNetChangeEquity := lrecCorpGLAcc."Net Change";
            end; // MP 10-12-15

            lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::"Corp. Account Summary",
              lrecCorpGLAcc."No.", lrecCorpGLAcc.Name, '', -ldecStartBalance, -ldecNetChangePL, -ldecNetChangeEquity, '', '', 0, 0D, 0D, false);
        until lrecCorpGLAcc.Next() = 0;

        // Calc Current Year Result
        // IF NOT grecCorpAccountingPeriod.Closed THEN BEGIN // MP 22-06-12
        lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Global Dimension 1 Code");
        lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterPL);

        // MP 03-12-13 >>
        if gblnBottomUp then
            lrecGLEntry.SetFilter("Global Dimension 1 Code", '''''|' + grecGenJnlTemplate[3]."Shortcut Dimension 1 Code")
        else
            // MP 03-12-13 <<
            lrecGLEntry.SetRange("Global Dimension 1 Code", '');
        lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd);
        lrecGLEntry.CalcSums(Amount);

        lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::"Corp. Account Summary",
          '', txt60004, '', 0, -lrecGLEntry.Amount, 0, '', '', 0, 0D, 0D, false);
        // END; // MP 22-06-12

        lfcnInsertLineSubtotal(ptmpEquityReconLine, ptmpEquityReconLine.Type::"Corp. Account Summary",
          txt60002, 0D, 0D);

        exit(true);
    end;

    local procedure lfcnPopulateEntryLines(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary)
    var
        lrecGLEntry: Record "G/L Entry";
        ltmpEntryBuffer: Record "Equity Reconciliation Buffer" temporary;
        ltmpPrevEntryBuffer: Record "Equity Reconciliation Buffer" temporary;
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecEquityCorrectionCode: Record "Equity Correction Code";
        lrecEquityReconEntryDesc: Record "Equity Recon. Entry Desc.";
        ltxtSubTotalCaption: Text[50];
        ldecAmount: Decimal;
        lintCurrYear: Integer;
        lintI: Integer;
    begin
        lrecGLEntry.SetCurrentKey("Global Dimension 1 Code", "Posting Date");

        if gblnStatutory then begin
            // MP 03-12-13 >>
            if gblnBottomUp then begin
                lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[3]."Shortcut Dimension 1 Code");
                if gblnCorpAccInUse then // MP 30-04-14 Added gblnCorpAccInUse check
                    lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::Total, '', txt60007, '', 0, 0, 0, '', '', 0, 0D, 0D, true); // MP 08-04-14
            end else
                // MP 03-12-13 <<
                lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[1]."Shortcut Dimension 1 Code");
            ltxtSubTotalCaption := txt60003;
        end else begin
            lrecGLEntry.SetRange("Global Dimension 1 Code", grecGenJnlTemplate[2]."Shortcut Dimension 1 Code");
            ltxtSubTotalCaption := txt60006;
        end;

        lrecGLEntry.SetRange("Posting Date", 0D, gdatEnd);
        lrecGLEntry.SetFilter("Equity Correction Code", '<>%1', '');

        //lintCurrYear := DATE2DMY(gdatStart,3);
        lintCurrYear := Date2DMY(gdatEnd, 3); // MP 10-12-15 Replaces above line
                                              // Populate temp. buffer table
        for lintI := 1 to 2 do begin
            // MP 03-12-13 >>
            if not gblnCorpAccInUse then
                if lintI = 1 then
                    lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterPL)
                else
                    lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterEquity)
            else
                // MP 03-12-13 <<
                if lintI = 1 then
                    lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterPL)
                else
                    lrecGLEntry.SetFilter("Corporate G/L Account No.", gtxtGLAccountFilterEquity);

            // MP 10-12-15 >>
            if gblnIncludeUnpostedEntries then
                lfcnProcessEntryLinesInclUnposted(lrecGLEntry, ltmpEntryBuffer, lintCurrYear, lintI)
            else
                // MP 10-12-15 <<
                if lrecGLEntry.FindSet() then
                    repeat
                        if NormalDate(lrecGLEntry."Posting Date") = lrecGLEntry."Posting Date" then begin // Exclude Closing Dates
                            ltmpEntryBuffer.Init();

                            if goptGroupBy = goptGroupBy::"Equity Correction Code" then
                                ltmpEntryBuffer.Year := 0
                            else
                                if lrecGLEntry."Posting Date" >= gdatStart then begin
                                    ltmpEntryBuffer.Year := lintCurrYear;
                                    ltmpEntryBuffer."Year Start Date" := gdatStart;
                                    ltmpEntryBuffer."Year End Date" := gdatEnd;
                                end else begin
                                    ltmpEntryBuffer.Year := Date2DMY(lrecGLEntry."Posting Date", 3);
                                    gmdlGAAPMgt.gfcnGetAccPeriodFilter(lrecGLEntry."Posting Date", ltmpEntryBuffer."Year Start Date", ltmpEntryBuffer."Year End Date");
                                end;

                            ltmpEntryBuffer."Equity Correction Code" := lrecGLEntry."Equity Correction Code";

                            if goptGroupBy = goptGroupBy::Year then
                                ltmpEntryBuffer."Document No." := lrecGLEntry."Document No.";

                            // MP 03-12-13 >>
                            if gblnBottomUp and gblnStatutory then
                                ldecAmount := -lrecGLEntry.Amount
                            else
                                ldecAmount := lrecGLEntry.Amount;
                            // MP 03-12-13 <<

                            if not ltmpEntryBuffer.Find() then begin

                                // MP 06-12-12 >>

                                if (goptGroupBy = goptGroupBy::"Equity Correction Code") and (lrecGLEntry."Posting Date" < gdatStart) then
                                    ltmpEntryBuffer."Start Balance" := ldecAmount // MP 03-12-13 Replaces lrecGLEntry.Amount
                                else

                                    // MP 06-12-12 <<

                                    if lintI = 1 then
                                        ltmpEntryBuffer."Net Change (P&L)" := ldecAmount // MP 03-12-13 Replaces lrecGLEntry.Amount
                                    else
                                        ltmpEntryBuffer."Net Change (Equity)" := ldecAmount; // MP 03-12-13 Replaces lrecGLEntry.Amount;

                                if goptGroupBy = goptGroupBy::Year then
                                    ltmpEntryBuffer."Entry Description" := lrecGLEntry.Description;

                                ltmpEntryBuffer.Insert();
                            end else begin

                                // MP 06-12-12 >>

                                if (goptGroupBy = goptGroupBy::"Equity Correction Code") and (lrecGLEntry."Posting Date" < gdatStart) then
                                    ltmpEntryBuffer."Start Balance" += ldecAmount // MP 21-01-13 Changed from := to += // MP 03-12-13 Replaces lrecGLEntry.Amount
                                else

                                    // MP 06-12-12 <<

                                    if lintI = 1 then
                                        ltmpEntryBuffer."Net Change (P&L)" += ldecAmount // MP 03-12-13 Replaces lrecGLEntry.Amount
                                    else
                                        ltmpEntryBuffer."Net Change (Equity)" += ldecAmount; // MP 03-12-13 Replaces lrecGLEntry.Amount;

                                ltmpEntryBuffer.Modify();
                            end;
                        end;
                    until lrecGLEntry.Next() = 0;
        end;

        // Create entries
        if ltmpEntryBuffer.FindSet() then begin
            ltmpPrevEntryBuffer := ltmpEntryBuffer;
            repeat
                // Insert Subtotal

                if ltmpPrevEntryBuffer.Year <> ltmpEntryBuffer.Year then
                    // MP 18-02-16 Do not create subtotals by year, only blank line >>
                    //  lfcnInsertLineSubtotal(ptmpEquityReconLine,ptmpEquityReconLine.Type::Entries,
                    //    STRSUBSTNO(ltxtSubTotalCaption,ltmpPrevEntryBuffer.Year),
                    //    ltmpPrevEntryBuffer."Year Start Date",ltmpPrevEntryBuffer."Year End Date");
                    lfcnInsertLineBlank(ptmpEquityReconLine);
                // MP 18-02-16 <<

                // Get Equity Correction Code Description
                if ltmpEntryBuffer."Equity Correction Code" <> '' then
                    lrecEquityCorrectionCode.Get(ltmpEntryBuffer."Equity Correction Code")
                else
                    Clear(lrecEquityCorrectionCode);

                // Get Entry Description
                if goptGroupBy = goptGroupBy::Year then
                    if lrecEquityReconEntryDesc.Get(ltmpEntryBuffer."Equity Correction Code", ltmpEntryBuffer.Year, ltmpEntryBuffer."Document No.") then
                        ltmpEntryBuffer."Entry Description" := lrecEquityReconEntryDesc.Description;

                // Insert Entry
                if (ltmpEntryBuffer.Year = lintCurrYear) or (goptGroupBy = goptGroupBy::"Equity Correction Code") then
                    lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::Entries,
                      ltmpEntryBuffer."Equity Correction Code", lrecEquityCorrectionCode.Description, ltmpEntryBuffer."Entry Description",
                      //          0,-"Net Change (P&L)",-"Net Change (Equity)",
                      -ltmpEntryBuffer."Start Balance", -ltmpEntryBuffer."Net Change (P&L)", -ltmpEntryBuffer."Net Change (Equity)", // MP 06-12-12 Replaces above line
                      '', ltmpEntryBuffer."Document No.", ltmpEntryBuffer.Year, ltmpEntryBuffer."Year Start Date", ltmpEntryBuffer."Year End Date", false)
                else
                    lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::Entries,
                      ltmpEntryBuffer."Equity Correction Code", lrecEquityCorrectionCode.Description, ltmpEntryBuffer."Entry Description",
                      -ltmpEntryBuffer."Net Change (P&L)" - ltmpEntryBuffer."Net Change (Equity)", 0, 0,
                      ltmpEntryBuffer."Document No.", '', ltmpEntryBuffer.Year, ltmpEntryBuffer."Year Start Date", ltmpEntryBuffer."Year End Date", false);

                ltmpPrevEntryBuffer := ltmpEntryBuffer;
            until ltmpEntryBuffer.Next() = 0;
        end;

        // Insert Subtotal
        // MP 18-02-16 Do not create subtotals by year, only blank line >>
        if (ltmpEntryBuffer.Year <> lintCurrYear) and (ltmpEntryBuffer.Year <> 0) then
            //  lfcnInsertLineSubtotal(ptmpEquityReconLine,ptmpEquityReconLine.Type::Entries,
            //    STRSUBSTNO(ltxtSubTotalCaption,ltmpPrevEntryBuffer.Year),
            //    ltmpPrevEntryBuffer."Year Start Date",ltmpPrevEntryBuffer."Year End Date");
            lfcnInsertLineBlank(ptmpEquityReconLine);
        // MP 18-02-16 <<
    end;

    local procedure lfcnSetGLAccountFilters()
    var
        lrecCorpGLAccount: Record "Corporate G/L Account";
        lrecPrevCorpGLAccount: Record "Corporate G/L Account";
    begin
        if (gtxtGLAccountFilterEquity <> '') or (gtxtGLAccountFilterPL <> '') then
            exit;

        lrecCorpGLAccount.SetRange("Account Class", lrecCorpGLAccount."Account Class"::Equity, lrecCorpGLAccount."Account Class"::"P&L");
        lrecCorpGLAccount.FindFirst();

        lrecCorpGLAccount.SetRange("Account Class");
        lrecCorpGLAccount.SetFilter("No.", '%1..', lrecCorpGLAccount."No.");

        lrecCorpGLAccount.FindSet();
        lrecPrevCorpGLAccount."Account Class" := lrecCorpGLAccount."Account Class";
        repeat
            if lrecPrevCorpGLAccount."Account Class" <> lrecCorpGLAccount."Account Class" then begin
                if lrecPrevCorpGLAccount."No." <> '' then begin
                    case lrecPrevCorpGLAccount."Account Class" of
                        lrecPrevCorpGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += '..' + lrecPrevCorpGLAccount."No." + '|';
                        lrecPrevCorpGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += '..' + lrecPrevCorpGLAccount."No." + '|';
                    end;

                    case lrecCorpGLAccount."Account Class" of
                        lrecCorpGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += lrecCorpGLAccount."No.";
                        lrecCorpGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += lrecCorpGLAccount."No.";
                    end;

                    Clear(lrecPrevCorpGLAccount."No.");
                    Clear(lrecPrevCorpGLAccount."Account Class");
                end;
            end else begin
                if lrecPrevCorpGLAccount."No." = '' then
                    case lrecCorpGLAccount."Account Class" of
                        lrecCorpGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += lrecCorpGLAccount."No.";
                        lrecCorpGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += lrecCorpGLAccount."No.";
                    end;
            end;

            lrecPrevCorpGLAccount."No." := lrecCorpGLAccount."No.";
            lrecPrevCorpGLAccount."Account Class" := lrecCorpGLAccount."Account Class";
        until lrecCorpGLAccount.Next() = 0;

        case lrecCorpGLAccount."Account Class" of
            lrecCorpGLAccount."Account Class"::Equity:
                gtxtGLAccountFilterEquity += '..' + lrecCorpGLAccount."No.";
            lrecCorpGLAccount."Account Class"::"P&L":
                gtxtGLAccountFilterPL += '..' + lrecCorpGLAccount."No.";
        end;

        if gtxtGLAccountFilterEquity[StrLen(gtxtGLAccountFilterEquity)] = '|' then
            gtxtGLAccountFilterEquity := CopyStr(gtxtGLAccountFilterEquity, 1, StrLen(gtxtGLAccountFilterEquity) - 1);

        if gtxtGLAccountFilterPL[StrLen(gtxtGLAccountFilterPL)] = '|' then
            gtxtGLAccountFilterPL := CopyStr(gtxtGLAccountFilterPL, 1, StrLen(gtxtGLAccountFilterPL) - 1);
    end;


    procedure gfcnGetAccountFilter(var ptxtGLAccountFilterEquity: Text; var ptxtGLAccountFilterPL: Text)
    begin
        // MP 15-01-13

        // MP 03-12-13 >>
        if not gblnCorpAccInUse then
            lfcnSetLocalGLAccountFilters()
        else
            // MP 03-12-13 <<
            lfcnSetGLAccountFilters();

        ptxtGLAccountFilterEquity := gtxtGLAccountFilterEquity;
        ptxtGLAccountFilterPL := gtxtGLAccountFilterPL;
    end;

    local procedure lfcnSetLocalGLAccountFilters()
    var
        lrecGLAccount: Record "G/L Account";
        lrecPrevGLAccount: Record "G/L Account";
    begin
        // MP 03-12-13

        if (gtxtGLAccountFilterEquity <> '') or (gtxtGLAccountFilterPL <> '') then
            exit;

        lrecGLAccount.SetRange("Account Class", lrecGLAccount."Account Class"::Equity, lrecGLAccount."Account Class"::"P&L");
        lrecGLAccount.FindFirst();

        lrecGLAccount.SetRange("Account Class");
        lrecGLAccount.SetFilter("No.", '%1..', lrecGLAccount."No.");

        lrecGLAccount.FindSet();
        lrecPrevGLAccount."Account Class" := lrecGLAccount."Account Class";
        repeat
            if lrecPrevGLAccount."Account Class" <> lrecGLAccount."Account Class" then begin
                if lrecPrevGLAccount."No." <> '' then begin
                    case lrecPrevGLAccount."Account Class" of
                        lrecPrevGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += '..' + lrecPrevGLAccount."No." + '|';
                        lrecPrevGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += '..' + lrecPrevGLAccount."No." + '|';
                    end;

                    case lrecGLAccount."Account Class" of
                        lrecGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += lrecGLAccount."No.";
                        lrecGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += lrecGLAccount."No.";
                    end;

                    Clear(lrecPrevGLAccount."No.");
                    Clear(lrecPrevGLAccount."Account Class");
                end;
            end else begin
                if lrecPrevGLAccount."No." = '' then
                    case lrecGLAccount."Account Class" of
                        lrecGLAccount."Account Class"::Equity:
                            gtxtGLAccountFilterEquity += lrecGLAccount."No.";
                        lrecGLAccount."Account Class"::"P&L":
                            gtxtGLAccountFilterPL += lrecGLAccount."No.";
                    end;
            end;

            lrecPrevGLAccount."No." := lrecGLAccount."No.";
            lrecPrevGLAccount."Account Class" := lrecGLAccount."Account Class";
        until lrecGLAccount.Next() = 0;

        case lrecGLAccount."Account Class" of
            lrecGLAccount."Account Class"::Equity:
                gtxtGLAccountFilterEquity += '..' + lrecGLAccount."No.";
            lrecGLAccount."Account Class"::"P&L":
                gtxtGLAccountFilterPL += '..' + lrecGLAccount."No.";
        end;

        if gtxtGLAccountFilterEquity[StrLen(gtxtGLAccountFilterEquity)] = '|' then
            gtxtGLAccountFilterEquity := CopyStr(gtxtGLAccountFilterEquity, 1, StrLen(gtxtGLAccountFilterEquity) - 1);

        if gtxtGLAccountFilterPL[StrLen(gtxtGLAccountFilterPL)] = '|' then
            gtxtGLAccountFilterPL := CopyStr(gtxtGLAccountFilterPL, 1, StrLen(gtxtGLAccountFilterPL) - 1);
    end;

    local procedure lfcnPopulateLocalAccSumLines(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary): Boolean
    var
        lrecGLEntry: Record "G/L Entry";
        lrecGLAcc: Record "G/L Account";
        lrrfAccPeriod: RecordRef;
        lfrfField: FieldRef;
        ldecStartBalance: Decimal;
        ldecNetChangePL: Decimal;
        ldecNetChangeEquity: Decimal;
    begin
        // MP 03-12-13

        lrecGLAcc.SetRange("Account Class", lrecGLAcc."Account Class"::Equity);
        if not lrecGLAcc.FindSet() then
            exit(false);

        grecEYCoreSetup.Get();
        grecEYCoreSetup.TestField("Local Retained Earnings Acc.");

        lrrfAccPeriod.Open(gmdlCompanyTypeMgt.gfcnGetAccPeriodTableID());
        lfrfField := lrrfAccPeriod.Field(1); // "Starting Date"
        lfrfField.SetRange(gdatStart);
        lrrfAccPeriod.FindFirst();

        gblnPeriodClosed := lrrfAccPeriod.Field(4).Value; // Closed

        // Corp. Account Summary section
        repeat
            lrecGLAcc.SetRange("Global Dimension 1 Filter", '');

            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
            //IF NOT gblnTBtoTB THEN
            lrecGLAcc.SetFilter("Date Filter", '<%1', gdatStart);
            //ELSE
            //  lrecGLAcc.SETFILTER("Date Filter",'<=%1',CALCDATE('-1D',gdatStart));
            // MP 08-05-14 <<

            // MP 10-12-15 >>
            if gblnIncludeUnpostedEntries then begin
                lrecGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                ldecStartBalance := lrecGLAcc."Net Change" + lrecGLAcc."Preposted Net Change" - lrecGLAcc."Preposted Net Change (Bal.)";
            end else begin
                // MP 10-12-15 <<
                lrecGLAcc.CalcFields("Net Change");
                ldecStartBalance := lrecGLAcc."Net Change";
            end; // MP 10-12-15

            if not gblnPeriodClosed then begin
                lrecGLAcc.SetRange("Date Filter", ClosingDate(gdatEnd));
                // MP 10-12-15 >>
                if gblnIncludeUnpostedEntries then begin
                    lrecGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                    ldecNetChangePL := lrecGLAcc."Net Change" + lrecGLAcc."Preposted Net Change" - lrecGLAcc."Preposted Net Change (Bal.)";
                end else begin
                    // MP 10-12-15 <<
                    lrecGLAcc.CalcFields("Net Change");
                    ldecNetChangePL := lrecGLAcc."Net Change";
                end; // MP 10-12-15
            end;

            // MP 08-05-14 Same filter regardless of TB-to-TB or Transactional >>
            //IF NOT gblnTBtoTB THEN
            lrecGLAcc.SetRange("Date Filter", gdatStart, gdatEnd);
            //ELSE
            //  lrecGLAcc.SETRANGE("Date Filter",gdatStartWithClosing,gdatEnd);
            // MP 08-05-14 <<

            // MP 10-12-15 >>
            if gblnIncludeUnpostedEntries then begin
                lrecGLAcc.CalcFields("Net Change", "Preposted Net Change", "Preposted Net Change (Bal.)");
                ldecNetChangeEquity := lrecGLAcc."Net Change" + lrecGLAcc."Preposted Net Change" - lrecGLAcc."Preposted Net Change (Bal.)";
            end else begin
                // MP 10-12-15 <<
                lrecGLAcc.CalcFields("Net Change");
                ldecNetChangeEquity := lrecGLAcc."Net Change";
            end; // MP 10-12-15

            lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::"Corp. Account Summary",
              lrecGLAcc."No.", lrecGLAcc.Name, '', -ldecStartBalance, -ldecNetChangePL, -ldecNetChangeEquity, '', '', 0, 0D, 0D, false);
        until lrecGLAcc.Next() = 0;

        // Calc Current Year Result
        lrecGLEntry.SetCurrentKey("G/L Account No.", "Global Dimension 1 Code");
        lrecGLEntry.SetFilter("G/L Account No.", gtxtGLAccountFilterPL);
        lrecGLEntry.SetRange("Global Dimension 1 Code", '');
        lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd);
        lrecGLEntry.CalcSums(Amount);

        lfcnInsertLine(ptmpEquityReconLine, ptmpEquityReconLine.Type::"Corp. Account Summary",
          '', txt60004, '', 0, -lrecGLEntry.Amount, 0, '', '', 0, 0D, 0D, false);

        exit(true);
    end;

    local procedure lfcnProcessEntryLinesInclUnposted(var precGLEntry: Record "G/L Entry"; var ptmpEntryBuffer: Record "Equity Reconciliation Buffer" temporary; pintCurrYear: Integer; pintI: Integer)
    var
        ltmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary;
        lmdlAdjmtsMgt: Codeunit "Adjustments Management";
        ldecAmount: Decimal;
    begin
        // MP 10-12-15

        lmdlAdjmtsMgt.gfcnGetEntries(ltmpAdjmtEntryBuffer, precGLEntry, true, false);

        if ltmpAdjmtEntryBuffer.FindSet() then begin
            repeat
                if NormalDate(ltmpAdjmtEntryBuffer."Posting Date") = ltmpAdjmtEntryBuffer."Posting Date" then begin // Exclude Closing Dates
                    ptmpEntryBuffer.Init();

                    if goptGroupBy = goptGroupBy::"Equity Correction Code" then
                        ptmpEntryBuffer.Year := 0
                    else
                        if ltmpAdjmtEntryBuffer."Posting Date" >= gdatStart then begin
                            ptmpEntryBuffer.Year := pintCurrYear;
                            ptmpEntryBuffer."Year Start Date" := gdatStart;
                            ptmpEntryBuffer."Year End Date" := gdatEnd;
                        end else begin
                            ptmpEntryBuffer.Year := Date2DMY(ltmpAdjmtEntryBuffer."Posting Date", 3);
                            gmdlGAAPMgt.gfcnGetAccPeriodFilter(ltmpAdjmtEntryBuffer."Posting Date", ptmpEntryBuffer."Year Start Date", ptmpEntryBuffer."Year End Date");
                        end;

                    ptmpEntryBuffer."Equity Correction Code" := ltmpAdjmtEntryBuffer."Equity Correction Code";

                    if goptGroupBy = goptGroupBy::Year then
                        ptmpEntryBuffer."Document No." := ltmpAdjmtEntryBuffer."Document No.";

                    if gblnBottomUp and gblnStatutory then
                        ldecAmount := -ltmpAdjmtEntryBuffer.Amount
                    else
                        ldecAmount := ltmpAdjmtEntryBuffer.Amount;

                    if not ptmpEntryBuffer.Find() then begin
                        if (goptGroupBy = goptGroupBy::"Equity Correction Code") and (ltmpAdjmtEntryBuffer."Posting Date" < gdatStart) then
                            ptmpEntryBuffer."Start Balance" := ldecAmount
                        else
                            if pintI = 1 then
                                ptmpEntryBuffer."Net Change (P&L)" := ldecAmount
                            else
                                ptmpEntryBuffer."Net Change (Equity)" := ldecAmount;

                        if goptGroupBy = goptGroupBy::Year then
                            ptmpEntryBuffer."Entry Description" := ltmpAdjmtEntryBuffer.Description;

                        ptmpEntryBuffer.Insert();
                    end else begin
                        if (goptGroupBy = goptGroupBy::"Equity Correction Code") and (ltmpAdjmtEntryBuffer."Posting Date" < gdatStart) then
                            ptmpEntryBuffer."Start Balance" += ldecAmount
                        else
                            if pintI = 1 then
                                ptmpEntryBuffer."Net Change (P&L)" += ldecAmount
                            else
                                ptmpEntryBuffer."Net Change (Equity)" += ldecAmount;

                        ptmpEntryBuffer.Modify();
                    end;
                end;
            until ltmpAdjmtEntryBuffer.Next() = 0;
            ltmpAdjmtEntryBuffer.DeleteAll();
        end;
    end;
}

