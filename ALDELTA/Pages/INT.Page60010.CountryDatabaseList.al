page 60010 "Country Database List"
{
    // MP 26-11-14
    // NAV 2013 R2 Upgrade - added field "Tenant Id"

    Caption = 'Country Database List';
    CardPageID = "Country Database Card";
    PageType = List;
    SourceTable = "Country Database";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Country Database Code"; Rec."Country Database Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country Database Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Server Address (Web Service)"; Rec."Server Address (Web Service)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Server Address (Web Service) field.';
                }
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tenant Id field.';
                }
            }
        }
    }

    actions
    {
    }
}

