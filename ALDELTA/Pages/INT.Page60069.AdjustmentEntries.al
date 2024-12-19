page 60069 "Adjustment Entries"
{
    Caption = 'Adjustment Entries';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Adjustment Entry Buffer";
    SourceTableView = SORTING("Posting Date", "Document No.");
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';

                }
                field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field("Corporate G/L Account Name"; Rec."Corporate G/L Account Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account Name field.';

                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';

                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Account Name field.';

                }
                field("GAAP Adjustment Reason"; Rec."GAAP Adjustment Reason")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GAAP Adjustment Reason field.';

                }
                field("Adjustment Role"; Rec."Adjustment Role")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Adjustment Role field.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field("Equity Correction Code"; Rec."Equity Correction Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Equity Correction Code field.';

                }
                field("G/L Entry No."; Rec."G/L Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Entry No. field.';

                }
            }
        }
    }

    actions
    {
    }
}

