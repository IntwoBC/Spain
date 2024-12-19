page 60013 "Import Log Card"
{
    Caption = 'Import Log Card';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Import Log";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Import Date"; Rec."Import Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Date field.';
                }
                field("Import Time"; Rec."Import Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Time field.';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';
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
                //                 field(Imported; gmodDataImportManagementCommon.gfncGetNoEntriesFromImportLog(Rec, ''))
                //                 {
                //                     Editable = false;
                //  ApplicationArea=all;
                //                     trigger OnDrillDown()
                //                     begin
                //                         gmodDataImportManagementCommon.gfncShowEntriesFromImportLog(Rec, '');
                //                     end;
                //                 }
            }
            part("Subsidiary Clients"; "Import Log Subform")
            {
                Caption = 'Subsidiary Clients';
                SubPageLink = "Import Log Entry No." = FIELD("Entry No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000009>")
            {
                Caption = 'Error Log';
                RunObject = Page "Import Error Log";
                RunPageLink = "Import Log Entry No." = FIELD("Entry No.");
                RunPageView = SORTING("Import Log Entry No.");
                ApplicationArea = all;
                ToolTip = 'Executes the Error Log action.';
            }
            separator(Action1000000015)
            {
            }
            action("<Action1000000016>")
            {
                Caption = 'Process';
                ApplicationArea = all;
                ToolTip = 'Executes the Process action.';

                trigger OnAction()
                var
                    lmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
                begin
                    lmodDataImportManagementGlobal.gfncPostImportRunConfirm(Rec, true);
                end;
            }
            separator(Action1000000004)
            {
            }
            action(Archive)
            {
                Caption = 'Archive';
                ApplicationArea = all;
                ToolTip = 'Executes the Archive action.';

                trigger OnAction()
                var
                    lmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
                begin
                    // lmodDataImportManagementGlobal.gfncArchive(Rec, true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //gfcnUpdateStagePicture(gtmpStatusColor);
    end;

    trigger OnOpenPage()
    begin
        lfcnInitStatusColor();
    end;

    var
        gtmpStatusColor: array[4] of Record "Status Color" temporary;
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

