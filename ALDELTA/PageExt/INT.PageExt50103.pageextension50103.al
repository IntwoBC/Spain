pageextension 50103 pageextension50103 extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("VAT Clause Code"; Rec."VAT Clause Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Clause Code field.';
            }
        }
    }
}

