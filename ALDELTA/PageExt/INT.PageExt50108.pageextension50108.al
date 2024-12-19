pageextension 50108 pageextension50108 extends "Customer Ledger Entries"
{
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Action added
    //   - Batch Application
    layout
    {
        addafter("Direct Debit Mandate ID")
        {
            field("Closed by Amount (LCY)"; Rec."Closed by Amount (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Closed by Amount (LCY) field.';
            }
        }
    }
    actions
    {
        addafter("Apply Entries")
        {
            action("Batch Application")
            {
                Caption = 'Batch Application';
                Description = 'EY-MYES0004';
                Image = ApplyEntries;
                ApplicationArea = All;
                ToolTip = 'Executes the Batch Application action.';

                trigger OnAction()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    // EY-MYES0004 >>
                    CustLedgEntry.SetRange("Customer No.", Rec."Customer No.");
                    REPORT.Run(REPORT::"Batch Appl. Customer Entries", true, true, CustLedgEntry);
                    // EY-MYES0004 <<
                end;
            }
        }
    }
}

