codeunit 63003 "P:General Journal"
{

    trigger OnRun()
    begin
    end;

    var
        txt60000: Label 'Note that only the lines marked as %1 will be posted.\Do you want to continue?';
        txt60001: Label 'The previous years entries will be reversed before the journal is posted, are you sure you want to continue?';
        txt60002: Label 'Reversing previous years entries...';

    // [EventSubscriber(ObjectType::Page, 39, 'OnAfterActionEvent', 'UnPostedBalance', false, false)]
    // local procedure levtOnAfterActionUnPostedBalance(var Rec: Record "Gen. Journal Line")
    // var
    //     lmdlUnpostedEntriesManagement: Codeunit "Un-posted Entries Management";
    // begin
    //     lmdlUnpostedEntriesManagement.gfcnPreview(Rec);
    // end;

    [EventSubscriber(ObjectType::Page, 39, 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure levtOnBeforeActionEventPost(var Rec: Record "Gen. Journal Line")
    begin
        gfcnConfirmReadyToPost(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 39, 'OnAfterActionEvent', 'Post', false, false)]
    local procedure levtOnAfterActionEventPost(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SetRange("Ready to Post");
    end;

    [EventSubscriber(ObjectType::Page, 39, 'OnBeforeActionEvent', 'PostAndPrint', false, false)]
    local procedure levtOnBeforeActionEventPostAndPrint(var Rec: Record "Gen. Journal Line")
    begin
        gfcnConfirmReadyToPost(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 39, 'OnAfterActionEvent', 'PostAndPrint', false, false)]
    local procedure levtOnAfterActionEventPostAndPrint(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SetRange("Ready to Post");
    end;

    [EventSubscriber(ObjectType::Page, 39, 'OnBeforeActionEvent', 'Preview', false, false)]
    local procedure levtOnBeforeActionPreviewPosting(var Rec: Record "Gen. Journal Line")
    begin
        gfcnSetReadyToPost(Rec);
    end;


    procedure gfcnConfirmReadyToPost(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lrecGenJournalBatch: Record "Gen. Journal Batch";
        lmdlReverseGLEntries: Codeunit "Reverse G/L Entries";
        ldlgWindow: Dialog;
    begin
        if lfcnUseReadyToPost(precGenJournalLine."Journal Template Name") then begin
            if not Confirm(StrSubstNo(txt60000, precGenJournalLine.FieldCaption("Ready to Post")), false) then
                Error('');

            precGenJournalLine.SetRange("Ready to Post", true);
        end;

        lrecGenJournalBatch.Get(precGenJournalLine."Journal Template Name", precGenJournalLine."Journal Batch Name");
        if lrecGenJournalBatch."Reverse TB to TB" then begin
            if not Confirm(txt60001) then
                Error('');

            ldlgWindow.Open(txt60002);
            lmdlReverseGLEntries.gfcnReverse();
            ldlgWindow.Close();
            Commit();
        end;
    end;


    procedure gfcnSetReadyToPost(var precGenJournalLine: Record "Gen. Journal Line")
    begin
        if lfcnUseReadyToPost(precGenJournalLine."Journal Template Name") then
            precGenJournalLine.SetRange("Ready to Post", true);
    end;

    local procedure lfcnUseReadyToPost(var pcodTemplateName: Code[10]): Boolean
    var
        lrecGenJournalTemplate: Record "Gen. Journal Template";
    begin
        lrecGenJournalTemplate.Get(pcodTemplateName);
        exit(lrecGenJournalTemplate."Use Ready to Post");
    end;
}

