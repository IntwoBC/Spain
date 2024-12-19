page 60033 "WS Gen Jnl Line Stg"
{
    Caption = 'WS Gen Jnl Line Stg';
    PageType = List;
    SourceTable = "Gen. Journal Line (Staging)";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Type field.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT % field.';

                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';

                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Factor field.';

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';

                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the External Document No. field.';

                }
                field("VAT Code"; Rec."VAT Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';

                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';

                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Business Unit field.';

                }
                field("Debit/Credit Indicator"; Rec."Debit/Credit Indicator")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Debit/Credit Indicator field.';

                }
                field("Additional Curr Amnt"; Rec."Additional Curr Amnt")
                {
                    Caption = '<Additional Curr Amount>';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the <Additional Curr Amount> field.';

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
                field("GAAP Adjmt Reason"; Rec."GAAP Adjmt Reason")
                {
                    Caption = '<GAAP Adjmt Reason>';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the <GAAP Adjmt Reason> field.';

                }
                field("Adjustment Role"; Rec."Adjustment Role")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Adjustment Role field.';

                }
                field("Tax Adjmt Reason"; Rec."Tax Adjmt Reason")
                {
                    Caption = '<Tax Adjmt Reason>';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the <Tax Adjmt Reason> field.';

                }
                field("Equity Corr Code"; Rec."Equity Corr Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Equity Corr Code field.';

                }
                field("Shortcut Dim 1 Code"; Rec."Shortcut Dim 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dim 1 Code field.';

                }
                field("Client Entry No."; Rec."Client Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Client Entry No. field.';

                }
                field("Description (English)"; Rec."Description (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description (English) field.';

                }
            }
        }
    }

    actions
    {
    }
}

