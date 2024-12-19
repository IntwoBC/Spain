page 60073 "Adjustments View"
{
    Caption = 'Adjustments View';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Integer";
    SourceTableView = SORTING(Number)
                      WHERE(Number = CONST(1));
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                group(Control4)
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
                            lfcnUpdateClosingDateFilter();
                            lfcnUpdate();
                        end;
                    }
                    field(EndDate; gdatEnd)
                    {
                        Caption = 'End Date';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the End Date field.';


                        trigger OnValidate()
                        begin
                            lfcnUpdateClosingDateFilter();
                            lfcnUpdate();
                        end;
                    }
                }
                group(Control5)
                {
                    ShowCaption = false;
                    field(gblnIncludeUnpostedEntries; gblnIncludeUnpostedEntries)
                    {
                        Caption = 'Include Un-posted Entries';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Include Un-posted Entries field.';


                        trigger OnValidate()
                        begin
                            lfcnUpdate();
                        end;
                    }
                    field(goptExcludeEntries; goptExcludeEntries)
                    {
                        Caption = 'Exclude Entries';
                        OptionCaption = ' ,Reclassification Reversals,Closing Date,Reclassification Reversals and Closing Date';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Exclude Entries field.';


                        trigger OnValidate()
                        begin
                            lfcnUpdate();
                        end;
                    }
                }
            }
            part(AdjmtsViewSubformExclUnp; "Adjmts. View Subform-Excl. Unp")
            {
                Visible = NOT gblnIncludeUnpostedEntries;
                ApplicationArea = all;

            }
            part(AdjmtsViewSubformInclUnp; "Adjmts. View Subform-Incl. Unp")
            {
                Visible = gblnIncludeUnpostedEntries;
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';


                    trigger OnAction()
                    begin
                        lfcnGetGLEntry();
                        grecGLEntry.ShowDimensions();
                    end;
                }
                action(GLDimensionOverview)
                {
                    Caption = 'G/L Dimension Overview';
                    Image = Dimensions;
                    Visible = NOT gblnIncludeUnpostedEntries;
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Dimension Overview action.';


                    trigger OnAction()
                    begin
                        CurrPage.AdjmtsViewSubformExclUnp.PAGE.gfcnGetCopy(grecGLEntry);
                        PAGE.Run(PAGE::"G/L Entries Dimension Overview", grecGLEntry);
                    end;
                }
                action("Value Entries")
                {
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Value Entries action.';


                    trigger OnAction()
                    begin
                        lfcnGetGLEntry();
                        grecGLEntry.ShowValueEntries();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ReverseTransaction)
                {
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Reverse Transaction action.';


                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        lfcnGetGLEntry();
                        Clear(ReversalEntry);
                        if grecGLEntry.Reversed then
                            ReversalEntry.AlreadyReversedEntry(grecGLEntry.TableCaption, grecGLEntry."Entry No.");
                        if grecGLEntry."Journal Batch Name" = '' then
                            ReversalEntry.TestFieldError();
                        grecGLEntry.TestField("Transaction No.");
                        ReversalEntry.ReverseTransaction(grecGLEntry."Transaction No.")
                    end;
                }
                action("<Action1000000013>")
                {
                    Caption = 'Toggle Mark for GAAP/Tax Reversal';
                    Image = ImplementRegAbsence;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Toggle Mark for GAAP/Tax Reversal action.';


                    trigger OnAction()
                    begin
                        lfcnGetGLEntry();
                        CODEUNIT.Run(CODEUNIT::"Toggle Mark GAAP/Tax Reversal", grecGLEntry);
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the &Navigate action.';


                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    lfcnGetGLEntry();
                    Navigate.SetDoc(grecGLEntry."Posting Date", grecGLEntry."Document No.");
                    Navigate.Run();
                end;
            }
            action("Incoming Document")
            {
                Caption = 'Incoming Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Incoming Document action.';


                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    lfcnGetGLEntry();
                    IncomingDocument.HyperlinkToDocument(grecGLEntry."Document No.", grecGLEntry."Posting Date");
                end;
            }
            action("Document Links")
            {
                Caption = 'Document Links';
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Document Links action.';


                trigger OnAction()
                var
                    lrecGLEntryRecLink: Record "G/L Entry Document Link";
                begin
                    lfcnGetGLEntry();
                    if lrecGLEntryRecLink.Get(grecGLEntry."Transaction No.", grecGLEntry."Document No.") then;
                    lrecGLEntryRecLink.SetRecFilter();
                    PAGE.Run(PAGE::"G/L Entry Document Links", lrecGLEntryRecLink);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        lfcnUpdate();
    end;

    trigger OnOpenPage()
    begin
        if (gdatStart = 0D) or (gdatEnd = 0D) then
            gmdlGAAPMgt.gfcnGetAccPeriodFilter(WorkDate(), gdatStart, gdatEnd);

        lfcnUpdateClosingDateFilter();
    end;

    var
        grecGLEntry: Record "G/L Entry";
        gmdlGAAPMgt: Codeunit "GAAP Mgt. - Global View";
        goptExcludeEntries: Option " ","Reclassification Reversals","Closing Date","Reclassification Reversals and Closing Date";
        gdatStart: Date;
        gdatEnd: Date;
        gtxtClosingDateFilter: Text;

        gblnIncludeUnpostedEntries: Boolean;
        txtErrorUnpostedEntry: Label 'This action is not available for unposted entries';

    local procedure lfcnUpdate()
    var
        ltxtDateFilter: Text;
    begin
        case goptExcludeEntries of
            goptExcludeEntries::" ", goptExcludeEntries::"Reclassification Reversals":
                ltxtDateFilter := StrSubstNo('%1..%2', gdatStart, gdatEnd);

            goptExcludeEntries::"Closing Date", goptExcludeEntries::"Reclassification Reversals and Closing Date":
                if gtxtClosingDateFilter <> '' then
                    ltxtDateFilter := StrSubstNo('%1..%2&%3', gdatStart, gdatEnd, gtxtClosingDateFilter)
                else
                    ltxtDateFilter := StrSubstNo('%1..%2', gdatStart, gdatEnd);
        end;

        if gblnIncludeUnpostedEntries then
            CurrPage.AdjmtsViewSubformInclUnp.PAGE.gfcnUpdate(ltxtDateFilter, goptExcludeEntries)
        else
            CurrPage.AdjmtsViewSubformExclUnp.PAGE.gfcnUpdate(ltxtDateFilter, goptExcludeEntries);
    end;

    local procedure lfcnGetGLEntry()
    var
        lrecAdjmtEntryBuffer: Record "Adjustment Entry Buffer";
    begin
        if gblnIncludeUnpostedEntries then begin
            CurrPage.AdjmtsViewSubformInclUnp.PAGE.GetRecord(lrecAdjmtEntryBuffer);
            if lrecAdjmtEntryBuffer."G/L Entry No." = 0 then
                Error(txtErrorUnpostedEntry);

            grecGLEntry.Get(lrecAdjmtEntryBuffer."G/L Entry No.");
        end else
            CurrPage.AdjmtsViewSubformExclUnp.PAGE.GetRecord(grecGLEntry);
    end;

    local procedure lfcnUpdateClosingDateFilter()
    var
        lrecCorpAccPeriod: Record "Corporate Accounting Period";
        ldatClosingDate: Date;
    begin
        Clear(gtxtClosingDateFilter);

        lrecCorpAccPeriod.SetRange("Starting Date", gdatStart + 1, gdatEnd);
        lrecCorpAccPeriod.SetRange("New Fiscal Year", true);
        if lrecCorpAccPeriod.FindSet() then
            repeat
                ldatClosingDate := ClosingDate(lrecCorpAccPeriod."Starting Date" - 1);
                if gtxtClosingDateFilter <> '' then
                    gtxtClosingDateFilter += '&';
                gtxtClosingDateFilter += '<>' + Format(ldatClosingDate);
            until lrecCorpAccPeriod.Next() = 0;
    end;
}

