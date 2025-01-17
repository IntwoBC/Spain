codeunit 50003 UpdateNewGLEntry
{
    trigger OnRun()
    var
        I2IGLentry: Record "I2I G/L Entry";
        GLEntry: Record "G/L Entry";
        LastProcessedEntryNo: Integer;
    begin
        if I2IGLentry.FindLast() then
            LastProcessedEntryNo := I2IGLentry."Entry No."
        else
            LastProcessedEntryNo := 0; // No entries processed yet

        GLEntry.SetFilter("Entry No.", '>=%1', LastProcessedEntryNo + 1);

        if GLEntry.FindSet() then
            repeat
                I2IGLentry.Init();
                I2IGLentry.TransferFields(GLEntry);
                I2IGLentry."Entry No." := GLEntry."Entry No.";
                I2IGLentry.Insert();
            until GLEntry.Next() = 0;
    end;
}