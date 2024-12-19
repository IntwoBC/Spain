pageextension 50125 pageextension50125 extends "Detailed Vendor Ledg. Entries"
{
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Field added:
    //   - Applied by Batch Job
    layout
    {
        addafter("Vendor Ledger Entry No.")
        {
            field("Applied by Batch Job"; Rec."Applied by Batch Job")
            {
                Description = 'EY-MYES0004';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applied by Batch Job field.';
            }
        }
    }
}

