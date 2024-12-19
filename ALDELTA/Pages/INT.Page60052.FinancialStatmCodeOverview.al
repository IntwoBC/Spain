page 60052 "Financial Statm. Code Overview"
{
    // MP 14-04-14
    // Amended code to handle extended field lengths of FS Descriptions

    Caption = 'Financial Statement Code Overview';
    Editable = false;
    PageType = List;
    SourceTable = "Corporate G/L Account";
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
                IndentationControls = "Local G/L Account No.";
                ShowAsTree = true;
                field("Local G/L Account No."; Rec."Local G/L Account No.")
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
                    ToolTip = 'Specifies the value of the Name field.';

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
                    ApplicationArea = all;

                    StyleExpr = true;
                    Visible = gblnShowFinStatCodeMismatch;
                    ToolTip = 'Specifies the value of the Financial Statement Code Mismatch field.';
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    HideValue = gblnBold;
                    Style = Standard;
                    StyleExpr = gblnBold;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

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
                                lrecGLAcc."No." := Rec."Local G/L Account No.";
                                PAGE.Run(PAGE::"G/L Account Card", lrecGLAcc);
                            end;
                        2:
                            begin
                                lrecCorpGLAcc."No." := Rec."Local G/L Account No.";
                                PAGE.Run(PAGE::"Corporate G/L Account Card", lrecCorpGLAcc);
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
        lrecGLAcc.SetRange("Account Type", lrecGLAcc."Account Type"::Posting);
        lrecGLAcc.SetCurrentKey("Financial Statement Code");
        lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");

        if lrecFinancialStatementCode.FindSet() then begin
            lcodNextNo := '10000';
            repeat
                Rec.Init();
                Rec."No." := lcodNextNo;
                lcodNextNo := IncStr(lcodNextNo);

                Rec."Local G/L Account No." := lrecFinancialStatementCode.Code;
                // MP 14-04-14 >>
                //Name := lrecFinancialStatementCode.Description;
                //"Name (English)" := lrecFinancialStatementCode."Description (English)";
                Rec.Name := CopyStr(lrecFinancialStatementCode.Description, 1, MaxStrLen(Rec.Name));
                Rec."Name (English)" := CopyStr(lrecFinancialStatementCode."Description (English)", 1, MaxStrLen(Rec."Name (English)"));
                // MP 14-04-14 <<
                Rec."New Page" := true;
                Rec."No. of Blank Lines" := 0;
                Rec.Insert();

                lrecGLAcc.SetRange("Financial Statement Code", lrecFinancialStatementCode.Code);
                if lrecGLAcc.FindSet() then
                    repeat
                        Rec.Init();
                        Rec."No." := lcodNextNo;
                        lcodNextNo := IncStr(lcodNextNo);

                        Rec."Local G/L Account No." := lrecGLAcc."No.";
                        Rec.Name := lrecGLAcc.Name;
                        Rec."Name (English)" := lrecGLAcc."Name (English)";
                        Rec."Account Type" := lrecGLAcc."Account Type";
                        Rec."Income/Balance" := lrecGLAcc."Income/Balance";
                        Rec."Account Class" := lrecGLAcc."Account Class";
                        Rec."No. of Blank Lines" := 1;
                        Rec.Insert();

                        lrecCorpGLAcc.SetRange("Local G/L Account No.", lrecGLAcc."No.");
                        if lrecCorpGLAcc.FindSet() then
                            repeat
                                Rec := lrecCorpGLAcc;
                                Rec."No." := lcodNextNo;
                                lcodNextNo := IncStr(lcodNextNo);

                                Rec."Local G/L Account No." := lrecCorpGLAcc."No.";
                                Rec."No. of Blank Lines" := 2;

                                if lrecCorpGLAcc."Financial Statement Code" <> lrecGLAcc."Financial Statement Code" then begin
                                    Rec."Financial Statement Code" := lrecCorpGLAcc."Financial Statement Code";
                                    gblnShowFinStatCodeMismatch := true;
                                end else
                                    Rec."Financial Statement Code" := '';

                                Rec.Insert();
                            until lrecCorpGLAcc.Next() = 0;
                    until lrecGLAcc.Next() = 0;
            until lrecFinancialStatementCode.Next() = 0;
            Rec.FindFirst();
        end;
    end;
}

