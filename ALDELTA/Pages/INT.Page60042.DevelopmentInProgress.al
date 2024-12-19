page 60042 "Development In Progress"
{
    Caption = 'Development In Progress';
    Editable = false;
    PageType = List;
    SourceTable = "Standard Text";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Description := '***** TO BE DEVELOPED *****';
        Rec.Insert();
    end;
}

