pageextension 50107 pageextension50107 extends "Customer List"
{
    layout
    {
        // modify("Balance (LCY)")
        // {
        //     Visible = false;
        // }
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
        }
        addafter("Base Calendar Code")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Balance field.';
            }
            // field("Balance (LCY)"; Rec."Balance (LCY)")
            // {
            //     ApplicationArea = All;
            // }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Change field.';
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Change (LCY) field.';
            }
        }
    }
}

