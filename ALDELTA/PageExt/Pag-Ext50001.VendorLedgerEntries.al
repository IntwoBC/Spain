pageextension 50001 VendorLedgerEntries extends "Vendor Ledger Entries"
{
    actions
    {
        addlast(navigation)
        {
            action("Custom. Det. Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Custom Det. Ledger Entries';
                Image = View;
                RunObject = Page "Cust. Det. Vend Ledg Entries";
                RunPageLink = "Vendor Ledger Entry No." = field("Entry No."),
                                  "Vendor No." = field("Vendor No.");
                RunPageView = sorting("Vendor Ledger Entry No.", "Posting Date");
                //Scope = Repeater;
                ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry';
            }
        }
    }
}
