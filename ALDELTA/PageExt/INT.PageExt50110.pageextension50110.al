pageextension 50110 pageextension50110 extends "Purchase Journal"
{
    // SUP:ISSUE:#111525  09/09/2021 COSMO.ABT
    //    # Show two fields ""IBAN / Bank Account" and "URL".
    // SUP:ISSUE:#112374  14/10/2021 COSMO.ABT
    //    # Show new field "E-mail".
    // SUP:ISSUE:#113602  14/12/2021 COSMO.ABT
    //    # Show new field "FA Posting Type".
    // SUP:ISSUE:#117922  24/08/2022 COSMO.ABT
    //    # Show new field "Purchase Order No.".
    // #1..7
    layout
    {
        moveafter("VAT Prod. Posting Group"; Amount)
    }
}

