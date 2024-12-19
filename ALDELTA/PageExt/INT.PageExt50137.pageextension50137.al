pageextension 50137 pageextension50137 extends Users
{
    layout
    {
        addafter("License Type")
        {
            field("Contact Email"; Rec."Contact Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the user''s email address.';
            }
        }
    }
}

