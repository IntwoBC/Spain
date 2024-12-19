codeunit 60014 "Reverse G/L Entries"
{
    // VarNameDataTypeSubtypeLength
    // Nop_datFromDate
    // Nop_datToDate
    // Nop_datReversalPostingDateDate
    // Nop_blnDialogBoolean
    // 
    // MP 25-04-13
    // Amended to only reverse <Blank> entries from the close income statement run (Case 13851)
    // 
    // MP 25-11-13
    // Amended in order to use "Accounting Period" or "Corporate Accounting Period" based on setup (CR 30)
    // 
    // MP 02-05-14
    // Development taken from Core II for Reversal functionality
    // Fixed issue with permissions to G/L Entry
    // 
    // MP 12-05-14
    // Amended function gfncReverseAdjustments in order to set "Reversed at" date as the reversal date
    // 
    // MP 17-11-14
    // Upgraded to NAV 2013 R2
    // 
    // MP 23-11-15
    // Changed to insert lines into journal rather than posting directly (CB1 Enhancements)

    Permissions = TableData "G/L Entry" = rm,
                  TableData "G/L Register" = rm;

    trigger OnRun()
    begin
    end;

    var
        DLG_001: Label 'Progress @1@@@@@@@@@@@@@@@@@@';
        txtSuccessMsg: Label 'The journal lines have now been created successfully.';
        txtNoEntriesMsg: Label 'No entries were found for reversal.';


    procedure gfcnReverse()
    var
        lrecGLRegister: Record "G/L Register";
        lrecGLRegister2: Record "G/L Register";
        lrecGLEntry: Record "G/L Entry";
        lrecGenJnlTemplate: Record "Gen. Journal Template";
        lrecGenJnlLine: Record "Gen. Journal Line";
        lrecSourceCodeSetup: Record "Source Code Setup";
        lrrfAccPeriod: RecordRef;
        lfrfField: FieldRef;
        lmdlDimMgt: Codeunit DimensionManagement;
        lmdlGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        lmdlGAAPMgtRollForward: Codeunit "GAAP Mgt. - Roll Forward";
        lmdlFiscalYearClose: Codeunit "Fiscal Year-Close";
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
        ldatPrevPostingDate: Date;
        ldatPostingDateReversal: Date;
        ldatPostingDateTemp: Date;
        ltxtSourceCodeFilter: Text[80];
    begin
        lrecSourceCodeSetup.Get();
        lrecSourceCodeSetup.TestField("TB Reversal");

        ltxtSourceCodeFilter := '<>' + lrecSourceCodeSetup."TB Reversal";

        // Get Source Codes for GAAP and Tax adjustments
        lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Tax Adjustments");
        if lrecGenJnlTemplate.FindFirst() then
            ltxtSourceCodeFilter += '&<>' + lrecGenJnlTemplate."Source Code";

        lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
        if lrecGenJnlTemplate.FindFirst() then
            ltxtSourceCodeFilter += '&<>' + lrecGenJnlTemplate."Source Code";

        lrecGLRegister.SetFilter("Source Code", ltxtSourceCodeFilter);

        lrecGLRegister.SetRange(Reversed, false);
        if not lrecGLRegister.FindLast() then
            exit;

        lrecGLRegister.SetRange("No.", 0, lrecGLRegister."No.");

        lrecGenJnlLine."Journal Batch Name" := lrecSourceCodeSetup."TB Reversal";

        // MP 25-11-13 >>
        //lrecCorpAccPeriod.SETRANGE("New Fiscal Year",TRUE);
        lrrfAccPeriod.Open(lmdlCompanyTypeMgt.gfcnGetAccPeriodTableID());
        lfrfField := lrrfAccPeriod.Field(3); // "New Fiscal Year"
        lfrfField.SetRange(true);
        // MP 25-11-13 <<
        //lrecLedgerEntryDim.SETRANGE("Table ID",DATABASE::"G/L Entry"); // MP 17-11-14 Upgraded to NAV 2013 R2
        if lrecGLRegister.FindSet() then
            repeat
                lrecGLEntry.SetRange("Entry No.", lrecGLRegister."From Entry No.", lrecGLRegister."To Entry No.");

                // MP 25-04-13 >>

                if (lrecSourceCodeSetup."Close Income Statement" <> '') and
                  (lrecGLRegister."Source Code" = lrecSourceCodeSetup."Close Income Statement")
                then
                    lrecGLEntry.SetRange("Global Dimension 1 Code", '')
                else begin

                    // MP 25-04-13 <<

                    // Exclude entries with "Global Dimension 1 Code", unless there is a mixture of blank and non-blank entries
                    lrecGLEntry.SetFilter("Global Dimension 1 Code", '<>%1', '');
                    if not lrecGLEntry.IsEmpty then begin // Entries exist with "Global Dimension 1 Code"
                        lrecGLEntry.SetRange("Global Dimension 1 Code", '');
                        if not lrecGLEntry.IsEmpty then // Mixture of blank and non-blank entries
                            lrecGLEntry.SetRange("Global Dimension 1 Code");
                    end else // All entries have blank "Global Dimension 1 Code"
                        lrecGLEntry.SetRange("Global Dimension 1 Code");
                end; // MP 25-04-13

                if lrecGLEntry.FindSet() then begin
                    repeat
                        if ldatPrevPostingDate <> lrecGLEntry."Posting Date" then begin
                            // MP 25-11-13 >>
                            //lrecCorpAccPeriod.SETRANGE("Starting Date","Posting Date",31129999D);
                            //lrecCorpAccPeriod.FINDFIRST;
                            //ldatPostingDateReversal := CLOSINGDATE(lrecCorpAccPeriod."Starting Date" - 1);

                            lfrfField := lrrfAccPeriod.Field(1); // "Starting Date"
                            lfrfField.SetRange(lrecGLEntry."Posting Date", 99991231D);
                            lrrfAccPeriod.FindFirst();
                            ldatPostingDateTemp := lfrfField.Value;
                            //ldatPostingDateReversal := CLOSINGDATE(ldatPostingDateTemp - 1);
                            ldatPostingDateReversal := ldatPostingDateTemp; // MP 08-05-14 Replaces above
                                                                            // MP 25-11-13 <<
                        end;

                        lrecGenJnlLine.Init();

                        lrecGenJnlLine."Account No." := lrecGLEntry."G/L Account No.";
                        lrecGenJnlLine."Posting Date" := ldatPostingDateReversal;
                        lrecGenJnlLine."Document No." := lrecGLEntry."Document No.";
                        lrecGenJnlLine.Description := lrecGLEntry.Description;
                        lrecGenJnlLine.Validate(Amount, -lrecGLEntry.Amount);
                        // MP 17-11-14 >>
                        if lrecGenJnlLine.Amount = 0 then
                            lrecGenJnlLine."Allow Zero-Amount Posting" := true;
                        // MP 17-11-14 <<
                        lrecGenJnlLine."Shortcut Dimension 1 Code" := lrecGLEntry."Global Dimension 1 Code";
                        lrecGenJnlLine."Shortcut Dimension 2 Code" := lrecGLEntry."Global Dimension 2 Code";
                        lrecGenJnlLine."Business Unit Code" := lrecGLEntry."Business Unit Code";
                        lrecGenJnlLine."External Document No." := lrecGLEntry."External Document No.";
                        lrecGenJnlLine."Corporate G/L Account No." := lrecGLEntry."Corporate G/L Account No.";
                        lrecGenJnlLine."Source Code" := lrecSourceCodeSetup."TB Reversal";

                        // MP 17-11-14 Upgraded to NAV 2013 R2 >>
                        //lrecLedgerEntryDim.SETRANGE("Entry No.","Entry No.");
                        //lrecLedgerEntryDim.SETRANGE("Table ID", DATABASE::"G/L Entry"); //TEC 09-10-12 -mdan-
                        //IF NOT lrecLedgerEntryDim.ISEMPTY THEN BEGIN
                        //  IF NOT ltmpJnlLineDim.ISEMPTY THEN
                        //    ltmpJnlLineDim.DELETEALL;
                        //  lmdlDimMgt.CopyLedgEntryDimToJnlLineDim(lrecLedgerEntryDim,ltmpJnlLineDim);
                        //END;
                        //
                        //lmdlGenJnlPostLine.RunWithCheck(lrecGenJnlLine,ltmpJnlLineDim);

                        lrecGenJnlLine."Dimension Set ID" := lrecGLEntry."Dimension Set ID";
                        lmdlGenJnlPostLine.RunWithCheck(lrecGenJnlLine);
                        // MP 17-11-14 Upgraded to NAV 2013 R2 <<

                        ldatPrevPostingDate := lrecGLEntry."Posting Date";
                    until lrecGLEntry.Next() = 0;

                    lrecGLRegister2 := lrecGLRegister;
                    lrecGLRegister2.Reversed := true;
                    lrecGLRegister2.Modify();

                    Clear(lmdlGenJnlPostLine);
                end;
            until lrecGLRegister.Next() = 0;
    end;


    procedure gfncReverseAdjustments(p_datFrom: Date; p_datTo: Date; p_datReversalPostingDate: Date; p_blnDialog: Boolean; var pcodGenJnlTemplate: array[2] of Record "Gen. Journal Template"; pcodJnlBatchName: array[2] of Code[10]) r_intLinesPosted: Integer
    var
        lrecGLEntry: Record "G/L Entry";
        lrecGenJournalLine: array[2] of Record "Gen. Journal Line";
        lrecSourceCodeSetup: Record "Source Code Setup";
        lmdlDimMgt: Codeunit DimensionManagement;
        lmdlGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        lintCount: Integer;
        lintCounter: Integer;
        ldecProgress: Decimal;
        ldlgDialog: Dialog;
        lintJnlNo: Integer;
    begin
        lrecSourceCodeSetup.Get();
        lrecSourceCodeSetup.TestField("GAAP/Tax Reversal");

        lrecGLEntry.SetCurrentKey(Reversible, "Reversed at", "Posting Date");
        lrecGLEntry.SetRange(Reversible, true);
        lrecGLEntry.SetRange("Reversed at", 0D);
        lrecGLEntry.SetRange("Posting Date", p_datFrom, p_datTo);
        lintCount := lrecGLEntry.Count;
        r_intLinesPosted := 0;

        // MP 23-11-15 >>
        //IF lrecGLEntry.FINDSET(TRUE, FALSE) THEN BEGIN
        if lrecGLEntry.FindSet() then begin

            for lintJnlNo := 1 to 2 do begin
                if pcodJnlBatchName[lintJnlNo] <> '' then begin
                    lrecGenJournalLine[lintJnlNo].SetRange("Journal Template Name", pcodGenJnlTemplate[lintJnlNo].Name);
                    lrecGenJournalLine[lintJnlNo].SetRange("Journal Batch Name", pcodJnlBatchName[lintJnlNo]);
                    if lrecGenJournalLine[lintJnlNo].FindLast() then;
                end;
            end;
            // MP 23-11-15 <<
            repeat
                if p_blnDialog then begin
                    ldlgDialog.Open(DLG_001);
                end;
                // Reverse the entry here
                // MP 23-11-15 Do not post directly, but create journal lines instead >>
                if lrecGLEntry."Global Dimension 1 Code" = pcodGenJnlTemplate[1]."Shortcut Dimension 1 Code" then
                    lintJnlNo := 1
                else
                    lintJnlNo := 2;

                if pcodJnlBatchName[lintJnlNo] <> '' then begin
                    lrecGenJournalLine[lintJnlNo].Init();

                    lrecGenJournalLine[lintJnlNo]."Journal Template Name" := pcodGenJnlTemplate[lintJnlNo].Name;
                    lrecGenJournalLine[lintJnlNo]."Journal Batch Name" := pcodJnlBatchName[lintJnlNo];
                    lrecGenJournalLine[lintJnlNo]."Line No." += 10000;

                    lrecGenJournalLine[lintJnlNo].Validate("Account No.", lrecGLEntry."G/L Account No.");
                    lrecGenJournalLine[lintJnlNo].Validate("Corporate G/L Account No.", lrecGLEntry."Corporate G/L Account No.");
                    lrecGenJournalLine[lintJnlNo].Validate("Posting Date", p_datReversalPostingDate);
                    lrecGenJournalLine[lintJnlNo].Validate("Document No.", lrecGLEntry."Document No.");
                    lrecGenJournalLine[lintJnlNo].Validate(Description, lrecGLEntry.Description);
                    lrecGenJournalLine[lintJnlNo].Validate(Amount, -lrecGLEntry.Amount);
                    if lrecGenJournalLine[lintJnlNo].Amount = 0 then
                        lrecGenJournalLine[lintJnlNo].Validate("Allow Zero-Amount Posting", true);

                    lrecGenJournalLine[lintJnlNo].Validate("Shortcut Dimension 1 Code", lrecGLEntry."Global Dimension 1 Code");
                    lrecGenJournalLine[lintJnlNo].Validate("Shortcut Dimension 2 Code", lrecGLEntry."Global Dimension 2 Code");
                    lrecGenJournalLine[lintJnlNo].Validate("Business Unit Code", lrecGLEntry."Business Unit Code");
                    lrecGenJournalLine[lintJnlNo].Validate("External Document No.", lrecGLEntry."External Document No.");
                    lrecGenJournalLine[lintJnlNo].Validate("Source Code", lrecSourceCodeSetup."GAAP/Tax Reversal");
                    lrecGenJournalLine[lintJnlNo].Validate("Description (English)", lrecGLEntry."Description (English)");

                    lrecGenJournalLine[lintJnlNo].Validate("GAAP Adjustment Reason", lrecGLEntry."GAAP Adjustment Reason");
                    if lrecGLEntry."Adjustment Role" = lrecGLEntry."Adjustment Role"::Auditor then
                        lrecGenJournalLine[lintJnlNo].Validate("Adjustment Role", lrecGLEntry."Adjustment Role"::EY)
                    else
                        lrecGenJournalLine[lintJnlNo].Validate("Adjustment Role", lrecGLEntry."Adjustment Role");

                    lrecGenJournalLine[lintJnlNo].Validate("Tax Adjustment Reason", lrecGLEntry."Tax Adjustment Reason");
                    lrecGenJournalLine[lintJnlNo].Validate("Equity Correction Code", lrecGLEntry."Equity Correction Code");

                    lrecGenJournalLine[lintJnlNo].Validate("Dimension Set ID", lrecGLEntry."Dimension Set ID");

                    lrecGenJournalLine[lintJnlNo].Validate("Entry No. to Reverse", lrecGLEntry."Entry No.");
                    lrecGenJournalLine[lintJnlNo].Insert(true);


                    //lrecGenJournalLine.INIT
                    //lrecGenJournalLine."Account No." := "G/L Account No.";
                    //lrecGenJournalLine."Posting Date" := p_datReversalPostingDate;
                    //lrecGenJournalLine."Document No." := "Document No.";
                    //lrecGenJournalLine.Description := Description;
                    //lrecGenJournalLine.VALIDATE(Amount,-Amount);
                    // MP 17-11-14 >>
                    //IF lrecGenJournalLine.Amount = 0 THEN
                    //  lrecGenJournalLine."Allow Zero-Amount Posting" := TRUE;
                    // MP 17-11-14 <<
                    //lrecGenJournalLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    //lrecGenJournalLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    //lrecGenJournalLine."Business Unit Code" := "Business Unit Code";
                    //lrecGenJournalLine."External Document No." := "External Document No.";
                    //lrecGenJournalLine."Corporate G/L Account No." := "Corporate G/L Account No.";
                    //lrecGenJournalLine."Source Code" := lrecSourceCodeSetup."GAAP/Tax Reversal";
                    //
                    //lrecGenJournalLine."Description (English)" := "Description (English)";
                    //lrecGenJournalLine."Consolidation G/L Account No." := "Consolidation G/L Account No."; // MP 02-05-14 N/A
                    //lrecGenJournalLine."GAAP Adjustment Reason" := "GAAP Adjustment Reason";
                    //lrecGenJournalLine."Adjustment Role" := "Adjustment Role";
                    //lrecGenJournalLine."Tax Adjustment Reason" := "Tax Adjustment Reason";
                    //lrecGenJournalLine."Equity Correction Code" := "Equity Correction Code";
                    //
                    // MP 17-11-14 Upgraded to NAV 2013 R2 >>
                    //lrecLedgerEntryDim.RESET;
                    //lrecLedgerEntryDim.SETRANGE("Entry No.","Entry No.");
                    //lrecLedgerEntryDim.SETRANGE("Table ID", DATABASE::"G/L Entry");
                    //IF NOT lrecLedgerEntryDim.ISEMPTY THEN BEGIN
                    //  IF NOT ltmpJnlLineDim.ISEMPTY THEN BEGIN
                    //    ltmpJnlLineDim.DELETEALL;
                    //  END;
                    //  lmdlDimMgt.CopyLedgEntryDimToJnlLineDim(lrecLedgerEntryDim,ltmpJnlLineDim);
                    //END;
                    //
                    //lmdlGenJnlPostLine.RunWithCheck(lrecGenJournalLine,ltmpJnlLineDim);

                    //lrecGenJournalLine."Dimension Set ID" := "Dimension Set ID";
                    //lmdlGenJnlPostLine.RunWithCheck(lrecGenJournalLine);
                    // MP 17-11-14 Upgraded to NAV 2013 R2 <<
                    //"Reversal Entry No." := lmdlGenJnlPostLine.gfncGetLastInsertedEntryNo();
                    //MODIFY;

                    // MP 23-11-15 <<

                    r_intLinesPosted += 1;
                end; // MP 23-11-15

                if p_blnDialog then begin
                    ldecProgress := r_intLinesPosted / lintCount;
                    ldecProgress := ldecProgress + 10000;
                    ldlgDialog.Update(1, Round(ldecProgress, 1));
                end;
            until lrecGLEntry.Next() = 0;

            if p_blnDialog then
                if r_intLinesPosted > 0 then
                    Message(txtSuccessMsg)
                else
                    Message(txtNoEntriesMsg);

            // Update Reversed AT
            //lrecGLEntry.MODIFYALL(lrecGLEntry."Reversed at", TODAY);
            //lrecGLEntry.MODIFYALL(lrecGLEntry."Reversed at",p_datReversalPostingDate); // MP 12-05-14 Replaces above // MP 23-11-15 Now handled on posting
        end else // MP 23-11-15 Added ELSE part
            Message(txtNoEntriesMsg);
    end;
}

