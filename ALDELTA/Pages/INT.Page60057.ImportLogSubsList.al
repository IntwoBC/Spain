page 60057 "Import Log Subs. List"
{
    Caption = 'Import Log Subform';
    Editable = false;
    PageType = ListPlus;
    SourceTable = "Import Log - Subsidiary Client";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
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
                // field(Imported; gmodDataImportManagementCommon.gfncGetNoEntriesFromImportLog(grecImportLog, Rec."Company No."))
                // {
                // ApplicationArea=all;


                //     trigger OnDrillDown()
                //     var
                //         lrecImportLog: Record "Import Log";
                //     begin
                //         lrecImportLog.Get(Rec."Import Log Entry No.");
                //         gmodDataImportManagementCommon.gfncShowEntriesFromImportLog(lrecImportLog, Rec."Company No.");
                //     end;
                // }
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lrecImportLog: Record "Import Log";
                    begin
                        if lrecImportLog.Get(Rec."Import Log Entry No.") then begin
                            PAGE.RunModal(PAGE::"Import Log Card", lrecImportLog);
                        end;
                    end;
                }
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lrecParentClient: Record "Parent Client";
                    begin
                        //IF lrecParentClient.GET("Parent Client No.") THEN
                        //  PAGE.RUNMODAL(PAGE::"Parent Client Card", lrecParentClient);
                    end;
                }
                field("Country Database Code"; Rec."Country Database Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country Database Code field.';


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // This will disable default lookup
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
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Creation Date field.';

                }
                field("First Entry Date"; Rec."First Entry Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the First Entry Date field.';

                }
                field("Last Entry Date"; Rec."Last Entry Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Entry Date field.';

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

