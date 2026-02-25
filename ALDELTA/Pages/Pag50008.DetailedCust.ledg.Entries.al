page 50008 "Detailed Cust.ledg.Entries"
{
    ApplicationArea = All;
    Caption = 'FN - Det. Customer Ledger Entries';
    PageType = List;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableView = where("Entry Type" = const(Application));
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "Detailed Cust. Ledg. Entry" = rm;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    Editable = false;
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    Editable = false;
                }

                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.', Comment = '%';
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.', Comment = '%';
                    Editable = false;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.', Comment = '%';
                    Editable = false;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.', Comment = '%';
                    Editable = false;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ToolTip = 'Specifies the value of the Initial Entry Due Date field.', Comment = '%';
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
                    Editable = false;
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    ToolTip = 'Specifies the value of the Initial Document Type field.', Comment = '%';
                    Editable = true;
                }
                field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Cust. Ledger Entry No. field.', Comment = '%';
                    Editable = false;
                }
                field("Applied by Batch Job"; Rec."Applied by Batch Job")
                {
                    ToolTip = 'Specifies the value of the Applied by Batch Job field.';
                    Editable = false;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ToolTip = 'Specifies the value of the Document Status field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
}
