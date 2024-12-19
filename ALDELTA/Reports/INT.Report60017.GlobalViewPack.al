report 60017 "Global View Pack"
{
    // MP 18-02-16
    // Fixed issue with Global View, was not Excluding Accounts based on selection
    // 
    // MP 22-02-16
    // Fixed error with Excel tab name due to not duplicate. Removed certain columns in Excel Export for Equity Reconciliation
    // 
    // MP 22-03-16
    // Swapped column order in Financial Statement (CB1 CR002)
    // Removed zero lines from Equity Reconciliation
    // Only populates FS Code for PY if different
    // Global Vies now always uses Local
    DefaultLayout = RDLC;
    RDLCLayout = './GlobalViewPack.rdlc';

    Caption = 'Global View Pack';
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem(CoverPage; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(GlobalViewPackCaption; txtGlobalViewPackCaptionLbl)
            {
            }
            column(StatutoryReportingCaption; txtStatutoryReportingCaptionLbl)
            {
            }
            column(CompanyName; CoverPage.Name)
            {
            }
            column(ContentPageCaption; txtContentPageCaptionLbl)
            {
            }
            column(ContentsLine1; gtxtContentsLine[1])
            {
            }
            column(ContentsLine2; gtxtContentsLine[2])
            {
            }
            column(ContentsLine3; gtxtContentsLine[3])
            {
            }
            column(ContentsLine4; gtxtContentsLine[4])
            {
            }
            column(ContentsLine5; gtxtContentsLine[5])
            {
            }
            column(GlobalViewCaption; StrSubstNo(txtGlobalViewCaptionLbl, gintFinancialYear))
            {
            }
            column(EquityReconciliationEquityCodeCaption; gtxtEquityReconciliationEquityCodeCaption)
            {
            }
            column(EquityReconciliationYearCaption; gtxtEquityReconciliationYearCaption)
            {
            }
            column(AdjustmentsViewCaption; StrSubstNo(txtAdjustmentsViewCaptionLbl, gintFinancialYear))
            {
            }
            column(FinancialStatementCaption; StrSubstNo(txtFinancialStatementCaptionLbl, gintFinancialYear))
            {
            }
            column(PostingDateCaption; txtPostingDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; txtDocumentNoCaptionLbl)
            {
            }
            column(CorporateGLAccountNoCaption; txtCorporateGLAccountNoCaptionLbl)
            {
            }
            column(CorporateGLAccountNameCaption; txtCorporateGLAccountNameCaptionLbl)
            {
            }
            column(GLAccountNoCaption; txtGLAccountNoCaptionLbl)
            {
            }
            column(GLAccountNameCaption; txtGLAccountNameCaptionLbl)
            {
            }
            column(CorpGAAPCaption; StrSubstNo(txtCorpGAAPCaptionLbl, gintFinancialYear))
            {
            }
            column(PriorYearAdjustmentsCaption; txtPriorYearAdjustmentsCaptionLbl)
            {
            }
            column(CurrentYearAdjustmentsCaption; txtCurrentYearAdjustmentsCaptionLbl)
            {
            }
            column(CurrentYearReclassificationsCaption; txtCurrentYearReclassificationsCaptionLbl)
            {
            }
            column(StatutoryTBCaption; StrSubstNo(txtStatutoryTBCaptionLbl, gintFinancialYear))
            {
            }
            column(FSCodeCaption; txtFSCodeCaptionLbl)
            {
            }
            column(FSCodeDescriptionCaption; txtFSCodeDescriptionCaptionLbl)
            {
            }
            column(AccountClassCaption; txtAccountClassCaptionLbl)
            {
            }
            column(CodeCaption; txtCodeCaptionLbl)
            {
            }
            column(DescriptionCaption; txtDescriptionCaptionLbl)
            {
            }
            column(EntryDescriptionCaption; txtEntryDescriptionCaptionLbl)
            {
            }
            column(YearCaption; txtYearCaptionLbl)
            {
            }
            column(StartBalanceEquityCaption; gtxtStartBalanceEquityCaption)
            {
            }
            column(NetChangePLCaption; gtxtNetChangePLCaption)
            {
            }
            column(NetChangeEquityCaption; gtxtNetChangeEquityCaption)
            {
            }
            column(EndBalanceEquityCaption; gtxtEndBalanceEquityCaption)
            {
            }
            column(GAAPAdjustmentReasonCaption; txtGAAPAdjustmentReasonCaptionLbl)
            {
            }
            column(AdjustmentRoleCaption; txtAdjustmentRoleCaptionLbl)
            {
            }
            column(AmountCaption; txtAmountCaptionLbl)
            {
            }
            column(EquityCorrectionCodeCaption; txtEquityCorrectionCodeCaptionLbl)
            {
            }
            column(DescriptionEngCaption; txtDescriptionEngCaptionLbl)
            {
            }
            column(StartBalanceCaption; gtxtStartBalanceCaption)
            {
            }
            column(EndBalanceCaption; gtxtEndBalanceCaption)
            {
            }
            column(DraftCaption; gtxtDraft)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if gblnExportToExcel then begin
                    //gtmpExcelBuffer.CreateBook(txtCoverPageCaptionLbl);
                    // gtmpExcelBuffer.CreateBook(txtGlobalViewPackCaptionLbl, txtCoverPageCaptionLbl); // MP 16-Jun-16 Replaces above

                    lfcnSetFontFormat(true, false, true);
                    lfcnEnterCellText(2, 2, txtGlobalViewPackCaptionLbl);

                    lfcnSetFontFormat(false, false, false);
                    lfcnEnterCellText(4, 2, txtStatutoryReportingCaptionLbl);
                    lfcnEnterCellText(6, 2, CoverPage.Name);
                end;
            end;

            trigger OnPostDataItem()
            begin
                if gblnExportToExcel then begin
                    gtmpExcelBuffer.WriteSheet(txtCoverPageCaptionLbl, CompanyName, UserId);
                    gtmpExcelBuffer.DeleteAll();
                end;
            end;
        }
        dataitem(ContentPage; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                lintI: Integer;
            begin
                if gblnExportToExcel then begin
                    // gtmpExcelBuffer.gfcnAddWorksheet(txtContentPageCaptionLbl);

                    lfcnSetFontFormat(true, false, true);
                    lfcnEnterCellText(2, 2, txtContentPageCaptionLbl);

                    lfcnSetFontFormat(false, false, false);
                    repeat
                        lintI += 1;
                        if gtxtContentsLine[lintI] = '' then
                            lintI := 5
                        else
                            lfcnEnterCellText(lintI * 2 + 2, 2, gtxtContentsLine[lintI]);
                    until lintI >= 5;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if gblnExportToExcel then begin
                    gtmpExcelBuffer.WriteSheet(txtContentPageCaptionLbl, CompanyName, UserId);
                    gtmpExcelBuffer.DeleteAll();
                end;
            end;
        }
        dataitem(FinancialStatement; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(Description_FinancialStatement; gtmpFinStatLine.Description)
            {
            }
            column(Description_FinancialStatementEnglish; gtmpFinStatLine."Description (English)")
            {
            }
            column(Code_FinancialStatement; gtmpFinStatLine.Code)
            {
            }
            column(EndBalance_FinancialStatement; gtmpFinStatLine."End Balance")
            {
            }
            column(StartBalance_FinancialStatement; gtmpFinStatLine."Start Balance")
            {
            }
            column(LineType_FinancialStatement; Format(gtmpFinStatLine."Line Type", 0, 2))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 2 then
                    gtmpFinStatLine.FindSet()
                else
                    gtmpFinStatLine.Next();

                if gblnExportToExcel then begin
                    if gtmpFinStatLine."Line Type" in [gtmpFinStatLine."Line Type"::Heading, gtmpFinStatLine."Line Type"::"Begin-Total", gtmpFinStatLine."Line Type"::"End-Total",
                      gtmpFinStatLine."Line Type"::Totalling, gtmpFinStatLine."Line Type"::Formula]
                    then
                        lfcnSetFontFormat(true, false, false)
                    else
                        lfcnSetFontFormat(false, false, false);

                    lfcnEnterCellText(Number, 1, gtmpFinStatLine.Description);
                    lfcnEnterCellText(Number, 2, gtmpFinStatLine."Description (English)");
                    lfcnEnterCellText(Number, 3, gtmpFinStatLine.Code);

                    if not (gtmpFinStatLine."Line Type" in [gtmpFinStatLine."Line Type"::" ", gtmpFinStatLine."Line Type"::Heading, gtmpFinStatLine."Line Type"::"Begin-Total"]) then begin
                        lfcnEnterCellDecimal(Number, 4, gtmpFinStatLine."End Balance"); // MP 22-03-16 Swapped two columns around
                        lfcnEnterCellDecimal(Number, 5, gtmpFinStatLine."Start Balance"); // MP 22-03-16 Swapped two columns around
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if gblnExportToExcel then begin
                    gtmpExcelBuffer.WriteSheet(StrSubstNo(txtFinancialStatementCaptionLbl, gintFinancialYear), CompanyName, UserId);
                    gtmpExcelBuffer.DeleteAll();
                end;

                gtmpFinStatLine.DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
                if not gblnPrintFinancialStatement then
                    CurrReport.Break();

                gmdlGAAPMgtFinStat.gfcnCalc(gtmpFinStatLine);

                if gblnExportToExcel then begin
                    // gtmpExcelBuffer.gfcnAddWorksheet(StrSubstNo(txtFinancialStatementCaptionLbl, gintFinancialYear));

                    lfcnSetFontFormat(true, false, true);
                    lfcnEnterCellText(1, 1, txtDescriptionCaptionLbl);
                    lfcnEnterCellText(1, 2, txtDescriptionEngCaptionLbl);
                    lfcnEnterCellText(1, 3, txtFSCodeCaptionLbl);
                    lfcnEnterCellText(1, 4, gtxtEndBalanceCaption); // MP 22-03-16 Swapped two columns around
                    lfcnEnterCellText(1, 5, gtxtStartBalanceCaption); // MP 22-03-16 Swapped two columns around
                end;

                gtmpFinStatLine.SetRange(Indentation, 0); // Summary only, do not show accounts
                FinancialStatement.SetRange(Number, 2, gtmpFinStatLine.Count + 1);
            end;
        }
        dataitem(EquityReconciliationLoop; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem(EquityReconciliation; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Group_EquityReconciliation; EquityReconciliationLoop.Number)
                {
                }
                column(Code_EquityReconciliation; gtmpEquityReconLine.Code)
                {
                }
                column(Description_EquityReconciliation; gtmpEquityReconLine.Description)
                {
                }
                column(EntryDescription_EquityReconciliation; gtmpEquityReconLine."Entry Description")
                {
                }
                column(Year_EquityReconciliation; gtmpEquityReconLine.Year)
                {
                }
                column(StartBalance_EquityReconciliation; gtmpEquityReconLine."Start Balance")
                {
                }
                column(DocNoStartBalance_EquityReconciliation; gtmpEquityReconLine."Document No. (Start Balance)")
                {
                }
                column(NetChangePL_EquityReconciliation; gtmpEquityReconLine."Net Change (P&L)")
                {
                }
                column(NetChangeEquity_EquityReconciliation; gtmpEquityReconLine."Net Change (Equity)")
                {
                }
                column(DocNoNetChange_EquityReconciliation; gtmpEquityReconLine."Document No. (Net Change)")
                {
                }
                column(EndBalance_EquityReconciliation; gtmpEquityReconLine."End Balance")
                {
                }
                column(Subtotal_EquityReconciliation; Format(gtmpEquityReconLine.Subtotal, 0, 9))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 2 then
                        gtmpEquityReconLine.FindSet()
                    else
                        gtmpEquityReconLine.Next();

                    if gblnExportToExcel then begin
                        if gtmpEquityReconLine.Subtotal then
                            lfcnSetFontFormat(true, false, false)
                        else
                            lfcnSetFontFormat(false, false, false);

                        lfcnEnterCellText(Number, 1, gtmpEquityReconLine.Code);
                        lfcnEnterCellText(Number, 2, gtmpEquityReconLine.Description);

                        if EquityReconciliationLoop.Number = 2 then begin // MP 22-02-16 Added condition
                            lfcnEnterCellText(Number, 3, gtmpEquityReconLine."Entry Description");
                            if gtmpEquityReconLine.Year <> 0 then
                                lfcnEnterCellText(Number, 4, Format(gtmpEquityReconLine.Year));
                            lfcnEnterCellDecimal(Number, 5, gtmpEquityReconLine."Start Balance");
                            lfcnEnterCellText(Number, 6, gtmpEquityReconLine."Document No. (Start Balance)");
                            lfcnEnterCellDecimal(Number, 7, gtmpEquityReconLine."Net Change (P&L)");
                            lfcnEnterCellDecimal(Number, 8, gtmpEquityReconLine."Net Change (Equity)");
                            lfcnEnterCellText(Number, 9, gtmpEquityReconLine."Document No. (Net Change)");
                            lfcnEnterCellDecimal(Number, 10, gtmpEquityReconLine."End Balance");
                            // MP 22-02-16 >>
                        end else begin
                            lfcnEnterCellDecimal(Number, 3, gtmpEquityReconLine."Start Balance");
                            lfcnEnterCellDecimal(Number, 4, gtmpEquityReconLine."Net Change (P&L)");
                            lfcnEnterCellDecimal(Number, 5, gtmpEquityReconLine."Net Change (Equity)");
                            lfcnEnterCellDecimal(Number, 6, gtmpEquityReconLine."End Balance");
                        end;
                        // MP 22-02-16 <<
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if gblnExportToExcel then begin
                        gtmpExcelBuffer.WriteSheet(txtEquityReconciliationCaptionLbl, CompanyName, UserId);
                        gtmpExcelBuffer.DeleteAll();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if gblnExportToExcel then begin
                        if EquityReconciliationLoop.Number = 1 then
                            //gtmpExcelBuffer.gfcnAddWorksheet(gtxtEquityReconciliationEquityCodeCaption)
                            // else
                            // MP 22-02-16 >>
                            if gblnPrintEquityReconciliationByCode then // Also printed by Code, make sure tab name is unique
                                                                        // gtmpExcelBuffer.gfcnAddWorksheet(CopyStr(gtxtEquityReconciliationYearCaption, 1, 30) + '_')
                                                                        // else
                                                                        // MP 22-02-16 <<
                                                                        // gtmpExcelBuffer.gfcnAddWorksheet(gtxtEquityReconciliationYearCaption);

                                lfcnSetFontFormat(true, false, true);
                        lfcnEnterCellText(1, 1, txtCodeCaptionLbl);
                        lfcnEnterCellText(1, 2, txtDescriptionCaptionLbl);

                        if EquityReconciliationLoop.Number = 2 then begin // MP 22-02-16 Added condition
                            lfcnEnterCellText(1, 3, txtEntryDescriptionCaptionLbl);
                            lfcnEnterCellText(1, 4, txtYearCaptionLbl);
                            lfcnEnterCellText(1, 5, gtxtStartBalanceEquityCaption);
                            lfcnEnterCellText(1, 6, txtDocumentNoCaptionLbl);
                            lfcnEnterCellText(1, 7, gtxtNetChangePLCaption);
                            lfcnEnterCellText(1, 8, gtxtNetChangeEquityCaption);
                            lfcnEnterCellText(1, 9, txtDocumentNoCaptionLbl);
                            lfcnEnterCellText(1, 10, gtxtEndBalanceEquityCaption);
                            // MP 22-02-16 >>
                        end else begin
                            lfcnEnterCellText(1, 3, gtxtStartBalanceEquityCaption);
                            lfcnEnterCellText(1, 4, gtxtNetChangePLCaption);
                            lfcnEnterCellText(1, 5, gtxtNetChangeEquityCaption);
                            lfcnEnterCellText(1, 6, gtxtEndBalanceEquityCaption);
                        end;
                        // MP 22-02-16 <<

                        lfcnSetFontFormat(false, false, false);
                    end;

                    if EquityReconciliationLoop.Number = 2 then begin
                        goptGroupBy := goptGroupBy::Year;
                        gmdlGAAPMgtEquityRecon.gfcnInit(gdatStart, gdatEnd, goptGroupBy, gblnIncludeUnpostedEntries);
                    end;

                    gmdlGAAPMgtEquityRecon.gfcnCalc(gtmpEquityReconLine);

                    // MP 18-03-16 Remove zero lines >>
                    if EquityReconciliationLoop.Number = 2 then begin // By Year
                        gtmpEquityReconLine.SetRange(Type, gtmpEquityReconLine.Type::Entries);
                        gtmpEquityReconLine.SetRange("Start Balance", 0);
                        gtmpEquityReconLine.SetRange("Net Change (P&L)", 0);
                        gtmpEquityReconLine.SetRange("Net Change (Equity)", 0);
                        gtmpEquityReconLine.SetRange("End Balance", 0);

                        gtmpEquityReconLine.DeleteAll();

                        gtmpEquityReconLine.SetRange(Type);
                        gtmpEquityReconLine.SetRange("Start Balance");
                        gtmpEquityReconLine.SetRange("Net Change (P&L)");
                        gtmpEquityReconLine.SetRange("Net Change (Equity)");
                        gtmpEquityReconLine.SetRange("End Balance");
                    end;
                    // MP 18-03-16 <<

                    gtmpEquityReconLine.SetRange(Statutory, true);

                    SetRange(Number, 2, gtmpEquityReconLine.Count + 1);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gtmpEquityReconLine.Reset();
                gtmpEquityReconLine.DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
                if not (gblnPrintEquityReconciliationByCode or gblnPrintEquityReconciliationByYear) then
                    CurrReport.Break();

                if gblnPrintEquityReconciliationByCode then
                    if gblnPrintEquityReconciliationByYear then
                        SetRange(Number, 1, 2)
                    else
                        SetRange(Number, 1)
                else
                    SetRange(Number, 2);
            end;
        }
        dataitem(AdjustmentsView; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(PostingDate_AdjustmentsView; gtmpAdjmtEntryBuffer."Posting Date")
            {
            }
            column(DocumentNo_AdjustmentsView; gtmpAdjmtEntryBuffer."Document No.")
            {
            }
            column(CorporateGLAccountNo_AdjustmentsView; gtmpAdjmtEntryBuffer."Corporate G/L Account No.")
            {
            }
            column(CorporateGLAccountName_AdjustmentsView; gtmpAdjmtEntryBuffer."Corporate G/L Account Name")
            {
            }
            column(GLAccountNo_AdjustmentsView; gtmpAdjmtEntryBuffer."G/L Account No.")
            {
            }
            column(GLAccountName_AdjustmentsView; gtmpAdjmtEntryBuffer."G/L Account Name")
            {
            }
            column(GAAPAdjustmentReason_AdjustmentsView; gtmpAdjmtEntryBuffer."GAAP Adjustment Reason")
            {
            }
            column(AdjustmentRole_AdjustmentsView; gtmpAdjmtEntryBuffer."Adjustment Role")
            {
            }
            column(Description_AdjustmentsView; gtmpAdjmtEntryBuffer.Description)
            {
            }
            column(Amount_AdjustmentsView; gtmpAdjmtEntryBuffer.Amount)
            {
            }
            column(EquityCorrectionCode_AdjustmentsView; gtmpAdjmtEntryBuffer."Equity Correction Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 2 then
                    gtmpAdjmtEntryBuffer.FindSet()
                else
                    gtmpAdjmtEntryBuffer.Next();

                if gblnExportToExcel then begin
                    lfcnEnterCellDate(Number, 1, gtmpAdjmtEntryBuffer."Posting Date");
                    lfcnEnterCellText(Number, 2, gtmpAdjmtEntryBuffer."Document No.");
                    lfcnEnterCellText(Number, 3, gtmpAdjmtEntryBuffer."Corporate G/L Account No.");
                    lfcnEnterCellText(Number, 4, gtmpAdjmtEntryBuffer."Corporate G/L Account Name");
                    lfcnEnterCellText(Number, 5, gtmpAdjmtEntryBuffer."G/L Account No.");
                    lfcnEnterCellText(Number, 6, gtmpAdjmtEntryBuffer."G/L Account Name");
                    lfcnEnterCellText(Number, 7, Format(gtmpAdjmtEntryBuffer."GAAP Adjustment Reason"));
                    lfcnEnterCellText(Number, 8, Format(gtmpAdjmtEntryBuffer."Adjustment Role"));
                    lfcnEnterCellText(Number, 9, gtmpAdjmtEntryBuffer.Description);
                    lfcnEnterCellDecimal(Number, 10, gtmpAdjmtEntryBuffer.Amount);
                    lfcnEnterCellText(Number, 11, gtmpAdjmtEntryBuffer."Equity Correction Code");
                    lfcnEnterCellText(Number, 12, gtmpAdjmtEntryBuffer."Equity Corr. Code Description");
                end;
            end;

            trigger OnPostDataItem()
            begin
                if gblnExportToExcel then begin
                    gtmpExcelBuffer.WriteSheet(txtAdjustmentsViewCaptionLbl, CompanyName, UserId);
                    gtmpExcelBuffer.DeleteAll();
                end;
            end;

            trigger OnPreDataItem()
            var
                lrecGLEntry: Record "G/L Entry";
                lmdlAdjmtsMgt: Codeunit "Adjustments Management";
            begin
                if not gblnPrintAdjustmentsView then
                    CurrReport.Break();

                if gblnExportToExcel then begin
                    //gtmpExcelBuffer.gfcnAddWorksheet(txtAdjustmentsViewCaptionLbl);
                    //gtmpExcelBuffer.gfcnAddWorksheet(StrSubstNo(txtAdjustmentsViewCaptionLbl, gintFinancialYear)); // MP 18-02-16 Replaces above

                    lfcnSetFontFormat(true, false, true);
                    lfcnEnterCellText(1, 1, txtPostingDateCaptionLbl);
                    lfcnEnterCellText(1, 2, txtDocumentNoCaptionLbl);
                    lfcnEnterCellText(1, 3, txtCorporateGLAccountNoCaptionLbl);
                    lfcnEnterCellText(1, 4, txtCorporateGLAccountNameCaptionLbl);
                    lfcnEnterCellText(1, 5, txtGLAccountNoCaptionLbl);
                    lfcnEnterCellText(1, 6, txtGLAccountNameCaptionLbl);
                    lfcnEnterCellText(1, 7, txtGAAPAdjustmentReasonCaptionLbl);
                    lfcnEnterCellText(1, 8, txtAdjustmentRoleCaptionLbl);
                    lfcnEnterCellText(1, 9, txtDescriptionCaptionLbl);
                    lfcnEnterCellText(1, 10, txtAmountCaptionLbl);
                    lfcnEnterCellText(1, 11, txtEquityCorrectionCodeCaptionLbl);
                    lfcnEnterCellText(1, 12, txtEquityCorrCodeDescriptionCaptionLbl);
                    lfcnSetFontFormat(false, false, false);
                end;

                lrecGLEntry.SetCurrentKey("Global Dimension 1 Code", "Posting Date");
                lrecGLEntry.SetFilter("Global Dimension 1 Code", '<>%1', '');
                lrecGLEntry.SetRange("Posting Date", gdatStart, gdatEnd);

                lmdlAdjmtsMgt.gfcnGetEntries(gtmpAdjmtEntryBuffer, lrecGLEntry, true, true);
                if not gblnIncludeUnpostedEntries then
                    gtmpAdjmtEntryBuffer.SetFilter("G/L Entry No.", '>0');

                gtmpAdjmtEntryBuffer.SetAutoCalcFields("G/L Account Name", "Corporate G/L Account Name", "Equity Corr. Code Description");
                gtmpAdjmtEntryBuffer.SetCurrentKey("Posting Date", "Document No.");

                SetRange(Number, 2, gtmpAdjmtEntryBuffer.Count + 1);
            end;
        }
        dataitem(GlobalView; "Corporate G/L Account")
        {
            DataItemTableView = SORTING("No.");
            column(No_GlobalView; GlobalView."No.")
            {
            }
            column(Name_GlobalView; GlobalView.Name)
            {
            }
            column(LocalGLAccountNo_GlobalView; GlobalView."Local G/L Account No.")
            {
            }
            column(LocalGLAccName_GlobalView; GlobalView."Local G/L Acc. Name")
            {
            }
            column(CorpAmt_GlobalView; gdecCorpAmt[1])
            {
            }
            column(PriorYearAdjmtAmt_GlobalView; gdecPriorYearAdjmtAmt)
            {
            }
            column(CurrYearAdjmtAmt_GlobalView; gdecCurrYearAdjmtAmt)
            {
            }
            column(CurrYearReclassAmt_GlobalView; gdecCurrYearReclassAmt)
            {
            }
            column(StatTBAmt_GlobalView; gdecStatTBAmt[1])
            {
            }
            column(FSCode_GlobalView; gcodFSCode[1])
            {
            }
            column(FSDescription_GlobalView; gtxtFSDescription[1])
            {
            }
            column(AccountClass_GlobalView; GlobalView."Account Class")
            {
            }

            trigger OnAfterGetRecord()
            var
                lcodFSCode: Code[10];
            begin
                gmdlGAAPMgt.gfcnCalc(GlobalView,
                  gdecCorpAmt, gdecStatPrepostAmt, gdecStatAdjmtAmt, gdecAuditorAdjmtAmt, gdecStatTBAmt,
                  gdecTaxPrepostAmt, gdecTaxAdjmtAmt, gdecTaxTBAmt,
                  gdecPriorYearAdjmtAmt, gdecCurrYearAdjmtAmt, gdecCurrYearReclassAmt, gcodFSCode, gtxtFSDescription);

                if gblnExportToExcel then begin
                    gintLineNo += 1;
                    lfcnEnterCellText(gintLineNo, 1, GlobalView."No.");
                    lfcnEnterCellText(gintLineNo, 2, GlobalView.Name);
                    lfcnEnterCellText(gintLineNo, 3, GlobalView."Local G/L Account No.");
                    lfcnEnterCellText(gintLineNo, 4, GlobalView."Local G/L Acc. Name");
                    lfcnEnterCellDecimal(gintLineNo, 5, gdecCorpAmt[1]);
                    lfcnEnterCellDecimal(gintLineNo, 6, gdecPriorYearAdjmtAmt);
                    lfcnEnterCellDecimal(gintLineNo, 7, gdecCurrYearAdjmtAmt);
                    lfcnEnterCellDecimal(gintLineNo, 8, gdecCurrYearReclassAmt);
                    lfcnEnterCellDecimal(gintLineNo, 9, gdecStatTBAmt[1]);

                    // MP 18-03-16 >>
                    //  lcodFSCode := GlobalView.gfcnGetFinancialStatementCode(gdatStart);
                    //  IF (lcodFSCode <> grecFinStatCode.Code) AND (lcodFSCode <> '') THEN
                    //    grecFinStatCode.GET(lcodFSCode);
                    //
                    //  lfcnEnterCellText(gintLineNo,10,lcodFSCode);
                    //  //lfcnEnterCellText(gintLineNo,11,grecFinStatCode.Description);
                    //  lfcnEnterCellText(gintLineNo,11,grecFinStatCode."Description (English)"); // MP 22-02-16 Replaces above
                    //
                    //  lcodFSCode := GlobalView.gfcnGetFinancialStatementCode(gdatStart-1);
                    //  IF (lcodFSCode <> grecFinStatCode.Code) AND (lcodFSCode <> '') THEN
                    //    grecFinStatCode.GET(lcodFSCode);
                    //
                    //  lfcnEnterCellText(gintLineNo,12,lcodFSCode);
                    //  //lfcnEnterCellText(gintLineNo,13,grecFinStatCode.Description);
                    //  lfcnEnterCellText(gintLineNo,13,grecFinStatCode."Description (English)"); // MP 22-02-16 Replaces above

                    lfcnEnterCellText(gintLineNo, 10, gcodFSCode[1]);
                    lfcnEnterCellText(gintLineNo, 11, gtxtFSDescription[1]);
                    lfcnEnterCellText(gintLineNo, 12, gcodFSCode[2]);
                    lfcnEnterCellText(gintLineNo, 13, gtxtFSDescription[2]);
                    // MP 18-03-16 <<

                    lfcnEnterCellText(gintLineNo, 14, Format(GlobalView."Account Class"));
                end;
            end;

            trigger OnPostDataItem()
            begin
                if gblnExportToExcel then begin
                    gtmpExcelBuffer.WriteSheet(txtGlobalViewCaptionLbl, CompanyName, UserId);
                    gtmpExcelBuffer.DeleteAll();
                end;
            end;

            trigger OnPreDataItem()
            begin
                if not gblnPrintGlobalView then
                    CurrReport.Break();

                if gblnExportToExcel then begin
                    //gtmpExcelBuffer.gfcnAddWorksheet(txtGlobalViewCaptionLbl);
                    //gtmpExcelBuffer.gfcnAddWorksheet(StrSubstNo(txtGlobalViewCaptionLbl, gintFinancialYear)); // MP 18-02-16 Replaces above line

                    lfcnSetFontFormat(true, false, true);
                    lfcnEnterCellText(1, 1, txtCorporateGLAccountNoCaptionLbl);
                    lfcnEnterCellText(1, 2, txtCorporateGLAccountNameCaptionLbl);
                    lfcnEnterCellText(1, 3, txtGLAccountNoCaptionLbl);
                    lfcnEnterCellText(1, 4, txtGLAccountNameCaptionLbl);
                    lfcnEnterCellText(1, 5, StrSubstNo(txtCorpGAAPCaptionLbl, gintFinancialYear));
                    lfcnEnterCellText(1, 6, txtPriorYearAdjustmentsCaptionLbl);
                    lfcnEnterCellText(1, 7, txtCurrentYearAdjustmentsCaptionLbl);
                    lfcnEnterCellText(1, 8, txtCurrentYearReclassificationsCaptionLbl);
                    lfcnEnterCellText(1, 9, StrSubstNo(txtStatutoryTBCaptionLbl, gintFinancialYear));
                    lfcnEnterCellText(1, 10, txtFSCodeCaptionLbl);
                    lfcnEnterCellText(1, 11, txtFSCodeDescriptionCaptionLbl);
                    lfcnEnterCellText(1, 12, txtFSCodeCaptionLbl + txtPY);
                    lfcnEnterCellText(1, 13, txtFSCodeDescriptionCaptionLbl + txtPY);
                    lfcnEnterCellText(1, 14, txtAccountClassCaptionLbl);
                    lfcnSetFontFormat(false, false, false);
                    gintLineNo := 1;
                end;

                SetRange("Date Filter", gdatStart, gdatEnd);

                // MP 17-02-16 >>
                if goptExcludeAccounts <> goptExcludeAccounts::" " then
                    gmdlGAAPMgt.gfcnFilterZeroMovementBlocked(GlobalView, goptExcludeAccounts);
                // MP 17-02-16 <<
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'General';
                    field("grecLanguage.Code"; grecLanguage.Code)
                    {
                        Caption = 'Language Code';
                        TableRelation = Language;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Language Code field.';
                    }
                    field(gblnExportToExcel; gblnExportToExcel)
                    {
                        Caption = 'Export to Excel';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Export to Excel field.';
                    }
                    field(StartDate; gdatStart)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Start Date field.';

                        trigger OnValidate()
                        var
                            ldatDateTemp: Date;
                        begin
                            gmdlGAAPMgt.gfcnGetAccPeriodFilter(gdatStart, ldatDateTemp, gdatEnd);
                        end;
                    }
                    field(EndDate; gdatEnd)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                    field(gblnIncludeUnpostedEntries; gblnIncludeUnpostedEntries)
                    {
                        Caption = 'Include Un-posted Entries';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Un-posted Entries field.';
                    }
                }
                group("Print Sections")
                {
                    Caption = 'Print Sections';
                    field(gblnPrintFinancialStatement; gblnPrintFinancialStatement)
                    {
                        Caption = 'Financial Statement';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Financial Statement field.';
                    }
                    field(gblnPrintEquityReconciliationByCode; gblnPrintEquityReconciliationByCode)
                    {
                        Caption = 'Equity Reconciliation (Group by Equity Correction Code)';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Equity Reconciliation (Group by Equity Correction Code) field.';
                    }
                    field(gblnPrintEquityReconciliationByYear; gblnPrintEquityReconciliationByYear)
                    {
                        Caption = 'Equity Reconciliation (Group by Year)';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Equity Reconciliation (Group by Year) field.';
                    }
                    field(gblnPrintAdjustmentsView; gblnPrintAdjustmentsView)
                    {
                        Caption = 'Adjustments View';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Adjustments View field.';
                    }
                    field(gblnPrintGlobalView; gblnPrintGlobalView)
                    {
                        Caption = 'Global View';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Global View field.';
                    }
                }
                group("Global View")
                {
                    Caption = 'Global View';
                    field(gblnShowLocalGLAcc; gblnShowLocalGLAcc)
                    {
                        Caption = 'Show Local G/L Account';
                        Visible = gblnBottomUp AND gblnCorpAccInUse;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Show Local G/L Account field.';
                    }
                    field(goptExcludeAccounts; goptExcludeAccounts)
                    {
                        Caption = 'Exclude Accounts';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Exclude Accounts field.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            lmdlCompanyTypeMgt: Codeunit "Company Type Management";
        begin
            gblnBottomUp := lmdlCompanyTypeMgt.gfcnIsBottomUp();
            gblnCorpAccInUse := lmdlCompanyTypeMgt.gfcnCorpAccInUse();

            // MP 22-03-16 Always use Local >>
            //IF NOT gblnCorpAccInUse THEN
            //  goptViewAccounts := goptViewAccounts::"Local"
            //ELSE
            //  goptViewAccounts := goptViewAccounts::Corporate;
            //
            //goptCorpStatementType := goptCorpStatementType::"Statutory Financial Statement";

            goptViewAccounts := goptViewAccounts::"Local";
            goptCorpStatementType := goptCorpStatementType::" ";
            // MP 22-03-16 <<

            if (gdatStart = 0D) or (gdatEnd = 0D) then
                gmdlGAAPMgt.gfcnGetAccPeriodFilter(WorkDate(), gdatStart, gdatEnd);

            grecFinStatStructure.SetRange(Default, true);
            grecFinStatStructure.FindFirst();

            gblnCorpStatementTypeEditable := goptViewAccounts <> goptViewAccounts::"Local";
        end;
    }

    labels
    {
        CurrReport_PAGENOCaptionLbl = 'Page';
    }

    trigger OnPostReport()
    begin
        if gblnExportToExcel then begin
            gtmpExcelBuffer.CloseBook();
            //gtmpExcelBuffer.SetFriendlyFilename(txtGlobalViewPackCaptionLbl); // MP 16-Jun-16 Now set in function CreateBook below
            gtmpExcelBuffer.OpenExcel();
            //gtmpExcelBuffer.GiveUserControl;
        end;
    end;

    trigger OnPreReport()
    var
        lintI: Integer;
    begin
        if grecLanguage.Code = '' then
            Error(txtLanguageCodeError);

        //CurrReport.Language := grecLanguage.GetLanguageID(grecLanguage.Code);

        gintFinancialYear := Date2DMY(gdatEnd, 3);

        gmdlGAAPMgt.gfcnInit(gdatStart, gdatEnd, gblnIncludeUnpostedEntries, gblnIncludeTax, false, gblnShowLocalGLAcc, 1);

        if gblnPrintEquityReconciliationByCode then
            goptGroupBy := goptGroupBy::"Equity Correction Code";

        gmdlGAAPMgtEquityRecon.gfcnInit(gdatStart, gdatEnd, goptGroupBy, gblnIncludeUnpostedEntries);
        gmdlGAAPMgtEquityRecon.gfcnGetCaptions(gtxtStartBalanceEquityCaption, gtxtNetChangePLCaption, gtxtNetChangeEquityCaption, gtxtEndBalanceEquityCaption);

        gmdlGAAPMgtFinStat.gfcnInit(grecFinStatStructure.Code, gdatStart, gdatEnd, goptViewAccounts, goptCorpStatementType, gblnIncludeUnpostedEntries);
        gmdlGAAPMgtFinStat.gfcnGetCaptions(gtxtStartBalanceCaption, gtxtEndBalanceCaption);

        if gblnIncludeUnpostedEntries then
            gtxtDraft := txtDraft;

        if gblnPrintEquityReconciliationByCode xor gblnPrintEquityReconciliationByYear then begin
            gtxtEquityReconciliationEquityCodeCaption := StrSubstNo(txtEquityReconciliationCaptionLbl, gintFinancialYear); // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
            gtxtEquityReconciliationYearCaption := StrSubstNo(txtEquityReconciliationCaptionLbl, gintFinancialYear); // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
        end else begin
            gtxtEquityReconciliationEquityCodeCaption := StrSubstNo(txtEquityReconciliationFormat,
              StrSubstNo(txtEquityReconciliationCaptionLbl, gintFinancialYear), // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
              txtEquityCorrectionCodeCaptionLbl);
            gtxtEquityReconciliationYearCaption := StrSubstNo(txtEquityReconciliationFormat,
              StrSubstNo(txtEquityReconciliationCaptionLbl, gintFinancialYear), // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
              txtYearCaptionLbl);
        end;

        if gblnPrintFinancialStatement then begin
            lintI += 1;
            gtxtContentsLine[lintI] := StrSubstNo(txtContentsLineFormat, lintI, StrSubstNo(txtFinancialStatementCaptionLbl, gintFinancialYear));
        end;

        if gblnPrintEquityReconciliationByCode then begin
            lintI += 1;
            gtxtContentsLine[lintI] := StrSubstNo(txtContentsLineFormat, lintI, gtxtEquityReconciliationEquityCodeCaption);
        end;

        if gblnPrintEquityReconciliationByYear then begin
            lintI += 1;
            gtxtContentsLine[lintI] := StrSubstNo(txtContentsLineFormat, lintI, gtxtEquityReconciliationYearCaption);
        end;

        if gblnPrintAdjustmentsView then begin
            lintI += 1;
            gtxtContentsLine[lintI] := StrSubstNo(txtContentsLineFormat, lintI,
              StrSubstNo(txtAdjustmentsViewCaptionLbl, gintFinancialYear)); // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
        end;

        if gblnPrintGlobalView then begin
            lintI += 1;
            gtxtContentsLine[lintI] := StrSubstNo(txtContentsLineFormat, lintI,
              StrSubstNo(txtGlobalViewCaptionLbl, gintFinancialYear)); // MP 18-02-16 Added STRSUBSTNO and gintFinancialYear
        end;

        if lintI = 0 then
            Error(txtSelectPrintSectionsError);
    end;

    var
        grecLanguage: Record Language;
        gtmpExcelBuffer: Record "Excel Buffer" temporary;
        gtmpEquityReconLine: Record "Equity Reconciliation Line" temporary;
        grecFinStatStructure: Record "Financial Statement Structure";
        gtmpFinStatLine: Record "Financial Statement Line" temporary;
        gtmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary;
        grecFinStatCode: Record "Financial Statement Code";
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        gmdlGAAPMgtEquityRecon: Codeunit "GAAP Mgt. - Equity Reconcil.";
        gmdlGAAPMgtFinStat: Codeunit "GAAP Mgt. -Financial Statement";

        gtxtStartBalanceCaption: Text[30];

        gtxtEndBalanceCaption: Text[30];
        gtxtFSDescription: array[2] of Text[100];
        gtxtStatTBCaption: Text[50];

        gtxtStartBalanceEquityCaption: Text[30];

        gtxtNetChangePLCaption: Text[30];
        gtxtNetChangeEquityCaption: Text[30];

        gtxtEndBalanceEquityCaption: Text[30];
        gtxtContentsLine: array[5] of Text;
        gtxtEquityReconciliationEquityCodeCaption: Text;
        gtxtEquityReconciliationYearCaption: Text;
        gtxtDraft: Text[30];
        gcodFSCode: array[2] of Code[10];
        gdecCorpAmt: array[2] of Decimal;
        gdecStatPrepostAmt: array[2] of Decimal;
        gdecStatAdjmtAmt: array[2] of Decimal;
        gdecAuditorAdjmtAmt: array[2] of Decimal;
        gdecStatTBAmt: array[2] of Decimal;
        gdecTaxPrepostAmt: array[2] of Decimal;
        gdecTaxAdjmtAmt: array[2] of Decimal;
        gdecTaxTBAmt: array[2] of Decimal;
        gdecPriorYearAdjmtAmt: Decimal;
        gdecCurrYearAdjmtAmt: Decimal;
        gdecCurrYearReclassAmt: Decimal;
        gdatStart: Date;
        gdatEnd: Date;
        goptGroupBy: Option Year,"Equity Correction Code";
        goptViewAccounts: Option "Local",Corporate,Both;
        goptCorpStatementType: Option " ","Group Financial Statement","Statutory Financial Statement","Tax Financial Statement";
        goptExcludeAccounts: Option " ","Zero Movement",Blocked,"Zero Movement and Blocked";
        gintFinancialYear: Integer;
        gintLineNo: Integer;

        gblnIncludeUnpostedEntries: Boolean;

        gblnBottomUp: Boolean;

        gblnIncludeStatutory: Boolean;

        gblnIncludeTax: Boolean;

        gblnIncludePreviousYear: Boolean;

        gblnShowLocalGLAcc: Boolean;

        gblnCorpAccInUse: Boolean;

        gblnCorpStatementTypeEditable: Boolean;

        gblnLocalAccView: Boolean;
        txtGlobalViewPackCaptionLbl: Label 'Global View Pack';
        txtStatutoryReportingCaptionLbl: Label 'Statutory Reporting';
        txtCoverPageCaptionLbl: Label 'Cover Page';
        txtContentPageCaptionLbl: Label 'Contents';
        txtGlobalViewCaptionLbl: Label 'Mapped Corporate GAAP TB to Local GAAP TB %1';
        txtCorpGAAPCaptionLbl: Label 'Corporate GAAP %1';
        txtPriorYearAdjustmentsCaptionLbl: Label 'Prior Year Adjustments';
        txtCurrentYearAdjustmentsCaptionLbl: Label 'Current Year Adjustments';
        txtCurrentYearReclassificationsCaptionLbl: Label 'Current Year Reclassifications';
        txtStatutoryTBCaptionLbl: Label 'Statutory TB %1';
        txtFSCodeCaptionLbl: Label 'FS Code';
        txtFSCodeDescriptionCaptionLbl: Label 'FS Code Description';
        txtPY: Label ' (PY)';
        txtAccountClassCaptionLbl: Label 'Account Class';
        txtEquityReconciliationCaptionLbl: Label 'Equity Reconciliation %1';
        txtCodeCaptionLbl: Label 'Code';
        txtDescriptionCaptionLbl: Label 'Description';
        txtEntryDescriptionCaptionLbl: Label 'Entry Description';
        txtYearCaptionLbl: Label 'Year';
        txtDocumentNoCaptionLbl: Label 'Document No.';
        txtAdjustmentsViewCaptionLbl: Label 'Local Statutory Adjustments %1';
        txtFinancialStatementCaptionLbl: Label 'Local Financial Statements %1';
        txtLanguageCodeError: Label 'You must specify a Language Code';
        txtDescriptionEngCaptionLbl: Label 'Description (English)';
        gblnBoldCurr: Boolean;
        gblnItalicCurr: Boolean;
        gblnUnderLineCurr: Boolean;
        gblnExportToExcel: Boolean;
        txtPostingDateCaptionLbl: Label 'Posting Date';
        txtCorporateGLAccountNoCaptionLbl: Label 'Corporate G/L Account No.';
        txtCorporateGLAccountNameCaptionLbl: Label 'Corporate G/L Account Name';
        txtGLAccountNoCaptionLbl: Label 'G/L Account No.';
        txtGLAccountNameCaptionLbl: Label 'G/L Account Name';
        txtGAAPAdjustmentReasonCaptionLbl: Label 'GAAP Adjustment Reason';
        txtAdjustmentRoleCaptionLbl: Label 'Adjustment Role';
        txtAmountCaptionLbl: Label 'Amount';
        txtEquityCorrectionCodeCaptionLbl: Label 'Equity Correction Code';
        txtEquityCorrCodeDescriptionCaptionLbl: Label 'Equity Correction Code Description';
        gblnPrintFinancialStatement: Boolean;
        gblnPrintEquityReconciliationByCode: Boolean;
        gblnPrintEquityReconciliationByYear: Boolean;
        gblnPrintAdjustmentsView: Boolean;
        gblnPrintGlobalView: Boolean;
        txtContentsLineFormat: Label '%1. %2';
        txtEquityReconciliationFormat: Label '%1 - %2';
        txtSelectPrintSectionsError: Label 'You must select at least one section to print';
        txtDraft: Label 'DRAFT';

    local procedure lfcnEnterCellText(pintRowNo: Integer; pintColumnNo: Integer; ptxtCellValue: Text[250])
    begin
        lfcnEnterCellExt(pintRowNo, pintColumnNo, ptxtCellValue, gblnBoldCurr, gblnItalicCurr, gblnUnderLineCurr, '', gtmpExcelBuffer."Cell Type"::Text);
    end;

    local procedure lfcnEnterCellDecimal(pintRowNo: Integer; pintColumnNo: Integer; pdecCellValue: Decimal)
    begin
        lfcnEnterCellExt(pintRowNo, pintColumnNo, Format(pdecCellValue), gblnBoldCurr, gblnItalicCurr, gblnUnderLineCurr, '_(* #,##0_);_(* (#,##0);-  ', gtmpExcelBuffer."Cell Type"::Number);
    end;

    local procedure lfcnEnterCellDate(pintRowNo: Integer; pintColumnNo: Integer; pdatCellValue: Date)
    begin
        lfcnEnterCellExt(pintRowNo, pintColumnNo, Format(pdatCellValue), gblnBoldCurr, gblnItalicCurr, gblnUnderLineCurr, '', gtmpExcelBuffer."Cell Type"::Date);
    end;

    local procedure lfcnEnterCellExt(pintRowNo: Integer; pintColumnNo: Integer; ptxtCellValue: Text[250]; pblnBold: Boolean; pblnItalic: Boolean; pblnUnderLine: Boolean; ptxtFormat: Text[30]; poptCellType: Option)
    begin
        gtmpExcelBuffer.Init();
        gtmpExcelBuffer.Validate("Row No.", pintRowNo);
        gtmpExcelBuffer.Validate("Column No.", pintColumnNo);
        gtmpExcelBuffer."Cell Value as Text" := ptxtCellValue;
        gtmpExcelBuffer.Formula := '';
        gtmpExcelBuffer.Bold := pblnBold;
        gtmpExcelBuffer.Italic := pblnItalic;
        gtmpExcelBuffer.Underline := pblnUnderLine;
        gtmpExcelBuffer.NumberFormat := ptxtFormat;
        gtmpExcelBuffer."Cell Type" := poptCellType;
        gtmpExcelBuffer.Insert();
    end;

    local procedure lfcnSetFontFormat(pblnBold: Boolean; pblnItalic: Boolean; pblnUnderLine: Boolean)
    begin
        gblnBoldCurr := pblnBold;
        gblnItalicCurr := pblnItalic;
        gblnUnderLineCurr := pblnUnderLine;
    end;
}

