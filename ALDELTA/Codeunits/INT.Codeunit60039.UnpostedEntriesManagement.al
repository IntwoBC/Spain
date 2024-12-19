codeunit 60039 "Un-posted Entries Management"
{
    EventSubscriberInstance = Manual;
    Permissions = TableData "G/L Entry" = rid;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        gtmpGLEntry: Record "G/L Entry" temporary;
        gmdlUnpostedEntriesManagement: Codeunit "Un-posted Entries Management";


    procedure gfcnPreview(precGenJournalLine: Record "Gen. Journal Line")
    var
        lmdlGenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        lfcnStart();
        if not lfcnCallPreview(precGenJournalLine) then begin
            lfcnFinish();

            // IF GETLASTERRORTEXT <> lmdlGenJnlPostPreview.GetPreviewModeErrMessage THEN
            //   ERROR(GETLASTERRORTEXT);
            lfcnShowUnpostedEntries(precGenJournalLine);
            Error('');
        end;
    end;


    procedure lfcnStart()
    begin
        BindSubscription(gmdlUnpostedEntriesManagement);
        gtmpGLEntry.Reset();
        gtmpGLEntry.DeleteAll();
    end;


    procedure lfcnFinish()
    begin
        UnbindSubscription(gmdlUnpostedEntriesManagement);
    end;

    [TryFunction]
    local procedure lfcnCallPreview(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lmdlGenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        //lmdlGenJnlPostBatch.Preview(precGenJournalLine);
        Error(''); // Just in case
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterInsertEvent', '', false, false)]
    local procedure levtOnAfterInsertGLEntry(var Rec: Record "G/L Entry"; RunTrigger: Boolean)
    begin
        gtmpGLEntry := Rec;
        gtmpGLEntry."Document No." := '***';
        if not gtmpGLEntry.Insert() then;
    end;


    procedure lfcnShowUnpostedEntries(var precGenJournalLine: Record "Gen. Journal Line")
    var
        lpagUnpostedBalance: Page "Un-posted Balance";
    begin
        lpagUnpostedBalance.SetGenJnlLine(precGenJournalLine, gtmpGLEntry);
        lpagUnpostedBalance.Run();
    end;
}

