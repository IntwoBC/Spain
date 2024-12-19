pageextension 50111 pageextension50111 extends "Vendor List"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        addafter("Base Calendar Code")
        {
            // field("Balance (LCY)"; Rec."Balance (LCY)")
            // {
            //     ApplicationArea = All;
            // }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Change field.';
            }
        }
    }
}

