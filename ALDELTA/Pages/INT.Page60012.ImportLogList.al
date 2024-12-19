page 60012 "Import Log List"
{
    Caption = 'Import Log List';
    CardPageID = "Import Log Card";
    Editable = false;
    PageType = List;
    SourceTable = "Import Log";
    SourceTableView = ORDER(Descending);
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Picture (Status)"; Rec."Picture (Status)")
                {
                    Caption = '^';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';
                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
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
                field("Table Caption"; Rec."Table Caption")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Caption field.';
                }
                field("File Name"; Rec."File Name")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(Status; Rec.Status)
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Errors; Rec.Errors)
                {
                    HideValue = gblnHideValueErrors;
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Errors field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                // field(Imported; gmodDataImportManagementCommon.gfncGetNoEntriesFromImportLog(Rec, ''))
                // {
                //     ApplicationArea = all;

                //     trigger OnDrillDown()
                //     begin
                //         gmodDataImportManagementCommon.gfncShowEntriesFromImportLog(Rec, '');
                //     end;
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Error Log")
            {
                Caption = 'Error Log';
                RunObject = Page "Import Error Log";
                RunPageLink = "Import Log Entry No." = FIELD("Entry No.");
                RunPageView = SORTING("Import Log Entry No.");
                ToolTip = 'Executes the Error Log action.';
            }
            separator(Action1000000015)
            {
            }
            action("<Action1000000016>")
            {
                Caption = 'Process';
                ToolTip = 'Action for data import';

                trigger OnAction()
                var
                    lmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
                begin
                    lmodDataImportManagementGlobal.gfncPostImportRunConfirm(Rec, true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Status <> TempgtmpStatusColor.Status then begin
            TempgtmpStatusColor.Get(Rec.Status);
            TempgtmpStatusColor.CalcFields(Picture);
        end;

        Rec."Picture (Status)" := TempgtmpStatusColor.Picture;

        gblnError := Rec.Status = Rec.Status::"In Progress";
        gblnHideValueErrors := ((Rec.Status = Rec.Status::Processed) and (Rec.Stage = Rec.Stage::"Record Creation/Update/Posting"));
        //gblnHideValueErrors := 'TRUE';
    end;

    trigger OnInit()
    begin
        gblnHideValueErrors := false;
    end;

    trigger OnOpenPage()
    begin
        if Rec.FindFirst() then;
        lfcnInitStatusColor();
    end;

    var
        TempgtmpStatusColor: Record "Status Color" temporary;

        gblnError: Boolean;
        //gmodDataImportManagementCommon: Codeunit "Data Import Management Common";

        gblnHideValueErrors: Boolean;

    local procedure lfcnInitStatusColor()
    var
        lrecStatusColor: Record "Status Color";
    begin
        lrecStatusColor.FindSet();
        repeat
            lrecStatusColor.CalcFields(Picture);
            TempgtmpStatusColor := lrecStatusColor;
            TempgtmpStatusColor.Insert();
        until lrecStatusColor.Next() = 0;
    end;


    procedure lfncImportedEntries(): Integer
    begin
        exit(10);
    end;
}

