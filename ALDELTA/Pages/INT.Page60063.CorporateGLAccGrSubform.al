page 60063 "Corporate G/L Acc. Gr. Subform"
{
    AutoSplitKey = true;
    Caption = 'Corporate G/L Acc. Gr. Subform';
    PageType = ListPart;
    SourceTable = "Corporate G/L Account Gr. Line";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Corporate G/L Account Filter"; Rec."Corporate G/L Account Filter")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account Filter field.';

                }
            }
        }
    }

    actions
    {
    }
}

