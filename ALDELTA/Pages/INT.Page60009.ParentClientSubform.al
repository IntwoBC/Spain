page 60009 "Parent Client Subform"
{
    Caption = 'Subsidiary Clients';
    PageType = ListPart;
    SourceTable = "Subsidiary Client";
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
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';
                }
                field("G/L Detail level"; Rec."G/L Detail level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Detail level field.';
                }
                field("Statutory Reporting"; Rec."Statutory Reporting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statutory Reporting field.';
                }
                field("Corp. Tax Reporting"; Rec."Corp. Tax Reporting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corp. Tax Reporting field.';
                }
                field("VAT Reporting level"; Rec."VAT Reporting level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Reporting level field.';
                }
            }
        }
    }

    actions
    {
    }
}

