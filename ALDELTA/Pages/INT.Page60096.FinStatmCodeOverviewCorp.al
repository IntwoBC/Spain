page 60096 "Fin. Statm. Code Overview Corp"
{
    Caption = 'Financial Statement Code Overview (Corporate)';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Account";
    SourceTableTemporary = true;
    SourceTableView = SORTING("No.");
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec."No. of Blank Lines";
                IndentationControls = "Corporate G/L Account No.";
                ShowAsTree = true;
                field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
                {
                    Caption = 'No.';
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
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
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name (English) field.';
                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    Caption = 'Financial Statement Code Mismatch';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = gblnShowFinStatCodeMismatch;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code Mismatch field.';
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    HideValue = gblnBold;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Class"; Rec."Account Class")
                {
                    HideValue = gblnBold;
                    ApplicationArea = all;
                    Style = Standard;
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
                    case Rec."No. of Blank Lines" of
                        1:
                            begin
                                lrecCorpGLAcc."No." := Rec."Corporate G/L Account No.";
                                PAGE.Run(PAGE::"Corporate G/L Account Card", lrecCorpGLAcc);
                            end;
                        2:
                            begin
                                lrecGLAcc."No." := Rec."Corporate G/L Account No.";
                                PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        gblnBold := Rec."New Page";
    end;

    trigger OnOpenPage()
    begin
        lfcnCopyGLAccToTemp();
    end;

    var

        gblnBold: Boolean;

        gblnShowFinStatCodeMismatch: Boolean;

    local procedure lfcnCopyGLAccToTemp()
    var
        lrecFinancialStatementCode: Record "Financial Statement Code";
        lrecGLAcc: Record "G/L Account";
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lcodNextNo: Code[20];
    begin
        lrecCorpGLAcc.SetRange("Account Type", lrecCorpGLAcc."Account Type"::Posting);
        lrecCorpGLAcc.SetCurrentKey("Financial Statement Code");
        lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");

        if lrecFinancialStatementCode.FindSet() then begin
            lcodNextNo := '10000';
            repeat
                Rec.Init();
                Rec."No." := lcodNextNo;
                lcodNextNo := IncStr(lcodNextNo);

                Rec."Corporate G/L Account No." := lrecFinancialStatementCode.Code;
                Rec.Name := CopyStr(lrecFinancialStatementCode.Description, 1, MaxStrLen(Rec.Name));
                Rec."Name (English)" := CopyStr(lrecFinancialStatementCode."Description (English)", 1, MaxStrLen(Rec."Name (English)"));
                Rec."New Page" := true;
                Rec."No. of Blank Lines" := 0;
                Rec.Insert();

                lrecCorpGLAcc.SetRange("Financial Statement Code", lrecFinancialStatementCode.Code);
                if lrecCorpGLAcc.FindSet() then
                    repeat
                        Rec.Init();
                        Rec."No." := lcodNextNo;
                        lcodNextNo := IncStr(lcodNextNo);

                        Rec."Corporate G/L Account No." := lrecCorpGLAcc."No.";
                        Rec.Name := CopyStr(lrecCorpGLAcc.Name, 1, MaxStrLen(Rec.Name));
                        Rec."Name (English)" := lrecCorpGLAcc."Name (English)";
                        Rec."Account Type" := lrecCorpGLAcc."Account Type";
                        Rec."Income/Balance" := lrecCorpGLAcc."Income/Balance";
                        Rec."Account Class" := lrecCorpGLAcc."Account Class";
                        Rec."No. of Blank Lines" := 1;
                        Rec.Insert();

                        lrecGLAcc.SetRange("Corporate G/L Account No.", lrecCorpGLAcc."No.");
                        if lrecGLAcc.FindSet() then
                            repeat
                                Rec := lrecGLAcc;
                                Rec."No." := lcodNextNo;
                                lcodNextNo := IncStr(lcodNextNo);

                                Rec."Corporate G/L Account No." := lrecGLAcc."No.";
                                Rec."No. of Blank Lines" := 2;

                                if lrecGLAcc."Financial Statement Code" <> lrecCorpGLAcc."Financial Statement Code" then begin
                                    Rec."Financial Statement Code" := lrecGLAcc."Financial Statement Code";
                                    gblnShowFinStatCodeMismatch := true;
                                end else
                                    Rec."Financial Statement Code" := '';

                                Rec.Insert();
                            until lrecGLAcc.Next() = 0;
                    until lrecCorpGLAcc.Next() = 0;
            until lrecFinancialStatementCode.Next() = 0;
            Rec.FindFirst();
        end;
    end;
}

