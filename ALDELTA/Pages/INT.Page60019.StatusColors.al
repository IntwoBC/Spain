page 60019 "Status Colors"
{
    Caption = 'Status Colors';
    Editable = false;
    PageType = List;
    SourceTable = "Status Color";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
            }
        }
    }

    actions
    {
    }
}

