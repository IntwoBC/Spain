// codeunit 60006 "Data Import Mgt 60018"
// {
//     // This codeunit contains Staging table specific functionality
//     // Specific to table 60018 - Corporate G/L Acc (Staging)
//     // 
//     // MP 19-04-12
//     // Added check for "Financial Statement Code". Changed Text Constant ERR_001 to be generic, removed ERR_002
//     // 
//     // TEC 12-04-13 -mdan-
//     //   Maintenance of new fields
//     // 
//     // MP 30-04-14
//     // Development taken from Core II
//     // 
//     // MP 31-03-16
//     // Amended function gfncPostTransactions() in order to populate historic FS Codes (CB1 CR002)


//     trigger OnRun()
//     begin
//     end;

//     var
//         TXT_PAGE: Label 'Page';
//         DLG_001: Label '#1################## \ Progress @2@@@@@@@@@@@@@@@@@@';
//         DLG_002: Label 'Target #1########################\Activity #2########\@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
//         DLG_003: Label 'Archiving records\@1@@@@@@@@@@@@@@@@@@';
//         ERR_001: Label '%1 is missing. Corporate Account No. %2';
//         ERR_003: Label 'G/L account %1 defined in Corporate Account %2 does not exist in Company %3';
//         MSG_001: Label 'Validating imported records';
//         MSG_002: Label 'Building Batch';
//         MSG_003: Label 'Sending';


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
//         lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
//         lintResult: Integer;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         //
//         // Table specific record initialization - default values depending on imported values
//         // Called after record is saved
//         //
//         //
//         // If imported record does not have value in "Local Chart Of Acc (Mapped)" then populate it with No.
//         //
//         p_rrefRecRef.SETTABLE(lrecCorporateGLAccStaging);
//         IF lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)" = '' THEN BEGIN
//             lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)" := lrecCorporateGLAccStaging."No.";
//             lrecCorporateGLAccStaging.MODIFY();
//         END;

//         lintResult := lmodDataImportManagementCommon.gfncResolveIncomeBalance(lrecCorporateGLAccStaging."Accounting Class");
//         IF lintResult <> -1 THEN BEGIN
//             lrecCorporateGLAccStaging."Income/Balance" := lintResult;
//             lrecCorporateGLAccStaging.MODIFY();
//         END;
//     end;


//     procedure "<-- Stage 2 related ->"()
//     begin
//     end;


//     procedure gfncValidateImportRec(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
//         lintTotal: Integer;
//         lintPosition: Integer;
//         lintLastPct: Integer;
//         ldlgDialog: Dialog;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;
//         lrecCorporateGLAccStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCorporateGLAccStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_001);
//             ldlgDialog.UPDATE(1, MSG_001);
//             lintTotal := lrecCorporateGLAccStaging.COUNT;
//             lintPosition := 0;
//         END;

//         //
//         // Checks that can be done one by one
//         //

//         lrecCorporateGLAccStaging.RESET();
//         lrecCorporateGLAccStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
//         lrecCorporateGLAccStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lintLastPct := 0;
//         IF lrecCorporateGLAccStaging.FINDSET(FALSE) THEN
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
//                 IF lrecCorporateGLAccStaging."Company No." = '' THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                       //                                   STRSUBSTNO(ERR_001, lrecCorporateGLAccStaging."No.")); // MP 19-04-12 Replaced by below
//                       STRSUBSTNO(ERR_001, lrecCorporateGLAccStaging.FIELDCAPTION("Company No."), lrecCorporateGLAccStaging."No."));
//                 END;
//                 IF lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)" = '' THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                       //                                   STRSUBSTNO(ERR_002, lrecCorporateGLAccStaging."No.")); // MP 19-04-12 Replaced by below
//                       STRSUBSTNO(ERR_001, lrecCorporateGLAccStaging.FIELDCAPTION("Local Chart Of Acc (Mapped)"), lrecCorporateGLAccStaging."No."));
//                 END;

//                 // MP 19-04-12 >>

//                 IF lrecCorporateGLAccStaging."Financial Statement Code" = '' THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                       STRSUBSTNO(ERR_001, lrecCorporateGLAccStaging.FIELDCAPTION("Financial Statement Code"), lrecCorporateGLAccStaging."No."));
//                 END;

//             // MP 19-04-12 <<

//             UNTIL lrecCorporateGLAccStaging.NEXT() = 0;


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
//         EXIT(TRUE);
//     end;


//     procedure gfncGetActionNoCopyData(): Integer
//     begin
//         //
//         // Returns Action Number which represents copy data
//         // as per definiton in CU 60008 Data Import Safe WS call
//         //
//         EXIT(9);
//     end;


//     procedure gfncCopyClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         //ldotCorpGLAccountStg_Service: DotNet CorpGLAccountStg_Service;
//         //ldotCorpGLAccountStg: DotNet CorpGLAccountStg;
//         //ldotArray: DotNet Array;
//         lintBatchSize: Integer;
//         lintArrayPosition: Integer;
//         lintArrayLength: Integer;
//         lintRemainingRecords: Integer;
//         lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
//         lblnNoMoreRecords: Boolean;
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//         lintRecordCount: Integer;
//         lintCounter: Integer;
//         lintLastPct: Integer;
//     begin
//         //
//         // Copy data to specific client using webservice
//         //
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_002);
//             ldlgDialog.UPDATE(1, p_recImportLogSubsidiaryClient."Company Name");
//         END;
//         //ldotCorpGLAccountStg_Service := ldotCorpGLAccountStg_Service.CorpGLAccountStg_Service();
//         //ldotCorpGLAccountStg_Service.UseDefaultCredentials(TRUE);

//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_PAGE,
//                                                            lmodDataImportManagementCommon.gfncGetCorpGLAccStgWSName(),
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         //ldotCorpGLAccountStg_Service.Url := ltxtURL;
//         //ToDo Move to setup
//         lintBatchSize := 500; // Initial batch size Should be in setup!
//         lblnNoMoreRecords := FALSE;

//         lrecCorporateGLAccStaging.SETCURRENTKEY("Import Log Entry No.", "Company No.");
//         lrecCorporateGLAccStaging.SETRANGE("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
//         lrecCorporateGLAccStaging.SETRANGE("Company No.", p_recImportLogSubsidiaryClient."Company No.");
//         lintRemainingRecords := lrecCorporateGLAccStaging.COUNT;
//         lintArrayPosition := 0;
//         //ldotCorpGLAccountStg := ldotCorpGLAccountStg.CorpGLAccountStg();

//         IF p_blnDialog THEN BEGIN
//             lintRecordCount := lrecCorporateGLAccStaging.COUNT;
//             lintCounter := 0;
//         END;

//         //IF lrecCorporateGLAccStaging.FINDSET(FALSE) THEN BEGIN
//         // REPEAT
//         // Build array up to the batch size
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.UPDATE(2, MSG_002);
//         END;

//         IF lintRemainingRecords > lintBatchSize THEN
//             lintArrayLength := lintBatchSize
//         ELSE
//             lintArrayLength := lintRemainingRecords;
//         // IF NOT ISNULL(ldotArray) THEN CLEAR(ldotArray);
//         //  ldotArray := ldotArray.CreateInstance(ldotCorpGLAccountStg.GetType(), lintArrayLength);
//         lintLastPct := 0;
//         REPEAT
//             IF p_blnDialog THEN BEGIN
//                 lintCounter += 1;
//                 IF ROUND((lintCounter / lintRecordCount) * 100, 1, '<') > lintLastPct THEN BEGIN
//                     lintLastPct := ROUND((lintCounter / lintRecordCount) * 100, 1, '<');
//                     ldlgDialog.UPDATE(3, lintLastPct * 100);
//                 END;
//             END;
//             //                 IF NOT ISNULL(ldotCorpGLAccountStg) THEN CLEAR(ldotCorpGLAccountStg);
//             //                 ldotCorpGLAccountStg := ldotCorpGLAccountStg.CorpGLAccountStg; // Constructor
//             //                                                                                // Build record
//             //                 ldotCorpGLAccountStg.No := lrecCorporateGLAccStaging."No.";
//             //                 ldotCorpGLAccountStg.Name := lrecCorporateGLAccStaging.Name;
//             //                 ldotCorpGLAccountStg.Income_Balance := lrecCorporateGLAccStaging."Income/Balance";
//             //                 ldotCorpGLAccountStg.Income_BalanceSpecified := TRUE;
//             //                 ldotCorpGLAccountStg.Gen_Bus_Posting_Type := lrecCorporateGLAccStaging."Gen. Bus. Posting Type";
//             //                 ldotCorpGLAccountStg.Gen_Bus_Posting_TypeSpecified := TRUE;
//             //                 ldotCorpGLAccountStg.Accounting_Class := lrecCorporateGLAccStaging."Accounting Class";
//             //                 ldotCorpGLAccountStg.Accounting_ClassSpecified := TRUE;
//             //                 ldotCorpGLAccountStg.Name_ENU := lrecCorporateGLAccStaging."Name - ENU";
//             //                 ldotCorpGLAccountStg.Financial_Statement_Code := lrecCorporateGLAccStaging."Financial Statement Code";
//             //                 ldotCorpGLAccountStg.Local_Chart_Of_Acc_Mapped := lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)";
//             //                 ldotCorpGLAccountStg.Company_No := lrecCorporateGLAccStaging."Company No.";
//             //                 ldotCorpGLAccountStg.Client_No := lrecCorporateGLAccStaging."Client No.";
//             //                 ldotCorpGLAccountStg.User_ID := lrecCorporateGLAccStaging."User ID";
//             //                 ldotCorpGLAccountStg.Status := lrecCorporateGLAccStaging.Status;
//             //                 ldotCorpGLAccountStg.StatusSpecified := TRUE;
//             //                 ldotCorpGLAccountStg.Import_Log_Entry_No := lrecCorporateGLAccStaging."Import Log Entry No.";
//             //                 ldotCorpGLAccountStg.Import_Log_Entry_NoSpecified := TRUE;

//             //                 ldotCorpGLAccountStg.FS_Name := lrecCorporateGLAccStaging."FS Name";
//             //                 ldotCorpGLAccountStg.FS_Name_English := lrecCorporateGLAccStaging."FS Name (English)";

//             //                 // Add to array
//             //                 ldotArray.SetValue(ldotCorpGLAccountStg, lintArrayPosition);
//             //                 lintArrayPosition += 1;
//             //                 lblnNoMoreRecords := (lrecCorporateGLAccStaging.NEXT = 0);
//             //                 lintRemainingRecords -= 1;
//             //             UNTIL ((lintArrayPosition = (lintBatchSize - 1)) OR lblnNoMoreRecords);
//             //             lintArrayPosition := 0;
//             //             IF p_blnDialog THEN BEGIN
//             //                 ldlgDialog.UPDATE(2, MSG_003);
//             //             END;
//             //             // and send it
//             //             ldotCorpGLAccountStg_Service.CreateMultiple(ldotArray); // disabled for testing
//             //         UNTIL lblnNoMoreRecords;
//             //     END;

//             //     IF p_blnDialog THEN BEGIN
//             //         ldlgDialog.CLOSE;
//             //     END;

//             //     EXIT(TRUE);
//             // end;


//             //procedure "<-- Stage 4 related ->"()
//             begin
//             end;

    
//     procedure gfncValidateLocalData(var
//                                         p_recImportLog: Record "Import Log";
//                                         p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
//         lrecGLAccount: Record "G/L Account";
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;

//         // Delete old Error entries
//         lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

//         lrecCorporateGLAccStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCorporateGLAccStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecCorporateGLAccStaging.FINDSET(FALSE) THEN
//             REPEAT
//                 // Specific checks here
//                 IF NOT lrecGLAccount.GET(lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)") THEN BEGIN
//                     r_blnResult := FALSE;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                    STRSUBSTNO(ERR_003,
//                                                    lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)",
//                                                    lrecCorporateGLAccStaging."No.",
//                                                    COMPANYNAME));
//                 END;
//             UNTIL lrecCorporateGLAccStaging.NEXT = 0;
//     end;

    
//     procedure "<-- Stage 5 related ->"()
//     begin
//     end;

    
//     procedure gfncPostTransactions(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
//         lrecCorporateGLAccount: Record "Corporate G/L Account";
//         lrecFinancialStatementCode: Record "Financial Statement Code";
//         lmdlFSCodeMgt: Codeunit "Fin. Stmt. Code Management";
//         lcodOrgFSCode: Code[10];
//     begin
//         lrecCorporateGLAccStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecCorporateGLAccStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

//         IF lrecCorporateGLAccStaging.FINDSET(FALSE) THEN
//             REPEAT
//                 //
//                 // Create Corporate G/L account line
//                 //
//                 IF NOT lrecCorporateGLAccount.GET(lrecCorporateGLAccStaging."No.") THEN lrecCorporateGLAccount.INIT;
//                 lrecCorporateGLAccount."No." := lrecCorporateGLAccStaging."No.";
//                 lrecCorporateGLAccount.Name := lrecCorporateGLAccStaging.Name;
//                 lrecCorporateGLAccount."Income/Balance" := lrecCorporateGLAccStaging."Income/Balance";
//                 lrecCorporateGLAccount."Account Class" := lrecCorporateGLAccStaging."Accounting Class";
//                 lrecCorporateGLAccount."Name (English)" := lrecCorporateGLAccStaging."Name - ENU";
//                 lrecCorporateGLAccount."Local G/L Account No." := lrecCorporateGLAccStaging."Local Chart Of Acc (Mapped)";
//                 lcodOrgFSCode := lrecCorporateGLAccount."Financial Statement Code"; // MP 31-03-16
//                 lrecCorporateGLAccount."Financial Statement Code" := lrecCorporateGLAccStaging."Financial Statement Code";

//                 //
//                 // Default values
//                 //
//                 lrecCorporateGLAccount."Debit/Credit" := lrecCorporateGLAccount."Debit/Credit"::Both;
//                 lrecCorporateGLAccount."Account Type" := lrecCorporateGLAccount."Account Type"::Posting;
//                 //
//                 // Insert / update Corporate G/L account
//                 //
//                 IF NOT lrecCorporateGLAccount.INSERT(TRUE) THEN lrecCorporateGLAccount.MODIFY(TRUE);

//                 // FS Code
//                 IF lrecCorporateGLAccount."Financial Statement Code" <> '' THEN BEGIN
//                     IF NOT lrecFinancialStatementCode.GET(lrecCorporateGLAccount."Financial Statement Code") THEN BEGIN
//                         lrecFinancialStatementCode.INIT;
//                         lrecFinancialStatementCode.Code := lrecCorporateGLAccount."Financial Statement Code";
//                         lrecFinancialStatementCode.INSERT(TRUE);
//                     END;
//                     IF lrecCorporateGLAccStaging."FS Name" <> '' THEN // MP 30-04-14
//                         lrecFinancialStatementCode.Description := lrecCorporateGLAccStaging."FS Name";
//                     IF lrecCorporateGLAccStaging."FS Name (English)" <> '' THEN // MP 30-04-14
//                         lrecFinancialStatementCode."Description (English)" := lrecCorporateGLAccStaging."FS Name (English)";
//                     lrecFinancialStatementCode.MODIFY(TRUE);
//                 END;
//                 lmdlFSCodeMgt.gfcnUpdateCorpGLAccFSCodeAndHistory(lrecCorporateGLAccount, lcodOrgFSCode); // MP 31-03-16
//             UNTIL lrecCorporateGLAccStaging.NEXT = 0;
//         EXIT(TRUE);
//     end;

    
//     procedure "<-- Other -->"()
//     begin
//     end;

    
//     procedure gfncArchive(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecStaging: Record "Corporate G/L Acc (Staging)";
//         lrecProcessed: Record "Corporate G/L Acc (Processed)";
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
//                 lrecProcessed.INIT;
//                 lrecProcessed.TRANSFERFIELDS(lrecStaging, TRUE);
//                 lrecProcessed.INSERT;
//                 IF p_blnDialog THEN BEGIN
//                     lintCounter += 1;
//                     IF ROUND(lintCount / lintCounter * 100, 1, '<') > lintLastPct THEN BEGIN
//                         lintLastPct := ROUND(lintCount / lintCounter * 100, 1, '<');
//                         ldlgDialog.UPDATE(1, lintLastPct * 100);
//                     END;
//                 END;
//             UNTIL lrecStaging.NEXT = 0;

//         //
//         // Delete source records
//         //
//         lrecStaging.RESET;
//         lrecStaging.SETCURRENTKEY("Import Log Entry No.");
//         lrecStaging.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecStaging.DELETEALL;

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.CLOSE;
//         END;
//     end;
// }

