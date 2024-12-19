pageextension 50130 pageextension50130 extends "Cash Flow Forecast Entries"
{
    // SUP:ISSUE:109077  04/05/2021 COSMO.ABT
    //    # Show two fields "Corp. GL Acc. No." and "Corp. GL Acc. Name".
    // 
    // SUP:ISSUE:108784  06/05/2021 COSMO.ABT
    //    # Show three fields "Company Name", "Country Name" and "Currency Code".
    // 
    // SUP:ISSUE:#110847  23/07/2021 COSMO.ABT
    //    # Add new action "Export Kyriba File".
    layout
    {
        addafter("Entry No.")
        {
            field("Company Name"; Rec."Company Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Name field.';
            }
            field("Country Name"; Rec."Country Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country Name field.';
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Code field.';
            }
        }
    }
    actions
    {
        addafter(ShowSource)
        {
            action("Export Kyriba File")
            {
                Caption = 'Export Kyriba File';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = XMLport "Kyriba File - Export";
                ApplicationArea = All;
                ToolTip = 'Executes the Export Kyriba File action.';
            }
        }
    }
}

