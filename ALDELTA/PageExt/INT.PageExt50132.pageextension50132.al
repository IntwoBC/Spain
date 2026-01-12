pageextension 50132 pageextension50132 extends "Acc. Receivables Adm. RC"
{
    layout
    {
        //moveafter(Control1900724808; Control1907692008)//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
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

