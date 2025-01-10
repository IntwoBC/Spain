pageextension 50001 TableMapping extends "Migration Table Mapping"
{
    layout
    {
        addafter("Extension Name")
        {
            field("Target Table Type"; Rec."Target Table Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
