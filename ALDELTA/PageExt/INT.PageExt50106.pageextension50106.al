pageextension 50106 pageextension50106 extends "General Ledger Entries"
{
    // PK 22-12-21 EY-MTES0002 EY Core compatibility modifications
    // "G/L Account Name" added
    // 
    // SUP:ISSUE:#117922  24/08/2022 COSMO.ABT
    //    # Show new field "Purchase Order No.".
    layout
    {
        addafter("Period Trans. No.")
        {
            // field("Source Type"; Rec."Source Type")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            // }
            // field("Source No."; Rec."Source No.")
            // {
            //     Editable = false;
            //     ApplicationArea = All;
            // }
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the System-Created Entry field.';
            }
        }
    }
}

