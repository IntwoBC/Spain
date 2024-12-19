page 60006 "Import Template Subform"
{
    Caption = 'Import Template Subform';
    PageType = ListPart;
    SourceTable = "Import Template Line";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Column; Rec.Column)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Column field.';
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field ID field.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field Name field.';
                }
            }
        }
    }

    actions
    {
    }
}

