page 60025 "Corporate G/L Account List"
{
    // MP 19-11-13
    // Added support for bottom-up companies, controling visibility of field "Local G/L Account No." (CR 30)
    // 
    // MP 19-02-14
    // Added field "Financial Statement Code" (CR 30)
    // 
    // MP 06-05-14
    // Added field "Name (English)"

    Caption = 'Corporate G/L Account List';
    CardPageID = "Corporate G/L Account Card";
    DataCaptionFields = "Search Name";
    Editable = false;
    PageType = List;
    SourceTable = "Corporate G/L Account";
    ApplicationArea = All;
    UsageCategory=lists;

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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

                }
                field("Account Type"; Rec."Account Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';

                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code field.';

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
                Visible = false;
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
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "Corporate G/L Account No." = FIELD("No.");
                    RunPageView = SORTING("Corporate G/L Account No.", "Global Dimension 1 Code")
                                  WHERE("Global Dimension 1 Code" = CONST(''));
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Ledger E&ntries action.';

                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Historic G/L Account"),
                                  "No." = FIELD("No.");
                    ApplicationArea = all;
                    ToolTip = 'Executes the Co&mments action.';

                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(15),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';

                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                action("G/L &Account Balance")
                {
                    Caption = 'G/L &Account Balance';
                    Image = GLAccountBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Business Unit Filter" = FIELD("Business Unit Filter");
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L &Account Balance action.';

                }
                action("G/L &Balance")
                {
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Balance";
                    RunPageOnRec = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L &Balance action.';

                }
                action("G/L Balance by &Dimension")
                {
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Balance by Dimension";
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Balance by &Dimension action.';

                }
            }
        }
        area(reporting)
        {
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Corporate Trial Balance";
                ApplicationArea = all;
                ToolTip = 'Executes the Trial Balance action.';

            }
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Corporate Detail Trial Balance";
                ApplicationArea = all;
                ToolTip = 'Executes the Detail Trial Balance action.';

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        NoOnFormat();
        NameOnFormat();
    end;

    trigger OnOpenPage()
    var
        lrecEYCoreSetup: Record "EY Core Setup";
    begin
        // MP 19-11-13 >>
        lrecEYCoreSetup.Get();
        gblnBottomUp := lrecEYCoreSetup."Company Type" = lrecEYCoreSetup."Company Type"::"Bottom-up";
        // MP 19-11-13 <<
    end;

    var

        "No.Emphasize": Boolean;

        NameEmphasize: Boolean;

        NameIndent: Integer;

        gblnBottomUp: Boolean;


    procedure SetSelection(var precCorpGLAcc: Record "Corporate G/L Account")
    begin
        CurrPage.SetSelectionFilter(precCorpGLAcc);
    end;


    procedure GetSelectionFilter(): Code[80]
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        FirstAcc: Text[20];
        LastAcc: Text[20];
        SelectionFilter: Code[80];
        GLAccCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(lrecCorpGLAcc);
        lrecCorpGLAcc.SetCurrentKey("No.");
        GLAccCount := lrecCorpGLAcc.Count;
        if GLAccCount > 0 then begin
            lrecCorpGLAcc.FindSet();
            while GLAccCount > 0 do begin
                GLAccCount := GLAccCount - 1;
                lrecCorpGLAcc.MarkedOnly(false);
                FirstAcc := lrecCorpGLAcc."No.";
                LastAcc := FirstAcc;
                More := (GLAccCount > 0);
                while More do
                    if lrecCorpGLAcc.Next() = 0 then
                        More := false
                    else
                        if not lrecCorpGLAcc.Mark() then
                            More := false
                        else begin
                            LastAcc := lrecCorpGLAcc."No.";
                            GLAccCount := GLAccCount - 1;
                            if GLAccCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstAcc = LastAcc then
                    SelectionFilter := SelectionFilter + FirstAcc
                else
                    SelectionFilter := SelectionFilter + FirstAcc + '..' + LastAcc;
                if GLAccCount > 0 then begin
                    lrecCorpGLAcc.MarkedOnly(true);
                    lrecCorpGLAcc.Next();
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

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

