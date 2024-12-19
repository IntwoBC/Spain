page 60037 "WS Vendor Stg"
{
    Caption = 'WS Vendor Stg';
    PageType = List;
    SourceTable = "Vendor (Staging)";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Address field.';

                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Address 2 field.';

                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the City field.';

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';

                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';

                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay-to Vendor No. field.';

                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';

                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Post Code field.';

                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Liable field.';

                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';

                }
                field("Payables Account"; Rec."Payables Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payables Account field.';

                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';

                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Client No. field.';

                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';

                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';

                }
            }
        }
    }

    actions
    {
    }
}

