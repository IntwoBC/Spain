codeunit 60013 "Import Monitoring View Mgt"
{

    trigger OnRun()
    var
        lrecInterfaceTypeBuffer: Record "Interface Type Buffer";
        lrecTmpArrStatusColor: array[4] of Record "Status Color" temporary;
        ldatDate: Date;
        loptPeriodType: Option Day,Week,Month,Quarter,Year;
        ltxtHeaderArray: array[12] of Text[30];
    begin
        Message(Format(gfncGetPeriodDate(3, 20070401D, 2, true)));
        /*
        gfcnInitStatusColor(lrecTmpArrStatusColor);
        gfncPopulateInterfaceTypeBuff(lrecInterfaceTypeBuffer);
        lrecInterfaceTypeBuffer.SETRANGE("Parent Client", 'TEST_02');
        lrecInterfaceTypeBuffer.SETRANGE("Subsidiary Client", '9323');
        lrecInterfaceTypeBuffer.SETRANGE("Start Date", 010111D);
        lrecInterfaceTypeBuffer.SETRANGE("Period Type", lrecInterfaceTypeBuffer."Period Type"::Year);
        IF lrecInterfaceTypeBuffer.FINDSET THEN REPEAT
          gfncUpdateInterfaceTypeBuffRec(lrecInterfaceTypeBuffer, lrecTmpArrStatusColor);
        UNTIL lrecInterfaceTypeBuffer.NEXT = 0;
        */

    end;


    procedure gfncUpdateInterfaceTypeBuffRec(var p_recInterfaceTypeBuffer: Record "Interface Type Buffer"; var p_recArrStatusColor: array[4] of Record "Status Color"; var p_blnHasDetails: array[12] of Boolean)
    var
        lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
        lrecTmpStatusColor: Record "Status Color" temporary;
//lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        loptPeriodType: Option Day,Week,Month,Quarter,Year;
        lintCounter: Integer;
        lintStatus: Integer;
        lbintImportLog: BigInteger;
        ldatDate: Date;
        ldatPeriodStart: Date;
        ldatPeriodEnd: Date;
    begin
        //
        // Sets status icons on current record
        // based on status of import log in each period
        //

        Evaluate(ldatDate, p_recInterfaceTypeBuffer.GetFilter("Start Date"));
        Evaluate(loptPeriodType, p_recInterfaceTypeBuffer.GetFilter("Period Type"));
        lrecImportLogSubsidiaryClient.Reset();
        lrecImportLogSubsidiaryClient.SetCurrentKey("Parent Client No.", "Company No.", "Interface Type",
                                                    "First Entry Date", "Last Entry Date");
        if p_recInterfaceTypeBuffer.GetFilter("Parent Client") <> '' then
            p_recInterfaceTypeBuffer.CopyFilter("Parent Client", lrecImportLogSubsidiaryClient."Parent Client No.")
        else
            lrecImportLogSubsidiaryClient.SetRange("Parent Client No.");
        if p_recInterfaceTypeBuffer.GetFilter("Subsidiary Client") <> '' then
            p_recInterfaceTypeBuffer.CopyFilter("Subsidiary Client", lrecImportLogSubsidiaryClient."Company No.")
        else
            lrecImportLogSubsidiaryClient.SetRange("Company No.");
        lrecImportLogSubsidiaryClient.SetRange("Interface Type", p_recInterfaceTypeBuffer.Id);

        for lintCounter := 1 to 12 do begin
            // Period loop
            lrecTmpStatusColor.Init();
            lintStatus := -1; // Zero based
            p_blnHasDetails[lintCounter] := false;
            // Select all subsididary client Import logs
            // for Parent client, Subsidiary client, type of interface, First/Last entry within period,
            ldatPeriodStart := gfncGetPeriodDate(loptPeriodType, ldatDate, lintCounter - 1, false);
            ldatPeriodEnd := gfncGetPeriodDate(loptPeriodType, ldatDate, lintCounter - 1, true);
            // There are 4 possible scenarios how can PeriodStart, PeriodEnd, FirstEntryDate and LastEntryDate overlap
            // Current approach - if at least one EntryDate is within PeriodStart - PeriodEnd
            lrecImportLogSubsidiaryClient.SetFilter("First Entry Date", '<=%1', ldatPeriodEnd);
            lrecImportLogSubsidiaryClient.SetFilter("Last Entry Date", '>=%1', ldatPeriodStart);
            // Find last Import entry
            lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.");
            lbintImportLog := 0;
            if lrecImportLogSubsidiaryClient.FindSet() then begin
                repeat
                    if lbintImportLog < lrecImportLogSubsidiaryClient."Import Log Entry No." then
                        lbintImportLog := lrecImportLogSubsidiaryClient."Import Log Entry No.";
                until lrecImportLogSubsidiaryClient.Next() = 0;
                lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.", lbintImportLog);
                // Determine status
                //  lintStatus := lmodDataImportManagementCommon.gfncGetLowestStatus(lrecImportLogSubsidiaryClient);
            end;
            //
            // update temporary variable
            if lintStatus >= 0 then begin
                p_blnHasDetails[lintCounter] := true;
                p_recArrStatusColor[lintStatus + 1].CalcFields(Picture);
                lrecTmpStatusColor.Picture := p_recArrStatusColor[lintStatus + 1].Picture;
                lrecTmpStatusColor.CalcFields(Picture);
            end;

            // Update field
            case lintCounter of
                1:
                    p_recInterfaceTypeBuffer.Status_01 := lrecTmpStatusColor.Picture;
                2:
                    p_recInterfaceTypeBuffer.Status_02 := lrecTmpStatusColor.Picture;
                3:
                    p_recInterfaceTypeBuffer.Status_03 := lrecTmpStatusColor.Picture;
                4:
                    p_recInterfaceTypeBuffer.Status_04 := lrecTmpStatusColor.Picture;
                5:
                    p_recInterfaceTypeBuffer.Status_05 := lrecTmpStatusColor.Picture;
                6:
                    p_recInterfaceTypeBuffer.Status_06 := lrecTmpStatusColor.Picture;
                7:
                    p_recInterfaceTypeBuffer.Status_07 := lrecTmpStatusColor.Picture;
                8:
                    p_recInterfaceTypeBuffer.Status_08 := lrecTmpStatusColor.Picture;
                9:
                    p_recInterfaceTypeBuffer.Status_09 := lrecTmpStatusColor.Picture;
                10:
                    p_recInterfaceTypeBuffer.Status_10 := lrecTmpStatusColor.Picture;
                11:
                    p_recInterfaceTypeBuffer.Status_11 := lrecTmpStatusColor.Picture;
                12:
                    p_recInterfaceTypeBuffer.Status_12 := lrecTmpStatusColor.Picture;
            end;
        end;
        p_recInterfaceTypeBuffer.Modify();
    end;


    procedure gfcnInitStatusColor(var p_recArrStatusColor: array[4] of Record "Status Color")
    var
        lrecStatusColor: Record "Status Color";
    begin
        //
        //  Fills color array
        //
        lrecStatusColor.FindSet();
        repeat
            lrecStatusColor.CalcFields(Picture);
            p_recArrStatusColor[lrecStatusColor.Status + 1] := lrecStatusColor;
            p_recArrStatusColor[lrecStatusColor.Status + 1].Insert();
        until lrecStatusColor.Next() = 0;
    end;


    procedure gfncPopulateInterfaceTypeBuff(var p_recInterfaceTypeBuffer: Record "Interface Type Buffer")
    var
//lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        lrrRecRef: RecordRef;
        lfrFieldRef: FieldRef;
        ltxtOptionCaptionString: Text[1024];
        ltxtText: Text[1024];
        lblnLast: Boolean;
        lintCounter: Integer;
    begin
        //
        // Fill buffer table from option values T60001, F15
        //
        lblnLast := false;
        lintCounter := 0;
        p_recInterfaceTypeBuffer.DeleteAll();
        lrrRecRef.Open(60001); // Import Template Header
        lfrFieldRef := lrrRecRef.Field(15); // Interface Type
        ltxtOptionCaptionString := lfrFieldRef.OptionCaption;
        repeat
            // ltxtText := lmodDataImportManagementCommon.gfncGetNextToken(ltxtOptionCaptionString, ',', '"', lblnLast);
            if ltxtText <> '' then begin
                p_recInterfaceTypeBuffer.Init();
                p_recInterfaceTypeBuffer.Id := lintCounter;
                p_recInterfaceTypeBuffer.Name := ltxtText;
                p_recInterfaceTypeBuffer.Insert();
            end;
            lintCounter += 1;
        until lblnLast;
    end;


    procedure gfncSetDefaultFilters(var p_recInterfaceTypeBuffer: Record "Interface Type Buffer")
    begin
        //
        // Sets default filters
        //
        p_recInterfaceTypeBuffer.SetRange("Period Type", p_recInterfaceTypeBuffer."Period Type"::Month);
        p_recInterfaceTypeBuffer.SetRange("Start Date", gfncGetPeriodDate(p_recInterfaceTypeBuffer."Period Type"::Month, Today, -11, false));
    end;


    procedure gfncGetPeriodDate(p_optPeriodType: Option Day,Week,Month,Quarter,Year; p_datFromDate: Date; p_intSteps: Integer; p_blnLastDate: Boolean) r_datDate: Date
    var
        ltxtPeriodID: Text[30];
        ltxtCalcDateFormula: Text[30];
    begin
        //
        // Returns first or last period date based on reference date and period type
        // if p_intSteps <> 0 then period date will be moved n periods up or down
        //
        case p_optPeriodType of
            p_optPeriodType::Day:
                ltxtPeriodID := 'D';
            p_optPeriodType::Week:
                ltxtPeriodID := 'W';
            p_optPeriodType::Month:
                ltxtPeriodID := 'M';
            p_optPeriodType::Quarter:
                ltxtPeriodID := 'Q';
            p_optPeriodType::Year:
                ltxtPeriodID := 'Y';
        end;

        // First date of the period
        ltxtCalcDateFormula := StrSubstNo('<C%1+1D-1%1>', ltxtPeriodID);
        r_datDate := CalcDate(ltxtCalcDateFormula, p_datFromDate);

        //IF p_blnLastDate THEN ltxtCalcDateFormula := STRSUBSTNO('<C%1>', ltxtPeriodID)
        //                 ELSE ltxtCalcDateFormula := STRSUBSTNO('<C%1+1D-1%1>', ltxtPeriodID);
        //r_datDate := CALCDATE(ltxtCalcDateFormula, p_datFromDate);

        if p_intSteps <> 0 then begin
            p_datFromDate := r_datDate;
            r_datDate := CalcDate(StrSubstNo('<%1%2>', Format(p_intSteps), ltxtPeriodID), p_datFromDate);
        end;

        // If last date get Current period date
        if p_blnLastDate then begin
            p_datFromDate := r_datDate;
            ltxtCalcDateFormula := StrSubstNo('<C%1>', ltxtPeriodID);
            r_datDate := CalcDate(ltxtCalcDateFormula, p_datFromDate);
        end;
    end;


    procedure gfncMovePeriodStart(var p_recInterfaceTypeBuffer: Record "Interface Type Buffer"; p_intStep: Integer)
    var
        ldatDate: Date;
    begin
        //
        // Moves perid start date for p_intStep Up or Down
        //
        Evaluate(ldatDate, p_recInterfaceTypeBuffer.GetFilter("Start Date"));
        Evaluate(p_recInterfaceTypeBuffer."Period Type", p_recInterfaceTypeBuffer.GetFilter("Period Type"));
        ldatDate := gfncGetPeriodDate(p_recInterfaceTypeBuffer."Period Type", ldatDate, p_intStep, false);
        p_recInterfaceTypeBuffer.SetRange("Start Date", ldatDate);
    end;


    procedure gfncGetPeriodHeaders(var p_txtHeaderArray: array[12] of Text[30]; p_optPeriodType: Option Day,Week,Month,Quarter,Year; p_datFirstDate: Date)
    var
        lintCounter: Integer;
        ldatPeriodStart: Date;
        ldatPeriodEnd: Date;
        ltxtPeriodText: Text[30];
    begin
        //
        // populates p_txtHeaderArray with names of periods
        // based on Period Type and first date of period
        //
        for lintCounter := 1 to 12 do begin
            ldatPeriodStart := gfncGetPeriodDate(p_optPeriodType, p_datFirstDate, lintCounter - 1, false);
            ldatPeriodEnd := gfncGetPeriodDate(p_optPeriodType, p_datFirstDate, lintCounter - 1, true);
            case p_optPeriodType of
                p_optPeriodType::Day:
                    ltxtPeriodText := Format(ldatPeriodStart);
                p_optPeriodType::Week:
                    ltxtPeriodText := Format(ldatPeriodStart, 8, 'W<Week,2>/<Year4>');
                p_optPeriodType::Month:
                    ltxtPeriodText := Format(ldatPeriodStart, 7, '<Month,2>/<Year4>');
                p_optPeriodType::Quarter:
                    ltxtPeriodText := Format(ldatPeriodStart, 7, 'Q<Quarter>/<Year4>');
                //p_optPeriodType::Quarter : ltxtPeriodText := FORMAT(ldatPeriodStart) + '..' + FORMAT(ldatPeriodEnd);
                p_optPeriodType::Year:
                    ltxtPeriodText := Format(ldatPeriodStart, 4, '<Year4>');
            end;
            p_txtHeaderArray[lintCounter] := ltxtPeriodText;
        end;
    end;


    procedure gfncShowDetails(var p_recInterfaceTypeBuffer: Record "Interface Type Buffer"; p_intPeriod: Integer) r_blnResult: Boolean
    var
        lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
        loptPeriodType: Option Day,Week,Month,Quarter,Year;
        lbintImportLog: BigInteger;
        ldatDate: Date;
        ldatPeriodStart: Date;
        ldatPeriodEnd: Date;
    begin
        //
        // will open related import log records
        //
        r_blnResult := false;
        Evaluate(ldatDate, p_recInterfaceTypeBuffer.GetFilter("Start Date"));
        Evaluate(loptPeriodType, p_recInterfaceTypeBuffer.GetFilter("Period Type"));
        lrecImportLogSubsidiaryClient.SetCurrentKey("Parent Client No.", "Company No.", "Interface Type",
                                                    "First Entry Date", "Last Entry Date");
        if p_recInterfaceTypeBuffer.GetFilter("Parent Client") <> '' then
            p_recInterfaceTypeBuffer.CopyFilter("Parent Client", lrecImportLogSubsidiaryClient."Parent Client No.")
        else
            lrecImportLogSubsidiaryClient.SetRange("Parent Client No.");
        if p_recInterfaceTypeBuffer.GetFilter("Subsidiary Client") <> '' then
            p_recInterfaceTypeBuffer.CopyFilter("Subsidiary Client", lrecImportLogSubsidiaryClient."Company No.")
        else
            lrecImportLogSubsidiaryClient.SetRange("Company No.");
        lrecImportLogSubsidiaryClient.SetRange("Interface Type", p_recInterfaceTypeBuffer.Id);

        ldatPeriodStart := gfncGetPeriodDate(loptPeriodType, ldatDate, p_intPeriod - 1, false);
        ldatPeriodEnd := gfncGetPeriodDate(loptPeriodType, ldatDate, p_intPeriod - 1, true);

        lrecImportLogSubsidiaryClient.SetFilter("First Entry Date", '<=%1', ldatPeriodEnd);
        lrecImportLogSubsidiaryClient.SetFilter("Last Entry Date", '>=%1', ldatPeriodStart);

        // Find last Import entry
        lbintImportLog := 0;
        if lrecImportLogSubsidiaryClient.FindSet() then begin
            repeat
                if lbintImportLog < lrecImportLogSubsidiaryClient."Import Log Entry No." then
                    lbintImportLog := lrecImportLogSubsidiaryClient."Import Log Entry No.";
            until lrecImportLogSubsidiaryClient.Next() = 0;
            lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.", lbintImportLog);
            // Determine status
            //MESSAGE('S:'+lrecImportLogSubsidiaryClient.GETFILTERS);
            //lintStatus := lmodDataImportManagementCommon.gfncGetLowestStatus(lrecImportLogSubsidiaryClient);
            PAGE.RunModal(60057, lrecImportLogSubsidiaryClient);
            r_blnResult := true;
        end;
    end;
}

