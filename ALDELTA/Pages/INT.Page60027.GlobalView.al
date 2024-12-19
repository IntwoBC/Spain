page 60027 "Global View"
{
    // MP 04-12-12
    // Amended all DrillDowns, to allow passing on new parameter pblnBalanceAtDate
    // 
    // MP 14-02-13
    // Fixed issue where accounting period is "remembered" from another company, but not same as in current company
    // 
    // MP 25-09-13
    // Added Actions GAAP-to-GAAP Adjustments and GAAP-to-Tax Adjustments
    // 
    // MP 25-11-13
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup (CR 30)
    // 
    // MP 08-04-13
    // Added to Note (Except for Group Adjustments) (CR 30)
    // 
    // MP 06-05-14
    // In addition to adding Core II function dated 25-09-13 also include Group Adjustments Action
    // 
    // MP 11-11-14
    // Upgrade to NAV 2013 R2
    // 
    // MP 25-11-15
    // Added fields "Financial Statement Code", "Fin. Statement Description" and "Account Class" (CB1 Enhancements)
    // Added functionality to support Unposted entries and new Column View "GAAP Adjustment Reason"

    Caption = 'Global View';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Corporate G/L Account";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory=lists;

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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Start Date field.';


                    trigger OnValidate()
                    var
                        ldatDateTemp: Date;
                    begin
                        gmdlGAAPMgt.gfcnGetAccPeriodFilter(gdatStart, ldatDateTemp, gdatEnd);
                        Rec.SetRange("Date Filter", gdatStart, gdatEnd);
                        lfcnUpdate();
                        CurrPage.Update(false);
                    end;
                }
                field(EndDate; gdatEnd)
                {
                    Caption = 'End Date';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Date field.';


                    trigger OnValidate()
                    begin
                        Rec.SetRange("Date Filter", gdatStart, gdatEnd);
                        lfcnUpdate();
                        CurrPage.Update(false);
                    end;
                }
                field(goptColumnView; goptColumnView)
                {
                    Caption = 'Column View';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Column View field.';


                    trigger OnValidate()
                    begin
                        // MP 25-11-15 >>
                        gblnGAAPAdjmtReasonView := goptColumnView = goptColumnView::"GAAP Adjustment Reason";
                        if gblnGAAPAdjmtReasonView then begin
                            goptIncludeStatTax := goptIncludeStatTax::"Statutory Only";
                            gblnIncludePreviousYear := false;
                        end;
                        lfcnUpdateColumns();
                        // MP 25-11-15 <<
                    end;
                }
                field(goptIncludeStatTax; goptIncludeStatTax)
                {
                    Caption = 'Include Statutory/Tax';
                    Enabled = NOT gblnGAAPAdjmtReasonView;
                    OptionCaption = 'Both,Statutory Only,Tax Only';
                    Visible = NOT gblnBottomUp;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Statutory/Tax field.';


                    trigger OnValidate()
                    begin
                        gblnIncludeStatutory := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Statutory Only"];
                        gblnIncludeTax := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Tax Only"];
                        lfcnUpdateColumns();
                    end;
                }
                field(IncludeGroupTax; goptIncludeStatTax)
                {
                    Caption = 'Include Group/Tax';
                    Enabled = NOT gblnGAAPAdjmtReasonView;
                    OptionCaption = 'Both,Group Only,Tax Only';
                    Visible = gblnBottomUp;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Group/Tax field.';


                    trigger OnValidate()
                    begin
                        gblnIncludeStatutory := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Statutory Only"];
                        gblnIncludeTax := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Tax Only"];
                        lfcnUpdateColumns();
                    end;
                }
                field(gblnIncludePrepostedEntries; gblnIncludePrepostedEntries)
                {
                    Caption = 'Include Un-posted Entries';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Un-posted Entries field.';


                    trigger OnValidate()
                    begin
                        lfcnUpdateColumns();
                        // MP 25-11-15 >>
                        if goptExcludeAccounts <> goptExcludeAccounts::" " then
                            gmdlGAAPMgt.gfcnFilterZeroMovementBlocked(Rec, goptExcludeAccounts);
                        // MP 25-11-15 <<
                    end;
                }
                field(gblnIncludePreviousYear; gblnIncludePreviousYear)
                {
                    Caption = 'Include Previous Year';
                    Enabled = NOT gblnGAAPAdjmtReasonView;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Previous Year field.';


                    trigger OnValidate()
                    begin
                        lfcnUpdateColumns();
                    end;
                }
                field(gblnShowLocalGLAcc; gblnShowLocalGLAcc)
                {
                    Caption = 'Show Local G/L Account';
                    Visible = gblnBottomUp AND gblnCorpAccInUse;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Show Local G/L Account field.';


                    trigger OnValidate()
                    begin
                        lfcnUpdateColumns(); // MP 23-04-14
                    end;
                }
                field(goptExcludeAccounts; goptExcludeAccounts)
                {
                    Caption = 'Exclude Accounts';
                    OptionCaption = ' ,Zero Movement,Blocked,Zero Movement and Blocked';
                    Visible = gblnGAAPAdjmtReasonView;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Exclude Accounts field.';


                    trigger OnValidate()
                    begin
                        gmdlGAAPMgt.gfcnFilterZeroMovementBlocked(Rec, goptExcludeAccounts);
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Note: DEBIT = Positive Amount, CREDIT = Negative Amount")
            {
                Caption = 'Note: DEBIT = Positive Amount, CREDIT = Negative Amount';
                Visible = NOT gblnBottomUp;
            }
            group("Note: DEBIT = Positive Amount, CREDIT = Negative Amount (Except for Group Adjustments)")
            {
                Caption = 'Note: DEBIT = Positive Amount, CREDIT = Negative Amount (Except for Group Adjustments)';
                Visible = gblnBottomUp;
            }
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Corporate G/L Account No.';
                    Visible = gblnCorpAccInUse AND NOT gblnShowLocalGLAcc;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field("Search Name"; Rec."Search Name")
                {
                    Caption = 'Corporate G/L Account No.';
                    Visible = gblnShowLocalGLAcc;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field(Name; Rec.Name)
                {
                    Caption = 'Corporate G/L Account Name';
                    Visible = gblnCorpAccInUse;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account Name field.';

                }
                field("Local G/L Account No."; Rec."Local G/L Account No.")
                {
                    ApplicationArea = all;

                    Visible = NOT gblnBottomUp OR (gblnBottomUp AND NOT gblnCorpAccInUse) OR gblnShowLocalGLAcc;
                    ToolTip = 'Specifies the value of the Local G/L Account No. field.';
                }
                field("Local G/L Acc. Name"; Rec."Local G/L Acc. Name")
                {
                    ApplicationArea = all;

                    Visible = NOT gblnBottomUp OR (gblnBottomUp AND NOT gblnCorpAccInUse) OR gblnShowLocalGLAcc;
                    ToolTip = 'Specifies the value of the Local G/L Acc. Name field.';
                }
                field("Local G/L Acc. Name (English)"; Rec."Local G/L Acc. Name (English)")
                {
                    ApplicationArea = all;

                    Visible = NOT gblnBottomUp OR (gblnBottomUp AND NOT gblnCorpAccInUse) OR gblnShowLocalGLAcc;
                    ToolTip = 'Specifies the value of the Local G/L Account Name (English) field.';
                }
                field(gdecCorpAmtLY; gdecCorpAmt[2])
                {
                    ApplicationArea = all;

                    BlankZero = true;
                    Caption = 'Corporate GAAP (PY)';
                    Visible = gblnIncludePreviousYear AND gblnIncludeStatutory AND gblnCorpAccInUse;
                    ToolTip = 'Specifies the value of the Corporate GAAP (PY) field.';

                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodGroupDimCode, '', false, true)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''', '', false, true);
                    end;
                }
                field(gdecStatAdjmtAmtLY; gdecStatAdjmtAmt[2])
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    CaptionClass = gtxtPostedStatGrAdjmtPYCaption;
                    Visible = gblnIncludePreviousYear AND gblnIncludeStatutory AND gblnCorpAccInUse AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the gdecStatAdjmtAmt[2] field.';

                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodGroupDimCode, '', false, false)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodStatDimCode, '<>3', false, false); // 3=Auditor
                    end;
                }
                field(gdecAuditorAdjmtAmtLY; gdecAuditorAdjmtAmt[2])
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    Caption = 'Posted Auditor Adjustments (PY)';
                    Visible = gblnIncludePreviousYear AND gblnIncludeStatutory AND (NOT gblnBottomUp) AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the Posted Auditor Adjustments (PY) field.';

                    trigger OnDrillDown()
                    begin
                        // MP 04-12-12 Added last parameter below
                        gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodStatDimCode, '3', false, false); // 3=Auditor
                    end;
                }
                field(gdecStatTBAmtLY; gdecStatTBAmt[2])
                {
                    BlankZero = true;
                    CaptionClass = gtxtStatTBPYCaption;
                    Visible = gblnIncludePreviousYear;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gdecStatTBAmt[2] field.';


                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''', '', false, true)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodStatDimCode, '', false, true);
                    end;
                }
                field(gdecTaxAdjmtAmtLY; gdecTaxAdjmtAmt[2])
                {
                    BlankZero = true;
                    Caption = 'Posted Tax Adjustments (PY)';
                    Visible = gblnIncludePreviousYear AND gblnIncludeTax;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted Tax Adjustments (PY) field.';


                    trigger OnDrillDown()
                    begin
                        // MP 04-12-12 Added last parameter below
                        gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodTaxDimCode, '', false, false);
                    end;
                }
                field(gdecTaxTBAmtLY; gdecTaxTBAmt[2])
                {
                    BlankZero = true;
                    Caption = 'Tax TB (PY)';
                    Visible = gblnIncludePreviousYear AND gblnIncludeTax;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax TB (PY) field.';


                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodTaxDimCode, '', false, true)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '', '', false, true);
                    end;
                }
                field("gdecCorpAmt[1]"; gdecCorpAmt[1])
                {
                    BlankZero = true;
                    Caption = 'Corporate GAAP';
                    Visible = gblnIncludeStatutory AND gblnCorpAccInUse;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate GAAP field.';


                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            if gblnIncludePrepostedEntries then
                                gmdlGAAPMgt.gfcnDrillDown(Rec, 0, '''''|' + gcodGroupDimCode, '', true, true)
                            else
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodGroupDimCode, '', true, true)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''', '', true, true);
                    end;
                }
                field("gdecStatPrepostAmt[1]"; gdecStatPrepostAmt[1])
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    CaptionClass = gtxtUnpostedStatAmount;
                    Visible = gblnIncludePrepostedEntries AND gblnIncludeStatutory AND gblnCorpAccInUse AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the gdecStatPrepostAmt[1] field.';

                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"Gen. Journal Line", gcodGroupDimCode, '', true, false)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"Gen. Journal Line", gcodStatDimCode, '', true, false);
                    end;
                }
                field("gdecStatAdjmtAmt[1]"; gdecStatAdjmtAmt[1])
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    CaptionClass = gtxtPostedStatGrAdjmtCaption;
                    Visible = gblnIncludeStatutory AND gblnCorpAccInUse AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the gdecStatAdjmtAmt[1] field.';

                    trigger OnDrillDown()
                    begin
                        // MP 26-11-13 >>
                        if gblnBottomUp then
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodGroupDimCode, '', true, false)
                        else
                            // MP 26-11-13 <<

                            // MP 04-12-12 Added last parameter below
                            gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodStatDimCode, '<>3', true, false); // 3=Auditor
                    end;
                }
                field("gdecAuditorAdjmtAmt[1]"; gdecAuditorAdjmtAmt[1])
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    Caption = 'Posted Auditor Adjustments';
                    Visible = gblnIncludeStatutory AND (NOT gblnBottomUp) AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the Posted Auditor Adjustments field.';

                    trigger OnDrillDown()
                    begin
                        // MP 04-12-12 Added last parameter below
                        gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodStatDimCode, '3', true, false); // 3=Auditor
                    end;
                }
                field(gdecPriorYearAdjmtAmt; gdecPriorYearAdjmtAmt)
                {
                    BlankZero = true;
                    Caption = 'Prior Year Adjustments';
                    ApplicationArea = all;

                    Visible = gblnGAAPAdjmtReasonView;
                    ToolTip = 'Specifies the value of the Prior Year Adjustments field.';

                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgt.gfcnDrillDownAdjmts(Rec, 0); // MP 25-11-15
                    end;
                }
                field(gdecCurrYearAdjmtAmt; gdecCurrYearAdjmtAmt)
                {
                    BlankZero = true;
                    Caption = 'Current Year Adjustments';
                    Visible = gblnGAAPAdjmtReasonView;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Current Year Adjustments field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgt.gfcnDrillDownAdjmts(Rec, 1); // MP 25-11-15
                    end;
                }
                field(gdecCurrYearReclassAmt; gdecCurrYearReclassAmt)
                {
                    BlankZero = true;
                    Caption = 'Current Year Reclassifications';
                    Visible = gblnGAAPAdjmtReasonView;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Current Year Reclassifications field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgt.gfcnDrillDownAdjmts(Rec, 2); // MP 25-11-15
                    end;
                }
                field("gdecStatTBAmt[1]"; gdecStatTBAmt[1])
                {
                    BlankZero = true;
                    CaptionClass = gtxtStatTBCaption;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gdecStatTBAmt[1] field.';


                    trigger OnDrillDown()
                    begin
                        if gblnIncludePrepostedEntries then
                            // MP 26-11-13 >>
                            if gblnBottomUp then
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''', '', true, true)
                            else
                                // MP 26-11-13 <<

                                // MP 04-12-12 Added last parameter below
                                gmdlGAAPMgt.gfcnDrillDown(Rec, 0, '''''|' + gcodStatDimCode, '', true, true)
                        else
                            // MP 26-11-13 >>
                            if gblnBottomUp then
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''', '', true, true)
                            else
                                // MP 26-11-13 <<

                                // MP 04-12-12 Added last parameter below
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodStatDimCode, '', true, true);
                    end;
                }
                field("gdecTaxPrepostAmt[1]"; gdecTaxPrepostAmt[1])
                {
                    BlankZero = true;
                    Caption = 'Un-posted Tax Amount';
                    ApplicationArea = all;

                    Visible = gblnIncludeTax AND gblnIncludePrepostedEntries AND (NOT gblnGAAPAdjmtReasonView);
                    ToolTip = 'Specifies the value of the Un-posted Tax Amount field.';

                    trigger OnDrillDown()
                    begin
                        // MP 04-12-12 Added last parameter below
                        gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"Gen. Journal Line", gcodTaxDimCode, '', true, false);
                    end;
                }
                field("gdecTaxAdjmtAmt[1]"; gdecTaxAdjmtAmt[1])
                {
                    BlankZero = true;
                    Caption = 'Posted Tax Adjustments';
                    Visible = gblnIncludeTax;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted Tax Adjustments field.';


                    trigger OnDrillDown()
                    begin
                        // MP 04-12-12 Added last parameter below
                        gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", gcodTaxDimCode, '', true, false);
                    end;
                }
                field("gdecTaxTBAmt[1]"; gdecTaxTBAmt[1])
                {
                    BlankZero = true;
                    Caption = 'Tax TB';
                    Visible = gblnIncludeTax;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax TB field.';


                    trigger OnDrillDown()
                    begin
                        if gblnIncludePrepostedEntries then
                            // MP 26-11-13 >>
                            if gblnBottomUp then
                                gmdlGAAPMgt.gfcnDrillDown(Rec, 0, '''''|' + gcodTaxDimCode, '', true, true)
                            else
                                // MP 26-11-13 <<

                                // MP 04-12-12 Added last parameter below
                                gmdlGAAPMgt.gfcnDrillDown(Rec, 0, '', '', true, true)
                        else
                            // MP 26-11-13 >>
                            if gblnBottomUp then
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '''''|' + gcodTaxDimCode, '', true, true)
                            else
                                // MP 26-11-13 <<

                                // MP 04-12-12 Added last parameter below
                                gmdlGAAPMgt.gfcnDrillDown(Rec, DATABASE::"G/L Entry", '', '', true, true);
                    end;
                }
                field("gcodFSCode[1]"; gcodFSCode[1])
                {
                    Caption = 'FS Code';
                    TableRelation = "Financial Statement Code";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FS Code field.';

                }
                field("gtxtFSDescription[1]"; gtxtFSDescription[1])
                {
                    Caption = 'FS Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FS Description field.';

                }
                field("gcodFSCode[2]"; gcodFSCode[2])
                {
                    Caption = 'FS Code (PY)';
                    ApplicationArea = all;

                    TableRelation = "Financial Statement Code";
                    Visible = gblnIncludePreviousYear OR gblnGAAPAdjmtReasonView;
                    ToolTip = 'Specifies the value of the FS Code (PY) field.';
                }
                field("gtxtFSDescription[2]"; gtxtFSDescription[2])
                {
                    Caption = 'FS Description (PY)';
                    Visible = gblnIncludePreviousYear OR gblnGAAPAdjmtReasonView;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FS Description (PY) field.';

                }
                field("Account Class"; Rec."Account Class")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Class field.';

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ccount")
            {
                Caption = 'A&ccount';
                action("<Action1000000035>")
                {
                    Caption = 'GAAP-to-GAAP Adjustments';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = NOT gblnBottomUp;
                    ToolTip = 'Executes the GAAP-to-GAAP Adjustments action.';

                    trigger OnAction()
                    var
                        lpagGAAPAdjJnl: Page "GAAP Adjustment Journal";
                    begin
                        lpagGAAPAdjJnl.RunModal(); // MP 25-09-13
                    end;
                }
                action("<Action1000000027>")
                {
                    Caption = 'GAAP-to-TAX Adjustments';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the GAAP-to-TAX Adjustments action.';

                    trigger OnAction()
                    var
                        lpagTaxAdjJnl: Page "Tax Adjustment Journal";
                    begin
                        lpagTaxAdjJnl.RunModal(); // MP 25-09-13
                    end;
                }
                action(GroupAdjustments)
                {
                    Caption = 'Group Adjustments';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = gblnBottomUp;
                    ToolTip = 'Executes the Group Adjustments action.';

                    trigger OnAction()
                    var
                        lpagGroupAdjJnl: Page "Group Adjustment Journal";
                    begin
                        lpagGroupAdjJnl.RunModal(); // MP 25-09-13
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';

                    trigger OnAction()
                    var
                        lrecGLAcc: Record "G/L Account";
                        lrecCorpGLAcc: Record "Corporate G/L Account";
                    begin
                        // MP 23-04-14 >>
                        // MP 27-11-13 >>
                        //IF gblnCorpAccInUse THEN
                        //  PAGE.RUN(PAGE::"Corporate G/L Account Card",Rec)
                        //ELSE BEGIN
                        //  lrecGLAcc."No." := "No.";
                        //  PAGE.RUN(PAGE::"G/L Account Card",lrecGLAcc);
                        //END;
                        // MP 27-11-13 <<

                        if gblnCorpAccInUse and not gblnShowLocalGLAcc then begin
                            lrecCorpGLAcc."No." := Rec."No.";
                            PAGE.Run(PAGE::"Corporate G/L Account Card", lrecCorpGLAcc)
                        end else begin
                            lrecGLAcc."No." := Rec."Local G/L Account No.";
                            PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
                        end;

                        // MP 23-04-14 <<
                    end;
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';

                    trigger OnAction()
                    var
                        lrecGLEntry: Record "G/L Entry";
                    begin
                        // MP 27-11-13 >>
                        //IF gblnCorpAccInUse THEN BEGIN
                        if gblnCorpAccInUse and not gblnShowLocalGLAcc then begin // MP 23-04-14 Added gblnShowLocalGLAcc condition
                            lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Posting Date");
                            lrecGLEntry.SetRange("Corporate G/L Account No.", Rec."No.");
                        end else begin
                            lrecGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                            //lrecGLEntry.SETRANGE("G/L Account No.","No.");
                            lrecGLEntry.SetRange("G/L Account No.", Rec."Local G/L Account No."); // MP 23-04-14 Replaces above
                        end;
                        PAGE.Run(0, lrecGLEntry);
                        // MP 27-11-13 <<
                    end;
                }
            }
        }
        area(reporting)
        {
            action(GlobalViewReport)
            {
                Caption = 'Global View';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Global View action.';

                trigger OnAction()
                var
                    lrptGlobalChartofAccountsView: Report "Global View";
                begin
                    lrptGlobalChartofAccountsView.gfcnInit(gdatStart, gdatEnd, goptIncludeStatTax, gblnIncludePrepostedEntries, gblnIncludePreviousYear,
                      goptColumnView); // MP 25-11-15 New parameter
                    lrptGlobalChartofAccountsView.SetTableView(Rec);
                    lrptGlobalChartofAccountsView.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        lrecFinancialStatementCode: Record "Financial Statement Code";
    begin
        gmdlGAAPMgt.gfcnCalc(Rec,
          gdecCorpAmt, gdecStatPrepostAmt, gdecStatAdjmtAmt, gdecAuditorAdjmtAmt, gdecStatTBAmt,
          gdecTaxPrepostAmt, gdecTaxAdjmtAmt, gdecTaxTBAmt,
          gdecPriorYearAdjmtAmt, gdecCurrYearAdjmtAmt, gdecCurrYearReclassAmt, gcodFSCode, gtxtFSDescription); // MP 25-11-15 New parameters
    end;

    trigger OnOpenPage()
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
        lrrfAccPeriod: RecordRef;
        lfrfField: FieldRef;
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
    begin
        // MP 25-11-13 >>
        lrrfAccPeriod.Open(lmdlCompanyTypeMgt.gfcnGetAccPeriodTableID());
        lfrfField := lrrfAccPeriod.Field(1); // "Starting Date"
        lfrfField.SetRange(gdatStart);
        gblnBottomUp := lmdlCompanyTypeMgt.gfcnIsBottomUp();
        gblnCorpAccInUse := lmdlCompanyTypeMgt.gfcnCorpAccInUse();
        gmdlGAAPMgt.gfcnGetCaptions(gtxtPostedStatGrAdjmtCaption, gtxtPostedStatGrAdjmtPYCaption, gtxtStatTBCaption, gtxtStatTBPYCaption,
          gtxtUnpostedStatAmount);
        // MP 25-11-13 <<

        if (gdatStart = 0D) or (gdatEnd = 0D) or
        //  ((gdatStart <> 0D) AND NOT lrecCorpAccPeriod.GET(gdatStart)) // MP 14-02-13
          ((gdatStart <> 0D) and not lrrfAccPeriod.FindFirst()) // MP 25-11-13 Replaces above
        then
            gmdlGAAPMgt.gfcnGetAccPeriodFilter(WorkDate(), gdatStart, gdatEnd);

        Rec.SetRange("Date Filter", gdatStart, gdatEnd);

        gblnIncludeStatutory := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Statutory Only"];
        gblnIncludeTax := goptIncludeStatTax in [goptIncludeStatTax::Both, goptIncludeStatTax::"Tax Only"];

        // MP 23-04-14 Moved first line down to after lfcnUpdate >>
        //lfcnPopulateAccounts; // MP 26-11-13
        if (not gblnCorpAccInUse) or (not gblnBottomUp) then
            gblnShowLocalGLAcc := false;
        // MP 23-04-14 <<
        lfcnUpdate();
        lfcnPopulateAccounts(); // MP 23-04-14

        gblnReopen := false;

        // MP 25-11-13 >>
        if lmdlCompanyTypeMgt.gfcnIsBottomUp() then begin
            lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"19");
            lrecGenJnlTemplate.FindFirst();
            gcodGroupDimCode := lrecGenJnlTemplate."Shortcut Dimension 1 Code";
        end else begin
            // MP 25-11-13 <<
            lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Tax Adjustments");
            lrecGenJnlTemplate.FindFirst();
            gcodStatDimCode := lrecGenJnlTemplate."Shortcut Dimension 1 Code";
        end; // MP 25-11-13

        lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
        lrecGenJnlTemplate.FindFirst();
        gcodTaxDimCode := lrecGenJnlTemplate."Shortcut Dimension 1 Code";

        // MP 25-11-15 >>
        gblnGAAPAdjmtReasonView := goptColumnView = goptColumnView::"GAAP Adjustment Reason";

        if gblnGAAPAdjmtReasonView then
            gmdlGAAPMgt.gfcnFilterZeroMovementBlocked(Rec, goptExcludeAccounts);
        // MP 25-11-15 <<
    end;

    var
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        goptIncludeStatTax: Option Both,"Statutory Only","Tax Only";
        goptColumnView: Option "Adjustment Role","GAAP Adjustment Reason";
        goptExcludeAccounts: Option " ","Zero Movement",Blocked,"Zero Movement and Blocked";
        gdatStart: Date;
        gdatEnd: Date;
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
        gtxtPostedStatGrAdjmtCaption: Text[50];
        gtxtPostedStatGrAdjmtPYCaption: Text[50];
        gtxtStatTBCaption: Text[50];
        gtxtStatTBPYCaption: Text[50];
        gtxtUnpostedStatAmount: Text[50];
        gtxtFSDescription: array[2] of Text[100];
        gcodStatDimCode: Code[20];
        gcodTaxDimCode: Code[20];
        gcodGroupDimCode: Code[20];
        gcodFSCode: array[2] of Code[10];

        gblnIncludeStatutory: Boolean;

        gblnIncludeTax: Boolean;

        gblnIncludePrepostedEntries: Boolean;

        gblnIncludePreviousYear: Boolean;
        gblnReopen: Boolean;

        gblnBottomUp: Boolean;

        gblnCorpAccInUse: Boolean;

        gblnShowLocalGLAcc: Boolean;

        gblnGAAPAdjmtReasonView: Boolean;

    local procedure lfcnUpdate()
    begin
        gmdlGAAPMgt.gfcnInit(gdatStart, gdatEnd, gblnIncludePrepostedEntries, gblnIncludeTax, gblnIncludePreviousYear,
          gblnShowLocalGLAcc, // MP 23-04-14 Added gblnShowLocalGLAcc
          goptColumnView); // MP 25-11-15 Added goptColumnView
    end;

    local procedure lfcnUpdateColumns()
    begin
        gblnReopen := true;
        CurrPage.Close();
    end;


    procedure gfcnReopen(): Boolean
    begin
        exit(gblnReopen);
    end;

    local procedure lfcnPopulateAccounts()
    begin
        // MP 26-11-13

        gmdlGAAPMgt.gfcnPopulateAccounts(Rec);
    end;
}

