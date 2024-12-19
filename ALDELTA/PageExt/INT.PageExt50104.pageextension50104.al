pageextension 50104 pageextension50104 extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
            }
        }
    }
}

