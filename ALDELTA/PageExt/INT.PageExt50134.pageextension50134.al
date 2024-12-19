pageextension 50134 pageextension50134 extends "Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
            }
        }
    }
}

