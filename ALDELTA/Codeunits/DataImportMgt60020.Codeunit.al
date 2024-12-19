codeunit 60011 "Data Import Mgt 60020"
{
    // This codeunit contains Staging table specific functionality
    // Specific to table 60020 - Vendor staging


    trigger OnRun()
    begin
    end;

    var
        TXT_PAGE: Label 'Page';
        DLG_001: Label '#1################## \ Progress @2@@@@@@@@@@@@@@@@@@';
        DLG_002: Label 'Target #1########################\Activity #2########\@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        DLG_003: Label 'Archiving records\@1@@@@@@@@@@@@@@@@@@';
        ERR_001: Label 'Company No. is missing. Account No. %1';
        ERR_002: Label 'Currency code %1 used in Vendor %2 is not defined in company %3';
        ERR_003: Label 'Pay-to Vendor %1 used in Vendor %2 is not defined in company %3 nor in the import file';
        ERR_004: Label 'Gen. Buss Posting group %1 used in Vendor %2 is not defined in company %3 nor in the import file';
        ERR_005: Label 'VAT Posting group %1 used in Vendor %2 is not defined in company %3 nor in the import file';
        ERR_006: Label 'Payables Account  is missing. Vendor No. %1';
        ERR_007: Label 'Payables Account  %1 used in Vendor %2 does not exist as Corporate G/L Account  in company %3';
        ERR_008: Label 'Local G/L account %1 does not exist in company %2';
        MSG_001: Label 'Validating imported records';
        MSG_002: Label 'Building Batch';
        MSG_003: Label 'Sending';
        MSG_004: Label 'Data exported to server located file %1';


    procedure "<-- Stage 1 related ->"()
    begin
    end;


    procedure gfncAfterInitRecord(var p_rrefRecRef: RecordRef)
    var
        lfrefFieldRef: FieldRef;
    begin
        //
        // Table specific record initialization - default values etc.
        // Called after record is initialized (99xxx fields)
        // before data is populated
        //
    end;


    procedure gfncAfterSaveRecord(var p_rrefRecRef: RecordRef)
    var
        lfrefFieldRef: FieldRef;
    begin
        //
        // Table specific record initialization - default values depending on imported values
        // Called after record is saved
        //
    end;


    procedure "<-- Stage 2 related ->"()
    begin
    end;


    procedure gfncValidateImportRec(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lrecVendorStaging: Record "Vendor (Staging)";
        lintTotal: Integer;
        lintPosition: Integer;
        lintLastPct: Integer;
        ldlgDialog: Dialog;
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        r_blnResult := TRUE;
        lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.");
        lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

        IF p_blnDialog THEN BEGIN
            ldlgDialog.OPEN(DLG_001);
            ldlgDialog.UPDATE(1, MSG_001);
            lintTotal := lrecVendorStaging.COUNT;
            lintPosition := 0;
        END;

        //
        // Checks that can be done one by one
        //

        lrecVendorStaging.RESET();
        lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
        lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        lintLastPct := 0;
        IF lrecVendorStaging.FINDSET(FALSE) THEN
            REPEAT
                IF p_blnDialog THEN BEGIN
                    lintPosition += 1;
                    IF ROUND((lintPosition / lintTotal) * 100, 1, '<') > lintLastPct THEN BEGIN
                        lintLastPct := ROUND((lintPosition / lintTotal) * 100, 1, '<');
                        ldlgDialog.UPDATE(2, lintLastPct * 100);
                    END;
                END;

                //
                // Specific check here
                //
                IF lrecVendorStaging."Company No." = '' THEN BEGIN
                    r_blnResult := FALSE;
                   // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                  // STRSUBSTNO(ERR_001, lrecVendorStaging."No."));
                END;
                IF lrecVendorStaging."Payables Account" = '' THEN BEGIN
                    r_blnResult := FALSE;
                    //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                 //  STRSUBSTNO(ERR_006, lrecVendorStaging."No."));
                END;
            UNTIL lrecVendorStaging.NEXT() = 0;


        IF p_blnDialog THEN BEGIN
            ldlgDialog.CLOSE();
        END;
    end;


    procedure gfncUpdateDateRange(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
        lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
      //  lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        ldatStartDate: Date;
        ldatEndDate: Date;
    begin
        r_blnResult := TRUE;
        // Get list of companies
        lrecGenJournalLineStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.", "Posting Date");
        lrecGenJournalLineStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        IF lrecImportLogSubsidiaryClient.FINDSET(TRUE) THEN
            REPEAT
                lrecImportLogSubsidiaryClient."First Entry Date" := p_recImportLog."Import Date";
                lrecImportLogSubsidiaryClient."Last Entry Date" := p_recImportLog."Import Date";
                lrecImportLogSubsidiaryClient.MODIFY();
            UNTIL lrecImportLogSubsidiaryClient.NEXT() = 0;
    end;


    procedure "<-- Stage 3 related ->"()
    begin
    end;


    procedure gfncProcessClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
    begin
        //
        // Do Processing of data before they are sent to local database
        // (Export data from Master database etc..)
        //
        r_blnResult := TRUE;
        IF p_recImportLogSubsidiaryClient."VAT Reporting level" =
           p_recImportLogSubsidiaryClient."VAT Reporting level"::"Create One Source File"
          THEN BEGIN
            r_blnResult := gfncExportVendor(p_recImportLog, p_recImportLogSubsidiaryClient, p_blnDialog);
        END;
    end;


    procedure gfncExportVendor(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lfilFile: File;
        lostFile: OutStream;
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        ltxtFileName: Text[1024];
        ltxtLine: Text[1024];
        lrecVendorStaging: Record "Vendor (Staging)";
    begin
        //
        // This will export Vendor file
        //
        // ToDo Implement here
       //r_blnResult := lmodDataImportManagementCommon.gfncCreateServerFile(lfilFile, p_recImportLog, p_recImportLogSubsidiaryClient, 'txt');
       // ltxtFileName := lfilFile.NAME;

        // MP 30-03-12 Replaced by XMLport >>

        // Header line
        //ltxtLine := 'MREF,NAME,COUNTRY,ADDRESS,PCODE,VAT Regn Number,VATRATE';
        //lfilFile.WRITE(ltxtLine);

        // MP 30-03-12 Replaced by XMLport <<

        lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
        lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
        lrecVendorStaging.SETRANGE("Company No.", p_recImportLogSubsidiaryClient."Company No.");

        // MP 30-03-12 Replaced by XMLport >>

       // lfilFile.CREATEOUTSTREAM(lostFile);
        XMLPORT.EXPORT(XMLPORT::"Vendor - OneSource", lostFile, lrecVendorStaging);

        //IF lrecVendorStaging.FINDSET(FALSE, FALSE) THEN REPEAT
        //  ltxtLine := lrecVendorStaging."No." + ',' +
        //              lrecVendorStaging.Name + ',' +
        //              lrecVendorStaging."Country/Region Code" + ',' +
        //              lrecVendorStaging.Address + ',' +
        //              lrecVendorStaging."Post Code" + ',' +
        //              lrecVendorStaging."VAT Registration No." + ',' +
        //              ',' ; // VAT Rate
        //  lfilFile.WRITE(ltxtLine);
        //UNTIL lrecVendorStaging.NEXT = 0;

        // MP 30-03-12 Replaced by XMLport <<

       // lfilFile.CLOSE;
       // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(MSG_004, ltxtFileName));
    end;


    procedure gfncGetActionNoCopyData(): Integer
    begin
        //
        // Returns Action Number which represents copy data
        // as per definiton in CU 60008 Data Import Safe WS call
        //
        EXIT(11);
    end;


    procedure gfncCopyClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        // ldotVendorStg_Service: DotNet VendorStg_Service;
        //ldotVendorStg: DotNet VendorStg;
        //ldotArray: DotNet Array;
        lintBatchSize: Integer;
        lintArrayPosition: Integer;
        lintArrayLength: Integer;
        lintRemainingRecords: Integer;
        lrecVendorStaging: Record "Vendor (Staging)";
        lblnNoMoreRecords: Boolean;
        ltxtURL: Text[1024];
        ltxtErr: Text[1024];
//lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        ldlgDialog: Dialog;
        lintRecordCount: Integer;
        lintCounter: Integer;
        lintLastPct: Integer;
    begin
        IF p_recImportLogSubsidiaryClient."VAT Reporting level" = p_recImportLogSubsidiaryClient."VAT Reporting level"::"Process In NAV"
          THEN BEGIN
            //
            // Copy data to specific client using webservice
            //
            IF p_blnDialog THEN BEGIN
                ldlgDialog.OPEN(DLG_002);
                ldlgDialog.UPDATE(1, p_recImportLogSubsidiaryClient."Company Name");
            END;
           // ldotVendorStg_Service := ldotVendorStg_Service.VendorStg_Service();
//ldotVendorStg_Service.UseDefaultCredentials(TRUE);

           // IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
                                                            //   TXT_PAGE,
                                                             //  lmodDataImportManagementCommon.gfncGetVendorStgWSName(),
                                                             //  ltxtURL, ltxtErr)
            //  THEN BEGIN
               // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
                EXIT(FALSE);
            END;

//ldotVendorStg_Service.Url := ltxtURL;
            //ToDo Move to setup
            lintBatchSize := 500; // Initial batch size Should be in setup!
            lblnNoMoreRecords := FALSE;

            lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
            lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
            lrecVendorStaging.SETRANGE("Company No.", p_recImportLogSubsidiaryClient."Company No.");
            lintRemainingRecords := lrecVendorStaging.COUNT;
            lintArrayPosition := 0;
          //  ldotVendorStg := ldotVendorStg.VendorStg();

            IF p_blnDialog THEN BEGIN
                lintRecordCount := lrecVendorStaging.COUNT;
                lintCounter := 0;
            END;

            // IF lrecVendorStaging.FINDSET(FALSE) THEN BEGIN
            //     REPEAT
            //         // Build array up to the batch size
            //         IF p_blnDialog THEN BEGIN
            //             ldlgDialog.UPDATE(2, MSG_002);
            //         END;

            //         IF lintRemainingRecords > lintBatchSize THEN
            //             lintArrayLength := lintBatchSize
            //         ELSE
            //             lintArrayLength := lintRemainingRecords;
            //       //  IF NOT ISNULL(ldotArray) THEN CLEAR(ldotArray);
            //       //  ldotArray := ldotArray.CreateInstance(ldotVendorStg.GetType(), lintArrayLength);
            //         lintLastPct := 0;
            //         REPEAT
            //             IF p_blnDialog THEN BEGIN
            //                 lintCounter += 1;
            //                 IF ROUND((lintCounter / lintRecordCount) * 100, 1, '<') > lintLastPct THEN BEGIN
            //                     lintLastPct := ROUND((lintCounter / lintRecordCount) * 100, 1, '<');
            //                     ldlgDialog.UPDATE(3, lintLastPct * 100);
            //                 END;
            //             END;
            //             IF NOT ISNULL(ldotVendorStg) THEN CLEAR(ldotVendorStg);
            //             ldotVendorStg := ldotVendorStg.VendorStg();
            //             // Build record
            //             ldotVendorStg.No := lrecVendorStaging."No.";
            //             ldotVendorStg.Name := lrecVendorStaging.Name;
            //             ldotVendorStg.Address := lrecVendorStaging.Address;
            //             ldotVendorStg.Address_2 := lrecVendorStaging."Address 2";
            //             ldotVendorStg.City := lrecVendorStaging.City;
            //             ldotVendorStg.Currency_Code := lrecVendorStaging."Currency Code";
            //             ldotVendorStg.Country_Region_Code := lrecVendorStaging."Country/Region Code";
            //             ldotVendorStg.Pay_to_Vendor_No := lrecVendorStaging."Pay-to Vendor No.";
            //             ldotVendorStg.VAT_Registration_No := lrecVendorStaging."VAT Registration No.";
            //             ldotVendorStg.Gen_Bus_Posting_Group := lrecVendorStaging."Gen. Bus. Posting Group";
            //             ldotVendorStg.Post_Code := lrecVendorStaging."Post Code";
            //             ldotVendorStg.Tax_Liable := lrecVendorStaging."Tax Liable";
            //             ldotVendorStg.Tax_LiableSpecified := TRUE;
            //             ldotVendorStg.VAT_Bus_Posting_Group := lrecVendorStaging."VAT Bus. Posting Group";
            //             ldotVendorStg.Payables_Account := lrecVendorStaging."Payables Account";
            //             ldotVendorStg.Company_No := lrecVendorStaging."Company No.";
            //             ldotVendorStg.Client_No := lrecVendorStaging."Client No.";
            //             ldotVendorStg.User_ID := lrecVendorStaging."User ID";
            //             ldotVendorStg.Status := lrecVendorStaging.Status;
            //             ldotVendorStg.StatusSpecified := TRUE;
            //             ldotVendorStg.Import_Log_Entry_No := lrecVendorStaging."Import Log Entry No.";
            //             ldotVendorStg.Import_Log_Entry_NoSpecified := TRUE;
            //             // Add to array
            //             ldotArray.SetValue(ldotVendorStg, lintArrayPosition);
            //             lintArrayPosition += 1;
            //             lblnNoMoreRecords := (lrecVendorStaging.NEXT() = 0);
            //             lintRemainingRecords -= 1;
            //         UNTIL ((lintArrayPosition = (lintBatchSize - 1)) OR lblnNoMoreRecords);
            //         lintArrayPosition := 0;
            //         IF p_blnDialog THEN BEGIN
            //             ldlgDialog.UPDATE(2, MSG_003);
            //         END;
            //         // and send it
            //         ldotVendorStg_Service.CreateMultiple(ldotArray); // disabled for testing
            //     UNTIL lblnNoMoreRecords;
            END;

         //   IF p_blnDialog THEN BEGIN
           //     ldlgDialog.CLOSE();
          //  END;
       // END;
       // EXIT(TRUE);
   // end;


    procedure "<-- Stage 4 related ->"()
    begin
    end;


    procedure gfncValidateLocalData(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lrecVendorStaging: Record "Vendor (Staging)";
        lrecCurrency: Record Currency;
        lrecVendor: Record Vendor;
        lrecVendorStaging2: Record "Vendor (Staging)";
        lrecGenBusinessPostingGroup: Record "Gen. Business Posting Group";
        lrecVATBusinessPostingGroup: Record "VAT Business Posting Group";
        lrecGLAccount: Record "G/L Account";
        lrecCorporateGLAccount: Record "Corporate G/L Account";
        //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        r_blnResult := TRUE;

        // Delete old Error entries
       // lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

        lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.");
        lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        IF lrecVendorStaging.FINDSET(FALSE) THEN
            REPEAT
                //
                // Currency
                //
                IF lrecVendorStaging."Currency Code" <> '' THEN BEGIN
                    IF NOT lrecCurrency.GET(lrecVendorStaging."Currency Code") THEN BEGIN
                        r_blnResult := FALSE;
                       // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                     //  STRSUBSTNO(ERR_002, lrecVendorStaging."Currency Code",
                                                                //  lrecVendorStaging."No.", COMPANYNAME));
                    END;
                END;
                //
                // Bill-to Vendor
                //
                IF (lrecVendorStaging."Pay-to Vendor No." <> '') THEN BEGIN
                    IF lrecVendorStaging."Pay-to Vendor No." <> lrecVendorStaging."No." THEN BEGIN
                        // Check Pay-to in database
                        IF NOT lrecVendor.GET(lrecVendorStaging."Pay-to Vendor No.") THEN BEGIN
                            // Check Pay-to in Staging
                            lrecVendorStaging2.SETCURRENTKEY("Import Log Entry No.", "No.");
                            lrecVendorStaging2.SETRANGE("No.", lrecVendorStaging."Pay-to Vendor No.");
                            lrecVendorStaging2.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
                            IF NOT lrecVendorStaging2.FINDFIRST() THEN BEGIN
                                r_blnResult := FALSE;
                              //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                             //  STRSUBSTNO(ERR_003, lrecVendorStaging."Pay-to Vendor No.",
                                                                     //     lrecVendorStaging."No.", COMPANYNAME));
                            END;
                        END;
                    END;
                END;
                // Gen. Bussiness Posting group
                IF lrecVendorStaging."Gen. Bus. Posting Group" <> '' THEN BEGIN
                    IF NOT lrecGenBusinessPostingGroup.GET(lrecVendorStaging."Gen. Bus. Posting Group") THEN BEGIN
                        r_blnResult := FALSE;
                       // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                    //   STRSUBSTNO(ERR_004, lrecVendorStaging."Gen. Bus. Posting Group",
                                                       //           lrecVendorStaging."No.", COMPANYNAME));
                    END;
                END;
                // VAT posting group
                IF lrecVendorStaging."VAT Bus. Posting Group" <> '' THEN BEGIN
                    IF NOT lrecVATBusinessPostingGroup.GET(lrecVendorStaging."VAT Bus. Posting Group") THEN BEGIN
                        r_blnResult := FALSE;
                       // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                     //  STRSUBSTNO(ERR_005, lrecVendorStaging."VAT Bus. Posting Group",
                                                                //  lrecVendorStaging."No.", COMPANYNAME));
                    END;
                END;
                // Corporate G/L account
                IF NOT lrecCorporateGLAccount.GET(lrecVendorStaging."Payables Account") THEN BEGIN
                    r_blnResult := FALSE;
                    //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                 //  STRSUBSTNO(ERR_007, lrecVendorStaging."Payables Account",
                                                          //    lrecVendorStaging."No.", COMPANYNAME));
                END ELSE BEGIN
                    // Receivables account
                    IF NOT lrecGLAccount.GET(lrecCorporateGLAccount."Local G/L Account No.") THEN BEGIN
                        r_blnResult := FALSE;
                        //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                     //  STRSUBSTNO(ERR_008, lrecCorporateGLAccount."Local G/L Account No.",
                                                               //   COMPANYNAME));
                    END;
                END;
            UNTIL lrecVendorStaging.NEXT() = 0;
    end;


    procedure "<-- Stage 5 related ->"()
    begin
    end;


    procedure gfncPostTransactions(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lrecVendorStaging: Record "Vendor (Staging)";
        lrecVendor: Record Vendor;
        lrecVendorPostingGroup: Record "Vendor Posting Group";
        lrecCorporateGLAccount: Record "Corporate G/L Account";
    begin
        lrecVendorStaging.SETCURRENTKEY("Import Log Entry No.");
        lrecVendorStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

        IF lrecVendorStaging.FINDSET(FALSE) THEN
            REPEAT
                //
                // Create Vendor record
                //

                IF NOT lrecVendor.GET(lrecVendorStaging."No.") THEN lrecVendor.INIT();
                lrecVendor."No." := lrecVendorStaging."No.";
                lrecVendor.VALIDATE(Name, lrecVendorStaging.Name);
                lrecVendor.Address := lrecVendorStaging.Address;
                lrecVendor."Address 2" := lrecVendorStaging."Address 2";
                lrecVendor.City := lrecVendorStaging.City;
                IF lrecVendorStaging."Currency Code" <> '' THEN
                    lrecVendor.VALIDATE("Currency Code", lrecVendorStaging."Currency Code");
                lrecVendor."Country/Region Code" := lrecVendorStaging."Country/Region Code";
                lrecVendor."Pay-to Vendor No." := lrecVendorStaging."Pay-to Vendor No.";
                lrecVendor."VAT Registration No." := lrecVendorStaging."VAT Registration No.";
                IF lrecVendorStaging."Gen. Bus. Posting Group" <> '' THEN
                    lrecVendor.VALIDATE("Gen. Bus. Posting Group", lrecVendorStaging."Gen. Bus. Posting Group");
                lrecVendor."Post Code" := lrecVendorStaging."Post Code";
                lrecVendor."Tax Liable" := lrecVendorStaging."Tax Liable";
                IF lrecVendorStaging."VAT Bus. Posting Group" <> '' THEN
                    lrecVendor.VALIDATE("VAT Bus. Posting Group", lrecVendorStaging."VAT Bus. Posting Group");

                //
                // Default/generated  values
                //
                lrecCorporateGLAccount.GET(lrecVendorStaging."Payables Account");
                lrecVendorPostingGroup.SETRANGE("Payables Account", lrecCorporateGLAccount."Local G/L Account No.");
                IF NOT lrecVendorPostingGroup.FINDFIRST() THEN BEGIN
                    // Create a new one
                    lrecVendorPostingGroup.INIT();
                    lrecVendorPostingGroup.Code := lrecVendorStaging."Payables Account";
                    lrecVendorPostingGroup.VALIDATE("Payables Account", lrecCorporateGLAccount."Local G/L Account No.");
                    lrecVendorPostingGroup.INSERT(TRUE);
                END;
                lrecVendor.VALIDATE("Vendor Posting Group", lrecVendorPostingGroup.Code);
                //
                // Insert / update Vendor account
                //
                IF NOT lrecVendor.INSERT(TRUE) THEN lrecVendor.MODIFY(TRUE);

            UNTIL lrecVendorStaging.NEXT() = 0;
        EXIT(TRUE);
    end;


    procedure "<-- Other -->"()
    begin
    end;


    procedure gfncArchive(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lrecStaging: Record "Vendor (Staging)";
        lrecProcessed: Record "Vendor (Processed)";
        ldlgDialog: Dialog;
        lintCount: Integer;
        lintCounter: Integer;
        lintLastPct: Integer;
    begin
        r_blnResult := TRUE;
        IF p_blnDialog THEN BEGIN
            ldlgDialog.OPEN(DLG_003);
        END;
        //
        // Copy to destination table
        //
        lrecStaging.SETCURRENTKEY("Import Log Entry No.");
        lrecStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        lintCount := lrecStaging.COUNT;
        lintCounter := 0;
        lintLastPct := 0;
        IF lrecStaging.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrecProcessed.INIT();
                lrecProcessed.TRANSFERFIELDS(lrecStaging, TRUE);
                lrecProcessed.INSERT();
                IF p_blnDialog THEN BEGIN
                    lintCounter += 1;
                    IF ROUND(lintCount / lintCounter * 100, 1, '<') > lintLastPct THEN BEGIN
                        lintLastPct := ROUND(lintCount / lintCounter * 100, 1, '<');
                        ldlgDialog.UPDATE(1, lintLastPct * 100);
                    END;
                END;
            UNTIL lrecStaging.NEXT() = 0;

        //
        // Delete source records
        //
        lrecStaging.RESET();
        lrecStaging.SETCURRENTKEY("Import Log Entry No.");
        lrecStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
        lrecStaging.DELETEALL();

        IF p_blnDialog THEN BEGIN
            ldlgDialog.CLOSE();
        END;
    end;
}

