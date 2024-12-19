page 60030 "Un-posted Balance"
{
    Caption = 'Un-posted Balance';
    DataCaptionExpression = Heading;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "G/L Account Prepost Balance";
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
                field(View; goptView)
                {
                    Caption = 'View';
                    OptionCaption = 'Local Chart of Accounts,Corporate Chart of Accounts';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the View field.';


                    trigger OnValidate()
                    begin
                        lfcnUpdate();
                    end;
                }
                field("Exclude Zero Net Change"; gblnExcludeZeroNetChange)
                {
                    Caption = 'Exclude Zero Net Change';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Exclude Zero Net Change field.';


                    trigger OnValidate()
                    begin
                        if gblnExcludeZeroNetChange then
                            Rec.SetFilter("Net Change in Jnl.", '<>0')
                        else
                            Rec.SetRange("Net Change in Jnl.");

                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control6)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Caption = 'Account';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account field.';

                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("G/L Account No. (Local)"; Rec."G/L Account No. (Local)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Account No. (Local) field.';

                }
                field("Start Balance"; Rec."Start Balance")
                {
                    CaptionClass = gtxtFieldCaption[1];
                    ToolTip = 'Specifies the value of the Start Balance field.';
                }
                field("Net Change in Jnl."; Rec."Net Change in Jnl.")
                {
                    CaptionClass = gtxtFieldCaption[3];
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Change in Jnl. field.';

                }
                field("Posted Adjustments"; Rec."Posted Adjustments")
                {
                    CaptionClass = gtxtFieldCaption[2];
                    Visible = gblnGAAPJnl;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted Adjustments field.';

                }
                field("Balance after Posting"; Rec."Balance after Posting")
                {
                    CaptionClass = gtxtFieldCaption[4];
                    Caption = 'Balance after Posting';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Balance after Posting field.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Enabled = gblnUseReadyToPost;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Approve action.';


                trigger OnAction()
                begin
                    lfcnUpdateReadyToPost(true);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                Enabled = gblnUseReadyToPost;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Reject action.';


                trigger OnAction()
                begin
                    lfcnUpdateReadyToPost(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        lfcnUpdate();
        if gblnExcludeZeroNetChange then
            Rec.SetFilter("Net Change in Jnl.", '<>0');
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        GLAcc: Record "G/L Account";
        BankAccPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        grecCorpGLAcc: Record "Corporate G/L Account";
        grecGenJnlTemplate: Record "Gen. Journal Template";
        gtmpGLEntry: Record "G/L Entry" temporary;
        Heading: Code[10];
        gtxtFieldCaption: array[4] of Text[50];
        goptView: Option "Local Chart of Accounts","Corporate Chart of Accounts";

        gblnExcludeZeroNetChange: Boolean;
        txt60000: Label 'The field %1 will be set to %2 on all lines in the journal.\\Do you want to continue?';
        txt60001: Label 'Corporate GAAP';
        txt60002: Label 'GAAP to GAAP Adjustments (Posted)';
        txt60003: Label 'GAAP to GAAP Adjustments (Un-posted)';
        txt60004: Label 'Statutory GAAP';
        txt60005: Label 'GAAP to Tax Adjustments (Posted)';
        txt60006: Label 'GAAP to Tax Adjustments (Un-posted)';
        txt60007: Label 'Tax GAAP';

        gblnGAAPJnl: Boolean;

        gblnUseReadyToPost: Boolean;


    procedure SetGenJnlLine(var NewGenJnlLine: Record "Gen. Journal Line"; var ptmpGLEntry: Record "G/L Entry" temporary)
    begin
        GenJnlLine.Copy(NewGenJnlLine);
        Heading := GenJnlLine."Journal Batch Name";

        grecGenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        gblnUseReadyToPost := grecGenJnlTemplate."Use Ready to Post";

        case grecGenJnlTemplate.Type of
            grecGenJnlTemplate.Type::"Tax Adjustments":
                begin
                    gtxtFieldCaption[1] := txt60001;
                    gtxtFieldCaption[2] := txt60002;
                    gtxtFieldCaption[3] := txt60003;
                    gtxtFieldCaption[4] := txt60004;
                    gblnGAAPJnl := true;
                end;
            grecGenJnlTemplate.Type::"Group Adjustments":
                begin
                    gtxtFieldCaption[1] := txt60004;
                    gtxtFieldCaption[2] := txt60005;
                    gtxtFieldCaption[3] := txt60006;
                    gtxtFieldCaption[4] := txt60007;
                    gblnGAAPJnl := true;
                end;
            else begin
                gtxtFieldCaption[1] := Rec.FieldCaption("Start Balance");
                gtxtFieldCaption[2] := Rec.FieldCaption("Posted Adjustments");
                gtxtFieldCaption[3] := Rec.FieldCaption("Net Change in Jnl.");
                gtxtFieldCaption[4] := Rec.FieldCaption("Balance after Posting");
            end;
        end;

        // MP 22-06-16 >>
        if ptmpGLEntry.FindSet() then
            repeat
                gtmpGLEntry := ptmpGLEntry;
                gtmpGLEntry.Insert();
            until ptmpGLEntry.Next() = 0;

        // MP 22-06-16 <<
    end;

    local procedure SaveNetChange(AccType: Integer; AccNo: Code[20]; pcodCorpAccNo: Code[20]; NetChange: Decimal)
    begin
        if AccNo = '' then
            exit;
        case AccType of
            GenJnlLine."Account Type"::"G/L Account":
                if goptView = goptView::"Corporate Chart of Accounts" then begin
                    if not Rec.Get(pcodCorpAccNo) then
                        exit;
                end else
                    if not Rec.Get(AccNo) then
                        exit;
            GenJnlLine."Account Type"::"Bank Account":
                begin
                    if AccNo <> BankAcc."No." then begin
                        BankAcc.Get(AccNo);
                        BankAcc.TestField("Bank Acc. Posting Group");
                        BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                        // BankAccPostingGr.TestField("G/L Bank Account No.");
                    end;
                    // AccNo := BankAccPostingGr."G/L Bank Account No.";
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            else
                exit;
        end;

        Rec."Net Change in Jnl." := Rec."Net Change in Jnl." + NetChange;
        Rec."Balance after Posting" := Rec."Balance after Posting" + NetChange;
        Rec.Modify();
    end;


    procedure InsertGLAccNetChange()
    begin
        Rec.Init();

        if goptView = goptView::"Corporate Chart of Accounts" then begin
            case grecGenJnlTemplate.Type of
                grecGenJnlTemplate.Type::"Tax Adjustments":
                    grecCorpGLAcc.SetRange("Global Dimension 1 Filter", '');

                grecGenJnlTemplate.Type::"Group Adjustments":
                    grecCorpGLAcc.SetFilter("Global Dimension 1 Filter", '<>%1', grecGenJnlTemplate."Shortcut Dimension 1 Code");
            end;

            grecCorpGLAcc.CalcFields("Balance at Date");
            Rec."Start Balance" := grecCorpGLAcc."Balance at Date";

            if gblnGAAPJnl then begin
                grecCorpGLAcc.SetRange("Global Dimension 1 Filter", grecGenJnlTemplate."Shortcut Dimension 1 Code");
                grecCorpGLAcc.CalcFields("Balance at Date");
                Rec."Posted Adjustments" := grecCorpGLAcc."Balance at Date";
            end;

            Rec."No." := grecCorpGLAcc."No.";
            Rec.Name := grecCorpGLAcc.Name;
            Rec."G/L Account No. (Local)" := grecCorpGLAcc."Local G/L Account No.";
        end else begin
            case grecGenJnlTemplate.Type of
                grecGenJnlTemplate.Type::"Tax Adjustments":
                    GLAcc.SetRange("Global Dimension 1 Filter", '');

                grecGenJnlTemplate.Type::"Group Adjustments":
                    GLAcc.SetFilter("Global Dimension 1 Filter", '<>%1', grecGenJnlTemplate."Shortcut Dimension 1 Code");
            end;

            GLAcc.CalcFields("Balance at Date");
            Rec."Start Balance" := GLAcc."Balance at Date";

            if gblnGAAPJnl then begin
                GLAcc.SetRange("Global Dimension 1 Filter", grecGenJnlTemplate."Shortcut Dimension 1 Code");
                GLAcc.CalcFields("Balance at Date");
                Rec."Posted Adjustments" := GLAcc."Balance at Date";
            end;

            Rec."No." := GLAcc."No.";
            Rec.Name := GLAcc.Name;
            Rec."G/L Account No. (Local)" := GLAcc."No.";
        end;

        Rec."Balance after Posting" := Rec."Start Balance" + Rec."Posted Adjustments";

        if Rec.Insert() then;
    end;

    local procedure lfcnUpdate()
    begin
        Rec.DeleteAll();

        if goptView = goptView::"Corporate Chart of Accounts" then begin
            grecCorpGLAcc.SetRange("Account Type", GLAcc."Account Type"::Posting);
            if grecCorpGLAcc.FindSet() then
                repeat
                    InsertGLAccNetChange();
                until grecCorpGLAcc.Next() = 0;
        end else begin
            GLAcc.SetRange("Account Type", GLAcc."Account Type"::Posting);
            if GLAcc.FindSet() then
                repeat
                    InsertGLAccNetChange();
                until GLAcc.Next() = 0;
        end;

        // MP 22-06-16 >>
        //IF GenJnlLine.FINDSET THEN
        //  REPEAT
        //    SaveNetChange(
        //      GenJnlLine."Account Type",GenJnlLine."Account No.",GenJnlLine."Corporate G/L Account No.",
        //      ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
        //    SaveNetChange(
        //      GenJnlLine."Bal. Account Type",GenJnlLine."Bal. Account No.",GenJnlLine."Bal. Corporate G/L Account No.",
        //      -ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."Bal. VAT %" / 100)));
        //  UNTIL GenJnlLine.NEXT = 0;

        if gtmpGLEntry.FindSet() then
            repeat
                SaveNetChange(
                  GenJnlLine."Account Type"::"G/L Account", gtmpGLEntry."G/L Account No.", gtmpGLEntry."Corporate G/L Account No.",
                  gtmpGLEntry.Amount);
            until gtmpGLEntry.Next() = 0;
        // MP 22-06-16 <<
        if Rec.Find('-') then;
    end;

    local procedure lfcnUpdateReadyToPost(pblnReadyToPost: Boolean)
    begin
        if not Confirm(StrSubstNo(txt60000, GenJnlLine.FieldCaption("Ready to Post"), pblnReadyToPost)) then
            exit;

        GenJnlLine.ModifyAll("Ready to Post", pblnReadyToPost);
        CurrPage.Close();
    end;
}

