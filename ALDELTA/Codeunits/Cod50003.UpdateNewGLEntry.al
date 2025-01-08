codeunit 50003 UpdateNewGLEntry
{
    trigger OnRun()
    var
        I2IGLentry: Record "I2I G/L Entry";
        GLEntry: Record "G/L Entry";
    begin
        Clear(GLEntry);
        Clear(I2IGLentry);
        GLEntry.SetFilter("Entry No.", '<>%1', 0);

        if GLEntry.FindSet() then
            repeat
                if not I2IGLentry.Get(GLEntry."Entry No.") then begin
                    I2IGLentry.Init();
                    I2IGLentry.TransferFields(GLEntry);
                    I2IGLentry."Entry No." := GLEntry."Entry No."; // Ensure Entry No. is set
                    I2IGLentry.Insert();
                end;
            until GLEntry.Next() = 0;
    end;

}