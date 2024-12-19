page 60014 "Import Log Subform"
{
    Caption = 'Import Log Subform';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Import Log - Subsidiary Client";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //
                    end;
                }
                field("Country Database Code"; Rec."Country Database Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country Database Code field.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //
                    end;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field("Picture (Stage-Data Transfer)"; Rec."Picture (Stage-Data Transfer)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Data Transfer field.';
                }
                field("Picture (Stage-Data Validat.)"; Rec."Picture (Stage-Data Validat.)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Data Validation field.';
                }
                field("Picture (Stage-Rec. CreUpdPos)"; Rec."Picture (Stage-Rec. CreUpdPos)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Record Create/Update/Posting field.';
                }
                field("TB to TB client"; Rec."TB to TB client")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TB to TB client field.';
                }
                // field(Imported; gmodDataImportManagementCommon.gfncGetNoEntriesFromImportLog(grecImportLog, Rec."Company No."))
                // {
                //    ApplicationArea=all;
                //     trigger OnDrillDown()
                //     begin
                //         gmodDataImportManagementCommon.gfncShowEntriesFromImportLog(grecImportLog, Rec."Company No.");
                //     end;
                // }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //gfcnUpdateStagePicture(gtmpStatusColor);
        grecImportLog.Get(Rec."Import Log Entry No.");
    end;

    trigger OnOpenPage()
    begin
        lfcnInitStatusColor();
    end;

    var
        gtmpStatusColor: array[4] of Record "Status Color" temporary;
        grecImportLog: Record "Import Log";
       // gmodDataImportManagementCommon: Codeunit "Data Import Management Common";

    local procedure lfcnInitStatusColor()
    var
        lrecStatusColor: Record "Status Color";
    begin
        lrecStatusColor.FindSet();
        repeat
            lrecStatusColor.CalcFields(Picture);
            gtmpStatusColor[lrecStatusColor.Status + 1] := lrecStatusColor;
            gtmpStatusColor[lrecStatusColor.Status + 1].Insert();
        until lrecStatusColor.Next() = 0;
    end;
}

