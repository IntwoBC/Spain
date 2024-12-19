page 50001 "Purchase Document Approver RC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(rolecenter)
        {
            group(Control4)
            {
                ShowCaption = false;
                part(Control2; "Purchase Document Approver Act")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

