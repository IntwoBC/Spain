page 60017 "G/L Accounts (Processed)"
{
    Caption = 'Processed Staging - G/L Accounts';
    PageType = List;
    SourceTable = "G/L Account (Processed)";
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
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';
                }
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
            }
        }
    }

    actions
    {
    }
}

