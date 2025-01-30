codeunit 61002 "T:Gen. Journal Line"
{

    trigger OnRun()
    begin
    end;

    var
        grecLastGenJnlLine: Record "Gen. Journal Line";

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterModifyEvent', '', false, false)]
    local procedure levtOnAfterModify(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    var
        lrecGenJnlLine: Record "Gen. Journal Line";
    begin
        if Rec."Shortcut Dimension 1 Code" = '' then
            lfcnPopulateShortcutDim1(Rec);

        if (Rec."Ready to Post" <> xRec."Ready to Post") and (Rec."Document No." <> '') then begin
            lrecGenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            lrecGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            lrecGenJnlLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
            lrecGenJnlLine.SetRange("Document No.", Rec."Document No.");
            if not lrecGenJnlLine.IsEmpty then
                lrecGenJnlLine.ModifyAll("Ready to Post", Rec."Ready to Post");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Account No.', false, false)]
    local procedure levtOnAfterValidateAccountNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecGenJnlBatch: Record "Gen. Journal Batch";
        lrecGLAcc: Record "G/L Account";
        lblnReplaceInfo: Boolean;
    begin
        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
            lblnReplaceInfo := Rec."Bal. Account No." = '';
            if not lblnReplaceInfo then begin
                lrecGenJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                lblnReplaceInfo := lrecGenJnlBatch."Bal. Account No." <> '';
            end;
            if lblnReplaceInfo and (Rec."Account No." <> '') then begin
                lrecGLAcc.Get(Rec."Account No.");
                Rec."Description (English)" := lrecGLAcc."Name (English)";
            end;

            if CurrFieldNo = Rec.FieldNo("Account No.") then
                Rec."Corporate G/L Account No." := lfcnGetCorpAccNo(Rec."Account No.");

            Rec.Validate("GAAP Adjustment Reason");
        end;
        lfcnPopulateShortcutDim1(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Amount', false, false)]
    local procedure levtOnAfterValidateAmount(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecGenJnlBatch: Record "Gen. Journal Batch";
        lrecGLAcc: Record "G/L Account";
        lblnReplaceInfo: Boolean;
    begin
        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then
            Rec."Corporate G/L Account No." := lfcnGetCorpAccNo(Rec."Account No.");
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure levtOnAfterValidatePostingDate(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecGenJnlBatch: Record "Gen. Journal Batch";
        lmdlNoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if (Rec."Line No." in [0, 10000]) and
  (CurrFieldNo = Rec.FieldNo("Posting Date"))
then begin
            lrecGenJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
            if lrecGenJnlBatch."No. Series" <> '' then begin
                Clear(lmdlNoSeriesMgt);
                Rec."Document No." := lmdlNoSeriesMgt.TryGetNextNo(lrecGenJnlBatch."No. Series", Rec."Posting Date");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Bal. Account No.', false, false)]
    local procedure levtOnAfterValidateBalAccountNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"G/L Account" then begin
            if CurrFieldNo = Rec.FieldNo("Bal. Account No.") then
                Rec."Bal. Corporate G/L Account No." := lfcnGetCorpAccNo(Rec."Bal. Account No.");
        end;
        lfcnPopulateShortcutDim1(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeValidateEvent', 'Corporate G/L Account No.', false, false)]
    local procedure levtOnBeforeValidateCorporateGLAccountNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
    begin
        if not lfcnIsBottomUp() then begin
            if Rec."Corporate G/L Account No." <> '' then begin
                lrecCorpGLAcc.Get(Rec."Corporate G/L Account No.");
                lrecCorpGLAcc.TestField("Local G/L Account No.");

                Rec.Validate("Account Type", Rec."Account Type"::"G/L Account");
                Rec.Validate("Account No.", lrecCorpGLAcc."Local G/L Account No.");
            end
        end else
            if Rec."Corporate G/L Account No." <> '' then begin
                Rec.Validate("Account Type", Rec."Account Type"::"G/L Account");

                lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
                lrecGLAcc.SetRange("Corporate G/L Account No.", Rec."Corporate G/L Account No.");
                if lrecGLAcc.Count = 1 then begin
                    lrecGLAcc.FindFirst();
                    Rec.Validate("Account No.", lrecGLAcc."No.");
                end else
                    Rec.Validate("Account No.", '');
            end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeValidateEvent', 'Bal. Corporate G/L Account No.', false, false)]
    local procedure levtOnBeforeValidateBalCorporateGLAccountNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
    begin
        if not lfcnIsBottomUp() then begin
            if Rec."Bal. Corporate G/L Account No." <> '' then begin
                lrecCorpGLAcc.Get(Rec."Bal. Corporate G/L Account No.");
                lrecCorpGLAcc.TestField("Local G/L Account No.");

                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");
                Rec.Validate("Bal. Account No.", lrecCorpGLAcc."Local G/L Account No.");
            end
        end else
            if Rec."Bal. Corporate G/L Account No." <> '' then begin
                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");

                lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
                lrecGLAcc.SetRange("Corporate G/L Account No.", Rec."Bal. Corporate G/L Account No.");
                if lrecGLAcc.Count = 1 then begin
                    lrecGLAcc.FindFirst();
                    Rec.Validate("Bal. Account No.", lrecGLAcc."No.");
                end else
                    Rec.Validate("Bal. Account No.", '');
            end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeValidateEvent', 'GAAP Adjustment Reason', false, false)]
    local procedure levtOnBeforeValidateGAAPAdjustmentReason(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        lrecGLAcc: Record "G/L Account";
    begin
        if (Rec."GAAP Adjustment Reason" = Rec."GAAP Adjustment Reason"::Reclassification) and
  (Rec."Account Type" = Rec."Account Type"::"G/L Account") and (Rec."Account No." <> '')
then begin
            lrecGLAcc.Get(Rec."Account No.");
            Rec.Validate(Reversible, lrecGLAcc."Income/Balance" = lrecGLAcc."Income/Balance"::"Balance Sheet");
        end else
            Rec.Validate(Reversible, false);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnBeforeValidateEvent', 'Reversible', false, false)]
    local procedure levtOnBeforeValidateReversible(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    begin
        if Rec.Reversible <> xRec.Reversible then
            gfncUpdateReversible(Rec);
    end;

    // [EventSubscriber(ObjectType::Table, 81, 'gpubOnSetUpNewLine', '', false, false)]
    // local procedure levtOnSetUpNewLine(var Sender: Record "Gen. Journal Line"; LastGenJnlLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean; GenJnlLine: Record "Gen. Journal Line"; GenJnlTemplate: Record "Gen. Journal Template")
    // begin
    //     if GenJnlLine.FindFirst() then
    //         if not (BottomLine and
    //           (Balance - LastGenJnlLine."Balance (LCY)" = 0) and
    //           not LastGenJnlLine.EmptyLine())
    //         then begin
    //             Sender."GAAP Adjustment Reason" := LastGenJnlLine."GAAP Adjustment Reason";
    //             Sender."Adjustment Role" := LastGenJnlLine."Adjustment Role";
    //             Sender."Tax Adjustment Reason" := LastGenJnlLine."Tax Adjustment Reason";
    //             Sender."Equity Correction Code" := LastGenJnlLine."Equity Correction Code";
    //         end;

    //     if GenJnlTemplate.Type in [GenJnlTemplate.Type::"Tax Adjustments", GenJnlTemplate.Type::"Group Adjustments",
    //       GenJnlTemplate.Type::"19"]
    //     then begin
    //         if Sender."Tax Adjustment Reason" = Sender."Tax Adjustment Reason"::" " then
    //             Sender."Tax Adjustment Reason" := Sender."Tax Adjustment Reason"::"P&L";
    //         if Sender."Adjustment Role" = Sender."Adjustment Role"::" " then
    //             Sender."Adjustment Role" := Sender."Adjustment Role"::EY;
    //     end;
    // end;


    procedure gfcnLookupCorporateGLAccountNo(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        precGenJournalLine.TestField("Account Type", precGenJournalLine."Account Type"::"G/L Account");

        lrecCorpGLAcc."No." := precGenJournalLine."Corporate G/L Account No.";

        if not lfcnIsBottomUp() then
            if precGenJournalLine."Account No." <> '' then begin
                lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
                lrecCorpGLAcc.SetRange("Local G/L Account No.", precGenJournalLine."Account No.");
            end;

        if PAGE.RunModal(0, lrecCorpGLAcc) = ACTION::LookupOK then
            precGenJournalLine.Validate("Corporate G/L Account No.", lrecCorpGLAcc."No.");
    end;


    procedure gfcnLookupBalCorporateGLAccountNo(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        precGenJournalLine.TestField("Bal. Account Type", precGenJournalLine."Bal. Account Type"::"G/L Account");

        lrecCorpGLAcc."No." := precGenJournalLine."Bal. Corporate G/L Account No.";

        if not lfcnIsBottomUp() then
            if precGenJournalLine."Bal. Account No." <> '' then begin
                lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
                lrecCorpGLAcc.SetRange("Local G/L Account No.", precGenJournalLine."Bal. Account No.");
            end;

        if PAGE.RunModal(0, lrecCorpGLAcc) = ACTION::LookupOK then
            precGenJournalLine.Validate("Bal. Corporate G/L Account No.", lrecCorpGLAcc."No.");
    end;

    local procedure lfcnGetCorpAccNo(var pcodAccNo: Code[20]): Code[20]
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
    begin
        if pcodAccNo = '' then
            exit;

        lrecGLAcc.Get(pcodAccNo);
        // MP 18-01-12

        // MP 19-11-13 >>
        if lfcnIsBottomUp() then
            exit(lrecGLAcc."Corporate G/L Account No.");
        // MP 19-11-13 <<

        lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
        lrecCorpGLAcc.SetRange("Local G/L Account No.", pcodAccNo);
        if lrecCorpGLAcc.Count = 1 then begin
            lrecCorpGLAcc.FindFirst();
            exit(lrecCorpGLAcc."No.");
        end
        // MP 19-02-14 >>
        else
            exit('');
        // MP 19-02-14 <<
    end;


    procedure gfcnMarkCorpAccLines(var precGenJournalLine: Record "Gen. Journal Line"; pcodCorpAccNo: Code[20])
    begin
        // MP 18-01-12
        // First mark all entries for "Corporate G/L Account No."
        precGenJournalLine.SetRange("Corporate G/L Account No.", pcodCorpAccNo);
        if precGenJournalLine.FindSet() then
            repeat
                precGenJournalLine.Mark(true);
            until precGenJournalLine.Next() = 0;

        // Then mark all entries for "Bal. Corporate G/L Account No."
        precGenJournalLine.SetRange("Corporate G/L Account No.");
        precGenJournalLine.SetRange("Bal. Corporate G/L Account No.", pcodCorpAccNo);
        if precGenJournalLine.FindSet() then
            repeat
                precGenJournalLine.Mark(true);
            until precGenJournalLine.Next() = 0;

        precGenJournalLine.SetRange("Bal. Corporate G/L Account No.");

        precGenJournalLine.MarkedOnly(true);
    end;

    local procedure lfcnPopulateShortcutDim1(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
    begin
        // MP 18-01-12
        if lrecGenJnlTemplate.Get(precGenJournalLine."Journal Template Name") then
            if (lrecGenJnlTemplate."Shortcut Dimension 1 Code" <> '') and
              (precGenJournalLine."Shortcut Dimension 1 Code" <> lrecGenJnlTemplate."Shortcut Dimension 1 Code")
            then
                precGenJournalLine.Validate("Shortcut Dimension 1 Code", lrecGenJnlTemplate."Shortcut Dimension 1 Code");
    end;


    procedure gfncUpdateReversible(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lrecGenJournalLine: Record "Gen. Journal Line";
    begin
        precGenJournalLine.TestField("Posting Date");
        precGenJournalLine.TestField("Document No.");
        lrecGenJournalLine.SetRange("Journal Template Name", precGenJournalLine."Journal Template Name");
        lrecGenJournalLine.SetRange("Journal Batch Name", precGenJournalLine."Journal Batch Name");
        lrecGenJournalLine.SetFilter("Line No.", '<>%1', precGenJournalLine."Line No.");
        lrecGenJournalLine.SetRange("Posting Date", precGenJournalLine."Posting Date");
        lrecGenJournalLine.SetRange("Document No.", precGenJournalLine."Document No.");
        if lrecGenJournalLine.FindSet() then
            repeat
                lrecGenJournalLine.Reversible := precGenJournalLine.Reversible;
                lrecGenJournalLine.Modify();
            until lrecGenJournalLine.Next() = 0;
    end;

    local procedure lfcnIsBottomUp(): Boolean
    var
        lrecEYCoreSetup: Record "EY Core Setup";
    begin
        // MP 19-11-13

        lrecEYCoreSetup.Get();
        exit(lrecEYCoreSetup."Company Type" = lrecEYCoreSetup."Company Type"::"Bottom-up");
    end;


    procedure gfcnMarkLocalAccLines(var precGenJournalLine: Record "Gen. Journal Line"; ptxtLocalAccNoFilter: Text[1024])
    begin
        // MP 19-11-13
        // First mark all entries for "Account No."
        precGenJournalLine.SetRange("Account Type", precGenJournalLine."Account Type"::"G/L Account");
        precGenJournalLine.SetFilter("Account No.", ptxtLocalAccNoFilter);
        if precGenJournalLine.FindSet() then
            repeat
                precGenJournalLine.Mark(true);
            until precGenJournalLine.Next() = 0;

        // Then mark all entries for "Bal. Account No."
        precGenJournalLine.SetRange("Account Type");
        precGenJournalLine.SetRange("Bal. Account Type", precGenJournalLine."Bal. Account Type"::"G/L Account");
        precGenJournalLine.SetRange("Account No.");
        precGenJournalLine.SetFilter("Bal. Account No.", ptxtLocalAccNoFilter);
        if precGenJournalLine.FindSet() then
            repeat
                precGenJournalLine.Mark(true);
            until precGenJournalLine.Next() = 0;

        precGenJournalLine.SetRange("Bal. Account Type");
        precGenJournalLine.SetRange("Bal. Account No.");

        precGenJournalLine.MarkedOnly(true);
    end;


    procedure gfcnLookupAccNo(var precGenJournalLine: Record "Gen. Journal Line"; poptAccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; pcodAccNo: Code[20]; pcodCorpGLAccNo: Code[20]; pintCurrFieldNo: Integer)
    var
        lrecGLAcc: Record "G/L Account";
        lrecCust: Record Customer;
        lrecVend: Record Vendor;
        lrecBankAcc: Record "Bank Account";
        lrecFixedAsset: Record "Fixed Asset";
        lrecICPartner: Record "IC Partner";
        lcodAccNo: Code[20];
    begin
        case poptAccType of
            poptAccType::"G/L Account":
                begin
                    if lfcnIsBottomUp() and (pcodCorpGLAccNo <> '') then begin
                        lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
                        lrecGLAcc.SetRange("Corporate G/L Account No.", pcodCorpGLAccNo);
                    end;

                    lrecGLAcc."No." := pcodAccNo;
                    if PAGE.RunModal(0, lrecGLAcc) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecGLAcc."No.";
                end;

            poptAccType::Customer:
                begin
                    lrecCust."No." := pcodAccNo;
                    if PAGE.RunModal(0, lrecCust) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecCust."No."
                end;

            poptAccType::Vendor:
                begin
                    lrecVend."No." := pcodAccNo;
                    if PAGE.RunModal(0, lrecVend) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecVend."No."
                end;

            poptAccType::"Bank Account":
                begin
                    lrecBankAcc."No." := pcodAccNo;
                    if PAGE.RunModal(0, lrecBankAcc) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecBankAcc."No."
                end;

            poptAccType::"Fixed Asset":
                begin
                    lrecFixedAsset."No." := pcodAccNo;
                    if PAGE.RunModal(0, lrecFixedAsset) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecFixedAsset."No."
                end;

            poptAccType::"IC Partner":
                begin
                    lrecICPartner.Code := pcodAccNo;
                    if PAGE.RunModal(0, lrecICPartner) <> ACTION::LookupOK then
                        exit;
                    lcodAccNo := lrecICPartner.Code
                end;

        end;

        case pintCurrFieldNo of
            precGenJournalLine.FieldNo("Account No."):
                precGenJournalLine.Validate("Account No.", lcodAccNo);

            precGenJournalLine.FieldNo("Bal. Account No."):
                precGenJournalLine.Validate("Bal. Account No.", lcodAccNo);
        end;
    end;


    procedure gfcnGetCorpAccounts(var precGenJnlLine: Record "Gen. Journal Line"; var ptxtCorpAccName: Text[50]; var ptxtBalCorpAccName: Text[50])
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        if precGenJnlLine."Corporate G/L Account No." <> grecLastGenJnlLine."Corporate G/L Account No." then begin
            ptxtCorpAccName := '';
            if precGenJnlLine."Corporate G/L Account No." <> '' then
                if lrecCorpGLAcc.Get(precGenJnlLine."Corporate G/L Account No.") then
                    ptxtCorpAccName := lrecCorpGLAcc.Name;
        end;

        if precGenJnlLine."Bal. Corporate G/L Account No." <> grecLastGenJnlLine."Bal. Corporate G/L Account No." then begin
            ptxtBalCorpAccName := '';
            if precGenJnlLine."Bal. Corporate G/L Account No." <> '' then
                if lrecCorpGLAcc.Get(precGenJnlLine."Bal. Corporate G/L Account No.") then
                    ptxtBalCorpAccName := lrecCorpGLAcc.Name;
        end;

        grecLastGenJnlLine := precGenJnlLine;
    end;
}

