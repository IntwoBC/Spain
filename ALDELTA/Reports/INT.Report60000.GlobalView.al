report 60000 "Global View"
{
    // MP 05-06-14
    // Added parameter to function call in OnPreReport
    // 
    // MP 25-11-15
    // Added option and code for Column View (CB1 Enhancements)
    DefaultLayout = RDLC;
    RDLCLayout = './GlobalView.rdlc';

    Caption = 'Global View';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Corporate G/L Account"; "Corporate G/L Account")
        {
            DataItemTableView = SORTING("No.");
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo())
            {
            }
            column(USERID; UserId)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(IncludePrepostedEntries; gblnIncludePrepostedEntries)
            {
            }
            column(IncludeTax; gblnIncludeTax)
            {
            }
            column(IncludePreviousYear; gblnIncludePreviousYear)
            {
            }
            column(IncludeStat; gblnIncludeStatutory)
            {
            }
            column(GAAPAdjmtReasonView; gblnGAAPAdjmtReasonView)
            {
            }
            column(Corporate_G_L_Account__No__; "No.")
            {
            }
            column(Corporate_G_L_Account_Name; Name)
            {
            }
            column(Corporate_G_L_Account__G_L_Account_No___Local__; "Local G/L Account No.")
            {
            }
            column(PrepostedStatutoryAmount; gdecStatPrepostAmt[1])
            {
            }
            column(StatutoryAdjustments; gdecStatAdjmtAmt[1])
            {
            }
            column(AuditorAdjustments; gdecAuditorAdjmtAmt[1])
            {
            }
            column(StatutoryTB; gdecStatTBAmt[1])
            {
            }
            column(PrepostedTaxAmount; gdecTaxPrepostAmt[1])
            {
            }
            column(TaxAdjustments; gdecTaxAdjmtAmt[1])
            {
            }
            column(TaxTB; gdecTaxTBAmt[1])
            {
            }
            column(StatutoryAdjustmentsLY; gdecStatAdjmtAmt[2])
            {
            }
            column(AuditorAdjustmentsLY; gdecAuditorAdjmtAmt[2])
            {
            }
            column(StatutoryTBLY; gdecStatTBAmt[2])
            {
            }
            column(TaxAdjustmentsLY; gdecTaxAdjmtAmt[2])
            {
            }
            column(TaxTBLY; gdecTaxTBAmt[2])
            {
            }
            column(CorpAmountLY; gdecCorpAmt[2])
            {
            }
            column(CorpAmount; gdecCorpAmt[1])
            {
            }
            column(Corporate_G_L_AccountCaption; Corporate_G_L_AccountCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Corporate_G_L_Account__No__Caption; Corporate_G_L_Account__No__CaptionLbl)
            {
            }
            column(Corporate_G_L_Account_NameCaption; Corporate_G_L_Account_NameCaptionLbl)
            {
            }
            column(Corporate_G_L_Account__G_L_Account_No___Local__Caption; FieldCaption("Local G/L Account No."))
            {
            }
            column(PrepostedStatutoryAmountCaption; PrepostedStatutoryAmountCaptionLbl)
            {
            }
            column(StatutoryAdjustmentsCaption; StatutoryAdjustmentsCaptionLbl)
            {
            }
            column(AuditorAdjustmentsCaption; AuditorAdjustmentsCaptionLbl)
            {
            }
            column(StatutoryTBCaption; StatutoryTBCaptionLbl)
            {
            }
            column(PrepostedTaxAmountCaption; PrepostedTaxAmountCaptionLbl)
            {
            }
            column(TaxAdjustmentsCaption; TaxAdjustmentsCaptionLbl)
            {
            }
            column(TaxTBCaption; TaxTBCaptionLbl)
            {
            }
            column(StatutoryAdjustmentsLYCaption; StatutoryAdjustmentsLYCaptionLbl)
            {
            }
            column(AuditorAdjustmentsLYCaption; AuditorAdjustmentsLYCaptionLbl)
            {
            }
            column(StatutoryTBLYCaption; StatutoryTBLYCaptionLbl)
            {
            }
            column(TaxAdjustmentsLYCaption; TaxAdjustmentsLYCaptionLbl)
            {
            }
            column(TaxTBLYCaption; TaxTBLYCaptionLbl)
            {
            }
            column(CorpAmountLYCaption; CorpAmountLYCaptionLbl)
            {
            }
            column(CorpAmountCaption; CorpAmountCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                gmdlGAAPMgt.gfcnCalc("Corporate G/L Account",
                  gdecCorpAmt, gdecStatPrepostAmt, gdecStatAdjmtAmt, gdecAuditorAdjmtAmt, gdecStatTBAmt,
                  gdecTaxPrepostAmt, gdecTaxAdjmtAmt, gdecTaxTBAmt,
                  gdecPriorYearAdjmtAmt, gdecCurrYearAdjmtAmt, gdecCurrYearReclassAmt, gcodFSCode, gtxtFSDescription); // MP 25-11-15 New parameters
            end;

            trigger OnPreDataItem()
            begin
                "Corporate G/L Account".SetRange("Date Filter", gdatStart, gdatEnd);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
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
                    field(goptIncludeStatTax; goptIncludeStatTax)
                    {
                        Caption = 'Include Statutory/Tax';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Statutory/Tax field.';
                    }
                    field(gblnIncludePrepostedEntries; gblnIncludePrepostedEntries)
                    {
                        Caption = 'Include Un-posted Entries';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Un-posted Entries field.';
                    }
                    field(gblnIncludePreviousYear; gblnIncludePreviousYear)
                    {
                        Caption = 'Include Previous Year';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Previous Year field.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        lblnShowLocalGLAcc: Boolean;
    begin
        gblnIncludeStatutory := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Statutory Only"];
        gblnIncludeTax := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Tax Only"];
        gmdlGAAPMgt.gfcnInit(gdatStart, gdatEnd, gblnIncludePrepostedEntries, gblnIncludeTax, gblnIncludePreviousYear,
          lblnShowLocalGLAcc, // MP 05-06-14 Added parameter (false)
          goptColumnView); // MP 25-11-15 New parameter
    end;

    var
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        goptIncludeStatTax: Option Both,"Statutory Only","Tax Only";
        goptColumnView: Option "Adjustment Role","GAAP Adjustment Reason";
        gdatStart: Date;
        gdatEnd: Date;
        gtxtFSDescription: array[2] of Text[100];
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

        gblnIncludePrepostedEntries: Boolean;

        gblnIncludeStatutory: Boolean;

        gblnIncludeTax: Boolean;

        gblnIncludePreviousYear: Boolean;
        Corporate_G_L_AccountCaptionLbl: Label 'Global View';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Corporate_G_L_Account__No__CaptionLbl: Label 'Corporate G/L Account No.';
        Corporate_G_L_Account_NameCaptionLbl: Label 'Corporate G/L Account Name';
        PrepostedStatutoryAmountCaptionLbl: Label 'Un-posted Statutory Amount';
        StatutoryAdjustmentsCaptionLbl: Label 'Posted Statutory Adjustments';
        AuditorAdjustmentsCaptionLbl: Label 'Posted Auditor Adjustments';
        StatutoryTBCaptionLbl: Label 'Statutory TB';
        PrepostedTaxAmountCaptionLbl: Label 'Un-posted Tax Amount';
        TaxAdjustmentsCaptionLbl: Label 'Posted Tax Adjustments';
        TaxTBCaptionLbl: Label 'Tax TB';
        StatutoryAdjustmentsLYCaptionLbl: Label 'Posted Statutory Adjustments (PY)';
        AuditorAdjustmentsLYCaptionLbl: Label 'Posted Auditor Adjustments (PY)';
        StatutoryTBLYCaptionLbl: Label 'Statutory TB (PY)';
        TaxAdjustmentsLYCaptionLbl: Label 'Posted Tax Adjustments (PY)';
        TaxTBLYCaptionLbl: Label 'Tax TB (PY)';
        CorpAmountLYCaptionLbl: Label 'Corporate GAAP (PY)';
        CorpAmountCaptionLbl: Label 'Corporate GAAP';

        gblnGAAPAdjmtReasonView: Boolean;


    procedure gfcnInit(pdatStart: Date; pdatEnd: Date; poptIncludeStatTax: Option Both,"Statutory Only","Tax Only"; pblnIncludePrepostedEntries: Boolean; pblnIncludePreviousYear: Boolean; poptColumnView: Option "Adjustment Role","GAAP Adjustment Reason")
    begin
        gdatStart := pdatStart;
        gdatEnd := pdatEnd;
        gblnIncludePrepostedEntries := pblnIncludePrepostedEntries;
        goptIncludeStatTax := poptIncludeStatTax;
        gblnIncludePreviousYear := pblnIncludePreviousYear;
        goptColumnView := poptColumnView; // MP 25-11-15 New parameter
    end;
}

