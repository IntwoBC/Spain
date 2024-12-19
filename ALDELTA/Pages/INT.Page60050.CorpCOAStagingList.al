page 60050 "Corp COA (Staging) List"
{
    Caption = 'Corp COA (Staging) List';
    PageType = List;
    SourceTable = "Corporate G/L Acc (Staging)";
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
                field("Income/Balance"; Rec."Income/Balance")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

                }
                field("Gen. Bus. Posting Type"; Rec."Gen. Bus. Posting Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Posting Type field.';

                }
                field("Accounting Class"; Rec."Accounting Class")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accounting Class field.';

                }
                field("Name - ENU"; Rec."Name - ENU")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name - ENU field.';

                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code field.';

                }
                field("Local Chart Of Acc (Mapped)"; Rec."Local Chart Of Acc (Mapped)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Local Chart Of Acc (Mapped) field.';

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

