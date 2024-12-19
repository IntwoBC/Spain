page 60018 "My Import Log"
{
    // MP 12-11-12
    // Added parameter to function call in Action Process
    // 
    // MP 30-04-14
    // Development taken from Core II

    Caption = 'My Import Log';
    CardPageID = "Import Log Card";
    PageType = ListPart;
    SourceTable = "Import Log";
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
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';
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
                field(Status; Rec.Status)
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Picture (Stage-File Import)"; Rec."Picture (Stage-File Import)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Import field.';
                }
                field("Picture (Stage-Post Imp. Va)"; Rec."Picture (Stage-Post Imp. Va)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Validation field.';
                }
                field(Errors; Rec.Errors)
                {
                    HideValue = gblnHideValueErrors;
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Errors field.';
                }
                // field(Imported; gmodDataImportManagementCommon.gfncGetNoEntriesFromImportLog(Rec, ''))
                // {
                //     //BlankZero = true;
                //     ApplicationArea = all;

                //     trigger OnDrillDown()
                //     begin
                //         gmodDataImportManagementCommon.gfncShowEntriesFromImportLog(Rec, '');
                //     end;
                // }
                field("File Name"; Rec."File Name")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnError;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action2>")
            {
                Caption = 'Open';
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ApplicationArea = all;
                ToolTip = 'Executes the Open action.';

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"Import Log Card", Rec);
                end;
            }
            action("Error Log")
            {
                Caption = 'Error Log';
                Image = ErrorLog;
                RunObject = Page "Import Error Log";
                RunPageLink = "Import Log Entry No." = FIELD("Entry No.");
                RunPageView = SORTING("Import Log Entry No.");
                ApplicationArea = all;
                ToolTip = 'Executes the Error Log action.';
            }
            action(Process)
            {
                Caption = 'Process';
                Image = PostDocument;
                ApplicationArea = all;
                ToolTip = 'Executes the Process action.';

                trigger OnAction()
                var
                    lmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
                begin
                    lmodDataImportManagementGlobal.gfncPostImportRun(Rec, true, true); // MP 12-11-12 Added third parameter to call (new parameter)
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Picture (Status)" := gtmpStatusColor[Rec.Status + 1].Picture;

        gblnError := Rec.Status = Rec.Status::Error;
        //gfcnUpdateStagePicture(gtmpStatusColor);

        gblnHideValueErrors := ((Rec.Status = Rec.Status::Processed) and (Rec.Stage = Rec.Stage::"Record Creation/Update/Posting"));
    end;

    trigger OnOpenPage()
    begin
        lfcnInitStatusColor();
        Rec.SetRange("User ID", UserId);
        if Rec.FindFirst() then;
    end;

    var
        //gmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        gtmpStatusColor: array[4] of Record "Status Color" temporary;

        gblnError: Boolean;

        gblnHideValueErrors: Boolean;

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

