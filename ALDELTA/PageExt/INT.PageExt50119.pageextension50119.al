pageextension 50119 pageextension50119 extends "Issued Reminder List"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Reminder Level"; Rec."Reminder Level")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reminder''s level.';
            }
        }
    }
}

