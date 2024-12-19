codeunit 60037 "Gen. Jnl.-Show Entries-Corp."
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
            grecGLEntry.SetCurrentKey("Corporate G/L Account No.", "Posting Date");
            grecGLEntry.SetRange("Corporate G/L Account No.", Rec."Corporate G/L Account No.");
            if grecGLEntry.FindLast() then;
            PAGE.Run(PAGE::"General Ledger Entries", grecGLEntry);
        end else
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", Rec);
    end;

    var
        grecGLEntry: Record "G/L Entry";
}

