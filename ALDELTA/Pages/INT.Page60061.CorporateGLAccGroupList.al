page 60061 "Corporate G/L Acc. Group List"
{
    Caption = 'Corporate G/L Account Group List';
    PageType = List;
    SourceTable = "Corporate G/L Account Group";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Description (English)"; Rec."Description (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description (English) field.';

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Card)
            {
                Caption = 'Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Corporate G/L Acc. Group Card";
                RunPageOnRec = true;
                ShortCutKey = 'Shift+F7';
                ApplicationArea = all;
                ToolTip = 'Executes the Card action.';

            }
        }
    }
}

