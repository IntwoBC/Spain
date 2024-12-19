codeunit 60025 "Toggle Mark GAAP/Tax Reversal"
{
    // MP 04-12-15
    // Fixed issue of not allowing to mark the very first adjustment entry (CB1 Enhancements)

    Permissions = TableData "G/L Entry" = rm;
    TableNo = "G/L Entry";

    trigger OnRun()
    var
        lrecGLEntry: Record "G/L Entry";
    begin
        Rec.TestField(Rec."Global Dimension 1 Code");
        Rec.TestField(Rec."Reversed at", 0D);

        if not Confirm(StrSubstNo(txtConfirmToggleReversal, Rec.FieldCaption(Rec."Document No."), Rec."Document No.",
         Rec.FieldCaption(Rec."Posting Date"), Rec."Posting Date"))
        then
            exit;

        lrecGLEntry.SetCurrentKey("Document No.", "Posting Date");
        lrecGLEntry.SetRange("Document No.", Rec."Document No.");
        lrecGLEntry.SetRange("Posting Date", Rec."Posting Date");
        lrecGLEntry.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code"); // MP 04-12-15

        lrecGLEntry.FindSet();
        repeat
            lrecGLEntry.TestField("Global Dimension 1 Code");
            lrecGLEntry.TestField("Reversed at", 0D);

            lrecGLEntry.Validate(Reversible, not Rec.Reversible);
            lrecGLEntry.Modify();
        until lrecGLEntry.Next() = 0;
    end;

    var
        txtConfirmToggleReversal: Label 'This will mark/un-mark all entries with %1 %2 and %3 %4 for reversal.\\Are you sure you want to continue?';
}

