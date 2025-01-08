Page 60023 "Corporate Chart of Accounts"
{
    // MP 19-11-13
    // Added support for bottom-up companies, controling visibility of field "Local G/L Account No." and filtering on
    // Adjustment Entries (CR 30)
    // 
    // MP 06-05-14
    // Added field "Name (English)"
    // 
    // MP 11-11-14
    // Upgrade to NAV 2013 R2

    Caption = 'Corporate Chart of Accounts';
    CardPageID = "Corporate G/L Account Card";
    PageType = List;
    SourceTable = "Corporate G/L Account";
    ApplicationArea = All;
    UsageCategory = lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("Name (English)"; Rec."Name (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name (English) field.';

                }
                field("Local G/L Account No."; Rec."Local G/L Account No.")
                {
                    Visible = NOT gblnBottomUp;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Local G/L Account No. field.';

                }
                field("Account Class"; Rec."Account Class")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Class field.';

                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

                }
                field("Account Type"; Rec."Account Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';

                }
                field(Totaling; Rec.Totaling)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Totaling field.';


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLaccList: Page "Corporate G/L Account List";
                    begin
                        GLaccList.LookupMode(true);
                        if not (GLaccList.RunModal() = ACTION::LookupOK) then
                            exit(false)
                        else
                            Text := GLaccList.GetSelectionFilter();
                        exit(true);
                    end;
                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code field.';

                }
                field("Net Change"; Rec."Net Change")
                {
                    BlankZero = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Change field.';

                }
                field("Balance at Date"; Rec."Balance at Date")
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    Visible = false;
                    ToolTip = 'Specifies the value of the Balance at Date field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = all;

                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field("Additional-Currency Net Change"; Rec."Additional-Currency Net Change")
                {
                    BlankZero = true;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Additional-Currency Net Change field.';

                }
                field("Add.-Currency Balance at Date"; Rec."Add.-Currency Balance at Date")
                {
                    BlankZero = true;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Add.-Currency Balance at Date field.';

                }
                field("Additional-Currency Balance"; Rec."Additional-Currency Balance")
                {
                    BlankZero = true;
                    ApplicationArea = all;

                    Visible = false;
                    ToolTip = 'Specifies the value of the Additional-Currency Balance field.';
                }
                field(Comment; Rec.Comment)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Comment field.';

                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;

            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
                ApplicationArea = all;

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
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    ApplicationArea = all;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "Corporate G/L Account No." = FIELD("No."),
                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter");
                    // RunPageView = SORTING("Corporate G/L Account No.", "Global Dimension 1 Code");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Corporate G/L Account"),
                                  "No." = FIELD("No.");
                    ApplicationArea = all;
                    ToolTip = 'Executes the Co&mments action.';

                }
                action("<Action1000000004>")
                {
                    Caption = 'G/L Account Mapping';
                    Image = SplitChecks;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Local G/L Acc. Map. Overview";
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Account Mapping action.';

                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                action(GlobalView)
                {
                    Caption = 'Gl&obal View';
                    Image = GLBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Gl&obal View action.';


                    trigger OnAction()
                    var
                        lmdlGAAPMgtGlobalView: Codeunit "GAAP Mgt. - Global View";
                    begin
                        lmdlGAAPMgtGlobalView.gfcnShow();
                    end;
                }
            }
            action("G/L Register")
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "G/L Registers";
                ApplicationArea = all;
                ToolTip = 'Executes the G/L Register action.';

            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Indent Chart of Accounts")
                {
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartofAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Corporate G/L Account-Indent";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Indent Chart of Accounts action.';

                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Corporate Detail Trial Balance";
                ApplicationArea = all;
                ToolTip = 'Executes the Detail Trial Balance action.';

            }
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Corporate Trial Balance";
                ApplicationArea = all;
                ToolTip = 'Executes the Trial Balance action.';

            }
            action(Action1900210206)
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
                ApplicationArea = all;
                ToolTip = 'Executes the G/L Register action.';

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        NoOnFormat();
        NameOnFormat();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewGLAcc(xRec, BelowxRec);
    end;

    trigger OnOpenPage()
    var
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
    begin
        // MP 19-11-13 >>
        gblnBottomUp := lmdlCompanyTypeMgt.gfcnApplyFilterCorpGLAcc(Rec, 2);

        //FILTERGROUP(2);
        //SETRANGE("Global Dimension 1 Filter",'');
        //FILTERGROUP(0);
        // MP 19-11-13 <<
    end;

    var

        "No.Emphasize": Boolean;

        NameEmphasize: Boolean;

        NameIndent: Integer;

        gblnBottomUp: Boolean;

    local procedure NoOnFormat()
    begin
        "No.Emphasize" := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;
}