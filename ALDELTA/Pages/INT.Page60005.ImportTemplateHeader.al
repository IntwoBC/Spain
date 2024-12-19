page 60005 "Import Template Header"
{
    Caption = 'Import Template Header';
    PageType = Card;
    SourceTable = "Import Template Header";
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
                field("Field Delimiter ASCII"; Rec."Field Delimiter ASCII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Field Delimiter ASCII field.';
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
                field("Date Format"; Rec."Date Format")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Format field.';
                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';
                }
                field("XLS Worksheet No."; Rec."XLS Worksheet No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the XLS Worksheet No. field.';
                }
            }
            part(Lines; "Import Template Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Template Header Code" = FIELD(Code);
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        lchrChar: Char;
    begin
        lchrChar := Rec."Field Delimiter"[1];
        gintDelimChar := lchrChar;
    end;

    var
        gintDelimChar: Integer;
}

