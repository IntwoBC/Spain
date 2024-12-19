page 80003 "SII Session Mod"
{
    PageType = List;
    SourceTable = "SII Session";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field("Request XML"; Rec."Request XML")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request XML field.';
                }
                field("Response XML"; Rec."Response XML")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Response XML field.';
                }
            }
        }
    }

    actions
    {
    }
}

