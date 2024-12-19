page 60065 "Gen. Journal Line (Processed)"
{
    Caption = 'Gen. Journal Line (Processed)';
    PageType = List;
    SourceTable = "Gen. Journal Line (Processed)";
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
                field("Debit/Credit Indicator"; Rec."Debit/Credit Indicator")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Debit/Credit Indicator field.';

                }
                field("Additional Curr Amnt"; Rec."Additional Curr Amnt")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Additional Currency Amount field.';

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

