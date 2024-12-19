page 60026 "Local G/L Acc. Map. Overview"
{
    // MP 04-12-13
    // Fixed issue for cases where same No. is used for both G/L Account and Corporate G/L Account (Case 13849)

    Caption = 'Local G/L Account Mapping Overview';
    Editable = false;
    PageType = List;
    SourceTable = "Corporate G/L Account";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Local G/L Account No.");
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = gintNameIndent;
                IndentationControls = "Search Name";
                ShowAsTree = true;
                field("Search Name"; Rec."Search Name")
                {
                    Caption = 'No.';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(Name; Rec.Name)
                {
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("Name (English)"; Rec."Name (English)")
                {
                    Style = Standard;
                    ApplicationArea = all;

                    StyleExpr = gblnBold;
                    ToolTip = 'Specifies the value of the Name (English) field.';
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

                }
                field("Account Class"; Rec."Account Class")
                {
                    Style = Standard;
                    ApplicationArea = all;

                    StyleExpr = gblnBold;
                    ToolTip = 'Specifies the value of the Account Class field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Open)
            {
                Caption = 'Open';
                ShortCutKey = 'Return';
                ApplicationArea = all;
                ToolTip = 'Executes the Open action.';


                trigger OnAction()
                var
                    lrecGLAcc: Record "G/L Account";
                    lrecCorpGLAcc: Record "Corporate G/L Account";
                begin
                    if Rec."New Page" then begin
                        //lrecGLAcc."No." := "No.";
                        lrecGLAcc."No." := Rec."Search Name"; // MP 04-12-13 Replaces above
                        PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
                    end else begin
                        //lrecCorpGLAcc."No." := "No.";
                        lrecCorpGLAcc."No." := Rec."Search Name"; // MP 04-12-13 Replaces above
                        PAGE.Run(PAGE::"Corporate G/L Account Card", lrecCorpGLAcc);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        gblnBold := Rec."New Page";
        if Rec."New Page" then
            gintNameIndent := 0
        else
            gintNameIndent := 1;
    end;

    trigger OnOpenPage()
    begin
        lfcnCopyGLAccToTemp();
    end;

    var

        gblnBold: Boolean;

        gintNameIndent: Integer;

    local procedure lfcnCopyGLAccToTemp()
    var
        lrecGLAcc: Record "G/L Account";
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lcodNextNo: Code[20];
    begin
        lrecGLAcc.SetRange("Account Type", lrecGLAcc."Account Type"::Posting);
        lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");

        if lrecGLAcc.FindSet() then begin
            lcodNextNo := '10000';
            repeat
                Rec.Init();
                // MP 04-12-13 >>
                //"No." := lrecGLAcc."No.";
                Rec."No." := lcodNextNo;
                Rec."Search Name" := lrecGLAcc."No.";
                // MP 04-12-13 <<
                Rec.Name := lrecGLAcc.Name;
                Rec."Name (English)" := lrecGLAcc."Name (English)";
                Rec."Account Type" := lrecGLAcc."Account Type";
                Rec."Income/Balance" := lrecGLAcc."Income/Balance";
                Rec."New Page" := true;
                Rec."Local G/L Account No." := lcodNextNo;
                lcodNextNo := IncStr(lcodNextNo);
                Rec.Insert();

                lrecCorpGLAcc.SetRange("Local G/L Account No.", lrecGLAcc."No.");
                if lrecCorpGLAcc.FindSet() then
                    repeat
                        Rec := lrecCorpGLAcc;
                        // MP 04-12-13 >>
                        Rec."No." := lcodNextNo;
                        Rec."Search Name" := lrecCorpGLAcc."No.";
                        // MP 04-12-13 <<
                        Rec."New Page" := false;
                        Rec."Local G/L Account No." := lcodNextNo;
                        lcodNextNo := IncStr(lcodNextNo);
                        Rec.Insert();
                    until lrecCorpGLAcc.Next() = 0;
            until lrecGLAcc.Next() = 0;

            Rec.FindFirst();
        end;
    end;
}

