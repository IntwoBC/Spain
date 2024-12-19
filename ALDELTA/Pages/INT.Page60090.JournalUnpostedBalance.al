page 60090 "Journal Un-posted Balance"
{
    // MP 01-05-14
    // Development taken from Core II.
    // Removed field "Exclude Zero Net Change" as this has no effect
    // Added functionality to include VAT

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
                    Editable = gblnCorpAccInUse;
                    OptionCaption = 'Local Chart of Accounts,Corporate Chart of Accounts';
                    ToolTip = 'Specifies the value of the View field.';

                    trigger OnValidate()
                    begin
                        lfcnUpdate();
                    end;
                }
                field("Exclude Zero Net Change"; gblnExcludeZeroNetChange)
                {
                    Caption = 'Exclude Zero Net Change';
                    Visible = false;
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
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("G/L Account No. (Local)"; Rec."G/L Account No. (Local)")
                {
                    CaptionClass = gtxtFieldCaption[5];
                    Visible = gblnCorpAccInUse;
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
                    ToolTip = 'Specifies the value of the Net Change in Jnl. field.';
                }
                field("Balance after Posting"; Rec."Balance after Posting")
                {
                    CaptionClass = gtxtFieldCaption[4];
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
                ToolTip = 'Executes the Reject action.';

                trigger OnAction()
                begin
                    lfcnUpdateReadyToPost(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
    begin
        // MP 01-05-14 >>
        gblnCorpAccInUse := lmdlCompanyTypeMgt.gfcnCorpAccInUse();
        gblnIsBottomUp := lmdlCompanyTypeMgt.gfcnIsBottomUp();
        if not gblnCorpAccInUse then
            goptView := goptView::"Local Chart of Accounts";
        gtxtVATCalcMessage := '';
        grecLCYCurrency.InitRoundingPrecision();
        // MP 01-05-14 <<
        lfcnUpdate();
        // MP 01-05-14 >>
        if gtxtVATCalcMessage <> '' then
            Message(gtxtVATCalcMessage);
        // MP 01-05-14 <<
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
        grecVATPostingSetup: Record "VAT Posting Setup";
        grecLCYCurrency: Record Currency;
        Heading: Code[10];
        gtxtFieldCaption: array[5] of Text[50];
        gtxtVATCalcMessage: Text[1024];
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

        gblnCorpAccInUse: Boolean;
        txt60008: Label 'One or more lines have %1 specified as %2, indirect postings for these entries have not been included';
        gblnIsBottomUp: Boolean;
        txt60009: Label '%1 has been specified in %2 related to one or more lines, any indirect postings for these entries have not been included';


    procedure SetGenJnlLine(var NewGenJnlLine: Record "Gen. Journal Line")
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlLine.Copy(NewGenJnlLine);
        Heading := GenJnlLine."Journal Batch Name";

        //TEC 24-10-12 -mdan- >>
        GenJnlLine.SetRange("Journal Template Name", NewGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", NewGenJnlLine."Journal Batch Name");
        //TEC 24-10-12 -mdan- <<

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
                // MP 01-05-14 >>
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
                lrecGenJnlTemplate.FindFirst();
                GLAcc.SetFilter("Global Dimension 1 Filter", '%1|%2', '', lrecGenJnlTemplate."Shortcut Dimension 1 Code");
                // MP 01-05-14 <<
            end;
        end;
    end;

    local procedure SaveNetChange(AccType: Integer; AccNo: Code[20]; pcodCorpAccNo: Code[20]; NetChange: Decimal)
    var
        lrecCustomerPostingGroup: Record "Customer Posting Group";
        lrecCustomer: Record Customer;
        lrecVendorPostingGroup: Record "Vendor Posting Group";
        lrecVendor: Record Vendor;
        lrecFixedAsset: Record "Fixed Asset";
        lrecFAPostingGroup: Record "FA Posting Group";
        lrecICPartner: Record "IC Partner";
    begin
        if AccNo = '' then
            exit;
        case AccType of
            GenJnlLine."Account Type"::"G/L Account":
                if goptView = goptView::"Corporate Chart of Accounts" then begin
                    if not Rec.Get(pcodCorpAccNo) then begin
                        grecCorpGLAcc.Get(pcodCorpAccNo);
                        InsertGLAccNetChange();
                    end;
                end else begin
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            GenJnlLine."Account Type"::"Bank Account":
                begin
                    if AccNo <> BankAcc."No." then begin
                        BankAcc.Get(AccNo);
                        BankAcc.TestField("Bank Acc. Posting Group");
                        BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                        //BankAccPostingGr.TestField("G/L Bank Account No.");
                    end;
                    //AccNo := BankAccPostingGr."G/L Bank Account No.";
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            GenJnlLine."Account Type"::Customer:
                begin
                    lrecCustomer.Get(AccNo);
                    lrecCustomerPostingGroup.Get(lrecCustomer."Customer Posting Group");
                    lrecCustomerPostingGroup.TestField("Receivables Account");
                    AccNo := lrecCustomerPostingGroup."Receivables Account";
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            GenJnlLine."Account Type"::Vendor:
                begin
                    lrecVendor.Get(AccNo);
                    lrecVendorPostingGroup.Get(lrecVendor."Vendor Posting Group");
                    lrecVendorPostingGroup.TestField("Payables Account");
                    AccNo := lrecVendorPostingGroup."Payables Account";
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            GenJnlLine."Account Type"::"Fixed Asset":
                begin
                    lrecFixedAsset.Get(AccNo);
                    lrecFAPostingGroup.Get(lrecFixedAsset."FA Posting Group");
                    lrecFAPostingGroup.TestField("Acquisition Cost Account");
                    AccNo := lrecFAPostingGroup."Acquisition Cost Account";
                    if not Rec.Get(AccNo) then begin
                        GLAcc.Get(AccNo);
                        InsertGLAccNetChange();
                    end;
                end;
            GenJnlLine."Account Type"::"IC Partner":
                begin
                    lrecICPartner.Get(AccNo);
                    case GenJnlLine."IC Direction" of
                        GenJnlLine."IC Direction"::Outgoing:
                            begin
                                lrecICPartner.TestField("Receivables Account");
                                AccNo := lrecICPartner."Receivables Account";
                            end;
                        GenJnlLine."IC Direction"::Incoming:
                            begin
                                lrecICPartner.TestField("Payables Account");
                                AccNo := lrecICPartner."Payables Account";
                            end;
                    end;
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

            GLAcc.CalcFields("Balance at Date");
            Rec."Start Balance" := GLAcc."Balance at Date";

            if gblnGAAPJnl then begin
                GLAcc.SetRange("Global Dimension 1 Filter", grecGenJnlTemplate."Shortcut Dimension 1 Code");
                GLAcc.CalcFields("Balance at Date");
                Rec."Posted Adjustments" := GLAcc."Balance at Date";
            end;

            Rec."No." := GLAcc."No.";
            Rec.Name := GLAcc.Name;
            //"G/L Account No. (Local)" := GLAcc."No.";
            Rec."G/L Account No. (Local)" := GLAcc."Corporate G/L Account No."; // MP 01-05-14 Replaces above line
        end;

        Rec."Balance after Posting" := Rec."Start Balance" + Rec."Posted Adjustments";

        if Rec.Insert() then;
    end;

    local procedure lfcnUpdate()
    begin
        Rec.DeleteAll();

        //IF goptView = goptView::"Corporate Chart of Accounts" THEN BEGIN
        //  grecCorpGLAcc.SETRANGE("Account Type",GLAcc."Account Type"::Posting);
        //  IF grecCorpGLAcc.FINDSET THEN
        //    REPEAT
        //      InsertGLAccNetChange;
        //    UNTIL grecCorpGLAcc.NEXT = 0;
        //END ELSE BEGIN
        //  GLAcc.SETRANGE("Account Type",GLAcc."Account Type"::Posting);
        //  IF GLAcc.FINDSET THEN
        //    REPEAT
        //      InsertGLAccNetChange;
        //    UNTIL GLAcc.NEXT = 0;
        //END;

        if GenJnlLine.FindSet() then
            repeat
                SaveNetChange(
                  GenJnlLine."Account Type", GenJnlLine."Account No.", GenJnlLine."Corporate G/L Account No.",
                  //      ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
                  GenJnlLine."VAT Base Amount (LCY)"); // MP 01-05-14 Replaces line above
                SaveNetChange(
                  GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.", GenJnlLine."Bal. Corporate G/L Account No.",
                  //      -ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."Bal. VAT %" / 100)));
                  GenJnlLine."Bal. VAT Base Amount (LCY)"); // MP 01-05-14 Replaces line above

                // MP 07-05-14 Include VAT >>
                lfcnSaveNetChangeVAT(GenJnlLine."Gen. Posting Type",
                  GenJnlLine."VAT Calculation Type", GenJnlLine."VAT Bus. Posting Group",
                  GenJnlLine."VAT Prod. Posting Group", GenJnlLine."VAT Amount (LCY)", GenJnlLine."VAT Base Amount (LCY)");

                lfcnSaveNetChangeVAT(GenJnlLine."Bal. Gen. Posting Type",
                  GenJnlLine."Bal. VAT Calculation Type", GenJnlLine."Bal. VAT Bus. Posting Group",
                  GenJnlLine."Bal. VAT Prod. Posting Group", GenJnlLine."Bal. VAT Amount (LCY)", GenJnlLine."Bal. VAT Base Amount (LCY)");
            // MP 07-05-14 <<
            until GenJnlLine.Next() = 0;
        if Rec.Find('-') then;

        // MP 01-05-14 >>
        if goptView = goptView::"Corporate Chart of Accounts" then
            gtxtFieldCaption[5] := grecCorpGLAcc.FieldCaption("Local G/L Account No.")
        else
            gtxtFieldCaption[5] := GLAcc.FieldCaption("Corporate G/L Account No.");
        // MP 01-05-14 <<
    end;

    local procedure lfcnUpdateReadyToPost(pblnReadyToPost: Boolean)
    begin
        if not Confirm(StrSubstNo(txt60000, GenJnlLine.FieldCaption("Ready to Post"), pblnReadyToPost)) then
            exit;

        GenJnlLine.ModifyAll("Ready to Post", pblnReadyToPost);
        CurrPage.Close();
    end;

    local procedure lfcnSaveNetChangeVAT(poptGenPostingType: Option " ",Purchase,Sale,Settlement; poptVATCalculationType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax"; pcodVATBusPostingGroup: Code[10]; pcodVATProdPostingGroup: Code[10]; pdecVATAmountLCY: Decimal; pdecVATBaseAmountLCY: Decimal)
    var
        lcodAccNo: Code[20];
        lcodCorpAccNo: Code[20];
        ldecVATAmount: Decimal;
    begin
        // MP 01-05-14

        if poptGenPostingType = poptGenPostingType::" " then
            exit;

        if poptGenPostingType = poptGenPostingType::Settlement then begin
            gtxtVATCalcMessage :=
              StrSubstNo(txt60008, GenJnlLine.FieldCaption("Gen. Posting Type"), Format(GenJnlLine."Gen. Posting Type"::Settlement));
            exit;
        end;

        if poptVATCalculationType = poptVATCalculationType::"Sales Tax" then begin
            gtxtVATCalcMessage :=
              StrSubstNo(txt60008, GenJnlLine.FieldCaption("VAT Calculation Type"), Format(GenJnlLine."VAT Calculation Type"::"Sales Tax"));
            exit;
        end;

        if (grecVATPostingSetup."VAT Bus. Posting Group" <> pcodVATBusPostingGroup) or
          (grecVATPostingSetup."VAT Prod. Posting Group" <> pcodVATProdPostingGroup)
        then
            grecVATPostingSetup.Get(pcodVATBusPostingGroup, pcodVATProdPostingGroup);

        if grecVATPostingSetup."Unrealized VAT Type" > grecVATPostingSetup."Unrealized VAT Type"::" " then begin
            gtxtVATCalcMessage :=
              StrSubstNo(txt60009, grecVATPostingSetup.FieldCaption("Unrealized VAT Type"), grecVATPostingSetup.TableCaption);
            exit;
        end;

        if poptVATCalculationType = poptVATCalculationType::"Reverse Charge VAT" then begin
            if poptGenPostingType = poptGenPostingType::Purchase then begin
                grecVATPostingSetup.TestField("Purchase VAT Account");
                grecVATPostingSetup.TestField("Reverse Chrg. VAT Acc.");

                if pdecVATAmountLCY <> 0 then
                    ldecVATAmount := pdecVATAmountLCY
                else
                    ldecVATAmount :=
                      Round(
                        pdecVATBaseAmountLCY * grecVATPostingSetup."VAT+EC %" / 100,
                        grecLCYCurrency."Amount Rounding Precision", grecLCYCurrency.VATRoundingDirection());

                lcodAccNo := grecVATPostingSetup."Purchase VAT Account";
                lcodCorpAccNo := lfcnGetCorpAcc(lcodAccNo);
                SaveNetChange(0, lcodAccNo, lcodCorpAccNo, ldecVATAmount);

                lcodAccNo := grecVATPostingSetup."Reverse Chrg. VAT Acc.";
                lcodCorpAccNo := lfcnGetCorpAcc(lcodAccNo);
                SaveNetChange(0, lcodAccNo, lcodCorpAccNo, -ldecVATAmount)
            end;
        end else begin
            if poptGenPostingType = poptGenPostingType::Sale then begin
                grecVATPostingSetup.TestField("Sales VAT Account");
                lcodAccNo := grecVATPostingSetup."Sales VAT Account"
            end else begin // Purchase
                grecVATPostingSetup.TestField("Purchase VAT Account");
                lcodAccNo := grecVATPostingSetup."Purchase VAT Account";
            end;

            lcodCorpAccNo := lfcnGetCorpAcc(lcodAccNo);
            SaveNetChange(0, lcodAccNo, lcodCorpAccNo, pdecVATAmountLCY)
        end;
    end;

    local procedure lfcnGetCorpAcc(pcodAccNo: Code[20]) rcodCorpAccNo: Code[20]
    var
        lrecGLAcc: Record "G/L Account";
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        // MP 01-05-14

        if gblnIsBottomUp then begin
            lrecGLAcc.Get(pcodAccNo);
            rcodCorpAccNo := lrecGLAcc."Corporate G/L Account No.";
        end else begin
            lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
            lrecCorpGLAcc.SetRange("Local G/L Account No.", pcodAccNo);
            lrecCorpGLAcc.FindFirst();
            rcodCorpAccNo := lrecCorpGLAcc."No.";
        end;
    end;
}

