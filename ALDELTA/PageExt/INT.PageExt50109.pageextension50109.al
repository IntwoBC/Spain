pageextension 50109 pageextension50109 extends "Sales Journal"
{
    // SUP:Ticket:#121664  09/05/2023 COSMO.ABT
    //    # Show the fields "FA Posting Type", "IBAN / Bank Account", "URL", "E-mail" and "Sales Order No.".
    // #1..7
    layout
    {
        addafter("Succeeded VAT Registration No.")
        {
            // field("Posting Group"; Rec."Posting Group")
            // {
            //     Editable = true;
            //     ApplicationArea = All;
            // }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Mail field.';
            }
        }
    }
}

