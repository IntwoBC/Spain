page 60032 "WS Import Error Log"
{
    Caption = 'WS Import Error Log';
    PageType = List;
    SourceTable = "Import Error Log";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';

                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Client No. field.';

                }
                field("Country Database Code"; Rec."Country Database Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country Database Code field.';

                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';

                }
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';

                }
                field("Staging Table Entry No."; Rec."Staging Table Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Staging Table Entry No. field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Date & Time"; Rec."Date & Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date && Time field.';

                }
            }
        }
    }

    actions
    {
    }
}

