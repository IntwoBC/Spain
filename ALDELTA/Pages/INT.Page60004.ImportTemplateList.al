page 60004 "Import Template List"
{
    Caption = 'Import Template List';
    CardPageID = "Import Template Header";
    PageType = List;
    SourceTable = "Import Template Header";
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
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Name field.';
                }
                field("Table Caption"; Rec."Table Caption")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Caption field.';
                }
                field("File Format"; Rec."File Format")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Format field.';
                }
                field("Field Delimiter"; Rec."Field Delimiter")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field Delimiter field.';
                }
                field("Text Qualifier"; Rec."Text Qualifier")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Text Qualifier field.';
                }
                field("Decimal Symbol"; Rec."Decimal Symbol")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Decimal Symbol field.';
                }
                field("Thousand Separator"; Rec."Thousand Separator")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Thousand Separator field.';
                }
                field("Skip Header Lines"; Rec."Skip Header Lines")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Skip Header Lines field.';
                }
            }
        }
    }

    actions
    {
    }
}

