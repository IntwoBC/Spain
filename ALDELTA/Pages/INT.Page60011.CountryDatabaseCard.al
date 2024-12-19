page 60011 "Country Database Card"
{
    // MP 26-11-14
    // NAV 2013 R2 Upgrade - added field "Tenant Id"

    Caption = 'Country Database Card';
    PageType = Card;
    SourceTable = "Country Database";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            group(General)
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

