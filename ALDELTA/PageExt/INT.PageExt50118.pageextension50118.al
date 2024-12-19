pageextension 50118 pageextension50118 extends "Reminder List"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Reminder Level"; Rec."Reminder Level")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reminder''s level.';
            }
        }
    }
}

