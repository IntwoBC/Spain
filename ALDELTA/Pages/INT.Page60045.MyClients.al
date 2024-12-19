page 60045 "My Clients"
{
    Caption = 'My Clients';
    PageType = List;
    SourceTable = "My Client";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';

                }
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';

                }
                field("Parent Client Name"; Rec."Parent Client Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client Name field.';

                }
            }
        }
    }

    actions
    {
    }
}

