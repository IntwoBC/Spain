pageextension 50127 pageextension50127 extends "Cash Flow Worksheet"
{
    // T107800 001 06/04/2021 AMH : Code CC1 dimension name
    //                              * Add field 50000 - Corp. GL Acc. No.
    //                              * Add field 50001 - Corp. GL Acc. Name
    // 
    // SUP:ISSUE:108784  06/05/2021 COSMO.ABT
    //    # Show three fields "Company Name", "Country Name" and "Currency Code".
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("Corp. GL Acc. No."; Rec."Corp. GL Acc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Corp. GL Acc. No. field.';
            }
            field("Company Name"; Rec."Company Name")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Name field.';
            }
            field("Currency Code"; Rec."Currency Code")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Code field.';
            }
        }
    }
}

