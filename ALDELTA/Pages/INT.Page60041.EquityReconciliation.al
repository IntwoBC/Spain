page 60041 "Equity Reconciliation"
{
    // MP 14-02-13
    // Fixed issue where accounting period is "remembered" from another company, but not same as in current company
    // 
    // MP 25-11-13
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup (CR 30)
    // 
    // MP 08-04-13
    // Added to Note (Except for Group Adjustments) (CR 30)
    // 
    // MP 10-12-15
    // Added functionality to include unposted entries (CB1 Enhancements)

    Caption = 'Equity Reconciliation';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Equity Reconciliation Line";
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
                group(Control1)
                {
                    ShowCaption = false;
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
                            lfcnUpdate();
                            CurrPage.Update(false);
                        end;
                    }
                }
                group(Control3)
                {
                    ShowCaption = false;
                    field("Include Statutory/Tax"; goptIncludeStatTax)
                    {
                        Caption = 'Include Statutory/Tax';
                        Visible = NOT gblnBottomUp;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Include Statutory/Tax field.';


                        trigger OnValidate()
                        begin
                            lfcnSetViewFilter();
                            CurrPage.Update(false);
                        end;
                    }
                    field("Include Group/Tax"; goptIncludeStatTax)
                    {
                        Caption = 'Include Group/Tax';
                        OptionCaption = 'Both,Group Only,Tax Only';
                        Visible = gblnBottomUp;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Include Group/Tax field.';


                        trigger OnValidate()
                        begin
                            lfcnSetViewFilter();
                            CurrPage.Update(false);
                        end;
                    }
                    field("Group By"; goptGroupBy)
                    {
                        Caption = 'Group By';
                        OptionCaption = 'Year,Equity Correction Code';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Group By field.';


                        trigger OnValidate()
                        begin
                            lfcnUpdate();
                            CurrPage.Update(false);
                        end;
                    }
                    field("Include Un-posted Entries"; gblnIncludeUnpostedEntries)
                    {
                        Caption = 'Include Un-posted Entries';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Include Un-posted Entries field.';


                        trigger OnValidate()
                        begin
                            // MP 10-12-15 >>
                            lfcnUpdate();
                            CurrPage.Update(false);
                            // MP 10-12-15 <<
                        end;
                    }
                }
            }
            group("Note: DEBIT = Negative Amount, CREDIT = Positive Amount")
            {
                Caption = 'Note: DEBIT = Negative Amount, CREDIT = Positive Amount';
                Visible = NOT gblnBottomUp OR NOT gblnCorpAccInUse;
            }
            group("Note: DEBIT = Negative Amount, CREDIT = Positive Amount (Except for Group Adjustments)")
            {
                Caption = 'Note: DEBIT = Negative Amount, CREDIT = Positive Amount (Except for Group Adjustments)';
                Visible = gblnBottomUp AND gblnCorpAccInUse;
            }
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Style = Standard;
                    ApplicationArea = all;

                    StyleExpr = gblnBold;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Entry Description"; Rec."Entry Description")
                {
                    Editable = gblnEntryDescriptionEditable;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry Description field.';


                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field(Year; Rec.Year)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Year field.';

                }
                field("Start Balance"; Rec."Start Balance")
                {
                    CaptionClass = gtxtStartBalanceCaption;
                    ApplicationArea = all;

                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ToolTip = 'Specifies the value of the Start Balance field.';

                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("Start Balance"));
                    end;
                }
                field("Document No. (Start Balance)"; Rec."Document No. (Start Balance)")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("Document No. (Start Balance)"));
                    end;
                }
                field("Net Change (P&L)"; Rec."Net Change (P&L)")
                {
                    CaptionClass = gtxtNetChangePLCaption;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Change (P&L) field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("Net Change (P&L)"));
                    end;
                }
                field("Net Change (Equity)"; Rec."Net Change (Equity)")
                {
                    CaptionClass = gtxtNetChangeEquityCaption;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Change (Equity) field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("Net Change (Equity)"));
                    end;
                }
                field("Document No. (Net Change)"; Rec."Document No. (Net Change)")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("Document No. (Net Change)"));
                    end;
                }
                field("End Balance"; Rec."End Balance")
                {
                    CaptionClass = gtxtEndBalanceCaption;
                    Editable = false;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Balance field.';


                    trigger OnDrillDown()
                    begin
                        gmdlGAAPMgtEquityRecon.gfcnDrillDown(Rec, Rec.FieldNo("End Balance"));
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000032>")
            {
                Caption = 'A&ccount';
                action("<Action1000000031>")
                {
                    Caption = 'Card';
                    Enabled = gblnGLAcc;
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Card action.';


                    trigger OnAction()
                    var
                        lrecCorpGLAcc: Record "Corporate G/L Account";
                        lrecGLAcc: Record "G/L Account";
                    begin
                        // MP 27-11-13 >>
                        if gblnCorpAccInUse then begin
                            lrecCorpGLAcc."No." := Rec.Code;
                            PAGE.Run(PAGE::"Corporate G/L Account Card", Rec);
                        end else begin
                            lrecGLAcc."No." := Rec.Code;
                            PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
                        end;
                        // MP 27-11-13 <<
                    end;
                }
                action("<Action1000000004>")
                {
                    Caption = 'Ledger E&ntries';
                    Enabled = gblnGLAcc;
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';

                    trigger OnAction()
                    var
                        lrecGLEntry: Record "G/L Entry";
                    begin
                        // MP 27-11-13 >>
                        if gblnCorpAccInUse then begin
                            lrecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Posting Date");
                            lrecGLEntry.SetRange("Corporate G/L Account No.", Rec.Code);
                        end else begin
                            lrecGLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                            lrecGLEntry.SetRange("G/L Account No.", Rec.Code);
                        end;
                        PAGE.Run(0, lrecGLEntry);
                        // MP 27-11-13 <<
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Equity Reconciliation")
            {
                Caption = 'Equity Reconciliation';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Equity Reconciliation action.';


                trigger OnAction()
                var
                    lrptEquityRecon: Report "Equity Reconciliation";
                begin
                    lrptEquityRecon.gfcnSetSource(Rec);
                    lrptEquityRecon.gfcnSetCaptions(gtxtStartBalanceCaption,
                      gtxtNetChangePLCaption, gtxtNetChangeEquityCaption, gtxtEndBalanceCaption);
                    lrptEquityRecon.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        gblnBold := Rec.Subtotal;
        gblnGLAcc := (Rec.Type = Rec.Type::"Corp. Account Summary") and (Rec.Code <> '');
        gblnEntryDescriptionEditable := (Rec.Type = Rec.Type::Entries) and (Rec.Code <> '') and (Rec.Year <> 0);
    end;

    trigger OnOpenPage()
    var
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
        // MP 25-11-13 <<

        if (gdatStart = 0D) or (gdatEnd = 0D) or
        //  ((gdatStart <> 0D) AND NOT lrecCorpAccPeriod.GET(gdatStart)) // MP 14-02-13
          ((gdatStart <> 0D) and not lrrfAccPeriod.FindFirst()) // MP 25-11-13 Replaces above
        then
            gmdlGAAPMgt.gfcnGetAccPeriodFilter(WorkDate(), gdatStart, gdatEnd)
        else
            gmdlGAAPMgt.gfcnGetAccPeriodFilter(gdatStart, gdatStart, gdatEnd);

        lfcnUpdate();
    end;

    var
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        gmdlGAAPMgtEquityRecon: Codeunit "GAAP Mgt. - Equity Reconcil.";
        goptIncludeStatTax: Option Both,"Statutory Only","Tax Only";
        goptGroupBy: Option Year,"Equity Correction Code";

        gtxtStartBalanceCaption: Text[30];

        gtxtNetChangePLCaption: Text[30];
        gtxtNetChangeEquityCaption: Text[30];

        gtxtEndBalanceCaption: Text[30];
        gdatStart: Date;
        gdatEnd: Date;

        gblnBold: Boolean;

        gblnGLAcc: Boolean;

        gblnEntryDescriptionEditable: Boolean;

        gblnBottomUp: Boolean;

        gblnCorpAccInUse: Boolean;

        gblnIncludeUnpostedEntries: Boolean;

    local procedure lfcnUpdate()
    begin
        gmdlGAAPMgtEquityRecon.gfcnInit(gdatStart, gdatEnd, goptGroupBy, gblnIncludeUnpostedEntries); // MP 10-12-15 Added parameter gblnIncludeUnpostedEntries
        gmdlGAAPMgtEquityRecon.gfcnCalc(Rec);
        gmdlGAAPMgtEquityRecon.gfcnGetCaptions(gtxtStartBalanceCaption, gtxtNetChangePLCaption, gtxtNetChangeEquityCaption,
          gtxtEndBalanceCaption);
        lfcnSetViewFilter();
    end;

    local procedure lfcnSetViewFilter()
    begin
        case goptIncludeStatTax of
            goptIncludeStatTax::Both:
                begin
                    Rec.SetRange(Statutory);
                    Rec.SetRange(Tax);
                end;

            goptIncludeStatTax::"Statutory Only":
                begin
                    Rec.SetRange(Statutory, true);
                    Rec.SetRange(Tax);
                end;

            goptIncludeStatTax::"Tax Only":
                begin
                    Rec.SetRange(Statutory);
                    Rec.SetRange(Tax, true);
                end;
        end;
    end;
}

