page 60028 "Gen. Journal Line List"
{
    Caption = 'Gen. Journal Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Gen. Journal Line";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Template Name field.';

                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';

                }
                field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the account type, such as Customer.';

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the account number of the customer/vendor.';

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies when the journal line will be posted.';

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of document in question.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the document in a posted bill group/payment order, from which this document was generated.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the record.';

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total on the journal line.';

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total amount on the journal line in LCY.';

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
                field("Tax Adjustment Reason"; Rec."Tax Adjustment Reason")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Adjustment Reason field.';

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a code for the business unit, in case the company is part of a group.';

                }
                field("Bal. Corporate G/L Account No."; Rec."Bal. Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bal. Corporate G/L Account No. field.';

                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';

                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted.';

                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action29>")
            {
                Caption = 'Open Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Open Journal action.';


                trigger OnAction()
                var
                    lrecGenJnlBatch: Record "Gen. Journal Batch";
                    lmdlGenJnlMgt: Codeunit GenJnlManagement;
                begin
                    lrecGenJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                    lmdlGenJnlMgt.TemplateSelectionFromBatch(lrecGenJnlBatch);
                end;
            }
        }
    }
}

