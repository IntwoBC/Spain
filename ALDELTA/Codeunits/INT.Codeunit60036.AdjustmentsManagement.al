codeunit 60036 "Adjustments Management"
{

    trigger OnRun()
    begin
    end;

    var
        GLE: Record "G/L Entry";


    procedure gfcnShowEntries(var precGLEntry: Record "G/L Entry"; pblnIncludeUnpostedEntries: Boolean; pblnCorporate: Boolean)
    var
        ltmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary;
    begin
        if not pblnIncludeUnpostedEntries then
            PAGE.Run(PAGE::"General Ledger Entries", precGLEntry)
        else begin
            gfcnGetEntries(ltmpAdjmtEntryBuffer, precGLEntry, pblnCorporate, false);
            PAGE.Run(PAGE::"Adjustment Entries", ltmpAdjmtEntryBuffer);
        end;
    end;


    procedure gfcnGetEntries(var ptmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary; var precGLEntry: Record "G/L Entry"; pblnCorporate: Boolean; pblnExcludeReclassReversal: Boolean)
    var
        lrecGenJnlLine: Record "Gen. Journal Line";
        lrecCorpAccPeriod: Record "Corporate Accounting Period";
        lintEntryNo: Integer;
    begin
        ptmpAdjmtEntryBuffer.Reset();
        ptmpAdjmtEntryBuffer.DeleteAll();

        if precGLEntry.FindSet() then
            repeat
                if not (pblnExcludeReclassReversal and (precGLEntry."GAAP Adjustment Reason" = precGLEntry."GAAP Adjustment Reason"::Reclassification) and
                  ((precGLEntry."Reversal Entry No." <> 0) or lrecCorpAccPeriod.Get(precGLEntry."Posting Date")))
                then begin
                    lintEntryNo += 1;
                    ptmpAdjmtEntryBuffer.TransferFields(precGLEntry);
                    ptmpAdjmtEntryBuffer."G/L Entry No." := precGLEntry."Entry No.";
                    ptmpAdjmtEntryBuffer."Entry No." := lintEntryNo;
                    ptmpAdjmtEntryBuffer.Insert();
                end;
            until precGLEntry.Next() = 0;

        precGLEntry.CopyFilter("Posting Date", lrecGenJnlLine."Posting Date");
        precGLEntry.CopyFilter("Document No.", lrecGenJnlLine."Document No.");
        precGLEntry.CopyFilter("Global Dimension 1 Code", lrecGenJnlLine."Shortcut Dimension 1 Code");
        precGLEntry.CopyFilter("Global Dimension 2 Code", lrecGenJnlLine."Shortcut Dimension 2 Code");
        precGLEntry.CopyFilter("Business Unit Code", lrecGenJnlLine."Business Unit Code");
        precGLEntry.CopyFilter("GAAP Adjustment Reason", lrecGenJnlLine."GAAP Adjustment Reason");
        precGLEntry.CopyFilter("Equity Correction Code", lrecGenJnlLine."Equity Correction Code");

        // First get all entries for Local/Corporate G/L Account No.
        lrecGenJnlLine.SetRange("Account Type", lrecGenJnlLine."Account Type"::"G/L Account");
        if pblnCorporate then
            precGLEntry.CopyFilter(precGLEntry."Corporate G/L Account No.", lrecGenJnlLine."Corporate G/L Account No.")
        else
            precGLEntry.CopyFilter(precGLEntry."G/L Account No.", lrecGenJnlLine."Account No.");

        if lrecGenJnlLine.FindSet() then
            repeat
                if not (pblnExcludeReclassReversal and (lrecGenJnlLine."GAAP Adjustment Reason" = lrecGenJnlLine."GAAP Adjustment Reason"::Reclassification) and
                  lrecCorpAccPeriod.Get(lrecGenJnlLine."Posting Date"))
                then
                    lfcnInsertUnpostedEntry(lintEntryNo, ptmpAdjmtEntryBuffer, lrecGenJnlLine, false);
            until lrecGenJnlLine.Next() = 0;

        // Then get all entries for Bal. Local/Corporate G/L Account No.
        lrecGenJnlLine.SetRange("Account Type");
        if pblnCorporate then
            lrecGenJnlLine.SetRange("Corporate G/L Account No.")
        else
            lrecGenJnlLine.SetRange("Account No.");

        lrecGenJnlLine.SetRange("Bal. Account Type", lrecGenJnlLine."Bal. Account Type"::"G/L Account");
        if pblnCorporate then
            precGLEntry.CopyFilter(precGLEntry."Corporate G/L Account No.", lrecGenJnlLine."Bal. Corporate G/L Account No.")
        else
            precGLEntry.CopyFilter(precGLEntry."G/L Account No.", lrecGenJnlLine."Bal. Account No.");

        if lrecGenJnlLine.FindSet() then
            repeat
                if not (pblnExcludeReclassReversal and (lrecGenJnlLine."GAAP Adjustment Reason" = lrecGenJnlLine."GAAP Adjustment Reason"::Reclassification) and
                  lrecCorpAccPeriod.Get(lrecGenJnlLine."Posting Date"))
                then
                    lfcnInsertUnpostedEntry(lintEntryNo, ptmpAdjmtEntryBuffer, lrecGenJnlLine, true);
            until lrecGenJnlLine.Next() = 0;
    end;

    local procedure lfcnInsertUnpostedEntry(var pintEntryNo: Integer; var ptmpAdjmtEntryBuffer: Record "Adjustment Entry Buffer" temporary; var precGenJnlLine: Record "Gen. Journal Line"; pblnBalAcc: Boolean)
    begin
        if pblnBalAcc and (precGenJnlLine."Bal. Account No." = '') then
            exit;

        ptmpAdjmtEntryBuffer.Init();
        pintEntryNo += 1;
        ptmpAdjmtEntryBuffer."Entry No." := pintEntryNo;

        if pblnBalAcc then begin
            ptmpAdjmtEntryBuffer."G/L Account No." := precGenJnlLine."Bal. Account No.";
            ptmpAdjmtEntryBuffer."Corporate G/L Account No." := precGenJnlLine."Bal. Corporate G/L Account No.";
        end else begin
            ptmpAdjmtEntryBuffer."G/L Account No." := precGenJnlLine."Account No.";
            ptmpAdjmtEntryBuffer."Corporate G/L Account No." := precGenJnlLine."Corporate G/L Account No.";
        end;

        ptmpAdjmtEntryBuffer."Posting Date" := precGenJnlLine."Posting Date";
        ptmpAdjmtEntryBuffer."Document No." := precGenJnlLine."Document No.";
        ptmpAdjmtEntryBuffer.Description := precGenJnlLine.Description;
        if pblnBalAcc then
            ptmpAdjmtEntryBuffer.Amount := -precGenJnlLine.Amount
        else
            ptmpAdjmtEntryBuffer.Amount := precGenJnlLine.Amount;

        ptmpAdjmtEntryBuffer."Global Dimension 1 Code" := precGenJnlLine."Shortcut Dimension 1 Code";

        ptmpAdjmtEntryBuffer."GAAP Adjustment Reason" := precGenJnlLine."GAAP Adjustment Reason";
        ptmpAdjmtEntryBuffer."Adjustment Role" := precGenJnlLine."Adjustment Role";
        ptmpAdjmtEntryBuffer."Equity Correction Code" := precGenJnlLine."Equity Correction Code";
        ptmpAdjmtEntryBuffer.Reversible := precGenJnlLine.Reversible;
        ptmpAdjmtEntryBuffer."G/L Entry No." := 0;
        ptmpAdjmtEntryBuffer.Insert();
    end;
}

