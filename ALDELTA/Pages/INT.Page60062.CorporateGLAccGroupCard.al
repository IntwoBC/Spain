page 60062 "Corporate G/L Acc. Group Card"
{
    Caption = 'Corporate G/L Account Group Card';
    PageType = Card;
    SourceTable = "Corporate G/L Account Group";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(General)
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
            part(Lines; "Corporate G/L Acc. Gr. Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Corp. G/L Account Group Code" = FIELD(Code);
                ApplicationArea = all;

            }
        }
    }

    actions
    {
    }
}

