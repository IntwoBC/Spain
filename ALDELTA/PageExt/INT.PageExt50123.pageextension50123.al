pageextension 50123 pageextension50123 extends "Depreciation Book Card"
{
    layout
    {
        addafter("Fiscal Year 365 Days")
        {
            field("Allow Acq. Cost below Zero"; Rec."Allow Acq. Cost below Zero")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Acq. Cost below Zero field.';
            }
        }
    }
}

