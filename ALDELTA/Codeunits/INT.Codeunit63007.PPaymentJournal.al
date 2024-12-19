codeunit 63007 "P:Payment Journal"
{

    trigger OnRun()
    begin
    end;

    // [EventSubscriber(ObjectType::Page, 256, 'OnAfterActionEvent', 'UnPostedBalance', false, false)]
    // local procedure levtOnAfterActionUnPostedBalance(var Rec: Record "Gen. Journal Line")
    // var
    //     lmdlUnpostedEntriesManagement: Codeunit "Un-posted Entries Management";
    // begin
    //     lmdlUnpostedEntriesManagement.gfcnPreview(Rec);
    // end;

    [EventSubscriber(ObjectType::Page, 256, 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure levtOnBeforeActionEventPost(var Rec: Record "Gen. Journal Line")
    var
        lmdlPGeneralJournal: Codeunit "P:General Journal";
    begin
        lmdlPGeneralJournal.gfcnConfirmReadyToPost(Rec);
    end;

    [EventSubscriber(ObjectType::Page, 256, 'OnAfterActionEvent', 'Post', false, false)]
    local procedure levtOnAfterActionEventPost(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SetRange("Ready to Post");
    end;

    // [EventSubscriber(ObjectType::Page, 256, 'OnBeforeActionEvent', 'PostAndPrint', false, false)]
    // local procedure levtOnBeforeActionEventPostAndPrint(var Rec: Record "Gen. Journal Line")
    // var
    //     lmdlPGeneralJournal: Codeunit "P:General Journal";
    // begin
    //     lmdlPGeneralJournal.gfcnConfirmReadyToPost(Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, 256, 'OnAfterActionEvent', 'PostAndPrint', false, false)]
    // local procedure levtOnAfterActionEventPostAndPrint(var Rec: Record "Gen. Journal Line")
    // begin
    //     Rec.SetRange("Ready to Post");
    // end;

    [EventSubscriber(ObjectType::Page, 256, 'OnBeforeActionEvent', 'Preview', false, false)]
    local procedure levtOnBeforeActionPreviewPosting(var Rec: Record "Gen. Journal Line")
    var
        lmdlPGeneralJournal: Codeunit "P:General Journal";
    begin
        lmdlPGeneralJournal.gfcnSetReadyToPost(Rec);
    end;
}

