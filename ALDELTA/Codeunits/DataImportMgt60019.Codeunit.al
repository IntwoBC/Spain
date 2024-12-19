// codeunit 60010 "Data Import Mgt 60019"
// {
//     // This codeunit contains Staging table specific functionality
//     // Specific to table 60019 - Customer staging


//     trigger OnRun()
//     begin
//     end;

//     var
//         TXT_PAGE: Label 'Page';
//         DLG_001: Label '#1################## \ Progress @2@@@@@@@@@@@@@@@@@@';
//         DLG_002: Label 'Target #1########################\Activity #2########\@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
//         DLG_003: Label 'Archiving records\@1@@@@@@@@@@@@@@@@@@';
//         ERR_001: Label 'Company No. is missing. Account No. %1';
//         ERR_002: Label 'Currency code %1 used in Customer %2 is not defined in company %3';
//         ERR_003: Label 'Bill-To Customer %1 used in Customer %2 is not defined in company %3 nor in the import file';
//         ERR_004: Label 'Gen. Buss Posting group %1 used in Customer %2 is not defined in company %3 nor in the import file';
//         ERR_005: Label 'VAT Posting group %1 used in Customer %2 is not defined in company %3 nor in the import file';
//         ERR_006: Label 'Receivables Account  is missing. Customer No. %1';
//         ERR_007: Label 'Receivables Account  %1 used in Customer %2 does not exist as Corporate G/L Account  in company %3';
//         ERR_008: Label 'Local G/L account %1 does not exist in company %2';
//         MSG_001: Label 'Validating imported records';
//         MSG_002: Label 'Building Batch';
//         MSG_003: Label 'Sending';
//         MSG_004: Label 'Data exported to server located file %1';


//     procedure "<-- Stage 1 related ->"()
//     begin
//     end;


//     procedure gfncAfterInitRecord(var p_rrefRecRef: RecordRef)
//     var
//         lfrefFieldRef: FieldRef;
//     begin
//         //
//         // Table specific record initialization - default values etc.
//         // Called after record is initialized (99xxx fields)
//         // before data is populated
//         //
//     end;


//     procedure gfncAfterSaveRecord(var p_rrefRecRef: RecordRef)
//     var
//         lfrefFieldRef: FieldRef;
//     begin
//         //
//         // Table specific record initialization - default values depending on imported values
//         // Called after record is saved
//         //
//     end;


//     procedure "<-- Stage 2 related ->"()
//     begin
//     end;


//     procedure gfncValidateImportRec(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCustomerStaging: Record "Customer (Staging)";
//         lintTotal: Integer;
//         lintPosition: Integer;
//         lintLastPct: Integer;
//         ldlgDialog: Dialog;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;
//         lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_001);
//             ldlgDialog.UPDATE(1, MSG_001);
//             lintTotal := lrecCustomerStaging.COUNT;
//             lintPosition := 0;
//         END;

//         //
//         // Checks that can be done one by one
//         //

//         lrecCustomerStaging.RESET();
//         lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
//         lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lintLastPct := 0;
//         IF lrecCustomerStaging.FINDSET(FALSE) THEN
//             REPEAT
//                 IF p_blnDialog THEN BEGIN
//                     lintPosition += 1;
//                     IF ROUND((lintPosition / lintTotal) * 100, 1, '<') > lintLastPct THEN BEGIN
//                         lintLastPct := ROUND((lintPosition / lintTotal) * 100, 1, '<');
//                         ldlgDialog.UPDATE(2, lintLastPct * 100);
//                     END;
//                 END;

//                 //
//                 // Specific check here
//                 //
//                 IF lrecCustomerStaging."Company No." = '' THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                    STRSUBSTNO(ERR_001, lrecCustomerStaging."No."));
//                 END;
//                 IF lrecCustomerStaging."Receivables Account" = '' THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                    STRSUBSTNO(ERR_006, lrecCustomerStaging."No."));
//                 END;
//             UNTIL lrecCustomerStaging.NEXT() = 0;


//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.CLOSE();
//         END;
//     end;


//     procedure gfncUpdateDateRange(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//         lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
//         lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldatStartDate: Date;
//         ldatEndDate: Date;
//     begin
//         r_blnResult := TRUE;
//         // Get list of companies
//         lrecGenJournalLineStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.", "Posting Date");
//         lrecGenJournalLineStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(TRUE) THEN
//             REPEAT
//                 lrecImportLogSubsidiaryClient."First Entry Date" := p_recImportLog."Import Date";
//                 lrecImportLogSubsidiaryClient."Last Entry Date" := p_recImportLog."Import Date";
//                 lrecImportLogSubsidiaryClient.MODIFY();
//             UNTIL lrecImportLogSubsidiaryClient.NEXT() = 0;
//     end;


//     procedure "<-- Stage 3 related ->"()
//     begin
//     end;


//     procedure gfncProcessClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     begin
//         //
//         // Do Processing of data before they are sent to local database
//         // (Export data from Master database etc..)
//         //
//         //
//         // Do Processing of data before they are sent to local database
//         // (Export data from Master database etc..)
//         //
//         r_blnResult := TRUE;
//         IF p_recImportLogSubsidiaryClient."VAT Reporting level" =
//            p_recImportLogSubsidiaryClient."VAT Reporting level"::"Create One Source File"
//           THEN BEGIN
//             r_blnResult := gfncExportCustomer(p_recImportLog, p_recImportLogSubsidiaryClient, p_blnDialog);
//         END;
//     end;


//     procedure gfncExportCustomer(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lfilFile: File;
//         lostFile: OutStream;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtFileName: Text[1024];
//         lrecCustomerStaging: Record "Customer (Staging)";
//     begin
//         //
//         // This will export Customer file
//         //
//         // ToDo Implement here
//         r_blnResult := lmodDataImportManagementCommon.gfncCreateServerFile(lfilFile, p_recImportLog, p_recImportLogSubsidiaryClient, 'txt');
//         ltxtFileName := lfilFile.NAME;

//         // MP 30-03-12 Replaced by XMLport >>

//         // Header line
//         //ltxtLine := 'MREF,NAME,COUNTRY,ADDRESS,PCODE,VAT Regn Number,VATRATE';
//         //lfilFile.WRITE(ltxtLine);

//         // MP 30-03-12 Replaced by XMLport <<

//         lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
//         lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
//         lrecCustomerStaging.SETRANGE("Company No.", p_recImportLogSubsidiaryClient."Company No.");

//         // MP 30-03-12 Replaced by XMLport >>

//         lfilFile.CREATEOUTSTREAM(lostFile);
//         XMLPORT.EXPORT(XMLPORT::"Customer - OneSource", lostFile, lrecCustomerStaging);

//         //IF lrecCustomerStaging.FINDSET(FALSE, FALSE) THEN REPEAT
//         //  ltxtLine := lrecCustomerStaging."No." + ',' +
//         //              lrecCustomerStaging.Name + ',' +
//         //              lrecCustomerStaging."Country/Region Code" + ',' +
//         //              lrecCustomerStaging.Address + ',' +
//         //              lrecCustomerStaging."Post Code" + ',' +
//         //              lrecCustomerStaging."VAT Registration No." + ',' +
//         //              ',' ; // VAT Rate
//         //  lfilFile.WRITE(ltxtLine);
//         //UNTIL lrecCustomerStaging.NEXT = 0;

//         // MP 30-03-12 Replaced by XMLport <<

//         lfilFile.CLOSE;
//         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(MSG_004, ltxtFileName));
//     end;


//     procedure gfncGetActionNoCopyData(): Integer
//     begin
//         //
//         // Returns Action Number which represents copy data
//         // as per definiton in CU 60008 Data Import Safe WS call
//         //
//         EXIT(10);
//     end;


//     procedure gfncCopyClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // ldotCustomerStg_Service: DotNet CustomerStg_Service;
//         // ldotCustomerStg: DotNet CustomerStg;
//         //ldotArray: DotNet Array;
//         lintBatchSize: Integer;
//         lintArrayPosition: Integer;
//         lintArrayLength: Integer;
//         lintRemainingRecords: Integer;
//         lrecCustomerStaging: Record "Customer (Staging)";
//         lblnNoMoreRecords: Boolean;
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//         lintRecordCount: Integer;
//         lintCounter: Integer;
//         lintLastPct: Integer;
//     begin

//         IF p_recImportLogSubsidiaryClient."VAT Reporting level" = p_recImportLogSubsidiaryClient."VAT Reporting level"::"Process In NAV"
//           THEN BEGIN
//             //
//             // Copy data to specific client using webservice
//             //
//             IF p_blnDialog THEN BEGIN
//                 ldlgDialog.OPEN(DLG_002);
//                 ldlgDialog.UPDATE(1, p_recImportLogSubsidiaryClient."Company Name");
//             END;
//             ldotCustomerStg_Service := ldotCustomerStg_Service.CustomerStg_Service();
//             ldotCustomerStg_Service.UseDefaultCredentials(TRUE);

//             IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                                TXT_PAGE,
//                                                                lmodDataImportManagementCommon.gfncGetCustomerStgWSName(),
//                                                                ltxtURL, ltxtErr)
//               THEN BEGIN
//                 lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//                 EXIT(FALSE);
//             END;

//             ldotCustomerStg_Service.Url := ltxtURL;
//             //ToDo Move to setup
//             lintBatchSize := 500; // Initial batch size Should be in setup!
//             lblnNoMoreRecords := FALSE;

//             lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
//             lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
//             lrecCustomerStaging.SETRANGE("Company No.", p_recImportLogSubsidiaryClient."Company No.");
//             lintRemainingRecords := lrecCustomerStaging.COUNT;
//             lintArrayPosition := 0;
//             ldotCustomerStg := ldotCustomerStg.CustomerStg();

//             IF p_blnDialog THEN BEGIN
//                 lintRecordCount := lrecCustomerStaging.COUNT;
//                 lintCounter := 0;
//             END;

//             IF lrecCustomerStaging.FINDSET(FALSE) THEN BEGIN
//                 REPEAT
//                     // Build array up to the batch size
//                     IF p_blnDialog THEN BEGIN
//                         ldlgDialog.UPDATE(2, MSG_002);
//                     END;

//                     IF lintRemainingRecords > lintBatchSize THEN
//                         lintArrayLength := lintBatchSize
//                     ELSE
//                         lintArrayLength := lintRemainingRecords;
//                     IF NOT ISNULL(ldotArray) THEN CLEAR(ldotArray);
//                     ldotArray := ldotArray.CreateInstance(ldotCustomerStg.GetType(), lintArrayLength);
//                     lintLastPct := 0;
//                     REPEAT
//                         IF p_blnDialog THEN BEGIN
//                             lintCounter += 1;
//                             IF ROUND((lintCounter / lintRecordCount) * 100, 1, '<') > lintLastPct THEN BEGIN
//                                 lintLastPct := ROUND((lintCounter / lintRecordCount) * 100, 1, '<');
//                                 ldlgDialog.UPDATE(3, lintLastPct * 100);
//                             END;
//                         END;
//                         IF NOT ISNULL(ldotCustomerStg) THEN CLEAR(ldotCustomerStg);
//                         ldotCustomerStg := ldotCustomerStg.CustomerStg();
//                         // Build record
//                         ldotCustomerStg.No := lrecCustomerStaging."No.";
//                         ldotCustomerStg.Name := lrecCustomerStaging.Name;
//                         ldotCustomerStg.Address := lrecCustomerStaging.Address;
//                         ldotCustomerStg.Address_2 := lrecCustomerStaging."Address 2";
//                         ldotCustomerStg.City := lrecCustomerStaging.City;
//                         ldotCustomerStg.Currency_Code := lrecCustomerStaging."Currency Code";
//                         ldotCustomerStg.Country_Region_Code := lrecCustomerStaging."Country/Region Code";
//                         ldotCustomerStg.Bill_to_Customer_No := lrecCustomerStaging."Bill-to Customer No.";
//                         ldotCustomerStg.VAT_Registration_No := lrecCustomerStaging."VAT Registration No.";
//                         ldotCustomerStg.Gen_Bus_Posting_Group := lrecCustomerStaging."Gen. Bus. Posting Group";
//                         ldotCustomerStg.Post_Code := lrecCustomerStaging."Post Code";
//                         ldotCustomerStg.Tax_Liable := lrecCustomerStaging."Tax Liable";
//                         ldotCustomerStg.Tax_LiableSpecified := TRUE;
//                         ldotCustomerStg.VAT_Bus_Posting_Group := lrecCustomerStaging."VAT Bus. Posting Group";
//                         ldotCustomerStg.Receivables_Account := lrecCustomerStaging."Receivables Account";
//                         ldotCustomerStg.Company_No := lrecCustomerStaging."Company No.";
//                         ldotCustomerStg.Client_No := lrecCustomerStaging."Client No.";
//                         ldotCustomerStg.User_ID := lrecCustomerStaging."User ID";
//                         ldotCustomerStg.Status := lrecCustomerStaging.Status;
//                         ldotCustomerStg.StatusSpecified := TRUE;
//                         ldotCustomerStg.Import_Log_Entry_No := lrecCustomerStaging."Import Log Entry No.";
//                         ldotCustomerStg.Import_Log_Entry_NoSpecified := TRUE;
//                         // Add to array
//                         ldotArray.SetValue(ldotCustomerStg, lintArrayPosition);
//                         lintArrayPosition += 1;
//                         lblnNoMoreRecords := (lrecCustomerStaging.NEXT() = 0);
//                         lintRemainingRecords -= 1;
//                     UNTIL ((lintArrayPosition = (lintBatchSize - 1)) OR lblnNoMoreRecords);
//                     lintArrayPosition := 0;
//                     IF p_blnDialog THEN BEGIN
//                         ldlgDialog.UPDATE(2, MSG_003);
//                     END;
//                     // and send it
//                     ldotCustomerStg_Service.CreateMultiple(ldotArray); // disabled for testing
//                 UNTIL lblnNoMoreRecords;
//             END;

//             IF p_blnDialog THEN BEGIN
//                 ldlgDialog.CLOSE();
//             END;
//         END;
//         EXIT(TRUE);
//     end;


//     procedure "<-- Stage 4 related ->"()
//     begin
//     end;


//     procedure gfncValidateLocalData(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCustomerStaging: Record "Customer (Staging)";
//         lrecCurrency: Record Currency;
//         lrecCustomer: Record Customer;
//         lrecCustomerStaging2: Record "Customer (Staging)";
//         lrecGenBusinessPostingGroup: Record "Gen. Business Posting Group";
//         lrecVATBusinessPostingGroup: Record "VAT Business Posting Group";
//         lrecGLAccount: Record "G/L Account";
//         lrecCorporateGLAccount: Record "Corporate G/L Account";
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;

//         // Delete old Error entries
//         lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

//         lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecCustomerStaging.FINDSET(FALSE) THEN
//             REPEAT
//                 //
//                 // Currency
//                 //
//                 IF lrecCustomerStaging."Currency Code" <> '' THEN BEGIN
//                     IF NOT lrecCurrency.GET(lrecCustomerStaging."Currency Code") THEN BEGIN
//                         r_blnResult := FALSE;
//                         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                        STRSUBSTNO(ERR_002, lrecCustomerStaging."Currency Code",
//                                                                   lrecCustomerStaging."No.", COMPANYNAME));
//                     END;
//                 END;
//                 //
//                 // Bill-to customer
//                 //
//                 IF (lrecCustomerStaging."Bill-to Customer No." <> '') THEN BEGIN
//                     IF (lrecCustomerStaging."Bill-to Customer No." <> lrecCustomerStaging."No.") THEN BEGIN
//                         // Check Bill-to in database
//                         IF NOT lrecCustomer.GET(lrecCustomerStaging."Bill-to Customer No.") THEN BEGIN
//                             // Check Bill-to in Staging
//                             lrecCustomerStaging2.SETCURRENTKEY("Import Log Entry No.", "No.");
//                             lrecCustomerStaging2.SETRANGE("No.", lrecCustomerStaging."Bill-to Customer No.");
//                             lrecCustomerStaging2.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//                             IF NOT lrecCustomerStaging2.FINDFIRST() THEN BEGIN
//                                 r_blnResult := FALSE;
//                                 lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                                STRSUBSTNO(ERR_003, lrecCustomerStaging."Bill-to Customer No.",
//                                                                           lrecCustomerStaging."No.", COMPANYNAME));
//                             END;
//                         END;
//                     END;
//                 END;
//                 // Gen. Bussiness Posting group
//                 IF lrecCustomerStaging."Gen. Bus. Posting Group" <> '' THEN BEGIN
//                     IF NOT lrecGenBusinessPostingGroup.GET(lrecCustomerStaging."Gen. Bus. Posting Group") THEN BEGIN
//                         r_blnResult := FALSE;
//                         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                        STRSUBSTNO(ERR_004, lrecCustomerStaging."Gen. Bus. Posting Group",
//                                                                   lrecCustomerStaging."No.", COMPANYNAME));
//                     END;
//                 END;
//                 // VAT posting group
//                 IF lrecCustomerStaging."VAT Bus. Posting Group" <> '' THEN BEGIN
//                     IF NOT lrecVATBusinessPostingGroup.GET(lrecCustomerStaging."VAT Bus. Posting Group") THEN BEGIN
//                         r_blnResult := FALSE;
//                         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                        STRSUBSTNO(ERR_005, lrecCustomerStaging."VAT Bus. Posting Group",
//                                                                   lrecCustomerStaging."No.", COMPANYNAME));
//                     END;
//                 END;
//                 // Corporate G/L account
//                 IF NOT lrecCorporateGLAccount.GET(lrecCustomerStaging."Receivables Account") THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                    STRSUBSTNO(ERR_007, lrecCustomerStaging."Receivables Account",
//                                                               lrecCustomerStaging."No.", COMPANYNAME));
//                 END ELSE BEGIN
//                     // Receivables account
//                     IF NOT lrecGLAccount.GET(lrecCorporateGLAccount."Local G/L Account No.") THEN BEGIN
//                         r_blnResult := FALSE;
//                         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                        STRSUBSTNO(ERR_008, lrecCorporateGLAccount."Local G/L Account No.",
//                                                                   COMPANYNAME));
//                     END;
//                 END;
//             UNTIL lrecCustomerStaging.NEXT() = 0;
//     end;


//     procedure "<-- Stage 5 related ->"()
//     begin
//     end;


//     procedure gfncPostTransactions(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCustomerStaging: Record "Customer (Staging)";
//         lrecCustomer: Record Customer;
//         lrecCustomerPostingGroup: Record "Customer Posting Group";
//         lrecCorporateGLAccount: Record "Corporate G/L Account";
//     begin
//         lrecCustomerStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCustomerStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

//         IF lrecCustomerStaging.FINDSET(FALSE) THEN
//             REPEAT
//                 //
//                 // Create Customer record
//                 //
//                 IF NOT lrecCustomer.GET(lrecCustomerStaging."No.") THEN lrecCustomer.INIT();
//                 lrecCustomer."No." := lrecCustomerStaging."No.";
//                 lrecCustomer.VALIDATE(Name, lrecCustomerStaging.Name);
//                 lrecCustomer.Address := lrecCustomerStaging.Address;
//                 lrecCustomer."Address 2" := lrecCustomerStaging."Address 2";
//                 lrecCustomer.City := lrecCustomerStaging.City;
//                 IF lrecCustomerStaging."Currency Code" <> '' THEN
//                     lrecCustomer.VALIDATE("Currency Code", lrecCustomerStaging."Currency Code");
//                 lrecCustomer."Country/Region Code" := lrecCustomerStaging."Country/Region Code";
//                 lrecCustomer."Bill-to Customer No." := lrecCustomerStaging."Bill-to Customer No.";
//                 lrecCustomer."VAT Registration No." := lrecCustomerStaging."VAT Registration No.";
//                 IF lrecCustomerStaging."Gen. Bus. Posting Group" <> '' THEN
//                     lrecCustomer.VALIDATE("Gen. Bus. Posting Group", lrecCustomerStaging."Gen. Bus. Posting Group");
//                 lrecCustomer."Post Code" := lrecCustomerStaging."Post Code";
//                 lrecCustomer."Tax Liable" := lrecCustomerStaging."Tax Liable";
//                 IF lrecCustomerStaging."VAT Bus. Posting Group" <> '' THEN
//                     lrecCustomer.VALIDATE("VAT Bus. Posting Group", lrecCustomerStaging."VAT Bus. Posting Group");
//                 //
//                 // Default/generated  values
//                 //
//                 lrecCorporateGLAccount.GET(lrecCustomerStaging."Receivables Account");
//                 lrecCustomerPostingGroup.SETRANGE("Receivables Account", lrecCorporateGLAccount."Local G/L Account No.");
//                 IF NOT lrecCustomerPostingGroup.FINDFIRST() THEN BEGIN
//                     // Create a new one
//                     lrecCustomerPostingGroup.INIT();
//                     lrecCustomerPostingGroup.Code := lrecCustomerStaging."Receivables Account";
//                     lrecCustomerPostingGroup.VALIDATE("Receivables Account", lrecCorporateGLAccount."Local G/L Account No.");
//                     lrecCustomerPostingGroup.INSERT(TRUE);
//                 END;
//                 lrecCustomer.VALIDATE("Customer Posting Group", lrecCustomerPostingGroup.Code);
//                 //
//                 // Insert / update Customer account
//                 //
//                 IF NOT lrecCustomer.INSERT(TRUE) THEN lrecCustomer.MODIFY(TRUE);

//             UNTIL lrecCustomerStaging.NEXT() = 0;
//         EXIT(TRUE);
//     end;


//     procedure "<-- Other -->"()
//     begin
//     end;


//     procedure gfncArchive(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecStaging: Record "Customer (Staging)";
//         lrecProcessed: Record "Customer (Processed)";
//         ldlgDialog: Dialog;
//         lintCount: Integer;
//         lintCounter: Integer;
//         lintLastPct: Integer;
//     begin
//         r_blnResult := TRUE;
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_003);
//         END;
//         //
//         // Copy to destination table
//         //
//         lrecStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lintCount := lrecStaging.COUNT;
//         lintCounter := 0;
//         lintLastPct := 0;
//         IF lrecStaging.FINDSET(FALSE, FALSE) THEN
//             REPEAT
//                 lrecProcessed.INIT();
//                 lrecProcessed.TRANSFERFIELDS(lrecStaging, TRUE);
//                 lrecProcessed.INSERT();
//                 IF p_blnDialog THEN BEGIN
//                     lintCounter += 1;
//                     IF ROUND(lintCount / lintCounter * 100, 1, '<') > lintLastPct THEN BEGIN
//                         lintLastPct := ROUND(lintCount / lintCounter * 100, 1, '<');
//                         ldlgDialog.UPDATE(1, lintLastPct * 100);
//                     END;
//                 END;
//             UNTIL lrecStaging.NEXT() = 0;

//         //
//         // Delete source records
//         //
//         lrecStaging.RESET();
//         lrecStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecStaging.DELETEALL();

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.CLOSE();
//         END;
//     end;
// }

