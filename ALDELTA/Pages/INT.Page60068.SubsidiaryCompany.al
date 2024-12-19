page 60068 "Subsidiary Company"
{
    Caption = 'Subsidiary Company';
    PageType = List;
    SourceTable = "Subsidiary Company";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
            }
        }
    }

    actions
    {
    }
}

