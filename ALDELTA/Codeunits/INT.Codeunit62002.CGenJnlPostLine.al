codeunit 62002 "C:Gen. Jnl.-Post Line"
{
    Permissions = TableData "G/L Entry" = rm;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        grecSourceCodeSetup: Record "Source Code Setup";
        grecGenJnlTemplate: Record "Gen. Journal Template";
        gmdlCompanyTypeMgt: Codeunit "Company Type Management";
        gintInsertedEntryNo: Integer;
        Text013: Label 'Please check that %3, %4, %5 and %6 are correct for each line.';
        txt60000: Label 'Error in %1 %2.\\%3 %4 and %5 must have the same %6 when %7 is specified as %8.';
        txt60001: Label '%1 %2 is out of balance by %7.\\';

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure levtOnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        lrecGenJournalLine: Record "Gen. Journal Line";
        lmdlReverseGLEntries: Codeunit "Reverse G/L Entries";
        ldatLastDate: Date;
        lintLastDocType: Integer;
        lcodLastDocNo: Code[20];
    begin
        Clear(grecSourceCodeSetup); // Codeunit is SingleInstance, this event is the first entry point, so clear variables
        Clear(gintInsertedEntryNo);

        if GenJournalLine."Journal Template Name" = '' then
            exit;

        // Perform checks on balances
        grecGenJnlTemplate.Get(GenJournalLine."Journal Template Name");
        if grecGenJnlTemplate.Type in [grecGenJnlTemplate.Type::"Tax Adjustments", grecGenJnlTemplate.Type::"19", grecGenJnlTemplate.Type::"Group Adjustments"] then begin
            lrecGenJournalLine.Copy(GenJournalLine);
            lrecGenJournalLine.SetRange("Journal Template Name", lrecGenJournalLine."Journal Template Name");
            lrecGenJournalLine.SetRange("Journal Batch Name", lrecGenJournalLine."Journal Batch Name");
            if lrecGenJournalLine.FindSet() then
                repeat
                    if (lrecGenJournalLine."Posting Date" <> ldatLastDate) or
                        grecGenJnlTemplate."Force Doc. Balance" and
                        ((lrecGenJournalLine."Document Type" <> lintLastDocType) or (lrecGenJournalLine."Document No." <> lcodLastDocNo))
                    then begin
                        if lrecGenJournalLine."Bal. Account No." = '' then
                            lfcnCheckGAAPBalance(lrecGenJournalLine);
                        lfcnCheckReclassification(lrecGenJournalLine);
                    end;

                    ldatLastDate := lrecGenJournalLine."Posting Date";
                    lintLastDocType := lrecGenJournalLine."Document Type";
                    if not lrecGenJournalLine.EmptyLine() then
                        lcodLastDocNo := lrecGenJournalLine."Document No.";
                until lrecGenJournalLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    local procedure levtOnBeforeInsertGLEntryBuffer(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line")
    var
        lrecGenJournalLineOrg: Record "Gen. Journal Line";
        lrecGLEntryToReverse: Record "G/L Entry";
        lrecGLEntryRecLink: Record "G/L Entry Document Link";
    begin
        if TempGLEntryBuf."Reversed Entry No." <> 0 then begin // Standard NAV Reverse entry
            lrecGLEntryToReverse.Get(TempGLEntryBuf."Reversed Entry No.");

            TempGLEntryBuf."Description (English)" := lrecGLEntryToReverse."Description (English)";
            TempGLEntryBuf."Equity Correction Code" := lrecGLEntryToReverse."Equity Correction Code";
            TempGLEntryBuf."Client Entry No." := lrecGLEntryToReverse."Client Entry No.";

            TempGLEntryBuf."GAAP Adjustment Reason" := lrecGLEntryToReverse."GAAP Adjustment Reason";
            TempGLEntryBuf."Adjustment Role" := lrecGLEntryToReverse."Adjustment Role";
            TempGLEntryBuf."Tax Adjustment Reason" := lrecGLEntryToReverse."Tax Adjustment Reason";
            TempGLEntryBuf.Reversible := lrecGLEntryToReverse.Reversible;

            TempGLEntryBuf."Corporate G/L Account No." := lrecGLEntryToReverse."Corporate G/L Account No.";
            TempGLEntryBuf."Bal. Corporate G/L Account No." := lrecGLEntryToReverse."Bal. Corporate G/L Account No.";
        end else begin
            TempGLEntryBuf."Description (English)" := GenJournalLine."Description (English)";
            TempGLEntryBuf."Equity Correction Code" := GenJournalLine."Equity Correction Code";
            TempGLEntryBuf."Client Entry No." := GenJournalLine."Client Entry No.";

            TempGLEntryBuf."GAAP Adjustment Reason" := GenJournalLine."GAAP Adjustment Reason";
            TempGLEntryBuf."Adjustment Role" := GenJournalLine."Adjustment Role";
            TempGLEntryBuf."Tax Adjustment Reason" := GenJournalLine."Tax Adjustment Reason";
            TempGLEntryBuf.Reversible := GenJournalLine.Reversible;

            // Populate Corp. Account Nos.
            if GenJournalLine."Journal Template Name" <> '' then
                if lrecGenJournalLineOrg.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Line No.") then begin
                    if (lrecGenJournalLineOrg."Account Type" = lrecGenJournalLineOrg."Account Type"::"G/L Account") and (TempGLEntryBuf."G/L Account No." = lrecGenJournalLineOrg."Account No.") then
                        TempGLEntryBuf."Corporate G/L Account No." := lrecGenJournalLineOrg."Corporate G/L Account No.";

                    if (lrecGenJournalLineOrg."Bal. Account Type" = lrecGenJournalLineOrg."Bal. Account Type"::"G/L Account") and (lrecGenJournalLineOrg."Bal. Account No." <> '') then
                        if TempGLEntryBuf."G/L Account No." = lrecGenJournalLineOrg."Bal. Account No." then
                            TempGLEntryBuf."Corporate G/L Account No." := lrecGenJournalLineOrg."Bal. Corporate G/L Account No.";

                    if TempGLEntryBuf."G/L Account No." = lrecGenJournalLineOrg."Account No." then
                        TempGLEntryBuf."Bal. Corporate G/L Account No." := lrecGenJournalLineOrg."Bal. Corporate G/L Account No."
                    else
                        if TempGLEntryBuf."G/L Account No." = lrecGenJournalLineOrg."Bal. Account No." then
                            TempGLEntryBuf."Bal. Corporate G/L Account No." := lrecGenJournalLineOrg."Corporate G/L Account No."
                end;
        end;

        if grecSourceCodeSetup."TB Reversal" = '' then
            grecSourceCodeSetup.Get();

        // Populate Corp. Account No. for cases where not reverse and normal journal posting etry
        if (TempGLEntryBuf."Corporate G/L Account No." = '') and (GenJournalLine."Corporate G/L Account No." <> '') then
            TempGLEntryBuf."Corporate G/L Account No." := GenJournalLine."Corporate G/L Account No.";

        if (TempGLEntryBuf."Bal. Corporate G/L Account No." = '') and (GenJournalLine."Bal. Corporate G/L Account No." <> '') then
            TempGLEntryBuf."Bal. Corporate G/L Account No." := GenJournalLine."Bal. Corporate G/L Account No.";

        if not ((TempGLEntryBuf."Source Code" <> '') and (TempGLEntryBuf."Source Code" in [grecSourceCodeSetup."Close Income Statement", grecSourceCodeSetup.Reversal,
          grecSourceCodeSetup."TB Reversal", grecSourceCodeSetup."GAAP/Tax Reversal"]))
        then begin
            if TempGLEntryBuf."System-Created Entry" or (TempGLEntryBuf."Corporate G/L Account No." = '') then
                TempGLEntryBuf."Corporate G/L Account No." := lfcnGetCorpAccNo(TempGLEntryBuf."G/L Account No.");

            if (TempGLEntryBuf."System-Created Entry" or (TempGLEntryBuf."Bal. Corporate G/L Account No." = '')) and
              (TempGLEntryBuf."Bal. Account Type" = TempGLEntryBuf."Bal. Account Type"::"G/L Account") and (TempGLEntryBuf."Bal. Account No." <> '')
            then
                TempGLEntryBuf."Bal. Corporate G/L Account No." := lfcnGetCorpAccNo(TempGLEntryBuf."Bal. Account No.");
        end;

        gintInsertedEntryNo := TempGLEntryBuf."Entry No.";

        // Update reversal source entry
        if GenJournalLine."Entry No. to Reverse" <> 0 then begin
            lrecGLEntryToReverse.Get(GenJournalLine."Entry No. to Reverse");
            lrecGLEntryToReverse.TestField("Reversed at", 0D);
            lrecGLEntryToReverse."Reversed at" := TempGLEntryBuf."Posting Date";
            lrecGLEntryToReverse."Reversal Entry No." := gintInsertedEntryNo;
            lrecGLEntryToReverse.Modify();
        end;

        // Copy Record Links
        if GenJournalLine.HasLinks then begin
            //lrecGLEntry.GET(GLEntryNo); ??????
            lrecGLEntryRecLink."Transaction No." := TempGLEntryBuf."Transaction No.";
            lrecGLEntryRecLink."Document No." := TempGLEntryBuf."Document No.";

            if not lrecGLEntryRecLink.Find() then
                lrecGLEntryRecLink.Insert();

            lrecGLEntryRecLink.CopyLinks(GenJournalLine);

            GenJournalLine.DeleteLinks();
        end;
    end;

    local procedure lfcnGetCorpAccNo(pcodGLAccNo: Code[20]): Code[20]
    var
        lrecGLAcc: Record "G/L Account";
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        if gmdlCompanyTypeMgt.gfcnCorpAccInUse() then
            if gmdlCompanyTypeMgt.gfcnIsBottomUp() then begin
                lrecGLAcc.Get(pcodGLAccNo);
                lrecGLAcc.TestField("Corporate G/L Account No.");
                exit(lrecGLAcc."Corporate G/L Account No.");
            end else begin
                lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
                lrecCorpGLAcc.SetRange("Local G/L Account No.", pcodGLAccNo);
                lrecCorpGLAcc.FindFirst();
                exit(lrecCorpGLAcc."No.");
            end;
    end;


    procedure gfncGetLastInsertedEntryNo(): Integer
    begin
        exit(gintInsertedEntryNo);
    end;

    local procedure lfcnCheckGAAPBalance(var precGenJnlLine: Record "Gen. Journal Line")
    var
        lrecGenJnlLine: Record "Gen. Journal Line";
    begin
        // MP 07-03-12
        lrecGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.", "Bal. Account No.",
  "GAAP Adjustment Reason", "Adjustment Role", "Tax Adjustment Reason", "Equity Correction Code");

        lrecGenJnlLine.SetRange("Journal Template Name", precGenJnlLine."Journal Template Name");
        lrecGenJnlLine.SetRange("Journal Batch Name", precGenJnlLine."Journal Batch Name");
        lrecGenJnlLine.SetRange("Posting Date", precGenJnlLine."Posting Date");
        lrecGenJnlLine.SetRange("Document No.", precGenJnlLine."Document No.");
        lrecGenJnlLine.SetRange("Bal. Account No.", '');

        lrecGenJnlLine.FindFirst();
        repeat
            lrecGenJnlLine.SetRange("GAAP Adjustment Reason", lrecGenJnlLine."GAAP Adjustment Reason");
            lrecGenJnlLine.SetRange("Adjustment Role", lrecGenJnlLine."Adjustment Role");
            lrecGenJnlLine.SetRange("Tax Adjustment Reason", lrecGenJnlLine."Tax Adjustment Reason");
            lrecGenJnlLine.SetRange("Equity Correction Code", lrecGenJnlLine."Equity Correction Code");
            lrecGenJnlLine.CalcSums("Amount (LCY)");
            if lrecGenJnlLine."Amount (LCY)" <> 0 then
                Error(
                  txt60001 +
                  Text013,
                  lrecGenJnlLine.FieldCaption("Document No."), lrecGenJnlLine."Document No.",
                  lrecGenJnlLine.FieldCaption("GAAP Adjustment Reason"), lrecGenJnlLine.FieldCaption("Adjustment Role"),
                  lrecGenJnlLine.FieldCaption("Equity Correction Code"), lrecGenJnlLine.FieldCaption("Tax Adjustment Reason"),
                  lrecGenJnlLine."Amount (LCY)");

            lrecGenJnlLine.FindLast();
            lrecGenJnlLine.SetRange("GAAP Adjustment Reason");
            lrecGenJnlLine.SetRange("Adjustment Role");
            lrecGenJnlLine.SetRange("Tax Adjustment Reason");
            lrecGenJnlLine.SetRange("Equity Correction Code");
        until lrecGenJnlLine.Next() = 0;
    end;

    local procedure lfcnCheckReclassification(var precGenJnlLine: Record "Gen. Journal Line")
    var
        lrecGenJnlLine: Record "Gen. Journal Line";
        lrecCorpGLAcc: array[2] of Record "Corporate G/L Account";
    begin
        // MP 07-03-12
        lrecGenJnlLine.SetRange("Journal Template Name", precGenJnlLine."Journal Template Name");
        lrecGenJnlLine.SetRange("Journal Batch Name", precGenJnlLine."Journal Batch Name");
        lrecGenJnlLine.SetRange("Document No.", precGenJnlLine."Document No.");
        lrecGenJnlLine.SetRange("GAAP Adjustment Reason", lrecGenJnlLine."GAAP Adjustment Reason"::Reclassification);

        if lrecGenJnlLine.FindSet() then
            repeat
                if (lrecGenJnlLine."Account Type" = lrecGenJnlLine."Account Type"::"G/L Account") or
                  (lrecGenJnlLine."Bal. Account Type" = lrecGenJnlLine."Bal. Account Type"::"G/L Account")
                then begin
                    if (lrecGenJnlLine."Account Type" = lrecGenJnlLine."Account Type"::"G/L Account") and (lrecGenJnlLine."Corporate G/L Account No." <> '') then begin
                        if lrecCorpGLAcc[1]."No." = '' then
                            lrecCorpGLAcc[1].Get(lrecGenJnlLine."Corporate G/L Account No.")
                        else
                            lrecCorpGLAcc[2].Get(lrecGenJnlLine."Corporate G/L Account No.");
                    end;

                    if (lrecGenJnlLine."Bal. Account Type" = lrecGenJnlLine."Bal. Account Type"::"G/L Account") and (lrecGenJnlLine."Bal. Corporate G/L Account No." <> '') then begin
                        if lrecCorpGLAcc[1]."No." = '' then
                            lrecCorpGLAcc[1].Get(lrecGenJnlLine."Bal. Corporate G/L Account No.")
                        else
                            lrecCorpGLAcc[2].Get(lrecGenJnlLine."Bal. Corporate G/L Account No.");
                    end;

                    if (lrecCorpGLAcc[1]."No." <> '') and (lrecCorpGLAcc[2]."No." <> '') then
                        if lrecCorpGLAcc[1]."Account Class" <> lrecCorpGLAcc[2]."Account Class" then
                            Error(txt60000, lrecGenJnlLine.FieldCaption("Document No."), lrecGenJnlLine."Document No.",
                              lrecCorpGLAcc[1].TableCaption, lrecCorpGLAcc[1]."No.", lrecCorpGLAcc[2]."No.",
                              lrecCorpGLAcc[1].FieldCaption("Account Class"),
                              lrecGenJnlLine.FieldCaption("GAAP Adjustment Reason"), lrecGenJnlLine."GAAP Adjustment Reason");
                end;
            until lrecGenJnlLine.Next() = 0;
    end;
}

