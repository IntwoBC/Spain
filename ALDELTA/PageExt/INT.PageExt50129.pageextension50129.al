pageextension 50129 pageextension50129 extends "Cash Flow Forecast Card"
{
    layout
    {
        // modify("Overdue CF Dates to Work Date")
        // {
        //     Visible = false;
        // }
        addafter("Manual Payments To")
        {
            // field("Overdue CF Dates to Work Date"; Rec."Overdue CF Dates to Work Date")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Move Overdue Cash Flow Dates to Work Date';
            //     ToolTip = 'Specifies if you want to change overdue dates to the current work date for the cash flow forecast. Choose the field if this forecast is shown in the forecast chart.';
            // }
        }
    }
    actions
    {
        addafter(CashFlowDateList)
        {
            action(CashFlowChart)
            {
                Caption = 'Cash Flow Chart';
                Ellipsis = false;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Cash Flow Forecast Chart";
                ApplicationArea = All;
                ToolTip = 'Executes the Cash Flow Chart action.';
            }
        }
    }
}

