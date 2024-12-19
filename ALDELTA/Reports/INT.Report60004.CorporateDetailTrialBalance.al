report 60004 "Corporate Detail Trial Balance"
{
    // MP 20-11-13
    // Amending filtering in G/L Account - OnPreDataItem() (CR 30)
    DefaultLayout = RDLC;
    RDLCLayout = './CorporateDetailTrialBalance.rdlc';

    Caption = 'Corporate Detail Trial Balance';
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("G/L Account"; "Corporate G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Income/Balance", "Debit/Credit", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_GLDateFilter_; StrSubstNo(Text000, GLDateFilter))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo())
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(PrintReversedEntries; PrintReversedEntries)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintClosingEntries; PrintClosingEntries)
            {
            }
            column(PrintOnlyCorrections; PrintOnlyCorrections)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; "G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(Detail_Trial_BalanceCaption; Detail_Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_also_includes_G_L_accounts_that_only_have_a_balance_Caption; This_also_includes_G_L_accounts_that_only_have_a_balance_CaptionLbl)
            {
            }
            column(This_report_also_includes_closing_entries_within_the_period_Caption; This_report_also_includes_closing_entries_within_the_period_CaptionLbl)
            {
            }
            column(Only_corrections_are_included_Caption; Only_corrections_are_included_CaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption; "G/L Entry".FieldCaption("Posting Date"))
            {
            }
            column(G_L_Entry__Document_No__Caption; "G/L Entry".FieldCaption("Document No."))
            {
            }
            column(G_L_Entry_DescriptionCaption; "G/L Entry".FieldCaption(Description))
            {
            }
            column(G_L_Entry__VAT_Amount__Control32Caption; "G/L Entry".FieldCaption("VAT Amount"))
            {
            }
            column(G_L_Entry__Debit_Amount__Control33Caption; G_L_Entry__Debit_Amount__Control33CaptionLbl)
            {
            }
            column(G_L_Entry__Credit_Amount__Control34Caption; G_L_Entry__Credit_Amount__Control34CaptionLbl)
            {
            }
            column(GLBalanceCaption; GLBalanceCaptionLbl)
            {
            }
            column(G_L_Entry__Entry_No__Caption; "G/L Entry".FieldCaption("Entry No."))
            {
            }
            column(G_L_Entry__GlobalDimension1CodeCaption; "G/L Entry".FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(G_L_Account_Date_Filter; "Date Filter")
            {
            }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Account_Business_Unit_Filter; "Business Unit Filter")
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(G_L_Account__Name; "G/L Account".Name)
                {
                }
                column(StartBalance; StartBalance)
                {
                    AutoFormatType = 1;
                }
                column(PageCounter_Number; Number)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Corporate G/L Account No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Business Unit Code" = FIELD("Business Unit Filter");
                    DataItemLinkReference = "G/L Account";
                    DataItemTableView = SORTING("Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role", "GAAP Adjustment Reason", "Posting Date");
                    column(G_L_Entry__VAT_Amount_; "VAT Amount")
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(StartBalance___Amount; StartBalance + Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(G_L_Entry__Posting_Date_; "Posting Date")
                    {
                    }
                    column(G_L_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(G_L_Entry_Description; Description)
                    {
                    }
                    column(G_L_Entry__VAT_Amount__Control32; "VAT Amount")
                    {
                    }
                    column(G_L_Entry__Debit_Amount__Control33; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount__Control34; "Credit Amount")
                    {
                    }
                    column(GLBalance; GLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(G_L_Entry__Entry_No__; "Entry No.")
                    {
                    }
                    column(ClosingEntry; ClosingEntry)
                    {
                    }
                    column(GLEntryReversed; "G/L Entry".Reversed)
                    {
                    }
                    column(G_L_Entry__GlobalDimension1Code; "Global Dimension 1 Code")
                    {
                    }
                    column(G_L_Entry__VAT_Amount__Control38; "VAT Amount")
                    {
                    }
                    column(G_L_Entry__Debit_Amount__Control39; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount__Control40; "Credit Amount")
                    {
                    }
                    column(StartBalance___Amount_Control41; StartBalance + Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(G_L_Entry__VAT_Amount_Caption; G_L_Entry__VAT_Amount_CaptionLbl)
                    {
                    }
                    column(G_L_Entry__VAT_Amount__Control38Caption; G_L_Entry__VAT_Amount__Control38CaptionLbl)
                    {
                    }
                    column(G_L_Entry_Corporate_G_L_Account_No_; "Corporate G/L Account No.")
                    {
                    }
                    column(G_L_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                    {
                    }
                    column(G_L_Entry_Business_Unit_Code; "Business Unit Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if PrintOnlyCorrections then
                            if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.Skip();
                        if not PrintReversedEntries and Reversed then
                            CurrReport.Skip();

                        if IsServiceTier then begin
                            GLBalance := GLBalance + Amount;
                            if ("Posting Date" = ClosingDate("Posting Date")) and
                               not PrintClosingEntries
                            then begin
                                "Debit Amount" := 0;
                                "Credit Amount" := 0;
                            end;

                            if ("Posting Date" = ClosingDate("Posting Date")) then
                                ClosingEntry := true
                            else
                                ClosingEntry := false;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLBalance := StartBalance;
                        CurrReport.CreateTotals(Amount, "Debit Amount", "Credit Amount", "VAT Amount");
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(G_L_Account__Name_Control42; "G/L Account".Name)
                    {
                    }
                    column(G_L_Entry___VAT_Amount_; "G/L Entry"."VAT Amount")
                    {
                    }
                    column(G_L_Entry___Debit_Amount_; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(G_L_Entry___Credit_Amount_; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(StartBalance____G_L_Entry__Amount; StartBalance + "G/L Entry".Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(Integer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("G/L Entry"."Debit Amount" = 0) and
                           ("G/L Entry"."Credit Amount" = 0) and
                           ((StartBalance = 0) or ExcludeBalanceOnly)
                        then
                            CurrReport.Skip();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if gblnExcludeZeroBalances then begin
                    CalcFields("Balance at Date");
                    if "Balance at Date" = 0 then
                        CurrReport.Skip();
                end;

                StartBalance := 0;
                if GLDateFilter <> '' then
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, ClosingDate(GetRangeMin("Date Filter") - 1));
                        CalcFields("Net Change");
                        StartBalance := "Net Change";
                        SetFilter("Date Filter", GLDateFilter);
                    end;

                if IsServiceTier then begin
                    if PrintOnlyOnePerPage then begin
                        GLEntryPage.Reset();
                        GLEntryPage.SetRange("G/L Account No.", "G/L Account"."No.");
                        if CurrReport.PrintOnlyIfDetail and GLEntryPage.Find('-') then
                            PageGroupNo := PageGroupNo + 1;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            var
                lmdlCompanyTypeMgt: Codeunit "Company Type Management";
            begin
                if IsServiceTier then
                    PageGroupNo := 1;

                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;

                // MP 20-11-13 >>
                if GetFilter("Global Dimension 1 Filter") = '' then
                    lmdlCompanyTypeMgt.gfcnApplyFilterCorpGLAcc("G/L Account", 0);
                //  SETRANGE("Global Dimension 1 Filter",'');
                // MP 20-11-13 >>
            end;
        }
    }

    requestpage
    {
        Caption = 'Detail Trial Balance';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per G/L Acc.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Page per G/L Acc. field.';
                    }
                    field(ExcludeBalanceOnly; ExcludeBalanceOnly)
                    {
                        Caption = 'Exclude G/L Accs. That Have a Balance Only';
                        MultiLine = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Exclude G/L Accs. That Have a Balance Only field.';
                    }
                    field(PrintClosingEntries; PrintClosingEntries)
                    {
                        Caption = 'Include Closing Entries Within the Period';
                        MultiLine = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Closing Entries Within the Period field.';
                    }
                    field(PrintReversedEntries; PrintReversedEntries)
                    {
                        Caption = 'Include Reversed Entries';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Include Reversed Entries field.';
                    }
                    field(PrintOnlyCorrections; PrintOnlyCorrections)
                    {
                        Caption = 'Print Corrections Only';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Print Corrections Only field.';
                    }
                    field(gblnExcludeZeroBalances; gblnExcludeZeroBalances)
                    {
                        Caption = 'Do Not Show Zero Balances';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Do Not Show Zero Balances field.';
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
    begin
        GLFilter := "G/L Account".GetFilters;
        GLDateFilter := "G/L Account".GetFilter("Date Filter");
    end;

    var
        Text000: Label 'Period: %1';
        GLDateFilter: Text[30];
        GLFilter: Text[250];
        GLBalance: Decimal;
        StartBalance: Decimal;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        PrintClosingEntries: Boolean;
        PrintOnlyCorrections: Boolean;
        PrintReversedEntries: Boolean;
        PageGroupNo: Integer;
        GLEntryPage: Record "G/L Entry";
        ClosingEntry: Boolean;
        gblnExcludeZeroBalances: Boolean;
        Detail_Trial_BalanceCaptionLbl: Label 'Corporate Detail Trial Balance';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_also_includes_G_L_accounts_that_only_have_a_balance_CaptionLbl: Label 'This also includes G/L accounts that only have a balance.';
        This_report_also_includes_closing_entries_within_the_period_CaptionLbl: Label 'This report also includes closing entries within the period.';
        Only_corrections_are_included_CaptionLbl: Label 'Only corrections are included.';
        Net_ChangeCaptionLbl: Label 'Net Change';
        G_L_Entry__Debit_Amount__Control33CaptionLbl: Label 'Debit';
        G_L_Entry__Credit_Amount__Control34CaptionLbl: Label 'Credit';
        GLBalanceCaptionLbl: Label 'Balance';
        G_L_Entry__VAT_Amount_CaptionLbl: Label 'Continued';
        G_L_Entry__VAT_Amount__Control38CaptionLbl: Label 'Continued';
}

