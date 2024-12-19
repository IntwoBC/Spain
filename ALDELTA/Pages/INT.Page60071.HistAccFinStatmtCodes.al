page 60071 "Hist. Acc. Fin. Statmt. Codes"
{
    Caption = 'Historic G/L Account Financial Statement Codes';
    DataCaptionFields = "G/L Account No.";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Hist. Acc. Fin. Statmt. Code";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code field.';
                }
            }
        }
    }

    actions
    {
    }
}

