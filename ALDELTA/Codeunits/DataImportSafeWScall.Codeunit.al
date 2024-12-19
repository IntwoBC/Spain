// codeunit 60008 "Data Import Safe WS call"
// {
//     // This codeunit contains procedures used to consume external Web service
//     // It also contains code dealing with dotNet variables
//     // 
//     // MP 30-04-14
//     // Development taken from Core II
//     // 
//     // MP 26-11-14
//     // NAV 2013 R2 Upgrade


//     trigger OnRun()
//     var
//         lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
//         lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         IF ISSERVICETIER THEN BEGIN
//             CASE gintAction OF
//                 1:
//                     gblnResult := lmodDataImportMgt_60012.gfncCopyClient(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 2:
//                     gblnResult := gfncDeleteRemoteData(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 3:
//                     gblnResult := gfncCopyImportLog(grecImportLog, grecImportLogSubsidiaryClient, gtxtKey, gblnDialog);
//                 4:
//                     gblnResult := gfncDeleteImportLog(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 5:
//                     gblnResult := gfncValidateRemoteData(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 6:
//                     gblnResult := gfncMoveRemoteErrorLog(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 7:
//                     gblnResult := gfncPostRemoteData(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 8:
//                     gblnResult := lmodDataImportMgt_60009.gfncCopyClient(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 9:
//                     gblnResult := lmodDataImportMgt_60018.gfncCopyClient(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 10:
//                     gblnResult := lmodDataImportMgt_60019.gfncCopyClient(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 11:
//                     gblnResult := lmodDataImportMgt_60020.gfncCopyClient(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 12:
//                     gblnResult := gfncUpdateImportLog(grecImportLog, grecImportLogSubsidiaryClient, gtxtKey, gblnDialog);
//                 13:
//                     gblnResult := gfncArchiveRemoteData(grecImportLog, grecImportLogSubsidiaryClient, gblnDialog);
//                 50:
//                     gblnResult := gfncDateRangeValid(grecImportLog, grecImportLogSubsidiaryClient, gdatStartDate, gdatEndDate);
//                 98:
//                     gblnResult := gfncAccessTest(gtxtURL);
//                 99:
//                     gblnResult := gfncTest(grecImportLog, grecImportLogSubsidiaryClient, 'test');
//                 ELSE
//                     ERROR(ERR_002);
//             END;
//         END ELSE BEGIN
//             ERROR(ERR_003);
//         END;
//     end;

//     var
//         TXT_PAGE: Label 'Page';
//         TXT_CODEUNIT: Label 'Codeunit';
//         DLG_001: Label 'Target #1########################\Activity #2########\@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
//         gintAction: Integer;
//         grecImportLog: Record "Import Log";
//         grecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//         gblnResult: Boolean;
//         gblnDialog: Boolean;
//         gdatStartDate: Date;
//         gdatEndDate: Date;
//         DLG_002: Label 'Transfering data from #1##############\Activity #2########\Key #3##################';
//         DLG_003: Label 'Posting remote data started';
//         ERR_001: Label 'User %1 is not allowed post in date range %2 .. %3 in DB %4 Company %5';
//         ERR_002: Label 'Unknown WS call';
//         ERR_003: Label 'WS can be called from Service Tier Only';
//         MSG_003: Label 'Sending Import Log';
//         MSG_004: Label 'Deleting Remote Import Log';
//         MSG_005: Label 'Reading remote Error Log';
//         MSG_006: Label 'Processing';
//         MSG_007: Label 'Updating Import Log';
//         gtxtKey: Text[1024];
//         ERR_004: Label 'Cannot build System service URL. Local DB %1 ';
//         gtxtURL: Text[1024];
//         txtTenant: Label '?tenant=';


//     procedure gfncTest(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_txtText: Text[1024]) r_blnResult: Boolean
//     var
//         //  ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//         //ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         //ldotDataImportMgt.UseDefaultCredentials(TRUE);
//        // IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                           // TXT_CODEUNIT,
//                                                           // lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                           // ltxtURL, ltxtErr)
//         //THEN BEGIN
//            // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//        // ldotDataImportMgt.Url(ltxtURL);

//       //  r_blnResult := (ldotDataImportMgt.Test(LOWERCASE(p_txtText)) = UPPERCASE(p_txtText));
//  //  end;


//     procedure gfncAccessTest(p_txtURL: Text[1024]) r_blnResult: Boolean
//     var
//         //ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//        // ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//       //  ldotDataImportMgt.UseDefaultCredentials(TRUE);
//        // ldotDataImportMgt.Url(p_txtURL);
//       //  ldotDataImportMgt.Test('test');
//         r_blnResult := TRUE;
//     end;


//     procedure gfncSetAction(p_intAction: Integer)
//     begin
//         gintAction := p_intAction;
//     end;


//     procedure gfncSetDialog(p_blnDialog: Boolean)
//     begin
//         gblnDialog := p_blnDialog;
//     end;


//     procedure gfncSetImportLog(var p_recImportLog: Record "Import Log")
//     begin
//         grecImportLog := p_recImportLog;
//     end;


//     procedure gfncSetSubsImportLog(var p_recImportLogSubsidaryClient: Record "Import Log - Subsidiary Client")
//     begin
//         grecImportLogSubsidiaryClient := p_recImportLogSubsidaryClient;
//     end;


//     procedure gfncSetStartEndDate(p_datStartDate: Date; p_datEndDate: Date)
//     begin
//         gdatStartDate := p_datStartDate;
//         gdatEndDate := p_datEndDate;
//     end;


//     procedure gfncSetURL(p_txtURL: Text[1024])
//     begin
//         gtxtURL := p_txtURL;
//     end;


//     procedure gfncSetKey(p_txtKey: Text[1024])
//     begin
//         gtxtKey := p_txtKey;
//     end;


//     procedure gfncGetKey(): Text[1024]
//     begin
//         EXIT(gtxtKey);
//     end;


//     procedure gfncGetLastResult(): Boolean
//     begin
//         EXIT(gblnResult);
//     end;


//     procedure gfncValidateRemoteData(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         //ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//         ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         ldotDataImportMgt.UseDefaultCredentials := TRUE;
//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_CODEUNIT,
//                                                            lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotDataImportMgt.Url := ltxtURL;

//         r_blnResult := ldotDataImportMgt.ValidateData(p_recImportLog."Entry No.", p_recImportLog."Table ID");
//     end;


//     procedure gfncDeleteRemoteData(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnValue: Boolean
//     var
//         // ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//         ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         ldotDataImportMgt.UseDefaultCredentials := TRUE;
//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_CODEUNIT,
//                                                            lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotDataImportMgt.Url := ltxtURL;

//         ldotDataImportMgt.DeleteEntries(p_recImportLog."Entry No.", p_recImportLog."Table ID");

//         r_blnValue := TRUE;
//     end;


//     procedure gfncPostRemoteData(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         //ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         ldlgDialog: Dialog;
//     begin
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_003);
//         END;
//         ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         ldotDataImportMgt.UseDefaultCredentials := TRUE;
//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_CODEUNIT,
//                                                            lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotDataImportMgt.Url := ltxtURL;

//         r_blnResult := ldotDataImportMgt.PostTransactions(p_recImportLog."Entry No.", p_recImportLog."Table ID");
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.CLOSE();
//         END;
//     end;


//     procedure gfncArchiveRemoteData(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnValue: Boolean
//     var
//         // ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//         ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         ldotDataImportMgt.UseDefaultCredentials := TRUE;
//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_CODEUNIT,
//                                                            lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotDataImportMgt.Url := ltxtURL;

//         ldotDataImportMgt.Archive(p_recImportLog."Entry No.", p_recImportLog."Table ID");

//         r_blnValue := TRUE;
//     end;


//     procedure gfncCopyImportLog(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; var p_txtKey: Text[1024]; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         //ldotImportLog: DotNet ImportLog;
//         // ldotImportLog_Service: DotNet ImportLog_Service;
//         lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//     begin
//         p_blnDialog := FALSE; // it is so quick that it only flashes anyway...
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_001, p_recImportLogSubsidiaryClient."Company Name");
//         END;
//         ldotImportLog_Service := ldotImportLog_Service.ImportLog_Service();
//         ldotImportLog_Service.UseDefaultCredentials(TRUE); // will work only within the same domain

//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_PAGE,
//                                                            lmodDataImportManagementCommon.gfncGetImportLogWSName(),
//                                                            //'ImportLog',
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotImportLog_Service.Url := ltxtURL;

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.UPDATE(2, MSG_003);
//         END;

//         // Build record
//         ldotImportLog := ldotImportLog.ImportLog();
//         ldotImportLog.Entry_No := p_recImportLog."Entry No.";
//         ldotImportLog.Entry_NoSpecified := TRUE;
//         ldotImportLog.Parent_Client_No := p_recImportLog."Parent Client No.";
//         ldotImportLog.Interface_Type := p_recImportLog."Interface Type";
//         ldotImportLog.Interface_TypeSpecified := TRUE;
//         ldotImportLog.User_ID := p_recImportLog."User ID";
//         ldotImportLog.Import_Date := CREATEDATETIME(p_recImportLog."Import Date", 0T);
//         ldotImportLog.Import_DateSpecified := TRUE;
//         ldotImportLog.Import_Time := CREATEDATETIME(01011754D, p_recImportLog."Import Time");
//         ldotImportLog.Import_TimeSpecified := TRUE;
//         ldotImportLog.Table_Caption := p_recImportLog."Table Caption";
//         ldotImportLog.File_Name := p_recImportLog."File Name";
//         ldotImportLog.Status := p_recImportLog.Status;
//         ldotImportLog.StatusSpecified := TRUE;
//         ldotImportLog.Stage := p_recImportLog.Stage;
//         ldotImportLog.StageSpecified := TRUE;
//         ldotImportLog.Table_ID := p_recImportLog."Table ID";
//         ldotImportLog.Table_IDSpecified := TRUE;
//         //ldotImportLog.TB_to_TB_client              := p_recImportLogSubsidiaryClient."TB to TB client";
//         //ldotImportLog.TB_to_TB_clientSpecified     := TRUE;

//         ldotImportLog.G_L_Detail_level := p_recImportLogSubsidiaryClient."G/L Detail level";
//         ldotImportLog.G_L_Detail_levelSpecified := TRUE;
//         ldotImportLog.Statutory_Reporting := p_recImportLogSubsidiaryClient."Statutory Reporting";
//         ldotImportLog.Statutory_ReportingSpecified := TRUE;
//         ldotImportLog.Corp_Tax_Reporting := p_recImportLogSubsidiaryClient."Corp. Tax Reporting";
//         ldotImportLog.Corp_Tax_ReportingSpecified := TRUE;
//         ldotImportLog.VAT_Reporting_level := p_recImportLogSubsidiaryClient."VAT Reporting level";
//         ldotImportLog.VAT_Reporting_levelSpecified := TRUE;

//         ldotImportLog.Posting_Method := p_recImportLog."Posting Method";
//         ldotImportLog.Posting_MethodSpecified := TRUE;

//         ldotImportLog.ARTransPost := p_recImportLog."A/R Trans Posting Scenario";
//         ldotImportLog.ARTransPostSpecified := TRUE;
//         ldotImportLog.APTransPost := p_recImportLog."A/P Trans Posting Scenario";
//         ldotImportLog.APTransPostSpecified := TRUE;
//         // and send it
//         ldotImportLog_Service.Create(ldotImportLog);
//         p_txtKey := ldotImportLog.Key;
//         EXIT(TRUE);
//     end;


//     procedure gfncUpdateImportLog(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_txtKey: Text[1024]; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // ldotImportLog: DotNet ImportLog;
//         // ldotImportLog_Service: DotNet ImportLog_Service;
//         lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//     begin
//         p_blnDialog := FALSE; // it is so quick that it only flashes anyway...
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_001, p_recImportLogSubsidiaryClient."Company Name");
//         END;
//         ldotImportLog_Service := ldotImportLog_Service.ImportLog_Service();
//         ldotImportLog_Service.UseDefaultCredentials(TRUE); // will work only within the same domain

//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_PAGE,
//                                                            lmodDataImportManagementCommon.gfncGetImportLogWSName(),
//                                                            //'ImportLog',
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotImportLog_Service.Url := ltxtURL;

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.UPDATE(2, MSG_007);
//         END;

//         // Build record
//         ldotImportLog := ldotImportLog.ImportLog();
//         ldotImportLog.Key := p_txtKey;
//         ldotImportLog.Entry_No := p_recImportLog."Entry No.";
//         ldotImportLog.Entry_NoSpecified := TRUE;
//         ldotImportLog.Parent_Client_No := p_recImportLog."Parent Client No.";
//         ldotImportLog.Interface_Type := p_recImportLog."Interface Type";
//         ldotImportLog.Interface_TypeSpecified := TRUE;
//         ldotImportLog.User_ID := p_recImportLog."User ID";
//         ldotImportLog.Import_Date := CREATEDATETIME(p_recImportLog."Import Date", 0T);
//         ldotImportLog.Import_DateSpecified := TRUE;
//         ldotImportLog.Import_Time := CREATEDATETIME(01011754D, p_recImportLog."Import Time");
//         ldotImportLog.Import_TimeSpecified := TRUE;
//         ldotImportLog.Table_Caption := p_recImportLog."Table Caption";
//         ldotImportLog.File_Name := p_recImportLog."File Name";
//         ldotImportLog.Status := p_recImportLog.Status;
//         ldotImportLog.StatusSpecified := TRUE;
//         ldotImportLog.Stage := p_recImportLog.Stage;
//         ldotImportLog.StageSpecified := TRUE;
//         ldotImportLog.Table_ID := p_recImportLog."Table ID";
//         ldotImportLog.Table_IDSpecified := TRUE;
//         ldotImportLog.TB_to_TB_client := p_recImportLogSubsidiaryClient."TB to TB client";
//         ldotImportLog.TB_to_TB_clientSpecified := TRUE;

//         // and update it
//         ldotImportLog_Service.Update(ldotImportLog);

//         //ERROR('Key :'+p_txtKey+' Status: '+ FORMAT(p_recImportLog.Status));

//         EXIT(TRUE);
//     end;


//     procedure gfncDeleteImportLog(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // ldotImportLog: DotNet ImportLog;
//         //ldotImportLog_Service: DotNet ImportLog_Service;
//         lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//     begin
//         p_blnDialog := FALSE; // Too quick, only flash
//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_001, p_recImportLogSubsidiaryClient."Company Name");
//         END;
//         ldotImportLog_Service := ldotImportLog_Service.ImportLog_Service();
//         ldotImportLog_Service.UseDefaultCredentials(TRUE); // will work only within the same domain

//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_PAGE,
//                                                            lmodDataImportManagementCommon.gfncGetImportLogWSName(),
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotImportLog_Service.Url := ltxtURL;

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.UPDATE(2, MSG_004);
//         END;

//         // Read record
//         ldotImportLog := ldotImportLog.ImportLog();
//         ldotImportLog := ldotImportLog_Service.Read(p_recImportLog."Entry No.");
//         ldotImportLog_Service.Delete(ldotImportLog.Key);

//         EXIT(TRUE);
//     end;


//     procedure gfncMoveRemoteErrorLog(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // ldotImportErrorLog_Service: DotNet ImportErrorLog_Service;
//         // ldotImportErrorLog: DotNet ImportErrorLog;
//         // ldotImportErrorLog_Filter: DotNet ImportErrorLog_Filter;
//         // ldotFilterArray: DotNet Array;
//         // ldotImportErrorLogArray: DotNet Array;
//         // ldotImportErrorLog_Fields: DotNet ImportErrorLog_Fields;
//         lrecImportErrorLog: Record "Import Error Log";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ldlgDialog: Dialog;
//         lintFetchSize: Integer;
//         lintCounter: Integer;
//         ltxtBookmarkKey: Text[1024];
//         lblnDone: Boolean;
//         lintFilterArrayLength: Integer;
//         lvarVar: Variant;
//     begin
//         lintFetchSize := 50; // Should be in setup
//         ltxtBookmarkKey := '';

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.OPEN(DLG_002);
//             ldlgDialog.UPDATE(1, p_recImportLogSubsidiaryClient."Company Name");
//         END;
//         ldotImportErrorLog_Service := ldotImportErrorLog_Service.ImportErrorLog_Service();
//         ldotImportErrorLog_Service.UseDefaultCredentials(TRUE); // will work only within the same domain

//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_PAGE,
//                                                            lmodDataImportManagementCommon.gfncGetImportErrorLogWSName(),
//                                                            ltxtURL, ltxtErr) THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotImportErrorLog_Service.Url := ltxtURL;

//         IF p_blnDialog THEN BEGIN
//             ldlgDialog.UPDATE(2, MSG_005);
//         END;

//         // Build Filter Array
//         ldotImportErrorLog_Filter := ldotImportErrorLog_Filter.ImportErrorLog_Filter();

//         lintFilterArrayLength := 1;
//         ldotFilterArray := ldotFilterArray.CreateInstance(ldotImportErrorLog_Filter.GetType(), 1);
//         ldotImportErrorLog := ldotImportErrorLog.ImportErrorLog();

//         //ldotImportErrorLog_Fields := ldotImportErrorLog_Fields.Parse(ldotImportErrorLog_Fields.GetType(), 'Import_Log_Entry_No');
//         ldotImportErrorLog_Filter.Field(4);  // Use more generic method - see suggestion above
//         ldotImportErrorLog_Filter.Criteria(FORMAT(p_recImportLog."Entry No."));
//         ldotFilterArray.SetValue(ldotImportErrorLog_Filter, 0);
//         lblnDone := FALSE;

//         ldotImportErrorLogArray := ldotImportErrorLog_Service.ReadMultiple(ldotFilterArray, ltxtBookmarkKey, lintFetchSize);
//         WHILE (ldotImportErrorLogArray.Length > 0) DO BEGIN
//             IF p_blnDialog THEN BEGIN
//                 ldlgDialog.UPDATE(2, MSG_006);
//             END;
//             lintCounter := 0;
//             WHILE (lintCounter < ldotImportErrorLogArray.Length) DO BEGIN
//                 ldotImportErrorLog := ldotImportErrorLogArray.GetValue(lintCounter);
//                 ltxtBookmarkKey := ldotImportErrorLog.Key;
//                 IF p_blnDialog THEN BEGIN
//                     ldlgDialog.UPDATE(3, ltxtBookmarkKey);
//                 END;
//                 // create and insert record
//                 ldotImportErrorLog := ldotImportErrorLogArray.GetValue(lintCounter);

//                 lrecImportErrorLog.INIT();
//                 lrecImportErrorLog."Entry No." := 0;
//                 lrecImportErrorLog."Client No." := grecImportLogSubsidiaryClient."Parent Client No.";
//                 lrecImportErrorLog."Country Database Code" := grecImportLogSubsidiaryClient."Country Database Code";
//                 lrecImportErrorLog."Company Name" := grecImportLogSubsidiaryClient."Company Name";
//                 lrecImportErrorLog."Import Log Entry No." := ldotImportErrorLog.Import_Log_Entry_No;
//                 lrecImportErrorLog."Staging Table Entry No." := ldotImportErrorLog.Staging_Table_Entry_No;
//                 lrecImportErrorLog.Description := ldotImportErrorLog.Description;
//                 lrecImportErrorLog."Date & Time" := ldotImportErrorLog.Date__Time;
//                 lrecImportErrorLog.INSERT(TRUE);
//                 // increment counter
//                 lintCounter += 1;
//             END;
//             // delete records
//             IF p_blnDialog THEN BEGIN
//                 ldlgDialog.UPDATE(2, MSG_004);
//                 ldlgDialog.UPDATE(3, '');
//             END;

//             lintCounter := 0;
//             WHILE (lintCounter < ldotImportErrorLogArray.Length) DO BEGIN
//                 ldotImportErrorLog := ldotImportErrorLogArray.GetValue(lintCounter);
//                 ldotImportErrorLog_Service.Delete(ldotImportErrorLog.Key);
//                 lintCounter += 1;
//             END;
//             ltxtBookmarkKey := ''; // As the records were deleted, we start from top
//             IF p_blnDialog THEN BEGIN
//                 ldlgDialog.UPDATE(2, MSG_005);
//                 ldlgDialog.UPDATE(3, '');
//             END;
//             ldotImportErrorLogArray := ldotImportErrorLog_Service.ReadMultiple(ldotFilterArray, ltxtBookmarkKey, lintFetchSize);
//         END;

//         EXIT(TRUE);
//     end;


//     procedure gfncDateRangeValid(var p_recImportLog: Record "Import Log"; var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_datStartDate: Date; p_datEndDate: Date) r_blnResult: Boolean
//     var
//         // ldotDataImportMgt: DotNet DataImportManagement;
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtErr: Text[1024];
//     begin
//         ldotDataImportMgt := ldotDataImportMgt.DataImportManagement();
//         ldotDataImportMgt.UseDefaultCredentials := TRUE;
//         IF NOT lmodDataImportManagementCommon.gfncBuildURL(p_recImportLogSubsidiaryClient,
//                                                            TXT_CODEUNIT,
//                                                            lmodDataImportManagementCommon.gfncGetImportMgtWSName,
//                                                            ltxtURL, ltxtErr)
//           THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, ltxtErr);
//             EXIT(FALSE);
//         END;

//         ldotDataImportMgt.Url := ltxtURL;

//         r_blnResult := ldotDataImportMgt.DateRangeValid(CREATEDATETIME(p_datStartDate, 0T), CREATEDATETIME(p_datEndDate, 0T));

//         IF NOT r_blnResult THEN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_001, USERID, gdatStartDate, gdatEndDate,
//                                            p_recImportLogSubsidiaryClient."Country Database Code",
//                                            p_recImportLogSubsidiaryClient."Company Name"));
//     end;


//     procedure gfncFillCompanyList(var p_recSubsidiaryCompany: Record "Subsidiary Company"; p_codCountryDatabase: Code[20]): Boolean
//     var
//         // ldotSystemService: DotNet SystemService;
//         lrecCountryDatabase: Record "Country Database";
//         ltxtError: Text[1024];
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         ltxtURL: Text[1024];
//         ltxtCompanyArray: array[250] of Text[250];
//         lvarVar: Variant;
//         //ldotArray: DotNet Array;
//         i: Integer;
//         lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//     begin
//         p_recSubsidiaryCompany.DELETEALL();
//         IF p_codCountryDatabase <> '' THEN BEGIN
//             ldotSystemService := ldotSystemService.SystemService();
//             ldotSystemService.UseDefaultCredentials := TRUE;

//             IF NOT lrecCountryDatabase.GET(p_codCountryDatabase) THEN BEGIN
//                 ERROR(STRSUBSTNO(ERR_004, p_codCountryDatabase));
//                 EXIT(FALSE);
//             END;
//             IF (STRPOS(lrecCountryDatabase."Server Address (Web Service)", 'WS') <>
//                (STRLEN(lrecCountryDatabase."Server Address (Web Service)") - 1))
//               THEN BEGIN
//                 ERROR(STRSUBSTNO(ERR_004, p_codCountryDatabase));
//                 EXIT(FALSE); // Check if WS are last characters
//             END;
//             ltxtURL := lrecCountryDatabase."Server Address (Web Service)";
//             ltxtURL := ltxtURL + '/SystemService';

//             // MP 26-11-14 >>
//             IF lrecCountryDatabase."Tenant Id" <> '' THEN
//                 ltxtURL += txtTenant + lrecCountryDatabase."Tenant Id";
//             // MP 26-11-14 <<

//             ldotSystemService.Url := ltxtURL;
//             lmodDataImportSafeWScall.gfncSetAction(99); // test call
//             lvarVar := ldotSystemService.Companies();
//             ldotArray := lvarVar;
//             FOR i := 0 TO ldotArray.Length - 1 DO BEGIN
//                 // Test access to the company
//                 ltxtURL := lrecCountryDatabase."Server Address (Web Service)";
//                 ltxtURL := ltxtURL + '/' + lmodDataImportManagementCommon.gfncCodeString(ldotArray.GetValue(i));
//                 ltxtURL := ltxtURL + '/' + TXT_CODEUNIT;
//                 ltxtURL := ltxtURL + '/' + lmodDataImportManagementCommon.gfncGetImportMgtWSName;

//                 // MP 26-11-14 >>
//                 IF lrecCountryDatabase."Tenant Id" <> '' THEN
//                     ltxtURL += txtTenant + lrecCountryDatabase."Tenant Id";
//                 // MP 26-11-14 <<

//                 lmodDataImportSafeWScall.gfncSetURL(ltxtURL);
//                 COMMIT();
//                 IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//                     p_recSubsidiaryCompany.INIT();
//                     p_recSubsidiaryCompany.Name := ldotArray.GetValue(i);
//                     p_recSubsidiaryCompany.INSERT();
//                 END;
//             END;
//         END;
//     end;
// }

