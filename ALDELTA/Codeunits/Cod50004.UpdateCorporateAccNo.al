codeunit 50004 UpdateCorporateAccNo
{
    Permissions = tabledata "G/L Entry" = RIMD;

    trigger OnRun()
    var
        GLEntry: Record "G/L Entry";
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        GLEntry.SetFilter("Corporate G/L Account No.", '');
        if GLEntry.FindSet() then
            repeat
                lrecCorpGLAcc.SetCurrentKey("Local G/L Account No.");
                lrecCorpGLAcc.SetRange("Local G/L Account No.", GLEntry."G/L Account No.");
                if lrecCorpGLAcc.FindFirst then begin
                    GLEntry."Corporate G/L Account No." := lrecCorpGLAcc."No.";
                    GLEntry.Modify();
                end;
            until GLEntry.Next() = 0;
    end;
}