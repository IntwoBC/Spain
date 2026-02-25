pageextension 50002 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    actions
    {
        addlast("Ent&ry")
        {
            action("FN - Det. Customer Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'FN - Det. Customer Ledger Entries';
                Image = View;
                RunObject = Page "Detailed Cust.ledg.Entries";
                RunPageLink = "Cust. Ledger Entry No." = field("Entry No."),
                                  "Customer No." = field("Customer No.");
                RunPageView = sorting("Cust. Ledger Entry No.", "Posting Date");
                ToolTip = 'View a summary of the all posted entries and adjustments related to a specific customer ledger entry';
            }
        }
    }
}
