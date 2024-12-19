page 60047 "Global File Storage"
{
    PageType = List;
    SourceTable = "Global File Storage";
    ApplicationArea = All;
    UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("File Name"; Rec."File Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Attachment")
            {
                Caption = '&Attachment';
                Image = Attachments;
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    Enabled = gblnIsEditable;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Import action.';


                    trigger OnAction()
                    begin
                        //gfcnImport;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Enabled = gblnIsEditable;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the E&xport action.';


                    trigger OnAction()
                    begin
                        //gfcnExport;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Ellipsis = true;
                    Enabled = gblnIsEditable;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Remove action.';


                    trigger OnAction()
                    begin
                        // gfcnRemove;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        gblnIsEditable := CurrPage.Editable;
    end;

    var
        //
        gblnIsEditable: Boolean;
}

