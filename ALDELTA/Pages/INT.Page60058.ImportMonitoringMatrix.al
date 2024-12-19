page 60058 "Import Monitoring Matrix"
{
    Caption = 'Import Monitoring Matrix';
    CardPageID = "Import Log Subs. List";
    DataCaptionExpression = Rec.Name;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = "Interface Type Buffer";
    SourceTableTemporary = true;
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field("<gcodParentClientNo>"; gcodParentClientNo)
                {
                    Caption = 'Parent Client';
                    Editable = gblnParentEditable;
                    TableRelation = "Parent Client"."No.";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client field.';


                    trigger OnValidate()
                    begin
                        gcodSubsidiaryClientNo := '';
                        gfncUpdateFilters();
                        CurrPage.Update(false);
                    end;
                }
                field(gcodSubsidiaryClientNo; gcodSubsidiaryClientNo)
                {
                    Caption = 'Subsidiary Client';
                    TableRelation = "Subsidiary Client"."Company No." WHERE("Parent Client No." = FIELD("Parent Client"));
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Subsidiary Client field.';

                    trigger OnValidate()
                    begin
                        gfncUpdateFilters();
                        CurrPage.Update(false);
                    end;
                }
                field(goptPeriodType; goptPeriodType)
                {
                    Caption = 'Period Type';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Period Type field.';


                    trigger OnValidate()
                    begin
                        gdatStartDate := gmodImportMonitoringViewMgt.gfncGetPeriodDate(goptPeriodType, gdatStartDate, 0, false);
                        gfncUpdateFilters();
                        gfncUpdateHeaders();
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Group)
            {
                Caption = 'Monitor';
                FreezeColumn = Name;
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field(Status_01; Rec.Status_01)
                {
                    Caption = '^';
                    ApplicationArea = all;

                    Editable = false;
                    ToolTip = 'Specifies the value of the ^ field.';

                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(1);
                    end;
                }
                field(Details_01; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[1];
                    Caption = 'Details_01';
                    Editable = false;
                    HideValue = gblnHideValue_01;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_01 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(1);
                    end;
                }
                field(Status_02; Rec.Status_02)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(2);
                    end;
                }
                field(Details_02; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[2];
                    Caption = 'Details_02';
                    Editable = false;
                    HideValue = gblnHideValue_02;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_02 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(2);
                    end;
                }
                field(Status_03; Rec.Status_03)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(3);
                    end;
                }
                field(Details_03; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[3];
                    Caption = 'Details_03';
                    Editable = false;
                    HideValue = gblnHideValue_03;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_03 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(3);
                    end;
                }
                field(Status_04; Rec.Status_04)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(4);
                    end;
                }
                field(Details_04; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[4];
                    Caption = 'Details_04';
                    Editable = false;
                    HideValue = gblnHideValue_04;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_04 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(4);
                    end;
                }
                field(Status_05; Rec.Status_05)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(5);
                    end;
                }
                field(Details_05; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[5];
                    Caption = 'Details_05';
                    Editable = false;
                    HideValue = gblnHideValue_05;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_05 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(5);
                    end;
                }
                field(Status_06; Rec.Status_06)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(6);
                    end;
                }
                field(Details_06; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[6];
                    Caption = 'Details_06';
                    Editable = false;
                    HideValue = gblnHideValue_06;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_06 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(6);
                    end;
                }
                field(Status_07; Rec.Status_07)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(7);
                    end;
                }
                field(Details_07; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[7];
                    Caption = 'Details_07';
                    Editable = false;
                    HideValue = gblnHideValue_07;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_07 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(7);
                    end;
                }
                field(Status_08; Rec.Status_08)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(8);
                    end;
                }
                field(Details_08; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[8];
                    Caption = 'Details_08';
                    Editable = false;
                    HideValue = gblnHideValue_08;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_08 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(8);
                    end;
                }
                field(Status_09; Rec.Status_09)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(9);
                    end;
                }
                field(Details_09; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[9];
                    Caption = 'Details_09';
                    Editable = false;
                    HideValue = gblnHideValue_09;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_09 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(9);
                    end;
                }
                field(Status_10; Rec.Status_10)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(10);
                    end;
                }
                field(Details_10; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[10];
                    Caption = 'Details_10';
                    Editable = false;
                    HideValue = gblnHideValue_10;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_10 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(10);
                    end;
                }
                field(Status_11; Rec.Status_11)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(11);
                    end;
                }
                field(Details_11; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[11];
                    Caption = 'Details_11';
                    Editable = false;
                    HideValue = gblnHideValue_11;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_11 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(11);
                    end;
                }
                field(Status_12; Rec.Status_12)
                {
                    Caption = '^';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ^ field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(12);
                    end;
                }
                field(Details_12; MSG_001)
                {
                    CaptionClass = '3,' + gtxtArrPeriodHeader[12];
                    Caption = 'Details_12';
                    Editable = false;
                    HideValue = gblnHideValue_12;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Details_12 field.';


                    trigger OnDrillDown()
                    begin
                        gfncDrillDown(12);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action21>")
            {
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Previous Period action.';


                trigger OnAction()
                begin
                    gdatStartDate := gmodImportMonitoringViewMgt.gfncGetPeriodDate(goptPeriodType, gdatStartDate, -1, false);
                    //gmodImportMonitoringViewMgt.gfncMovePeriodStart(Rec, 1);
                    gfncUpdateFilters();
                    gfncUpdateHeaders();
                    CurrPage.Update();
                end;
            }
            action("<Action22>")
            {
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Next Period action.';


                trigger OnAction()
                begin
                    gdatStartDate := gmodImportMonitoringViewMgt.gfncGetPeriodDate(goptPeriodType, gdatStartDate, 1, false);
                    //gmodImportMonitoringViewMgt.gfncMovePeriodStart(Rec, 1);
                    gfncUpdateFilters();
                    gfncUpdateHeaders();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        gmodImportMonitoringViewMgt.gfncUpdateInterfaceTypeBuffRec(Rec, grecTmpArrStatusColor, gblnHasDetails);
        gfncSetDetailsVisibility();
    end;

    trigger OnInit()
    begin
        gblnParentEditable := true;
        gmodImportMonitoringViewMgt.gfcnInitStatusColor(grecTmpArrStatusColor);
        gmodImportMonitoringViewMgt.gfncPopulateInterfaceTypeBuff(Rec);
        gmodImportMonitoringViewMgt.gfncSetDefaultFilters(Rec);
    end;

    trigger OnOpenPage()
    begin
        gfncUpdateFromFilters();
        gfncUpdateHeaders();
    end;

    var
        gmodImportMonitoringViewMgt: Codeunit "Import Monitoring View Mgt";
        grecTmpArrStatusColor: array[4] of Record "Status Color" temporary;
        gcodParentClientNo: Code[20];
        gcodSubsidiaryClientNo: Code[20];
        goptPeriodType: Option Day,Week,Month,Quarter,Year;
        gdatStartDate: Date;
        gtxtArrPeriodHeader: array[12] of Text[30];

        gblnParentEditable: Boolean;
        gblnHasDetails: array[12] of Boolean;

        gblnHideValue_01: Boolean;
        MSG_001: Label 'Details';

        gblnHideValue_02: Boolean;

        gblnHideValue_03: Boolean;

        gblnHideValue_04: Boolean;

        gblnHideValue_05: Boolean;

        gblnHideValue_06: Boolean;

        gblnHideValue_07: Boolean;

        gblnHideValue_08: Boolean;

        gblnHideValue_09: Boolean;

        gblnHideValue_10: Boolean;

        gblnHideValue_11: Boolean;

        gblnHideValue_12: Boolean;
        MSG_002: Label 'There are no details available for %1, period %2';


    procedure gfncUpdateFilters()
    begin
        if gcodParentClientNo <> '' then
            Rec.SetRange("Parent Client", gcodParentClientNo)
        else
            Rec.SetRange("Parent Client");
        if gcodSubsidiaryClientNo <> '' then
            Rec.SetRange("Subsidiary Client", gcodSubsidiaryClientNo)
        else
            Rec.SetRange("Subsidiary Client");
        Rec.SetRange("Start Date", gdatStartDate);
        Rec.SetRange("Period Type", goptPeriodType);
    end;


    procedure gfncUpdateFromFilters()
    begin
        gcodParentClientNo := Rec.GetFilter("Parent Client");
        gcodSubsidiaryClientNo := Rec.GetFilter("Subsidiary Client");
        Evaluate(goptPeriodType, Rec.GetFilter("Period Type"));
        Evaluate(gdatStartDate, Rec.GetFilter("Start Date"));
    end;


    procedure gfncUpdateHeaders()
    begin
        gmodImportMonitoringViewMgt.gfncGetPeriodHeaders(gtxtArrPeriodHeader, goptPeriodType, gdatStartDate);
    end;


    procedure gfncSetParentClientFilter(p_codParentClientCode: Code[20])
    begin
        if p_codParentClientCode <> '' then begin
            Rec.SetRange("Parent Client", p_codParentClientCode);
            gblnParentEditable := false;
        end;
    end;


    procedure gfncSetDetailsVisibility()
    var
        lintCounter: Integer;
    begin
        for lintCounter := 1 to 12 do begin
            case lintCounter of
                1:
                    gblnHideValue_01 := not gblnHasDetails[lintCounter];
                2:
                    gblnHideValue_02 := not gblnHasDetails[lintCounter];
                3:
                    gblnHideValue_03 := not gblnHasDetails[lintCounter];
                4:
                    gblnHideValue_04 := not gblnHasDetails[lintCounter];
                5:
                    gblnHideValue_05 := not gblnHasDetails[lintCounter];
                6:
                    gblnHideValue_06 := not gblnHasDetails[lintCounter];
                7:
                    gblnHideValue_07 := not gblnHasDetails[lintCounter];
                8:
                    gblnHideValue_08 := not gblnHasDetails[lintCounter];
                9:
                    gblnHideValue_09 := not gblnHasDetails[lintCounter];
                10:
                    gblnHideValue_10 := not gblnHasDetails[lintCounter];
                11:
                    gblnHideValue_11 := not gblnHasDetails[lintCounter];
                12:
                    gblnHideValue_12 := not gblnHasDetails[lintCounter];
            end;
        end;
    end;


    procedure gfncDrillDown(p_intPeriod: Integer)
    begin
        if not gmodImportMonitoringViewMgt.gfncShowDetails(Rec, p_intPeriod) then
            Message(MSG_002, Rec.Name, gtxtArrPeriodHeader[p_intPeriod]);
    end;
}

