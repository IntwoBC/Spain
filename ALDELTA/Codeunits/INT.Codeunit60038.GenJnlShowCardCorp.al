codeunit 60038 "Gen. Jnl.-Show Card-Corp."
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        if Rec."Account Type" = Rec."Account Type"::"G/L Account" then begin
            grecCorpGLAcc."No." := Rec."Corporate G/L Account No.";
            PAGE.Run(PAGE::"Corporate G/L Account Card", grecCorpGLAcc);
        end else
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", Rec);
    end;

    var
        grecCorpGLAcc: Record "Corporate G/L Account";
}

