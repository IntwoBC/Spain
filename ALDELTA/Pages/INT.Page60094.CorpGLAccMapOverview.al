page 60094 "Corp. G/L Acc. Map. Overview"
{
    // MP 03-12-13
    // Object created (CR 30)
    // 
    // MP 15-04-14
    // Removed Action "Import Mapping"

    Caption = 'Local G/L Account Mapping Overview';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Account";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Corporate G/L Account No.");
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
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(Name; Rec.Name)
                {
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the general ledger account.';
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
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Class"; Rec."Account Class")
                {
                    Style = Standard;
                    StyleExpr = gblnBold;
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
            action(Open)
            {
                Caption = 'Open';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ApplicationArea = all;
                ToolTip = 'Executes the Open action.';

                trigger OnAction()
                var
                    lrecGLAcc: Record "G/L Account";
                    lrecCorpGLAcc: Record "Corporate G/L Account";
                begin
                    if Rec."New Page" then begin
                        lrecCorpGLAcc."No." := Rec."Search Name";
                        PAGE.Run(PAGE::"Corporate G/L Account Card", lrecCorpGLAcc);
                    end else begin
                        lrecGLAcc."No." := Rec."Search Name";
                        PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
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
    var
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
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
        lrecCorpGLAcc.SetRange("Account Type", lrecCorpGLAcc."Account Type"::Posting);
        lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");

        if lrecCorpGLAcc.FindSet() then begin
            lcodNextNo := '10000';
            repeat
                Rec.Init();
                Rec."No." := lcodNextNo;
                Rec."Search Name" := lrecCorpGLAcc."No.";
                Rec.Name := lrecCorpGLAcc.Name;
                Rec."Name (English)" := lrecCorpGLAcc."Name (English)";
                Rec."Account Type" := lrecCorpGLAcc."Account Type";
                Rec."Income/Balance" := lrecCorpGLAcc."Income/Balance";
                Rec."New Page" := true;
                Rec."Corporate G/L Account No." := lcodNextNo;
                lcodNextNo := IncStr(lcodNextNo);
                Rec.Insert();

                lrecGLAcc.SetRange("Corporate G/L Account No.", lrecCorpGLAcc."No.");
                if lrecGLAcc.FindSet() then
                    repeat
                        Rec := lrecGLAcc;
                        Rec."No." := lcodNextNo;
                        Rec."Search Name" := lrecGLAcc."No.";
                        Rec."New Page" := false;
                        Rec."Corporate G/L Account No." := lcodNextNo;
                        lcodNextNo := IncStr(lcodNextNo);
                        Rec.Insert();
                    until lrecGLAcc.Next() = 0;
            until lrecCorpGLAcc.Next() = 0;

            Rec.FindFirst();
        end;
    end;
}

