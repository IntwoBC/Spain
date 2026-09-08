pageextension 50105 pageextension50105 extends "G/L Account Card"
{
    layout
    {
        //  Ticket ID:-74794,# financial statement code + direct posting blocked as yes
        // modify("Direct Posting")
        // {
        //     Editable = false;
        // }

        addlast(Reporting)
        {
            // field("Financial Statement Code";Rec."Financial Statement Code")
            // {
            //     Caption='Financial Statement Code';
            //     ApplicationArea = All;
            // }
        }
    }
}



