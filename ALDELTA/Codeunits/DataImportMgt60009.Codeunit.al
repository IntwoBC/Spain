// codeunit 60005 "Data Import Mgt 60009"
// {
//     // This codeunit contains Staging table specific functionality
//     // Specific to table 60009  G/L Account (Staging)
//     // 
//     // MP 19-04-12
//     // Added check for "Financial Statement Code". Changed Text Constant ERR_001 to be generic
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
//         ERR_001: Label '%1 is missing. Account No. %2';
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
//         lrecGLAccountStaging: Record "G/L Account (Staging)";
//         lintResult: Integer;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         //
//         // Table specific record initialization - default values depending on imported values
//         // Called after record is saved
//         //
//         p_rrefRecRef.SetTable(lrecGLAccountStaging);
//         lintResult := lmodDataImportManagementCommon.gfncResolveIncomeBalance(lrecGLAccountStaging."Accounting Class");
//         if lintResult <> -1 then begin
//             lrecGLAccountStaging."Income/Balance" := lintResult;
//             lrecGLAccountStaging.Modify();
//         end;
//     end;


//     procedure "<-- Stage 2 related ->"()
//     begin
//     end;


//     procedure gfncValidateImportRec(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecGLAccountStaging: Record "G/L Account (Staging)";
//         lintTotal: Integer;
//         lintPosition: Integer;
//         lintLastPct: Integer;
//         ldlgDialog: Dialog;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := true;
//         lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.");
//         lrecGLAccountStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");

//         if p_blnDialog then begin
//             ldlgDialog.Open(DLG_001);
//             ldlgDialog.Update(1, MSG_001);
//             lintTotal := lrecGLAccountStaging.Count;
//             lintPosition := 0;
//         end;

//         //
//         // Checks that can be done one by one
//         //

//         lrecGLAccountStaging.Reset();
//         lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.", "Company No.");
//         lrecGLAccountStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         lintLastPct := 0;
//         if lrecGLAccountStaging.FindSet(false) then
//             repeat
//                 if p_blnDialog then begin
//                     lintPosition += 1;
//                     if Round((lintPosition / lintTotal) * 100, 1, '<') > lintLastPct then begin
//                         lintLastPct := Round((lintPosition / lintTotal) * 100, 1, '<');
//                         ldlgDialog.Update(2, lintLastPct * 100);
//                     end;
//                 end;

//                 //
//                 // Specific check here
//                 //
//                 if lrecGLAccountStaging."Company No." = '' then begin
//                     r_blnResult := false;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                       //                                   STRSUBSTNO(ERR_001, lrecGLAccountStaging."No.")); // MP 19-04-12 Replaced by below
//                       StrSubstNo(ERR_001, lrecGLAccountStaging.FieldCaption("Company No."), lrecGLAccountStaging."No."));
//                 end;

//                 // MP 19-04-12 >>

//                 if lrecGLAccountStaging."Financial Statement Code" = '' then begin
//                     r_blnResult := false;
//                     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                       StrSubstNo(ERR_001, lrecGLAccountStaging.FieldCaption("Financial Statement Code"), lrecGLAccountStaging."No."));
//                 end;

//             // MP 19-04-12 <<

//             until lrecGLAccountStaging.Next() = 0;


//         if p_blnDialog then begin
//             ldlgDialog.Close();
//         end;
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
//         r_blnResult := true;
//         // Get list of companies
//         lrecGenJournalLineStaging.SetCurrentKey("Import Log Entry No.", "Company No.", "Posting Date");
//         lrecGenJournalLineStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         if lrecImportLogSubsidiaryClient.FindSet(true) then
//             repeat
//                 lrecImportLogSubsidiaryClient."First Entry Date" := p_recImportLog."Import Date";
//                 lrecImportLogSubsidiaryClient."Last Entry Date" := p_recImportLog."Import Date";
//                 lrecImportLogSubsidiaryClient.Modify();
//             until lrecImportLogSubsidiaryClient.Next() = 0;
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
//         exit(true);
//     end;


//     procedure gfncGetActionNoCopyData(): Integer
//     begin
//         //
//         // Returns Action Number which represents copy data
//         // as per definiton in CU 60008 Data Import Safe WS call
//         //
//         exit(8);
//     end;


//     procedure gfncCopyClient(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // ldotGLAccountStg_Service: DotNet GLAccountStg_Service;
//         // ldotGLAccountStg: DotNet GLAccountStg;
//         // ldotArray: DotNet Array;
//         lintBatchSize: Integer;
//         lintArrayPosition: Integer;
//         lintArrayLength: Integer;
//         lintRemainingRecords: Integer;
//         lintLastPct: Integer;
//         lrecGLAccountStaging: Record "G/L Account (Staging)";
//         lblnNoMoreRecords: Boolean;
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//         lintRecordCount: Integer;
//         lintCounter: Integer;
//     begin
//         //
//         // Copy data to specific client using webservice
//         //
//         if p_blnDialog then begin
//             ldlgDialog.Open(DLG_002);
//             ldlgDialog.Update(1, p_recImportLogSubsidiaryClient."Company Name");
//         end;
//         //ldotGLAccountStg_Service := ldotGLAccountStg_Service.GLAccountStg_Service();
//         //ldotGLAccountStg_Service.UseDefaultCredentials(TRUE);

//         // if not lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//         //    TXT_PAGE,
//         //    lmodDataImportManagementCommon.gfncGetGLAccStgWSName(),
//         //    ltxtURL, ltxtErr)
//         //   then begin
//         //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//         //     exit(false);
//     end;

//         //ldotGLAccountStg_Service.Url := ltxtURL;
//         //ToDo Move to setup
//        // lintBatchSize := 500; // Initial batch size Should be in setup!
//         //lblnNoMoreRecords := false;

//        // lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.", "Company No.");
//         //lrecGLAccountStaging.SetRange("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
//         //lrecGLAccountStaging.SetRange("Company No.", p_recImportLogSubsidiaryClient."Company No.");
//         //lintRemainingRecords := lrecGLAccountStaging.Count;
//        // lintArrayPosition := 0;
//         //ldotGLAccountStg := ldotGLAccountStg.GLAccountStg();

//         // if p_blnDialog then begin
//         //     lintRecordCount := lrecGLAccountStaging.Count;
//         //     lintCounter := 0;
//         //end;

//         if lrecGLAccountStaging.FindSet(false) then begin
//             repeat
//                 // Build array up to the batch size
//                 if p_blnDialog then begin
//                     ldlgDialog.Update(2, MSG_002);
//                 end;

//                 if lintRemainingRecords > lintBatchSize then
//                     lintArrayLength := lintBatchSize
//                 else
//                     lintArrayLength := lintRemainingRecords;
//                // if not IsNull(ldotArray) then Clear(ldotArray);
//                 // ldotArray := ldotArray.CreateInstance(ldotGLAccountStg.GetType(), lintArrayLength);
//                 lintLastPct := 0;
//                 repeat
//                     if p_blnDialog then begin
//                         lintCounter += 1;
//                         if Round((lintCounter / lintRecordCount) * 100, 1, '<') > lintLastPct then begin
//                             lintLastPct := Round((lintCounter / lintRecordCount) * 100, 1, '<');
//                             ldlgDialog.Update(3, lintLastPct * 100);
//                         end;
//                     end;
//                     //if not IsNull(ldotGLAccountStg) then Clear(ldotGLAccountStg);
//                     // ldotGLAccountStg := ldotGLAccountStg.GLAccountStg(); // Constructor
//                     // Build record
//                     // ldotGLAccountStg.No                            := lrecGLAccountStaging."No.";
//                     //ldotGLAccountStg.Name                          := lrecGLAccountStaging.Name;
//                     // ldotGLAccountStg.Income_Balance                := lrecGLAccountStaging."Income/Balance";
//                     // ldotGLAccountStg.Income_BalanceSpecified       := TRUE;
//                     // ldotGLAccountStg.Gen_Bus_Posting_Type          := lrecGLAccountStaging."Gen. Bus. Posting Type";
//                     //  ldotGLAccountStg.Gen_Bus_Posting_TypeSpecified := TRUE;
//                     //ldotGLAccountStg.Accounting_Class              := lrecGLAccountStaging."Accounting Class";
//                     // ldotGLAccountStg.Accounting_ClassSpecified     := TRUE;
//                     //ldotGLAccountStg.Name_ENU                      := lrecGLAccountStaging."Name - ENU";
//                     // ldotGLAccountStg.Financial_Statement_Code      := lrecGLAccountStaging."Financial Statement Code";
//                     // ldotGLAccountStg.Company_No                    := lrecGLAccountStaging."Company No.";
//                     // ldotGLAccountStg.Client_No                     := lrecGLAccountStaging."Client No.";
//                     // ldotGLAccountStg.User_ID                       := lrecGLAccountStaging."User ID";
//                     // ldotGLAccountStg.Status                        := lrecGLAccountStaging.Status;
//                     //ldotGLAccountStg.StatusSpecified               := TRUE;
//                     //ldotGLAccountStg.Import_Log_Entry_No           := lrecGLAccountStaging."Import Log Entry No.";
//                     //  ldotGLAccountStg.Import_Log_Entry_NoSpecified  := TRUE;

//                     // ldotGLAccountStg.FS_Name                       := lrecGLAccountStaging."FS Name";
//                     // ldotGLAccountStg.FS_Name_English               := lrecGLAccountStaging."FS Name (English)";
//                     // Add to array
//                    // ldotArray.SetValue(ldotGLAccountStg, lintArrayPosition);
//                     lintArrayPosition += 1;
//                     lblnNoMoreRecords := (lrecGLAccountStaging.Next = 0);
//                     lintRemainingRecords -= 1;
//                 until ((lintArrayPosition = (lintBatchSize - 1)) or lblnNoMoreRecords);
//                 lintArrayPosition := 0;
//                 if p_blnDialog then begin
//                     ldlgDialog.Update(2, MSG_003);
//                 end;
//             // and send it
//             //ldotGLAccountStg_Service.CreateMultiple(ldotArray); // disabled for testing
//             until lblnNoMoreRecords;
//         end;

//         if p_blnDialog then begin
//             ldlgDialog.Close;
//         end;

//         exit(true);
//     end;

    
//     procedure "<-- Stage 4 related ->"()
//     begin
//     end;

    
//     procedure gfncValidateLocalData(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecGLAccountStaging: Record "G/L Account (Staging)";
//     begin
//         //
//         // Not much to be tested here
//         //
//         exit(true);

//         // Sample code -->
//         r_blnResult := true;
//         lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.");
//         lrecGLAccountStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         if lrecGLAccountStaging.FindSet(false) then
//             repeat
//             // Specific checks here

//             until lrecGLAccountStaging.Next = 0;
//         // Sample code <--
//     end;

    
//     procedure "<-- Stage 5 related ->"()
//     begin
//     end;

    
//     procedure gfncPostTransactions(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecGLAccountStaging: Record "G/L Account (Staging)";
//         lrecGLAccount: Record "G/L Account";
//         lrecFinancialStatementCode: Record "Financial Statement Code";
//         lmdlFSCodeMgt: Codeunit "Fin. Stmt. Code Management";
//         lcodOrgFSCode: Code[10];
//     begin
//         lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.");
//         lrecGLAccountStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");

//         if lrecGLAccountStaging.FindSet(false) then
//             repeat
//                 //
//                 // Create G/L account line
//                 //
//                 if not lrecGLAccount.Get(lrecGLAccountStaging."No.") then lrecGLAccount.Init;
//                 lrecGLAccount."No." := lrecGLAccountStaging."No.";
//                 lrecGLAccount.Name := lrecGLAccountStaging.Name;
//                 lrecGLAccount."Income/Balance" := lrecGLAccountStaging."Income/Balance";
//                 lrecGLAccount."Gen. Posting Type" := lrecGLAccountStaging."Gen. Bus. Posting Type";
//                 lrecGLAccount."Account Class" := lrecGLAccountStaging."Accounting Class";
//                 lrecGLAccount."Name (English)" := lrecGLAccountStaging."Name - ENU";
//                 lcodOrgFSCode := lrecGLAccount."Financial Statement Code"; // MP 31-03-16
//                 lrecGLAccount."Financial Statement Code" := lrecGLAccountStaging."Financial Statement Code";
//                 //
//                 // Default values
//                 //
//                 lrecGLAccount."Direct Posting" := true;
//                 lrecGLAccount."Debit/Credit" := lrecGLAccount."Debit/Credit"::Both;
//                 lrecGLAccount."Account Type" := lrecGLAccount."Account Type"::Posting;
//                 //
//                 // Insert / update G/L account
//                 //
//                 if not lrecGLAccount.Insert(true) then lrecGLAccount.Modify(true);

//                 // FS Code
//                 if lrecGLAccount."Financial Statement Code" <> '' then begin
//                     if not lrecFinancialStatementCode.Get(lrecGLAccount."Financial Statement Code") then begin
//                         lrecFinancialStatementCode.Init;
//                         lrecFinancialStatementCode.Code := lrecGLAccount."Financial Statement Code";
//                         lrecFinancialStatementCode.Insert(true);
//                     end;
//                     if lrecGLAccountStaging."FS Name" <> '' then // MP 30-04-14
//                         lrecFinancialStatementCode.Description := lrecGLAccountStaging."FS Name";
//                     if lrecGLAccountStaging."FS Name (English)" <> '' then // MP 30-04-14
//                         lrecFinancialStatementCode."Description (English)" := lrecGLAccountStaging."FS Name (English)";
//                     lrecFinancialStatementCode.Modify(true);
//                 end;
//                // lmdlFSCodeMgt.gfcnUpdateGLAccFSCodeAndHistory(lrecGLAccount, lcodOrgFSCode); // MP 31-03-16
//             until lrecGLAccountStaging.Next = 0;
//         exit(true);
//     end;

    
//     procedure "<-- Other -->"()
//     begin
//     end;

    
//     procedure gfncArchive(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecStaging: Record "G/L Account (Staging)";
//         lRecProcessed: Record "G/L Account (Processed)";
//         ldlgDialog: Dialog;
//         lintCount: Integer;
//         lintCounter: Integer;
//         lintLastPct: Integer;
//     begin
//         r_blnResult := true;
//         if p_blnDialog then begin
//             ldlgDialog.Open(DLG_003);
//         end;
//         //
//         // Copy to destination table
//         //
//         lrecStaging.SetCurrentKey("Import Log Entry No.");
//         lrecStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         lintCount := lrecStaging.Count;
//         lintCounter := 0;
//         lintLastPct := 0;
//         if lrecStaging.FindSet(false, false) then
//             repeat
//                 lRecProcessed.Init;
//                 lRecProcessed.TransferFields(lrecStaging, true);
//                 lRecProcessed.Insert;
//                 if p_blnDialog then begin
//                     lintCounter += 1;
//                     if Round(lintCount / lintCounter * 100, 1, '<') > lintLastPct then begin
//                         lintLastPct := Round(lintCount / lintCounter * 100, 1, '<');
//                         ldlgDialog.Update(1, lintLastPct * 100);
//                     end;
//                 end;
//             until lrecStaging.Next = 0;

//         //
//         // Delete source records
//         //
//         lrecStaging.Reset;
//         lrecStaging.SetCurrentKey("Import Log Entry No.");
//         lrecStaging.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecStaging.DeleteAll;

//         if p_blnDialog then begin
//             ldlgDialog.Close;
//         end;
//     end;
// }

