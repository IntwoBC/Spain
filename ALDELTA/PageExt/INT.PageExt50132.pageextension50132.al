pageextension 50132 pageextension50132 extends "Acc. Receivables Adm. RC"
{
    layout
    {
        moveafter(Control1900724808; Control1907692008)
    }
    actions
    {
        addafter("C&ustomer")
        {
            action("<Report Create Reminders>")
            {
                Caption = 'Create Reminders';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
                ApplicationArea = All;
                ToolTip = 'Executes the Create Reminders action.';
            }
            action("<Page Issued Reminders>")
            {
                Caption = 'Issued Reminders';
                Ellipsis = true;
                Image = Archive;
                RunObject = Page "Issued Reminder List";
                ApplicationArea = All;
                ToolTip = 'Executes the Issued Reminders action.';
            }
            action("<Report Statement>")
            {
                Caption = 'Statement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Codeunit "Customer Layout - Statement";
                ApplicationArea = All;
                ToolTip = 'Executes the Statement action.';
            }
        }
    }
}

