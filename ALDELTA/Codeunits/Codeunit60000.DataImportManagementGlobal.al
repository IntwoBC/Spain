codeunit 60000 "Data Import Management Global"
{
    // MP 30-04-14
    // Development taken from Core II
    // 
    // MP 17-11-14
    // Upgraded to NAV 2013 R2
    // 
    // MP 25-May-16
    // Upgraded to NAV 2016: deleted obsolete functions gfncImportXLS and gfncImportXLSLine, changed from using Automation to .NET components


    trigger OnRun()
    begin
    end;

    var
        DLG_001: Label 'Import progress\@1@@@@@@@@@@@@@@@@@@';
        DLG_002: Label 'Uploading file to server: #1#############';
        DLG_003: Label '#1################## \ Progress @2@@@@@@@@@@@@@@@@@@';
        DLG_004: Label 'Are you sure you want to delete entries related to import log %1 from table "%2" and move them to the "Processed table"?';
        DLG_005: Label 'Do you want to process Import log No. %1?';
        DLG_006: Label 'Please select Posting Method';
        ERR_001: Label 'Automated processing of Import Log %1 failed at %2. Check details above.';
        ERR_002: Label 'File %1 is empty';
        ERR_003: Label 'Incorrect value "%1" Line:%2 Column:%3 Expected type is %4';
        ERR_004: Label 'Unsupported file type: %1';
        ERR_005: Label 'Unsupported field Type %1, Field %2';
        ERR_006: Label 'Incorrect decimal value "%1" Line:%2 Column:%3';
        ERR_007: Label 'Incorrect date format "%1" Line:%2 Column:%3';
        ERR_008: Label 'Text "%1..." is too long.\Max length is %2\Line:%3 Column:%4';
        ERR_009: Label 'Unsupported Table No. %1';
        ERR_010: Label 'Cannot open file %1';
        ERR_011: Label 'File %1 does not exist';
        ERR_012: Label 'Missing definition for subsidiary company %1';
        ERR_013: Label 'Stage 2 failed. Entries in staging table related to Import log %1 were deleted';
        ERR_014: Label 'Local database %1 does not exist';
        ERR_015: Label 'Automated process cannot start from Stage "%1", Status "%2"';
        ERR_016: Label '%1 WS call error.';
        ERR_017: Label 'Remote validation of Journal %1 in company %2 failed.';
        ERR_018: Label 'Remote posting of Journal %1 in company %2 failed.';
        ERR_019: Label 'Cannot delete temporary file';
        ERR_020: Label 'Stage %1 failed. Entries in remote staging table related to Import log %2 were deleted';
        ERR_021: Label 'Rollback of remote data failed. Stage %1, Import log %2 ';
        ERR_022: Label 'Cannot create server located file %1';
        ERR_023: Label 'Cannot upload into stream file %1. %2';
        ERR_024: Label 'Cannot determine version of Excel : "%1"';
        ERR_025: Label 'Incorrect version of Excel. Current version is "%1". Required version is 12 or higher ';
        ERR_026: Label 'Cannot create file %1. Missing write rights to the directory?';
        ERR_027: Label 'Cannot delete file %1.';
        ERR_028: Label 'Cannot upload file %1 on the server. %2';
        MSG_001: Label 'Import file for G/L Account';
        MSG_002: Label 'Import file for Corporate Account';
        MSG_003: Label 'Import file for Trial Balance';
        MSG_004: Label 'Import file for G/L Entry';
        MSG_005: Label 'Import file for Customer';
        MSG_006: Label 'Import file for Vendor';
        MSG_007: Label 'Import file for AR';
        MSG_008: Label 'Import file for AP';
        MSG_010: Label 'File %1 was imported successfully.\Import log %2 was created.';
        MSG_011: Label 'Import of file %1 failed.\Please check import log %2 for more information.';
        MSG_012: Label 'Preparation ...';
        MSG_013: Label 'Uploading ...';
        MSG_014: Label 'Saving ...';
        MSG_015: Label 'Building list of Companies';
        MSG_016: Label 'Automated processing of Import Log No. %1 started at %2';
        MSG_017: Label 'Automated processing of Import Log No. %1 successfully finished at %2';
        MSG_018: Label 'Processing was successfull';
        MSG_019: Label 'Processing failed. Please check Error log for details';
        MSG_020: Label 'Achiving was successfull';
        MSG_021: Label 'Archiving failed';
        MSG_022: Label 'Import file for SSB Imports';
        MNU_001: Label 'Post,Simulate';

    //[Scope('Internal')]
    procedure "<-- Automated Run -->"()
    var
        lintInfoType: Integer;
    begin
    end;

    //[Scope('Internal')]
    procedure gfncSSBImports(p_recParentClient: Record "Parent Client"; p_blnDialog: Boolean; p_txtFileName: Text[1024]; p_blnShowIndividualResults: Boolean) r_blnResult: Boolean
    var
        lintOption: Integer;
        lrecImportLog: array[4] of Record "Import Log";
        lintIndex: Integer;
        lintInfoType: Integer;
        lintDownCount: Integer;
        ltxtClientFileName: Text[1024];
    begin
        r_blnResult := gfncSSBImports1(p_recParentClient, p_blnDialog, p_txtFileName, p_blnShowIndividualResults);

        IF NOT p_blnShowIndividualResults THEN BEGIN
            //Do not show individual results, but one result at the end
            IF r_blnResult THEN
                MESSAGE(MSG_018)
            ELSE
                MESSAGE(MSG_019);
        END;
    end;

    //
    procedure gfncSSBImports1(p_recParentClient: Record "Parent Client"; p_blnDialog: Boolean; p_txtFileName: Text[1024]; p_blnShowIndividualResults: Boolean) r_blnResult: Boolean
    var
        lintOption: Integer;
        lrecImportLog: array[4] of Record "Import Log";
        lintIndex: Integer;
        lintInfoType: Integer;
        lintDownCount: Integer;
        ltxtClientFileName: Text[1024];
    //lmdlFileMgt: Codeunit "File Management";
    begin
        //lintOption := STRMENU(MNU_001,1,DLG_006);
        lintOption := p_recParentClient."Posting Method" + 1;

        IF lintOption > 0 THEN BEGIN
            IF p_txtFileName <> '' THEN
                ltxtClientFileName := p_txtFileName
            //                         ELSE ltxtClientFileName := lmodCommonDialogManagement.OpenFile(MSG_022,'',2,'',0);
            ELSE
                //ltxtClientFileName := lmdlFileMgt.OpenFileDialog(MSG_022, '', ''); // MP 17-11-14 Replaces above

                IF ltxtClientFileName <> '' THEN BEGIN
                    // Import files
                    FOR lintIndex := 1 TO 4 DO BEGIN
                        CASE lintIndex OF
                            1:
                                lintInfoType := 1; // Local COA
                            2:
                                lintInfoType := 2; // Corp COA
                            3:
                                lintInfoType := 3; // Trial Balance
                            4:
                                lintInfoType := 4; // Local Adjustments
                        END;
                        IF NOT gfncRunStage1(p_recParentClient, lintInfoType, p_blnDialog, lrecImportLog[lintIndex], ltxtClientFileName) THEN BEGIN
                            IF lintIndex > 1 THEN BEGIN
                                // Delete previous imports here. The crashed one is deleted by by the RunStage1 process
                                FOR lintDownCount := lintIndex DOWNTO 1 DO BEGIN
                                    lrecImportLog[lintDownCount].DELETE(TRUE); // this will delete all related info
                                END;
                            END;
                            EXIT(FALSE);
                        END;
                        lrecImportLog[lintIndex]."Posting Method" := lintOption - 1;
                        lrecImportLog[lintIndex].MODIFY();
                    END;

                    // Process files
                    FOR lintIndex := 1 TO 4 DO BEGIN
                        IF NOT gfncPostImportRun(lrecImportLog[lintIndex], p_blnDialog, p_blnShowIndividualResults) THEN EXIT(FALSE);
                    END;

                    EXIT(TRUE);
                END ELSE BEGIN
                    EXIT(FALSE);
                END;
        END;
    end;

    //[Scope('Internal')]
    procedure gfncEndToEndProcess(p_recParentClient: Record "Parent Client"; p_intInfoType: Integer; p_blnDialog: Boolean; p_txtClientFileName: Text[1024]) r_blnResult: Boolean
    var
        lrecImportLog: Record "Import Log";
        lintOption: Integer;
    begin
        CASE p_intInfoType OF
            3, 4, 7, 8:
                lintOption := p_recParentClient."Posting Method" + 1;
            //4,7,8 : lintOption := STRMENU(MNU_001,1,DLG_006);
            ELSE
                lintOption := 1;
        END;

        //IF p_intInfoType IN [3,4,7,8] THEN lintOption := STRMENU(MNU_001,1,DLG_006)
        //                              ELSE lintOption := 1;

        IF lintOption > 0 THEN BEGIN
            r_blnResult := gfncRunStage1(p_recParentClient, p_intInfoType, p_blnDialog, lrecImportLog, p_txtClientFileName);
            lrecImportLog."Posting Method" := lintOption - 1;
            lrecImportLog.MODIFY();

            IF r_blnResult THEN r_blnResult := gfncPostImportRun(lrecImportLog, p_blnDialog, FALSE);

            IF r_blnResult THEN
                MESSAGE(MSG_018)
            ELSE
                MESSAGE(MSG_019);
        END;
    end;

    //[Scope('Internal')]
    procedure gfncPostImportRunConfirm(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
    var
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        IF CONFIRM(DLG_005, FALSE, p_recImportLog."Entry No.") THEN BEGIN
            // lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);
            gfncPostImportRun(p_recImportLog, p_blnDialog, TRUE);
        END;
    end;

    //
    procedure gfncPostImportRun(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean; p_blnShowResult: Boolean) r_blnResult: Boolean
    var
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        lintStageNo: Integer;
    begin
        //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                                                         // STRSUBSTNO(MSG_016, p_recImportLog."Entry No.",
                                                         // FORMAT(CURRENTDATETIME)));
        r_blnResult := TRUE;
        CASE p_recImportLog.Stage OF
            p_recImportLog.Stage::"File Import":
                lintStageNo := 2;
            p_recImportLog.Stage::"Post Import Validation":
                lintStageNo := 3;
            p_recImportLog.Stage::"Data Transfer":
                lintStageNo := 4;
            p_recImportLog.Stage::"Data Validation":
                lintStageNo := 5;
            p_recImportLog.Stage::"Record Creation/Update/Posting":
                lintStageNo := 6;
        END;

        // Last attempt failed - try again
        IF (p_recImportLog.Status = p_recImportLog.Status::Error) OR
           (p_recImportLog.Status = p_recImportLog.Status::"In Progress") THEN
            lintStageNo -= 1;

        IF (lintStageNo <= 1) THEN BEGIN
            r_blnResult := FALSE;
            //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
            // STRSUBSTNO(ERR_015, FORMAT(p_recImportLog.Stage),
            //FORMAT(p_recImportLog.Status)));
        END;
        //r_blnResult := (lintStageNo > 1);
        // WHILE (lintStageNo <= 6) AND r_blnResult DO BEGIN
        //     CASE lintStageNo OF
        //         2:
        //             r_blnResult := gfncRunStage2(p_recImportLog, p_blnDialog, FALSE);
        //         3:
        //             r_blnResult := gfncRunStage3(p_recImportLog, p_blnDialog, FALSE);
        //         4:
        //             r_blnResult := gfncRunStage4(p_recImportLog, p_blnDialog, FALSE);
        //         5:
        //             r_blnResult := gfncRunStage5(p_recImportLog, p_blnDialog, FALSE);
        //         6:
        //             r_blnResult := gfncRunStage6(p_recImportLog, FALSE); // Do not ask user for confirmation
        //     END;
        lintStageNo += 1;
    END;

    // IF r_blnResult THEN BEGIN
    //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //                                                       STRSUBSTNO(MSG_017, p_recImportLog."Entry No.",
    //                                                       FORMAT(CURRENTDATETIME)));
    // END ELSE BEGIN
    //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //                                                       STRSUBSTNO(ERR_001, p_recImportLog."Entry No.",
    //                                                       FORMAT(CURRENTDATETIME)));
    // END;

    //     IF p_blnShowResult THEN BEGIN
    //         IF r_blnResult THEN
    //             MESSAGE(MSG_018)
    //         ELSE
    //             MESSAGE(MSG_019);
    //     END;
    // end;

    //
    procedure "<-- Stage 1 related -->"()
    begin
    end;

    //[Scope('Internal')]
    procedure gfncRunStage1(p_recParentClient: Record "Parent Client"; p_intInfoType: Integer; p_blnDialog: Boolean; var p_recImportLog: Record "Import Log"; p_txtFileName: Text[1024]) r_blnResult: Boolean
    var
        lrecImportTemplateHeader: Record "Import Template Header";
        //lmod3TierAutomationMgt: Codeunit "File Management";
        lintDefaultFileType: Integer;
        ltxtWindowTitle: Text[1024];
        ltxtConvertedClientFileName: Text[1024];
        ltxtClientFileName: Text[1024];
        ltxtServerFileName: Text[1024];
        ltxtPath: Text[1024];
        lfilFile: File;
        lblnClient: Boolean;
    begin
        r_blnResult := TRUE;

        //
        // Find Import Template Header
        //

        CASE p_intInfoType OF
            1:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."G/L Account Template Code");
                    ltxtWindowTitle := MSG_001;
                END;
            2:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."Corporate GL Acc. Templ. Code");
                    ltxtWindowTitle := MSG_002;
                END;
            3:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."Trial Balance Template Code");
                    ltxtWindowTitle := MSG_003;
                END;
            4:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."G/L Entry Template Code");
                    ltxtWindowTitle := MSG_004;
                END;
            5:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."Customer Template Code");
                    ltxtWindowTitle := MSG_005;
                END;
            6:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."Vendor Template Code");
                    ltxtWindowTitle := MSG_006;
                END;
            7:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."AR Template Code");
                    ltxtWindowTitle := MSG_007;
                END;
            8:
                BEGIN
                    lrecImportTemplateHeader.GET(p_recParentClient."AP Template Code");
                    ltxtWindowTitle := MSG_008;
                END;
        END;

        CASE lrecImportTemplateHeader."File Format" OF
            lrecImportTemplateHeader."File Format"::"Variable Delimited":
                BEGIN
                    lintDefaultFileType := 1; // Text
                END;
            lrecImportTemplateHeader."File Format"::Excel:
                BEGIN
                    lintDefaultFileType := 2; // Excel
                END;
        //lrecImportTemplateHeader."File Format"::Excel2007 : BEGIN
        //  lintDefaultFileType := 2; // Excel
        //END;
        END;

        IF p_txtFileName <> '' THEN
            ltxtClientFileName := p_txtFileName
        //ELSE ltxtClientFileName := lmodCommonDialogManagement.OpenFile(ltxtWindowTitle,'',lintDefaultFileType,'',0);
        ELSE
            // ltxtClientFileName := lmod3TierAutomationMgt.OpenFileDialog(ltxtWindowTitle, '', ''); // MP 17-11-14 Replaces above


            IF ltxtClientFileName <> '' THEN BEGIN
                //
                // Create new Import Log entry
                //
             //   gfncInitImportLog(p_recParentClient, lrecImportTemplateHeader, ltxtClientFileName, p_recImportLog);
                p_recImportLog.Stage := p_recImportLog.Stage::"File Import";
                p_recImportLog.Status := p_recImportLog.Status::"In Progress";
                p_recImportLog.MODIFY();
                //
                // Commit here so we have record of an attempt
                //
                COMMIT();

                // Convert xls to xlsx if necessary
                ltxtConvertedClientFileName := '';
                IF lrecImportTemplateHeader."File Format" = lrecImportTemplateHeader."File Format"::Excel THEN BEGIN
                    // lfncGetFileExtension(ltxtClientFileName) = 'xls' THEN BEGIN
                      //  IF lfncConvertXLStoXLSX(p_recImportLog, ltxtClientFileName, ltxtConvertedClientFileName, p_blnDialog) THEN BEGIN
                            ltxtClientFileName := ltxtConvertedClientFileName;
                        END ELSE BEGIN
                            // error
                            r_blnResult := FALSE;
                            EXIT; //Message should be already in log from the lfncConvertXLStoXLSX(..)
                        END;
                    END;
                END;
                //
                // lblnClient = true  - run on client
                // lblnClient = false - run on service tier
                //
                //lblnClient := NOT (ISSERVICETIER AND (lintDefaultFileType = 1)); // Run XLS locally
                //lblnClient := NOT (ISSERVICETIER);
               // IF NOT lblnClient THEN BEGIN
                    // copy file to the server
                  //  IF NOT lfncServerUpload(p_recImportLog, ltxtClientFileName, ltxtServerFileName, p_blnDialog) THEN BEGIN
                        // server upload failed
                      //  r_blnResult := FALSE;
                  //  END;
              //  END ELSE BEGIN
                  //  ltxtServerFileName := ltxtClientFileName;
               // END;

//IF r_blnResult AND (ltxtClientFileName <> '') THEN BEGIN
                 //   r_blnResult := gfncImportFile(p_recParentClient, lrecImportTemplateHeader, ltxtClientFileName,
                                      //  ltxtServerFileName, p_recImportLog, p_blnDialog, lblnClient);
              //  END;

                // IF NOT lblnClient THEN BEGIN
                //     IF NOT ERASE(ltxtServerFileName) THEN;
          //  END;
        // IF ltxtConvertedClientFileName <> '' THEN BEGIN
        //     IF NOT ERASE(ltxtConvertedClientFileName) THEN; // ERROR(ERR_019);
        // END;
        //
        // Update Status
        //
       // p_recImportLog.Stage := p_recImportLog.Stage::"File Import";
       // IF r_blnResult THEN
         //   p_recImportLog.Status := p_recImportLog.Status::Imported
      //  ELSE
         //   p_recImportLog.Status := p_recImportLog.Status::Error;
      //  p_recImportLog.MODIFY();

        //IF r_blnResult THEN
        //  MESSAGE(MSG_010, ltxtClientFileName, p_recImportLog."Entry No.")
        //ELSE
        //  MESSAGE(MSG_011, ltxtClientFileName, p_recImportLog."Entry No.");
        // Show message only if dialog and failed
     //   IF p_blnDialog AND NOT r_blnResult THEN
        //    MESSAGE(MSG_011, ltxtClientFileName, p_recImportLog."Entry No.");
  //  END;
   // end;

    //[Scope('Internal')]
    procedure gfncImportFile(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; p_txtClientFileName: Text[1024]; p_txtServerFileName: Text[1024]; var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean; p_blnLocal: Boolean) r_blnResult: Boolean
    var
        lfilInputFile: File;
        lrrefRecRef: RecordRef;
        lblnUseTempRecords: Boolean;
    begin
        //
        // Top level function
        //
        lblnUseTempRecords := FALSE;
        //
        // Create new Import Log entry
        //
        //gfncInitImportLog(p_recParentClient, p_recImportTemplateHeader, p_txtClientFileName, p_recImportLog);
        //p_recImportLog.Stage := p_recImportLog.Stage::"File Import";
        //p_recImportLog.Status := p_recImportLog.Status::"In Progress";
        //p_recImportLog.MODIFY;
        //
        // Commit here so we have record of an attempt
        //
        //COMMIT;
        //
        // Pre-processing Checks
        //
        r_blnResult := gfncPreImport(p_recImportTemplateHeader, p_txtServerFileName, p_recImportLog, p_blnLocal);
        //
        // Create new table recref
        //
        lrrefRecRef.OPEN(p_recImportTemplateHeader."Table ID", lblnUseTempRecords);
        //
        // Process Input
        //
        IF r_blnResult THEN // Only if previous stage was success
            r_blnResult := gfncImport(p_recParentClient, p_recImportTemplateHeader, p_txtServerFileName,
                                      p_recImportLog, lrrefRecRef, p_blnDialog, p_blnLocal);
        //
        // Save to table (If used temp and success)
        //
        IF r_blnResult AND lblnUseTempRecords THEN
          //  gfncSaveRecords(lrrefRecRef);
        //
        // Delete from table (if failed and used permanent)
        //
        IF NOT (r_blnResult OR lblnUseTempRecords) THEN
          //  gfncCleanUp(p_recImportLog, lrrefRecRef);
        //
        // Update Import log
        //
        IF r_blnResult THEN
            p_recImportLog.Status := p_recImportLog.Status::Imported
        ELSE
            p_recImportLog.Status := p_recImportLog.Status::Error;

        p_recImportLog.Stage := p_recImportLog.Stage::"File Import";
        p_recImportLog.MODIFY();
    end;

    //
    procedure gfncInitImportLog(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; p_txtClientFileName: Text[1024]; var p_recImportLog: Record "Import Log")
    var
        lrecSubsidiaryClient: Record "Subsidiary Client";
        lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
        lrecImportLog: Record "Import Log";
        lintEntryNo: BigInteger;
    begin
        lrecImportLog.RESET();
        IF lrecImportLog.FINDLAST() THEN
            lintEntryNo := lrecImportLog."Entry No." + 1
        ELSE
            lintEntryNo := 1;
        p_recImportLog.INIT();
        //p_recImportLog."Entry No." := 0; // Auto increment
        p_recImportLog."Entry No." := lintEntryNo;
        p_recImportLog."Parent Client No." := p_recParentClient."No.";
        p_recImportLog."User ID" := USERID;
        p_recImportLog."Import Date" := TODAY;
        p_recImportLog."Import Time" := TIME;
        p_recImportLog."File Name" := p_txtClientFileName;
        p_recImportLog.Status := p_recImportLog.Status::Error;
        p_recImportLog."Table ID" := p_recImportTemplateHeader."Table ID";
        p_recImportLog."Interface Type" := p_recImportTemplateHeader."Interface Type";
        p_recImportLog.INSERT(TRUE);
    end;

    //[Scope('Internal')]
    procedure gfncPreImport(p_recImportTemplateHeader: Record "Import Template Header"; p_txtFileName: Text[1024]; var p_recImportLog: Record "Import Log"; p_blnClient: Boolean): Boolean
    var
        //lmdlFileManagement: Codeunit "File Management";
        lfilFile: File;
        lchrDummy: Char;
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        //
        // Check if file exists and we can read it
        //
        IF NOT ISSERVICETIER THEN BEGIN
            // Classic client, local test
            //     lfilFile.WRITEMODE(FALSE);
            //     lfilFile.TEXTMODE(FALSE);
            //     IF NOT lfilFile.OPEN(p_txtFileName) THEN BEGIN
            //         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_010, p_txtFileName));
            //         EXIT(FALSE);
            //     END;
            //     IF lfilFile.READ(lchrDummy) = 0 THEN BEGIN
            //         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_002, p_txtFileName));
            //         EXIT(FALSE);
            //     END;
            //     lfilFile.CLOSE;
            // END ELSE BEGIN
            //     IF p_blnClient THEN BEGIN
            //         // RTC, file local - use test on client

            //         // MP 25-May-16 Redone to not use Automation Servers >>
            //         //IF ISCLEAR(lautFileSystemObject) THEN
            //         //  CREATE(lautFileSystemObject, TRUE, TRUE); // instantiate locally
            //         //  IF NOT lautFileSystemObject.FileExists(p_txtFileName) THEN BEGIN
            //         IF NOT lmdlFileManagement.ClientFileExists(p_txtFileName) THEN BEGIN
            //             // MP 25-May-16 <<
            //             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_011, p_txtFileName));
            //             EXIT(FALSE);
            //         END;
            //     END ELSE BEGIN
            //         //RTC, file on server - use lfilfile
            //         lfilFile.WRITEMODE(FALSE);
            //         lfilFile.TEXTMODE(FALSE);
            //         IF NOT lfilFile.OPEN(p_txtFileName) THEN BEGIN
            //             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_010, p_txtFileName));
            //             EXIT(FALSE);
            //         END;
            //         IF lfilFile.READ(lchrDummy) = 0 THEN BEGIN
            //             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_002, p_txtFileName));
            //             EXIT(FALSE);
            //         END;
            //         lfilFile.CLOSE;
            //     END;
            // END;

            // ToDo
            // Check mapping so it does not contain fields with unsupported data types
            // flow fields, flow filter fields
            // Create separate function so it can be called from mapping form.
            //

            EXIT(TRUE);
        end;
    end;

    //
    procedure gfncImport(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; p_txtFileName: Text[1024]; var p_recImportLog: Record "Import Log"; var p_rrefRecRef: RecordRef; p_blnDialog: Boolean; p_blnLocal: Boolean) r_blnResult: Boolean
    var
      //  lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        CASE p_recImportTemplateHeader."File Format" OF
            p_recImportTemplateHeader."File Format"::"Variable Delimited":
                BEGIN
//r_blnResult := gfncImportCSV(p_recParentClient, p_recImportTemplateHeader,
                                               //  p_txtFileName, p_recImportLog,
                                               //  p_rrefRecRef, p_blnDialog);
                END;
            p_recImportTemplateHeader."File Format"::Excel:
                BEGIN
                    //r_blnResult := gfncImportXLS(p_recParentClient, p_recImportTemplateHeader,
//r_blnResult := gfncImportXLSX(p_recParentClient, p_recImportTemplateHeader,
//p_txtFileName, p_recImportLog,
//p_rrefRecRef, p_blnDialog, p_blnLocal);
                END;
            //  p_recImportTemplateHeader."File Format"::Excel2007: BEGIN
            //   r_blnResult := gfncImportXLSX(p_recParentClient, p_recImportTemplateHeader,
            //                                 p_txtFileName, p_recImportLog,
            //                                 p_rrefRecRef, p_blnDialog, p_blnLocal);
            //  END;
            ELSE BEGIN
                //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
                // STRSUBSTNO(ERR_004, FORMAT(p_recImportTemplateHeader."File Format")));
            END;
        END;
    end;

    //[Scope('Internal')]
    procedure gfncImportCSV(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; var p_txtFileName: Text[1024]; var p_recImportLog: Record "Import Log"; var p_rrefRecRef: RecordRef; p_blnDialog: Boolean) r_blnResult: Boolean
    var
        lfilFile: File;
        ltxtLine: Text[1024];
        lintBytesRead: Integer;
        lintLineNo: Integer;
        lintSkipLines: Integer;
        lintFileLength: Integer;
        lintTotalRead: Integer;
        lintLastPct: Integer;
        ldlgDialog: Dialog;
    begin
        //lfilFile.WRITEMODE(FALSE);
        //lfilFile.TEXTMODE(TRUE);
        //lfilFile.OPEN(p_txtFileName);
        IF p_blnDialog THEN BEGIN
            ldlgDialog.OPEN(DLG_001);
            // lintFileLength := lfilFile.LEN;
            lintTotalRead := 0;
        END;
        //lintBytesRead := lfilFile.READ(ltxtLine);
        lintLineNo := 1;
        r_blnResult := TRUE;
        lintSkipLines := p_recImportTemplateHeader."Skip Header Lines";
        IF lintSkipLines < 0 THEN lintSkipLines := 0;

        WHILE lintSkipLines > 0 DO BEGIN // Skip header lines
                                         // lintBytesRead := lfilFile.READ(ltxtLine);
            lintSkipLines -= 1;
            lintLineNo += 1;
        END;
        lintLastPct := 0;
        WHILE lintBytesRead > 0 DO BEGIN  // Loop trough all lines
            IF p_blnDialog THEN BEGIN
                lintTotalRead += lintBytesRead;
                IF ROUND((lintTotalRead / lintFileLength) * 100, 1, '<') > lintLastPct THEN BEGIN
                    lintLastPct := ROUND((lintTotalRead / lintFileLength) * 100, 1, '<');
                    ldlgDialog.UPDATE(1, lintLastPct * 100);
                END;
            END;
            // r_blnResult := r_blnResult AND gfncImportCSVLine(p_recParentClient, p_recImportTemplateHeader, ltxtLine,
            // p_recImportLog, lintLineNo, p_rrefRecRef,
            // lfncGetLastColumnName(p_recImportTemplateHeader));
            // lintBytesRead := lfilFile.READ(ltxtLine);
            lintLineNo += 1;
        END;

        IF p_blnDialog THEN BEGIN
            ldlgDialog.CLOSE();
        END;
    end;

    //[Scope('Internal')]
    // procedure gfncImportXLSX(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; var p_txtFileName: Text[1024]; var p_recImportLog: Record "Import Log"; var p_rrefRecRef: RecordRef; p_blnDialog: Boolean; p_blnLocal: Boolean) r_blnResult: Boolean
    // var
    //     // ldotXLSXWrapper: DotNet XLSXWrapperSAX;
    //     lintWorksheetNo: Integer;
    //     lcodColumnName: Code[10];
    //     lvarVariant: Variant;
    //     lfrefFieldRef: FieldRef;
    //     lintRows: Integer;
    //     lintColumns: Integer;
    //     lintCurrentRow: Integer;
    //     ltxtValue: Text[1024];
    //     ltxtRange: Text[30];
    //     lrecImportTemplateLine: Record "Import Template Line";
    //     lintLineNox: Integer;
    //     lintSkipLines: Integer;
    //     lintLastPct: Integer;
    //     ldlgDialog: Dialog;
    //    // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
    //   //  lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
    //    // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
    //    // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
    // // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
    // begin
    //     r_blnResult := TRUE;

    //     IF p_blnDialog THEN BEGIN
    //         ldlgDialog.OPEN(DLG_001);
    //     END;

    //     lintWorksheetNo := p_recImportTemplateHeader."XLS Worksheet No.";
    //     lintSkipLines := p_recImportTemplateHeader."Skip Header Lines";

    //     // ldotXLSXWrapper := ldotXLSXWrapper.XLSXWrapperSAX(p_txtFileName, lintWorksheetNo); // this can take some time
    //     // lintRows := ldotXLSXWrapper.RowCount;

    //     lintCurrentRow := 0;
    //     // IF ldotXLSXWrapper.GetFirstRow THEN
    //     REPEAT
    //         lintCurrentRow += 1;
    //         IF lintCurrentRow > lintSkipLines THEN BEGIN
    //             //lfncInitRecord(p_rrefRecRef, lintCurrentRow, p_recParentClient."No.",
    //             p_recImportLog."Entry No.", p_recImportTemplateHeader."Interface Type");
    //             p_rrefRecRef.INSERT(TRUE);
    //             lintLastPct := 0;
    //             //IF ldotXLSXWrapper.GetFirstCell() THEN
    //             REPEAT
    //                 IF p_blnDialog THEN BEGIN
    //                     IF ROUND((lintCurrentRow / lintRows) * 100, 1, '<') > lintLastPct THEN BEGIN
    //                         lintLastPct := ROUND((lintCurrentRow / lintRows) * 100, 1, '<');
    //                         ldlgDialog.UPDATE(1, lintLastPct * 100);
    //                     END;
    //                 END;
    //                 // process cell here
    //                 // lcodColumnName := ldotXLSXWrapper.CellReference;
    //                 // Remove numerical part
    //                 lcodColumnName := DELCHR(lcodColumnName, '<=>', '0123456789');
    //                 IF lrecImportTemplateLine.GET(p_recImportTemplateHeader.Code, lcodColumnName) THEN BEGIN
    //                     lfrefFieldRef := p_rrefRecRef.FIELD(lrecImportTemplateLine."Field ID");
    //                     // lvarVariant := ldotXLSXWrapper.CellValue;

    //                     // r_blnResult := r_blnResult AND lfncConvertVariantValue(lvarVariant, p_recImportTemplateHeader, lrecImportTemplateLine,
    //                     lfrefFieldRef, lintCurrentRow, p_recImportLog);
    //                 END;
    //                 //UNTIL ldotXLSXWrapper.GetNextCell = FALSE;
    //                 p_rrefRecRef.MODIFY(TRUE);

                    //
                    // Specific post import processing
                    //
                    // CASE p_rrefRecRef.NUMBER OF
                    //     60009:
                    //         lmodDataImportMgt_60009.gfncAfterSaveRecord(p_rrefRecRef);
                    //     60012:
                    //         lmodDataImportMgt_60012.gfncAfterSaveRecord(p_rrefRecRef);
                    //     60018:
                    //         lmodDataImportMgt_60018.gfncAfterSaveRecord(p_rrefRecRef);
                    //     60019:
                    //         lmodDataImportMgt_60019.gfncAfterSaveRecord(p_rrefRecRef);
                    //     60020:
                    //         lmodDataImportMgt_60020.gfncAfterSaveRecord(p_rrefRecRef);
                    // END;
                    //  END;
                    //UNTIL (ldotXLSXWrapper.GetNextRow() = FALSE);

                    // ldotXLSXWrapper.Close();

                   // IF p_blnDialog THEN BEGIN
//ldlgDialog.CLOSE();
                 //   END;
                    // CLEAR(ldotXLSXWrapper);
                    // end;

                    //[Scope('Internal')]
                    // procedure gfncImportCSVLine(var p_recParentClient: Record "Parent Client"; var p_recImportTemplateHeader: Record "Import Template Header"; var p_txtLine: Text[1024]; var p_recImportLog: Record "Import Log"; p_intLineNo: Integer; var p_rrefRecRef: RecordRef; p_codLastUsedColumnName: Code[20]) r_blnResult: Boolean
                    // var
                    //     lcodColumnName: Code[2];
                    //     lcodLastUsedColumnName: Code[2];
                    //     lblnLast: Boolean;
                    //     ltxtToken: Text[1024];
                    //     lrecImportTemplateLine: Record "Import Template Line";
                    //     lfrefFieldRef: FieldRef;
                    //     // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
                    //     // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
                    //     // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
                    //     // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
                    //     // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
                    //     // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
                    // begin
                    //    // IF lmodDataImportManagementCommon.gfncTextToASCII(p_recImportTemplateHeader."Field Delimiter") <>
                    //                                                       p_recImportTemplateHeader."Field Delimiter ASCII" THEN BEGIN
                    //        // p_recImportTemplateHeader."Field Delimiter ASCII" :=
                    //        //                            lmodDataImportManagementCommon.gfncTextToASCII(p_recImportTemplateHeader."Field Delimiter");
                    //         p_recImportTemplateHeader.MODIFY;
                    //     END;

                    //     IF p_codLastUsedColumnName = '' THEN p_codLastUsedColumnName := 'ZZ';
                    //     p_codLastUsedColumnName := lflncNormColName(p_codLastUsedColumnName);
                    //     lcodColumnName := 'A';
                    //     r_blnResult := TRUE;
                    //     lfncInitRecord(p_rrefRecRef, p_intLineNo, p_recParentClient."No.",
                    //                    p_recImportLog."Entry No.", p_recImportTemplateHeader."Interface Type");
                    //     p_rrefRecRef.INSERT(TRUE);
                    //     IF p_txtLine <> '' THEN
                    //         REPEAT
                    //             //ltxtToken := lmodDataImportManagementCommon.gfncGetNextToken(p_txtLine, p_recImportTemplateHeader."Field Delimiter"[1],
                    //             ltxtToken := lmodDataImportManagementCommon.gfncGetNextToken(p_txtLine, p_recImportTemplateHeader."Field Delimiter ASCII",
                    //                                           p_recImportTemplateHeader."Text Qualifier"[1], lblnLast);
                    //             IF lrecImportTemplateLine.GET(p_recImportTemplateHeader.Code, lcodColumnName) THEN BEGIN
                    //                 lfrefFieldRef := p_rrefRecRef.FIELD(lrecImportTemplateLine."Field ID");
                    //                 r_blnResult := r_blnResult AND lfncConvertTextValue(ltxtToken, p_recImportTemplateHeader, lrecImportTemplateLine,
                    //                                                                 lfrefFieldRef, p_intLineNo, p_recImportLog);
                    //             END;
                    //             lcodColumnName := lfncIncrColName(lcodColumnName);
                    //         UNTIL lblnLast OR (lflncNormColName(lcodColumnName) > p_codLastUsedColumnName);
                    //     p_rrefRecRef.MODIFY(TRUE);
                    //     //
                    //     // Specific post import processing
                    //     //
                    //     // CASE p_rrefRecRef.NUMBER OF
                    //     //     60009:
                    //     //         lmodDataImportMgt_60009.gfncAfterSaveRecord(p_rrefRecRef);
                    //     //     60012:
                    //     //         lmodDataImportMgt_60012.gfncAfterSaveRecord(p_rrefRecRef);
                    //     //     60018:
                    //     //         lmodDataImportMgt_60018.gfncAfterSaveRecord(p_rrefRecRef);
                    //     //     60019:
                    //     //         lmodDataImportMgt_60019.gfncAfterSaveRecord(p_rrefRecRef);
                    //     //     60020:
                    //     //         lmodDataImportMgt_60020.gfncAfterSaveRecord(p_rrefRecRef);
                    //     // END;
                    //end;

                    //[Scope('Internal')]
    //                 ieldRef;
    //                 lbintBigInt: BigInteger;
    //                 lintFieldIndex: Integer;
    //                 begin
    //                     IF p_rrefRecRef.ISTEMPORARY THEN BEGIN
    //                         lrrRecRef.OPEN(p_rrefRecRef.NUMBER);
    //                         IF p_rrefRecRef.FIND('-') THEN
    //                             REPEAT
    //                                 lrrRecRef.INIT;
    //                                 lintFieldIndex := 1;
    //                                 WHILE  procedure gfncSaveRecords(var p_rrefRecRef: RecordRef)
    // var
    //     lrrRecRef: RecordRef;
    //             lfrFieldRef: FieldRef;
    //             lfrTmpFieldRef: FlintFieldIndex <= p_rrefRecRef.FIELDCOUNT DO BEGIN
    //                 lfrTmpFieldRef := p_rrefRecRef.FIELDINDEX(lintFieldIndex);
    //                 lfrFieldRef.VALUE := lfrTmpFieldRef.VALUE;
    //                 lintFieldIndex += 1;
    //             END;
    //             lfrFieieldRef := lrrRecRef.FIELDINDEX(lintFieldIndex);
    //             lfrFldRef := lrrRecRef.FIELD(99999);
    //             lfrFieldRef.VALUE := 0;
    //             lrrRecRef.INSERT;
            
//UNTIL p_rrefRecRef.NEXT() = 0;
    ////         END;
    // end;
    

    //
    // procedure gfncCleanUp(var p_recImportLog: Record "Import Log"; var p_rrefRecRef: RecordRef)
    // var
    //     lrrRecRef: RecordRef;
    //     lffFieldRef: FieldRef;
    // begin
    //     lrrRecRef.OPEN(p_rrefRecRef.NUMBER);
    //     lffFieldRef := lrrRecRef.FIELD(99998);
    //     lffFieldRef.SETFILTER(FORMAT(p_recImportLog."Entry No."));
    //     lrrRecRef.DELETEALL();
    // end;

    // //[Scope('Internal')]
    // procedure lfncConvertXLStoXLSX(var p_recImportLog: Record "Import Log"; p_txtXLSFileName: Text[1024]; var p_txtXLSXFileName: Text[1024]; p_blnDialog: Boolean) r_blnResult: Boolean
    // var
    //     // [RunOnClient]
    //     // ldotXlApp: DotNet ApplicationClass;
    //     // [RunOnClient]
    //     // ldotXlWrkBk: DotNet Workbook;
    //     // [RunOnClient]
    //     // ldotXlHelper: DotNet ExcelHelper;
    //     // [RunOnClient]
    //     // ldotXlFileFormat: DotNet XlFileFormat;
    //     // [RunOnClient]
    //     // ldotXlSaveAsAccessMode: DotNet XlSaveAsAccessMode;
    //     ltxtVersion: Text[30];
    //     lfilFile: File;
    //     ldecVersion: Decimal;
    //     ldlgDialog: Dialog;
    // //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    // begin

    //     r_blnResult := TRUE;
    //     p_txtXLSXFileName := COPYSTR(p_txtXLSFileName, 1, STRPOS(p_txtXLSFileName, '.xls')) + 'xlsx';

    //     // MP 25-May-16 Redone to use .NET >>
    //     //CREATE(lautXLSApplication, TRUE, TRUE);
    //     //lautXLSApplication.Visible := FALSE;
    //     // Check Excel version
    //     //ltxtVersion := lautXLSApplication.Version;

    //     // ldotXlApp := ldotXlApp.ApplicationClass;
    //     //  ldotXlApp.Visible := FALSE;
    //     // Check Excel version
    //     // ltxtVersion := ldotXlApp.Version;
    //     // MP 25-May-16 <<
    //     IF STRPOS(ltxtVersion, '.') > 0 THEN
    //         ltxtVersion := COPYSTR(ltxtVersion, 1, STRPOS(ltxtVersion, '.') - 1);
    //     IF NOT EVALUATE(ldecVersion, ltxtVersion) THEN BEGIN
    //         // Error - strange version
    //         r_blnResult := FALSE;
    //         //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //         //STRSUBSTNO(ERR_024, ltxtVersion));
    //     END;

    //     IF ldecVersion < 12 THEN BEGIN
    //         // Error wrong client version
    //         r_blnResult := FALSE;
    //         //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //         // STRSUBSTNO(ERR_025, ltxtVersion));
    //     END;

        // Check we can write to the directory
        // Caused problems on RTC - disabled
        //lfilFile.WRITEMODE(TRUE);
        //lfilFile.TEXTMODE(TRUE);
        //IF NOT lfilFile.CREATE(p_txtXLSXFileName) THEN BEGIN
        //  // Cannot create file
        //  r_blnResult := FALSE;
        //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
        //                                 STRSUBSTNO(ERR_026, p_txtXLSXFileName));
        //END;
        //lfilFile.WRITE('A');
        //lfilFile.CLOSE();
        //error('After file close');
        //
        //IF NOT ERASE(p_txtXLSXFileName) THEN BEGIN
        //  r_blnResult := FALSE;
        //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
        //                                 STRSUBSTNO(ERR_027, p_txtXLSXFileName));
        //END;

        //error('Before automation');

        // MP 25-May-16 Redone to use .NET >>
        //IF r_blnResult THEN BEGIN
        //  lautXLSWorkbooks := lautXLSApplication.Workbooks;
        //  lautXLSWorkbook := lautXLSWorkbooks.Open(p_txtXLSFileName);
        //  lautXLSWorkbook.SaveAs(p_txtXLSXFileName, 51);
        //  lautXLSWorkbook.Close();
        //  CLEAR(lautXLSWorkbooks);
        //  CLEAR(lautXLSWorkbook);
        //END;
        //CLEAR(lautXLSApplication);

        // ldotXlWrkBk := ldotXlHelper.CallOpen(ldotXlApp, p_txtXLSFileName);
        // ldotXlWrkBk.SaveAs(p_txtXLSXFileName, ldotXlFileFormat.xlWorkbookDefault, '', '', FALSE, FALSE, ldotXlSaveAsAccessMode.xlNoChange, '', FALSE, '', '', TRUE);

        // CLEAR(ldotXlWrkBk);
        // ldotXlHelper.CallQuit(ldotXlApp);
        // CLEAR(ldotXlApp);
        // MP 25-May-16 <<
    // end;

    // local procedure lfncInitRecord(var p_rrefRecRef: RecordRef; p_intLineNo: Integer; p_codClientID: Code[20]; p_bintImportLogEntryNo: BigInteger; p_optInterfaceType: Option "Trial Balance","GL Transactions","AR Transactions",APTransactions,"Chart Of Accounts","Corporate Chart Of Accounts",Customer,Vendor)
    // var
    //     lfrefFieldRef: FieldRef;
    // // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
    // // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
    // // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
    // // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
    // // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
    // begin
    //     p_rrefRecRef.INIT();

    //     //99000 Interface Type - only if exists
    //     IF p_rrefRecRef.FIELDEXIST(99000) THEN BEGIN
    //         lfrefFieldRef := p_rrefRecRef.FIELD(99000);
    //         lfrefFieldRef.VALUE(p_optInterfaceType);
    //     END;

    //     //99994 Company No.   In file - cant be populated here

    //     //99995 Client No.  Parent client
    //     lfrefFieldRef := p_rrefRecRef.FIELD(99995);
    //     lfrefFieldRef.VALUE(p_codClientID);

    //     //99996 User ID
    //     lfrefFieldRef := p_rrefRecRef.FIELD(99996);
    //     lfrefFieldRef.VALUE(USERID);

    //     //99997 Status - Leave defaul value

    //     //99998 Import Log Entry No.
    //     lfrefFieldRef := p_rrefRecRef.FIELD(99998);
    //     lfrefFieldRef.VALUE(p_bintImportLogEntryNo);

    //     //99999 Entry No.
    //     lfrefFieldRef := p_rrefRecRef.FIELD(99999);
    //     IF p_rrefRecRef.ISTEMPORARY THEN
    //         lfrefFieldRef.VALUE(p_intLineNo)
    //     ELSE
    //         lfrefFieldRef.VALUE(0);
    //     //
    //     // Table specific record initialization
    //     //
    //     // CASE p_rrefRecRef.NUMBER OF
    //     //     60009:
    //     //         lmodDataImportMgt_60009.gfncAfterInitRecord(p_rrefRecRef);
    //     //     60012:
    //     //         lmodDataImportMgt_60012.gfncAfterInitRecord(p_rrefRecRef);
    //     //     60018:
    //     //         lmodDataImportMgt_60018.gfncAfterInitRecord(p_rrefRecRef);
    //     //     60019:
    //     //         lmodDataImportMgt_60019.gfncAfterInitRecord(p_rrefRecRef);
    //     //     60020:
    //     //         lmodDataImportMgt_60020.gfncAfterInitRecord(p_rrefRecRef);
    //     // END;
    // end;

    // local procedure lfncConvertTextValue(p_txtText: Text[1024]; var p_recImportTemplateHeader: Record "Import Template Header"; var p_recImportTemplateLine: Record "Import Template Line"; var p_frefFieldRef: FieldRef; p_intLineNo: Integer; var p_recImportLog: Record "Import Log") r_blnResult: Boolean
    // var
    //     ltxtType: Text[30];
    //     ltxtConverted: Text[1024];
    // //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    // begin
    //     r_blnResult := TRUE;
    //     //
    //     // Pre-format some data types
    //     //
    //     ltxtType := FORMAT(p_frefFieldRef.TYPE);
    //     CASE ltxtType OF
    //         'Date':
    //             BEGIN
    //                 // IF lfncConvertDate(p_txtText, ltxtConverted,
    //                 //                       p_recImportTemplateHeader."Date Format") THEN BEGIN
    //                 //     p_txtText := ltxtConverted;
    //                 // END ELSE BEGIN
    //                 //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //                 //         STRSUBSTNO(ERR_007, p_txtText, p_intLineNo, p_recImportTemplateLine.Column));
    //                 //     EXIT(FALSE);
    //                 // END;
    //             END;
    //         'Decimal':
    //             BEGIN
    //                 IF p_txtText = '' THEN p_txtText := '0'; // Handle null values
    //                                                          // IF lfncConvertDecimal(p_txtText, ltxtConverted,
    //                                                          //                   p_recImportTemplateHeader."Decimal Symbol"[1],
    //                                                          //                   p_recImportTemplateHeader."Thousand Separator"[1]) THEN BEGIN
    //                                                          // p_txtText := ltxtConverted;
    //                                                          // END ELSE BEGIN
    //                                                          //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //                                                          //   STRSUBSTNO(ERR_006, p_txtText, p_intLineNo, p_recImportTemplateLine.Column));
    //                 EXIT(FALSE);
    //             END;
    //     END;
    //     // 'Text':
    //     //     BEGIN
    //     //         IF STRLEN(p_txtText) > p_frefFieldRef.LENGTH THEN BEGIN
    //     //             p_txtText := COPYSTR(p_txtText, 1, p_frefFieldRef.LENGTH); // Truncate text
    //     //         END;
    //     //     END;
    //     // 'Code':
    //     //     BEGIN
    //     //         IF STRLEN(p_txtText) > p_frefFieldRef.LENGTH THEN BEGIN // For code, throw error
    //     //            // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //     //                 //STRSUBSTNO(ERR_008, COPYSTR(p_txtText, 1, 20), p_frefFieldRef.LENGTH, p_intLineNo, p_recImportTemplateLine.Column));
    //     //             EXIT(FALSE);
    //     //         END;
    //     //     END;
    // END;

    // //
    // // Generic conversion
    // //
    // // IF NOT lfncSetFieldValue(p_frefFieldRef, p_txtText, p_recImportLog) THEN BEGIN
    // //     //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    // //        // STRSUBSTNO(ERR_003, p_txtText, p_intLineNo, p_recImportTemplateLine.Column, p_frefFieldRef.TYPE));
    // //     r_blnResult := FALSE;
    // // END;
    // // end;

    // local procedure lfncConvertVariantValue(p_varVariant: Variant; var p_recImportTemplateHeader: Record "Import Template Header"; var p_recImportTemplateLine: Record "Import Template Line"; var p_frefFieldRef: FieldRef; p_intLineNo: Integer; var p_recImportLog: Record "Import Log") r_blnResult: Boolean
    // var
    //     ltxtType: Text[30];
    //     ltxtText: Text[1024];
    //     //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    //     ldtDatetime: DateTime;
    // begin
    //     r_blnResult := TRUE;
    //     //
    //     // Try direct conversion first
    //     //
    //     ltxtType := FORMAT(p_frefFieldRef.TYPE);
    //     CASE TRUE OF
    //         p_varVariant.ISBOOLEAN:
    //             IF ltxtType = 'Boolean' THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //         p_varVariant.ISOPTION:
    //             IF ltxtType = 'Option' THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //         p_varVariant.ISINTEGER:
    //             IF ltxtType IN ['Integer', 'BigInteger'] THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //         p_varVariant.ISDECIMAL:
    //             IF ltxtType = 'Decimal' THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //         p_varVariant.ISTEXT,
    //         p_varVariant.ISCODE:
    //             BEGIN
    //                 IF ltxtType = 'Code' THEN BEGIN
    //                     p_frefFieldRef.VALUE(p_varVariant);
    //                     EXIT(TRUE);
    //                 END;
    //                 IF ltxtType = 'Text' THEN BEGIN
    //                     ltxtText := p_varVariant;
    //                     IF STRLEN(ltxtText) > p_frefFieldRef.LENGTH THEN BEGIN
    //                         ltxtText := COPYSTR(ltxtText, 1, p_frefFieldRef.LENGTH); // Truncate text
    //                     END;
    //                     p_frefFieldRef.VALUE(ltxtText);
    //                     EXIT(TRUE);
    //                 END;
    //             END;
    //         p_varVariant.ISDATE:
    //             IF ltxtType = 'Date' THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //         p_varVariant.ISTIME:
    //             IF ltxtType = 'Time' THEN BEGIN
    //                 p_frefFieldRef.VALUE(p_varVariant);
    //                 EXIT(TRUE);
    //             END;
    //     END;

    //     ltxtText := DELCHR(FORMAT(p_varVariant, 250, 9), '<>');

    //     //
    //     // Try if this is not datetime (p_varVariant.ISDATETIME method is missing)
    //     //
    //     IF EVALUATE(ldtDatetime, ltxtText, 9) THEN BEGIN
    //         IF ltxtType = 'DateTime' THEN BEGIN
    //             p_frefFieldRef.VALUE(ldtDatetime);
    //             EXIT(TRUE);
    //         END;
    //         IF ltxtType = 'Date' THEN BEGIN
    //             p_frefFieldRef.VALUE(DT2DATE(ldtDatetime));
    //             EXIT(TRUE);
    //         END;
    //         IF ltxtType = 'Time' THEN BEGIN
    //             p_frefFieldRef.VALUE(DT2TIME(ldtDatetime));
    //             EXIT(TRUE);
    //         END;
    //     END;

    //     //
    //     // Try Text value conversion
    //     //
    //     r_blnResult := r_blnResult AND lfncConvertTextValue(ltxtText, p_recImportTemplateHeader, p_recImportTemplateLine,
    //                                                     p_frefFieldRef, p_intLineNo, p_recImportLog);
    // end;

    // local procedure lfncGetLastColumnName(p_recImportTemplateHeader: Record "Import Template Header") r_codValue: Code[2]
    // var
    //     lrecImportTemplateLine: Record "Import Template Line";
    //     lcodValue1: Code[2];
    //     lcodValue2: Code[2];
    // begin
    //     r_codValue := '';
    //     lcodValue2 := '';
    //     lrecImportTemplateLine.SETRANGE("Template Header Code", p_recImportTemplateHeader.Code);
    //     IF lrecImportTemplateLine.FINDSET(FALSE) THEN
    //         REPEAT
    //             lcodValue1 := lflncNormColName(lrecImportTemplateLine.Column);
    //             IF lcodValue1 > lcodValue2 THEN BEGIN
    //                 r_codValue := lrecImportTemplateLine.Column;
    //                 lcodValue2 := lflncNormColName(r_codValue)
    //             END;
    //         UNTIL lrecImportTemplateLine.NEXT() = 0;
    // end;

    // local procedure lfncIncrColName(var p_codColName: Code[2]) r_codValue: Code[2]
    // var
    //     lchr0: Char;
    //     lchr1: Char;
    // begin
    //     r_codValue := 'A';
    //     IF p_codColName <> '' THEN BEGIN
    //         lchr0 := p_codColName[2];
    //         IF lchr0 = 0 THEN
    //             lchr0 := p_codColName[1]
    //         ELSE
    //             lchr1 := p_codColName[1];
    //         lchr0 += 1;
    //         IF lchr0 > 'Z' THEN BEGIN
    //             lchr1 += 1;
    //             IF lchr1 = 1 THEN lchr1 := 'A';
    //             IF lchr1 > 'Z' THEN lchr1 := 0;
    //             lchr0 := 'A';
    //         END;
    //         r_codValue := FORMAT(lchr0);
    //         IF lchr1 > 0 THEN r_codValue := FORMAT(lchr1) + r_codValue;
    //     END;
    // end;

    // local procedure lflncNormColName(p_codColName: Code[2]) r_codValue: Code[2]
    // begin
    //     //
    //     // Normalize column name so they are sorted as A,B,...,AA,AB (not the A,AA,B,BB)
    //     //
    //     r_codValue := p_codColName;
    //     IF STRLEN(r_codValue) = 1 THEN r_codValue := '.' + r_codValue
    // end;

    // local procedure lfncSetFieldValue(var p_frefFieldRef: FieldRef; p_txtValue: Text[1024]; var p_recImportLog: Record "Import Log"): Boolean
    // var
    //     ltxtType: Text[30];
    //     lintValue: Integer;
    //     lintOptionCount: Integer;
    //     ltxtValue: Text[1024];
    //     lcodValue: Code[1024];
    //     ldecValue: Decimal;
    //     loptValue: Option;
    //     lblnValue: Boolean;
    //     ldatValue: Date;
    //     ltimValue: Time;
    //     //lbinValue: Binary[100];
    //     //ldfValue: DateFormula;
    //     lbintValue: BigInteger;
    //     ldurValue: Duration;
    //     lguidValue: Guid;
    //     lrecidValue: RecordID;
    //     ldtValue: DateTime;
    //     lblnOptionAsInteger: Boolean;
    // //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    // begin
    //     ltxtValue := p_txtValue;
    //     ltxtType := FORMAT(p_frefFieldRef.TYPE);
    //     CASE ltxtType OF
    //         'Integer':
    //             BEGIN
    //                 IF NOT EVALUATE(lintValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(lintValue);
    //             END;
    //         'BigInteger':
    //             BEGIN
    //                 IF NOT EVALUATE(lintValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(lintValue);
    //             END;
    //         'Text':
    //             BEGIN
    //                 ltxtValue := ltxtValue;
    //                 p_frefFieldRef.VALUE(ltxtValue);
    //             END;
    //         'Code':
    //             BEGIN
    //                 lcodValue := UPPERCASE(ltxtValue);
    //                 p_frefFieldRef.VALUE(lcodValue);
    //             END;
    //         'Decimal':
    //             BEGIN
    //                 IF NOT EVALUATE(ldecValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(ldecValue);
    //             END;
    //         'Option':
    //             BEGIN
    //                 IF NOT EVALUATE(lintValue, ltxtValue, 9) THEN BEGIN
    //                     lintValue := lfncOptionToInt(p_frefFieldRef.OPTIONSTRING, ltxtValue);
    //                 END ELSE BEGIN
    //                     IF lintValue > lfncLastOptionNo(p_frefFieldRef.OPTIONSTRING) THEN EXIT(FALSE);
    //                 END;
    //                 IF lintValue = -1 THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(lintValue);
    //             END;
    //         'Boolean':
    //             BEGIN
    //                 IF NOT EVALUATE(lblnValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(lblnValue);
    //             END;
    //         'Date':
    //             BEGIN
    //                 IF NOT EVALUATE(ldatValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 // IF ldatValue < 01011754D THEN ldatValue := 0D;  // All dates before 01011754 are assumed to be 0D
    //                 p_frefFieldRef.VALUE(ldatValue);
    //             END;
    //         'Time':
    //             BEGIN
    //                 IF NOT EVALUATE(ltimValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 p_frefFieldRef.VALUE(ltimValue);
    //             END;
    //         'DateTime':
    //             BEGIN
    //                 IF NOT EVALUATE(ldtValue, ltxtValue, 9) THEN EXIT(FALSE);
    //                 // IF ldtValue < CREATEDATETIME(01011754D,0T) THEN ldtValue := CREATEDATETIME(0D,0T);
    //                 p_frefFieldRef.VALUE(ldtValue);
    //             END;
    //         ELSE BEGIN
    //             // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_005, ltxtType, p_frefFieldRef.NAME));
    //             EXIT(FALSE); // Unsupported data type
    //         END;
    //     END;
    //     EXIT(TRUE);
    // end;

    // local procedure lfncOptionToInt(p_txtOptionString: Text[1024]; p_txtOption: Text[1024]) r_intValue: Integer
    // var
    //     lintPosition: Integer;
    //     lintCounter: Integer;
    //     lintLength: Integer;
    // begin
    //     r_intValue := 0;
    //     IF p_txtOption = '' THEN p_txtOption := ' ';
    //     lintPosition := STRPOS(p_txtOptionString, p_txtOption);
    //     IF lintPosition = 1 THEN BEGIN
    //         r_intValue := 0;
    //     END ELSE BEGIN
    //         IF lintPosition > 0 THEN BEGIN
    //             p_txtOptionString := COPYSTR(p_txtOptionString, 1, lintPosition - 1);
    //             lintLength := STRLEN(p_txtOptionString);
    //             lintCounter := 1;
    //             WHILE lintCounter <= lintLength DO BEGIN
    //                 IF p_txtOptionString[lintCounter] = ',' THEN r_intValue += 1;
    //                 lintCounter += 1;
    //             END;
    //         END ELSE BEGIN
    //             r_intValue := -1;
    //         END;
    //     END;
    // end;

    // local procedure lfncLastOptionNo(p_txtOptionString: Text[1024]) r_intValue: Integer
    // var
    //     lintPosition: Integer;
    //     lintCounter: Integer;
    //     lintLength: Integer;
    // begin
    //     r_intValue := 0;
    //     lintLength := STRLEN(p_txtOptionString);
    //     lintCounter := 1;
    //     WHILE lintCounter <= lintLength DO BEGIN
    //         IF p_txtOptionString[lintCounter] = ',' THEN r_intValue += 1;
    //         lintCounter += 1;
    //     END;
    // end;

    // local procedure lfncConvertDecimal(p_txtOriginal: Text[1024]; var p_txtConverted: Text[1024]; p_chrDecimalSymbol: Char; p_chrThousandDelimiter: Char): Boolean
    // var
    //     i: Integer;
    //     ldecDecimal: Decimal;
    //     lintDecimalPosition: Integer;
    //     lint: Integer;
    //     ltxtText: Text[30];
    // begin
    //     p_txtConverted := p_txtOriginal;
    //     //
    //     // Check string if contains only numbers, spaces decimal and thousand separator
    //     // if not return original string. do not attempt to do anything else
    //     //
    //     FOR i := 1 TO STRLEN(p_txtOriginal) DO
    //         IF NOT (p_txtOriginal[i] IN ['0' .. '9', ' ', '-', '+', p_chrDecimalSymbol, p_chrThousandDelimiter]) THEN
    //             EXIT(FALSE);

    //     // Check if there is only one decimal symbol and get its position from right
    //     i := STRLEN(p_txtOriginal);
    //     lintDecimalPosition := 0;
    //     WHILE i > 0 DO BEGIN
    //         IF p_txtOriginal[i] = p_chrDecimalSymbol THEN BEGIN
    //             IF lintDecimalPosition > 0 THEN EXIT(FALSE); // second decimal symbol - error
    //             lintDecimalPosition := i;
    //         END;
    //         i -= 1;
    //     END;

    //     // Clear out all spaces
    //     p_txtConverted := DELCHR(p_txtConverted, '<=>', ' ');

    //     // Clear out all thousand separators
    //     p_txtConverted := DELCHR(p_txtConverted, '<=>', FORMAT(p_chrThousandDelimiter));

    //     // The '.' is default XML decimal delimiter
    //     IF p_chrDecimalSymbol <> '.' THEN BEGIN
    //         p_txtConverted := CONVERTSTR(p_txtConverted, FORMAT(p_chrDecimalSymbol), '.');
    //     END;

    //     IF p_txtConverted[1] = '+' THEN p_txtConverted := COPYSTR(p_txtConverted, 2);

    //     EXIT(EVALUATE(ldecDecimal, p_txtConverted, 9)); // Make sure string can be evaluated
    // end;

    // local procedure lfncConvertDate(p_txtOriginal: Text[1024]; var p_txtConverted: Text[1024]; p_txtDateFormat: Text[30]): Boolean
    // var
    //     lintDummy: Integer;
    //     lintDay: Integer;
    //     lintMonth: Integer;
    //     lintYear: Integer;
    //     lintActiveBlock: Integer;
    //     lintPFormat: Integer;
    //     lintPOriginal: Integer;
    //     lintFChars: Integer;
    //     lintOChars: Integer;
    //     lblnDelimiter: Boolean;
    //     lblnLeap: Boolean;
    //     ldatDate: Date;
    //     lchrFChar: Char;
    //     lchrOChar: Char;
    // begin
    //     p_txtConverted := p_txtOriginal;
    //     IF p_txtDateFormat = '' THEN EXIT(FALSE);
    //     p_txtDateFormat := UPPERCASE(p_txtDateFormat);
    //     lintFChars := STRLEN(p_txtDateFormat);
    //     lintOChars := STRLEN(p_txtOriginal);
    //     lintPFormat := 0;
    //     lintPOriginal := 0;

    //     REPEAT
    //         IF lintPFormat < lintFChars THEN lintPFormat += 1;
    //         lchrFChar := p_txtDateFormat[lintPFormat];
    //         lblnDelimiter := FALSE;
    //         CASE lchrFChar OF
    //             'D':
    //                 lintActiveBlock := 1;
    //             'M':
    //                 lintActiveBlock := 2;
    //             'Y':
    //                 lintActiveBlock := 3;
    //             ELSE
    //                 lblnDelimiter := TRUE;
    //         END;
    //         lintPOriginal += 1;
    //         IF lintPOriginal > lintOChars THEN EXIT(FALSE); // we run out of characters
    //         lchrOChar := p_txtOriginal[lintPOriginal];
    //         IF lchrOChar IN ['0' .. '9'] THEN BEGIN
    //             EVALUATE(lintDummy, FORMAT(lchrOChar));
    //             CASE lintActiveBlock OF
    //                 1:
    //                     lintDay := lintDay * 10 + lintDummy;
    //                 2:
    //                     lintMonth := lintMonth * 10 + lintDummy;
    //                 3:
    //                     lintYear := lintYear * 10 + lintDummy;
    //             END;
    //         END ELSE BEGIN
    //             IF NOT lblnDelimiter THEN EXIT(FALSE); // Expecting number
    //         END;
    //         IF lblnDelimiter THEN BEGIN
    //             IF lchrFChar <> lchrOChar THEN lintPOriginal += 1;
    //         END;
    //     UNTIL (lintPFormat = lintFChars) AND (lintPOriginal = lintOChars);

    //     IF lintYear < 100 THEN
    //         IF lintYear < 80 THEN
    //             lintYear += 2000
    //         ELSE
    //             lintYear += 1900;

    //     // Check validity of day month etc
    //     IF (lintMonth < 1) OR (lintMonth > 12) THEN EXIT(FALSE);
    //     IF (lintDay < 1) OR (lintDay > 31) THEN EXIT(FALSE);
    //     IF (lintMonth IN [4, 6, 9, 11]) AND (lintDay > 30) THEN EXIT(FALSE);
    //     // Leap years between 1980 and 2079 - every 4th.
    //     // the only year here divisible by 100 is 2000, which is also leap - divisible by 400)
    //     lblnLeap := ((lintYear MOD 4) = 0);
    //     IF lintMonth = 2 THEN BEGIN
    //         IF (lblnLeap AND (lintDay > 29)) THEN EXIT(FALSE);
    //         IF ((NOT lblnLeap) AND (lintDay > 28)) THEN EXIT(FALSE);
    //     END;

    //     p_txtConverted := FORMAT(DMY2DATE(lintDay, lintMonth, lintYear), 10, 9);
    //     EXIT(EVALUATE(ldatDate, p_txtConverted, 9)); // Make sure string can be evaluated
    // end;

    // local procedure lfncServerUpload(var p_recImportLog: Record "Import Log"; p_txtClientFullFileName: Text[1024]; var p_txtServerFullFileName: Text[1024]; p_blnShowDialog: Boolean) r_blnValue: Boolean
    // var
    //     //lmdlFileManagement: Codeunit "File Management";
    //     lfilFile: File;
    //     listrInStream: InStream;
    //     xlistrInStream2: InStream;
    //     lostrOutStream: OutStream;
    //     ltxtDummy: Text[1024];
    //     ltxtMagicFullFileName: Text[1024];
    //     ltxtMagicPath: Text[1024];
    //     ltxtTmpFullFileName: Text[1024];
    //     ltxtTmpFilePath: Text[1024];
    //     ltxtClientFileName: Text[1024];
    //     ltxtServerFileName: Text[1024];
    //     ldlgDialog: Dialog;
    //    // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    // begin
    //     r_blnValue := TRUE;
    //     IF p_blnShowDialog THEN BEGIN
    //         ldlgDialog.OPEN(DLG_002);
    //         ldlgDialog.UPDATE(1, MSG_012);
    //     END;

    //     // Get Client file name
    //     //ltxtClientFileName := lfncGetFileName(p_txtClientFullFileName);
    //     // Create server temporary file
    //     // lfilFile.CREATETEMPFILE;
    //     //ltxtTmpFilePath := lfncGetFilePath(lfilFile.NAME);


    //     // Try delete all previous tmp files
    //     //ltxtDummy := 'cmd /c del ' + ltxtTmpFilePath + '\*.* ';
    //     //CREATE(lautWsShell, TRUE, FALSE);
    //     //lautWsShell.Exec(ltxtDummy);
    //     //CLEAR(lautWsShell);

    //     // Build Server side file name
    //     //ltxtServerFileName := lfncGetFileName(lfilFile.NAME) + '.' + lfncGetFileExtension(ltxtClientFileName); // xxxx.tmp.xlsx
    //     // ltxtServerFileName := lfncGetFileName(lfilFile.NAME);  // leave file name as .tmp
    //     //ltxtServerFileName := ltxtClientFileName;
    //     // lfilFile.CREATEINSTREAM(listrInStream);
    //     // Download server temp file to local Magic path
    //     DOWNLOADFROMSTREAM(listrInStream, '', '<TEMP>', '', ltxtMagicFullFileName);
    //     //lfilFile.CLOSE();
    //     CLEAR(listrInStream);

    //     // MP 25-May-16 Redone to not use Automation Servers >>
    //     //IF ISCLEAR(lautFileSystemObject) THEN
    //     //  CREATE(lautFileSystemObject, TRUE, TRUE);
    //     // MP 25-May-16 <<

    //     // Build full server file name
    //     p_txtServerFullFileName := ltxtTmpFilePath + ltxtServerFileName;

    //     // ltxtMagicPath := lfncGetFilePath(ltxtMagicFullFileName);

    //     // Copy local file to magic path
    //     // MP 25-May-16 Redone to not use Automation Servers >>
    //     //lautFileSystemObject.CopyFile(p_txtClientFullFileName, ltxtMagicPath+ltxtServerFileName, TRUE);
    //     // lmdlFileManagement.CopyClientFile(p_txtClientFullFileName, ltxtMagicPath+ltxtServerFileName, TRUE);
    //     // MP 25-May-16 <<

    //     IF p_blnShowDialog THEN BEGIN
    //         ldlgDialog.UPDATE(1, MSG_013);
    //     END;

        // Upload file from Magic path to server
        // IF NOT UPLOAD('', '<TEMP>', '', ltxtServerFileName, p_txtServerFullFileName) THEN BEGIN
       // r_blnValue := FALSE;
        // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog,0,STRSUBSTNO(ERR_028,ltxtClientFileName, GETLASTERRORTEXT));
  //  END;

        //
        // Uploadintostream is leaving temp file on the server
        //
        //IF UPLOADINTOSTREAM('', '<TEMP>', '', ltxtServerFileName, listrInStream) THEN BEGIN
        //  IF p_blnShowDialog THEN BEGIN
        //    ldlgDialog.UPDATE(1, MSG_014);
        //  END;
        //  lfilFile.WRITEMODE(TRUE);
        //  IF lfilFile.CREATE(p_txtServerFullFileName) THEN BEGIN
        //    lfilFile.CREATEOUTSTREAM(lostrOutStream);
        //    COPYSTREAM(lostrOutStream, listrInStream);
        //    lfilFile.CLOSE;
        //    CLEAR(lostrOutStream);
        //  END ELSE BEGIN
        //    r_blnValue := FALSE;
        //    lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog,0,STRSUBSTNO(ERR_022,p_txtServerFullFileName));
        //  END;
        //END ELSE BEGIN
        //  r_blnValue := FALSE;
        //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog,0,STRSUBSTNO(ERR_023,ltxtClientFileName, GETLASTERRORTEXT));
        //END;

        //CLEAR(listrInStream);

        // Delete files from Local MagicPath
        // MP 25-May-16 Redone to not use Automation Servers >>
        //IF lautFileSystemObject.FileExists(ltxtMagicFullFileName) THEN
        //  lautFileSystemObject.DeleteFile(ltxtMagicFullFileName);
        //
        //IF lautFileSystemObject.FileExists(ltxtMagicPath + ltxtServerFileName) THEN
        //  lautFileSystemObject.DeleteFile(ltxtMagicPath + ltxtServerFileName);

    //     //lmdlFileManagement.DeleteClientFile(ltxtMagicFullFileName);
    //     lmdlFileManagement.DeleteClientFile(ltxtMagicPath + ltxtServerFileName);
    //     // MP 25-May-16 <<

    //     IF p_blnShowDialog THEN BEGIN
    //       ldlgDialog.CLOSE;
    //     END;

    //     CLEARALL;
    // end;

    // local procedure lfncGetFileName(p_txtFullFileName: Text[1024]): Text[1024]
    // var
    //     i: Integer;
    // begin
    //     i := STRLEN(p_txtFullFileName);
    //     WHILE i > 0 DO BEGIN
    //       IF p_txtFullFileName[i] = '\' THEN EXIT(COPYSTR(p_txtFullFileName, i+1));
    //       i -= 1;
    //     END;
    // end;

//     local procedure lfncGetFileExtension(p_txtFullFileName: Text[1024]): Text[1024]
//     var
//         i: Integer;
//     begin
//         i := STRLEN(p_txtFullFileName);
//         WHILE i > 0 DO BEGIN
//           IF p_txtFullFileName[i] = '.' THEN EXIT(COPYSTR(p_txtFullFileName, i+1));
//           i -= 1;
//         END;
//     end;

//     local procedure lfncGetFilePath(p_txtFullFileName: Text[1024]): Text[1024]
//     var
//         i: Integer;
//     begin
//         i := STRLEN(p_txtFullFileName);
//         WHILE i > 0 DO BEGIN
//           IF p_txtFullFileName[i] = '\' THEN EXIT(COPYSTR(p_txtFullFileName, 1, i));
//           i -= 1;
//         END;
//     end;

//     //[Scope('Internal')]
//     procedure "<-- Stage 2 related -->"()
//     begin
//     end;

//     //[Scope('Internal')]
//     procedure gfncRunStage2(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean;p_blnDeleteErrorLog: Boolean) r_blnResult: Boolean
//     var
//        // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         p_recImportLog.Stage := p_recImportLog.Stage::"Post Import Validation";
//         p_recImportLog.Status := p_recImportLog.Status::"In Progress";
//         p_recImportLog.MODIFY;
//         COMMIT;

//         // Delete old Import log entries
//        // IF p_blnDeleteErrorLog THEN lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

//         r_blnResult := TRUE;
//         r_blnResult := r_blnResult AND gfncCheckCompanies(p_recImportLog, p_blnDialog);
//         r_blnResult := r_blnResult AND gfncValidateImportRecords(p_recImportLog, p_blnDialog);
//         r_blnResult := r_blnResult AND gfncCheckPostingDateRange(p_recImportLog, p_blnDialog);
//         r_blnResult := r_blnResult AND gfncUpdateDateRange(p_recImportLog, p_blnDialog);

//         IF NOT r_blnResult THEN BEGIN
//           // Roll-Back
//           lmodDataImportManagementCommon.gfncDeleteEntries(p_recImportLog."Entry No.", p_recImportLog."Table ID", p_blnDialog);
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_013, p_recImportLog."Entry No."));
//           p_recImportLog.Status := p_recImportLog.Status::Error;
//         END ELSE BEGIN
//           p_recImportLog.Status := p_recImportLog.Status::Processed;
//         END;
//         p_recImportLog.MODIFY(TRUE);
//     end;

//     //[Scope('Internal')]
//     procedure gfncValidateImportRecords(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
//         // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         r_blnResult := TRUE;
//         // CASE p_recImportLog."Table ID" OF
//         //   60009 : r_blnResult := r_blnResult AND lmodDataImportMgt_60009.gfncValidateImportRec(p_recImportLog, p_blnDialog);
//         //   60012 : r_blnResult := r_blnResult AND lmodDataImportMgt_60012.gfncValidateImportRec(p_recImportLog, p_blnDialog);
//         //   60018 : r_blnResult := r_blnResult AND lmodDataImportMgt_60018.gfncValidateImportRec(p_recImportLog, p_blnDialog);
//         //   60019 : r_blnResult := r_blnResult AND lmodDataImportMgt_60019.gfncValidateImportRec(p_recImportLog, p_blnDialog);
//         //   60020 : r_blnResult := r_blnResult AND lmodDataImportMgt_60020.gfncValidateImportRec(p_recImportLog, p_blnDialog);
//         //   ELSE BEGIN
//         //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_009, p_recImportLog."Table ID"));
//         //   END;
//         END;
//    // end;

    //[Scope('Internal')]
//     procedure gfncCheckCompanies(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrrRecRef: RecordRef;
//         lfrCompanyNo: FieldRef;
//         lfrImportLog: FieldRef;
//         lrecTmpCustomer: Record Customer temporary;
//         lrecSubsidiaryClient: Record "Subsidiary Client";
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//         ldlgDialog: Dialog;
//         lintTotal: Integer;
//         lintPosition: Integer;
//         lintLastPct: Integer;
//        // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         lrrRecRef.OPEN(p_recImportLog."Table ID");
//         lfrImportLog := lrrRecRef.FIELD(99998);
//         lfrCompanyNo := lrrRecRef.FIELD(99994);
//         lfrImportLog.SETRANGE(p_recImportLog."Entry No.");
//         r_blnResult := TRUE;
//         IF p_blnDialog THEN BEGIN
//           ldlgDialog.OPEN(DLG_003);
//           ldlgDialog.UPDATE(1, MSG_015);
//           lintTotal := lrrRecRef.COUNT;
//           lintPosition := 0;
//         END;
//         //
//         // Make list of unique values
//         //
//         lrecTmpCustomer.DELETEALL;
//         lintLastPct := 0;
//         IF lrrRecRef.FINDSET(FALSE) THEN REPEAT
//           IF p_blnDialog THEN BEGIN
//             lintPosition += 1;
//             IF ROUND((lintPosition/lintTotal)*100,1,'<') > lintLastPct THEN BEGIN
//               lintLastPct := ROUND((lintPosition/lintTotal)*100,1,'<');
//               ldlgDialog.UPDATE(2, lintLastPct * 100);
//             END;
//           END;
//           lrecTmpCustomer."No." := lfrCompanyNo.VALUE;
//           IF lrecTmpCustomer."No." <> '' THEN
//             IF NOT lrecTmpCustomer.INSERT(FALSE) THEN ;
//         UNTIL lrrRecRef.NEXT = 0;
//         //
//         // Check the list against existing records
//         //
//         lrecTmpCustomer.RESET;
//         lrecSubsidiaryClient.SETCURRENTKEY("Company No.");
//         IF lrecTmpCustomer.FINDSET(FALSE) THEN REPEAT
//           lrecSubsidiaryClient.SETRANGE("Company No.", lrecTmpCustomer."No.");
//           lrecSubsidiaryClient.SETRANGE("Parent Client No.", p_recImportLog."Parent Client No.");
//           IF NOT lrecSubsidiaryClient.FIND('-') THEN BEGIN
//             r_blnResult := FALSE;
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_012, lrecTmpCustomer."No."));
//           END;
//         UNTIL lrecTmpCustomer.NEXT = 0;
//         //
//         // If success create subs. import entries
//         //
//         IF r_blnResult THEN BEGIN
//           lrecTmpCustomer.RESET;
//           lrecSubsidiaryClient.SETCURRENTKEY("Company No.");
//           IF lrecTmpCustomer.FINDSET(FALSE) THEN REPEAT
//             lrecSubsidiaryClient.SETRANGE("Company No.", lrecTmpCustomer."No.");
//             lrecSubsidiaryClient.SETRANGE("Parent Client No.", p_recImportLog."Parent Client No.");
//             lrecSubsidiaryClient.FIND('-');
//             lrecImportLogSubsidiaryClient.INIT;
//             lrecImportLogSubsidiaryClient."Import Log Entry No."  := p_recImportLog."Entry No.";
//             lrecImportLogSubsidiaryClient."Parent Client No."     := lrecSubsidiaryClient."Parent Client No.";
//             lrecImportLogSubsidiaryClient."Country Database Code" := lrecSubsidiaryClient."Country Database Code";
//             lrecImportLogSubsidiaryClient."Company Name"          := lrecSubsidiaryClient."Company Name";
//             lrecImportLogSubsidiaryClient."Company No."           := lrecSubsidiaryClient."Company No.";
//             lrecImportLogSubsidiaryClient."Creation Date"         := TODAY;
//             lrecImportLogSubsidiaryClient."Creation Time"         := TIME;
//             lrecImportLogSubsidiaryClient."Interface Type"        := p_recImportLog."Interface Type";
//             lrecImportLogSubsidiaryClient."TB to TB client"       := lrecSubsidiaryClient."TB to TB client";
//             lrecImportLogSubsidiaryClient."G/L Detail level"      := lrecSubsidiaryClient."G/L Detail level";
//             lrecImportLogSubsidiaryClient."Statutory Reporting"   := lrecSubsidiaryClient."Statutory Reporting";
//             lrecImportLogSubsidiaryClient."Corp. Tax Reporting"   := lrecSubsidiaryClient."Corp. Tax Reporting";
//             lrecImportLogSubsidiaryClient."VAT Reporting level"   := lrecSubsidiaryClient."VAT Reporting level";
//             lrecImportLogSubsidiaryClient.INSERT(TRUE);
//           UNTIL lrecTmpCustomer.NEXT = 0;
//         END;

//         IF p_blnDialog THEN BEGIN
//           ldlgDialog.CLOSE;
//         END;
//     end;

//     //[Scope('Internal')]
//     procedure gfncCheckPostingDateRange(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//     begin
//         r_blnResult := TRUE;
//         CASE p_recImportLog."Table ID" OF
//           60009 : ; // No need to check
//           60012 : r_blnResult := r_blnResult AND lmodDataImportMgt_60012.gfncCheckPostDateRange(p_recImportLog, p_blnDialog);
//           60018 : ; // No need to check
//           60019 : ; // No need to check
//           60020 : ; // No need to check
//           ELSE BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_009, p_recImportLog."Table ID"));
//           END;
//         END;
//     end;

//     //[Scope('Internal')]
//     procedure gfncUpdateDateRange(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
//         // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         r_blnResult := TRUE;
//         // CASE p_recImportLog."Table ID" OF
//         //   60009 : r_blnResult := r_blnResult AND lmodDataImportMgt_60009.gfncUpdateDateRange(p_recImportLog, p_blnDialog);
//         //   60012 : r_blnResult := r_blnResult AND lmodDataImportMgt_60012.gfncUpdateDateRange(p_recImportLog, p_blnDialog);
//         //   60018 : r_blnResult := r_blnResult AND lmodDataImportMgt_60018.gfncUpdateDateRange(p_recImportLog, p_blnDialog);
//         //   60019 : r_blnResult := r_blnResult AND lmodDataImportMgt_60019.gfncUpdateDateRange(p_recImportLog, p_blnDialog);
//         //   60020 : r_blnResult := r_blnResult AND lmodDataImportMgt_60020.gfncUpdateDateRange(p_recImportLog, p_blnDialog);
//         //   ELSE BEGIN
//         //     lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0, STRSUBSTNO(ERR_009, p_recImportLog."Table ID"));
//         //   END;
//         // END;
//     end;

//     //[Scope('Internal')]
//     procedure "<-- Stage 3 related -->"()
//     begin
//     end;

//    //
//     procedure gfncRunStage3(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean;p_blnDeleteErrorLog: Boolean) r_blnResult: Boolean
//     var
//        // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         //
//         // Copy all individual companies
//         //
//         p_recImportLog.Stage := p_recImportLog.Stage::"Data Transfer";
//         p_recImportLog.Status := p_recImportLog.Status::"In Progress";
//         p_recImportLog.MODIFY;
//         COMMIT;

//         // Delete old Import log entries - Header
//         IF p_blnDeleteErrorLog THEN lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);
//         // Delete old Import log entries - Subs clients
//         gfncDeleteSubsErrEntries(p_recImportLog, p_blnDialog);

//         // Local processing of Data (Export files etc)
//         r_blnResult := gfncLocalProcessData(p_recImportLog, p_blnDialog);

//         // Copy data to subsidiary database
//         r_blnResult := r_blnResult AND gfncCopyData(p_recImportLog, p_blnDialog);

//         IF NOT r_blnResult THEN BEGIN
//           p_recImportLog.Status := p_recImportLog.Status :: Error;
//           // Roll-Back Stage 3
//           IF lmodDataImportManagementCommon.gfncRollBackRemoteData(p_recImportLog, TRUE) THEN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                               STRSUBSTNO(ERR_020, 3, p_recImportLog."Entry No."))
//           ELSE
//             // Rollback failed
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                               STRSUBSTNO(ERR_021, 3, p_recImportLog."Entry No."));
//         END ELSE BEGIN
//           p_recImportLog.Status := p_recImportLog.Status :: Processed;
//         END;
//         p_recImportLog.MODIFY;
//     end;

   
//     procedure gfncDeleteSubsErrEntries(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//       //  lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
//           lmodDataImportManagementCommon.gfncDelSubsClientErrLogEntries(lrecImportLogSubsidiaryClient); // Delete old error entries
//         UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
//     end;

   
//     procedure gfncLocalProcessData(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//       //  lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
//           r_blnResult := r_blnResult AND gfncLocalProcessClient(p_recImportLog, lrecImportLogSubsidiaryClient, p_blnDialog);
//         UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
//     end;

   
//     procedure gfncLocalProcessClient(var p_recImportLog: Record "Import Log";var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         // lmodDataImportManagementCommon: codeunit "Data Import Management Common";
//         // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
//         // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::"In Progress";
//         p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Data Transfer";
//         p_recImportLogSubsidiaryClient.MODIFY;
//         COMMIT;

//         r_blnResult := TRUE;

//         //  data Process
//         CASE p_recImportLog."Table ID" OF
//           60009 : r_blnResult := lmodDataImportMgt_60009.gfncProcessClient(p_recImportLog,p_recImportLogSubsidiaryClient,p_blnDialog);
//           60012 : r_blnResult := lmodDataImportMgt_60012.gfncProcessClient(p_recImportLog,p_recImportLogSubsidiaryClient,p_blnDialog);
//           60018 : r_blnResult := lmodDataImportMgt_60018.gfncProcessClient(p_recImportLog,p_recImportLogSubsidiaryClient,p_blnDialog);
//           60019 : r_blnResult := lmodDataImportMgt_60019.gfncProcessClient(p_recImportLog,p_recImportLogSubsidiaryClient,p_blnDialog);
//           60020 : r_blnResult := lmodDataImportMgt_60020.gfncProcessClient(p_recImportLog,p_recImportLogSubsidiaryClient,p_blnDialog);
//         END;

//         IF r_blnResult THEN BEGIN
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Processed;
//         END ELSE BEGIN
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Error;
//         END;
//         p_recImportLogSubsidiaryClient.MODIFY;
//     end;

   
//     procedure gfncCopyData(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//         //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := TRUE;
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
//           //lmodDataImportManagementCommon.gfncDelSubsClientErrLogEntries(lrecImportLogSubsidiaryClient); // Delete old error entries
//           r_blnResult := r_blnResult AND gfncCopyClient(p_recImportLog, lrecImportLogSubsidiaryClient, p_blnDialog);
//         UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
//     end;

//     //[Scope('Internal')]
//     procedure gfncCopyClient(var p_recImportLog: Record "Import Log";var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lintCopyActionId: Integer;
//         lrecCountryDatabase: Record "Country Database";
//         ltxtImportLogKey: Text[1024];
//         // // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//         // lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//         // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
//         // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::"In Progress";
//         p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Data Transfer";
//         p_recImportLogSubsidiaryClient.MODIFY;
//         COMMIT;

//         IF NOT lrecCountryDatabase.GET(p_recImportLogSubsidiaryClient."Country Database Code") THEN BEGIN
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_014, p_recImportLogSubsidiaryClient."Country Database Code"));
//           EXIT(FALSE);
//         END;

//         lmodDataImportSafeWScall.gfncSetDialog(p_blnDialog);
//         lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
//         lmodDataImportSafeWScall.gfncSetSubsImportLog(p_recImportLogSubsidiaryClient);
//         // Copy log header
//         lmodDataImportSafeWScall.gfncSetAction(3); // Copy import log
//         COMMIT;
//         IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//           r_blnResult := lmodDataImportSafeWScall.gfncGetLastResult();
//           ltxtImportLogKey := lmodDataImportSafeWScall.gfncGetKey();
//         END ELSE BEGIN
//           r_blnResult := FALSE;
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//         END;

//         IF r_blnResult THEN BEGIN // Continue only if header was success
//           // Copy data
//           CASE p_recImportLog."Table ID" OF
//             60009 : lintCopyActionId := lmodDataImportMgt_60009.gfncGetActionNoCopyData();
//             60012 : lintCopyActionId := lmodDataImportMgt_60012.gfncGetActionNoCopyData();
//             60018 : lintCopyActionId := lmodDataImportMgt_60018.gfncGetActionNoCopyData();
//             60019 : lintCopyActionId := lmodDataImportMgt_60019.gfncGetActionNoCopyData();
//             60020 : lintCopyActionId := lmodDataImportMgt_60020.gfncGetActionNoCopyData();
//           END;

//           lmodDataImportSafeWScall.gfncSetAction(lintCopyActionId);
//           COMMIT;
//           IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//             r_blnResult := r_blnResult AND lmodDataImportSafeWScall.gfncGetLastResult();
//           END ELSE BEGIN
//             r_blnResult := FALSE;
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//           END;
//           IF NOT r_blnResult THEN BEGIN
//             // Delete local data
//             lmodDataImportSafeWScall.gfncSetAction(2);
//             COMMIT;
//             IF NOT lmodDataImportSafeWScall.RUN() THEN BEGIN // Even delete crashed. Not much to do here
//               lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                              STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//             END;
//             // Delete log
//             //lmodDataImportSafeWScall.gfncSetAction(4); // Delete Import log
//             //COMMIT;
//             //IF NOT lmodDataImportSafeWScall.RUN() THEN BEGIN // Even delete crashed. Not much to do here
//             //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//             //                                 STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//             //END;
//           END;
//         END;



//         IF r_blnResult THEN BEGIN
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Processed;
//         END ELSE BEGIN
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Error;
//         END;
//         //p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Data Transfer";
//         p_recImportLogSubsidiaryClient.MODIFY;

//         IF r_blnResult THEN BEGIN
//           // update import log here
//           p_recImportLog.Status := p_recImportLog.Status::Processed;
//           lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
//           lmodDataImportSafeWScall.gfncSetKey(ltxtImportLogKey);
//           lmodDataImportSafeWScall.gfncSetAction(12); // Update import log
//           COMMIT;
//           IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//             r_blnResult := lmodDataImportSafeWScall.gfncGetLastResult();
//           END ELSE BEGIN
//             r_blnResult := FALSE;
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//           END;
//         END;
//         IF  NOT r_blnResult THEN BEGIN
//           // Delete log
//           lmodDataImportSafeWScall.gfncSetAction(4); // Delete Import log
//           COMMIT;
//           IF NOT lmodDataImportSafeWScall.RUN() THEN BEGIN // Even delete crashed. Not much to do here
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//           END;
//         END;
//     end;

//     //[Scope('Internal')]
//     procedure "<-- Stage 4 related -->"()
//     begin
//     end;

//     //[Scope('Internal')]
//     procedure gfncRunStage4(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean;p_blnDeleteErrorLog: Boolean) r_blnResult: Boolean
//     var
//       //  lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         //
//         // Copy all individual companies
//         //
//         p_recImportLog.Stage := p_recImportLog.Stage::"Data Validation";
//         p_recImportLog.Status := p_recImportLog.Status::"In Progress";
//         p_recImportLog.MODIFY;
//         COMMIT;

//         // Delete old Import log entries
//         IF p_blnDeleteErrorLog THEN lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

//         r_blnResult := gfncValidateRemoteData(p_recImportLog, p_blnDialog);

//         IF NOT r_blnResult THEN BEGIN
//           p_recImportLog.Status := p_recImportLog.Status :: Error;
//           // Roll-Back Stage 4
//           IF lmodDataImportManagementCommon.gfncRollBackRemoteData(p_recImportLog, TRUE) THEN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                               STRSUBSTNO(ERR_020, 4, p_recImportLog."Entry No."))
//           ELSE
//             // Rollback failed
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                                               STRSUBSTNO(ERR_021, 4, p_recImportLog."Entry No."));
//         END ELSE BEGIN
//           p_recImportLog.Status := p_recImportLog.Status :: Processed;
//         END;
//         p_recImportLog.MODIFY;
//     end;

//    //[Scope('Internal')]
//     procedure gfncValidateRemoteData(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//     begin
//         r_blnResult := TRUE;
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
//           r_blnResult := r_blnResult AND gfncValidateRemoteClientData(p_recImportLog, lrecImportLogSubsidiaryClient, p_blnDialog);
//         UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
//     end;

//     //[Scope('Internal')]
//     procedure gfncValidateRemoteClientData(var p_recImportLog: Record "Import Log";var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCountryDatabase: Record "Country Database";
//         //lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//        // lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//     begin
//         p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::"In Progress";
//         p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Data Validation";
//         p_recImportLogSubsidiaryClient.MODIFY;
//         COMMIT;

//         IF NOT lrecCountryDatabase.GET(p_recImportLogSubsidiaryClient."Country Database Code") THEN BEGIN
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_014, p_recImportLogSubsidiaryClient."Country Database Code"));
//           EXIT(FALSE);
//         END;
//         // Delete old error entries
//         lmodDataImportManagementCommon.gfncDelSubsClientErrLogEntries(p_recImportLogSubsidiaryClient);

//         lmodDataImportSafeWScall.gfncSetDialog(p_blnDialog);
//         lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
//         lmodDataImportSafeWScall.gfncSetSubsImportLog(p_recImportLogSubsidiaryClient);

//         lmodDataImportSafeWScall.gfncSetAction(5); // ValidateRemote data
//         COMMIT;
//         IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//           r_blnResult := lmodDataImportSafeWScall.gfncGetLastResult();
//           IF NOT r_blnResult THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_017, p_recImportLogSubsidiaryClient."Import Log Entry No.",
//                                            p_recImportLogSubsidiaryClient."Company Name"));
//           END;
//         END ELSE BEGIN
//           r_blnResult := FALSE;
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//         END;
//         //
//         // Validation failed, get validation errors
//         //
//         IF NOT r_blnResult THEN BEGIN
//           lmodDataImportSafeWScall.gfncSetAction(6); // Retrieve remote error log
//           COMMIT;
//           IF NOT lmodDataImportSafeWScall.RUN() THEN BEGIN //
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//           END;
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Error;
//         END ELSE BEGIN
//           p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Processed;
//         END;
//         //p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Data Validation";
//         p_recImportLogSubsidiaryClient.MODIFY;
//     end;

//     //[Scope('Internal')]
//     procedure "<-- Stage 5 related -->"()
//     begin
//     end;

//     //[Scope('Internal')]
//     procedure gfncRunStage5(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean;p_blnDeleteErrorLog: Boolean) r_blnResult: Boolean
//     var
//        // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         //
//         // Copy all individual companies
//         //
//         p_recImportLog.Stage := p_recImportLog.Stage::"Record Creation/Update/Posting";
//         p_recImportLog.Status := p_recImportLog.Status::"In Progress";
//         p_recImportLog.MODIFY;
//         COMMIT;

//         // Delete old Import log entries
//         IF p_blnDeleteErrorLog THEN lmodDataImportManagementCommon.gfncDeleteErrorLogEntries(p_recImportLog);

//         r_blnResult := gfncPostRemoteData(p_recImportLog, p_blnDialog);

//         IF NOT r_blnResult THEN
//           p_recImportLog.Status := p_recImportLog.Status :: Error
//         ELSE
//           p_recImportLog.Status := p_recImportLog.Status :: Processed;
//         p_recImportLog.MODIFY;
//     end;

//     //[Scope('Internal')]
//     procedure gfncPostRemoteData(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//     begin
//         r_blnResult := TRUE;
//         lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");
//         IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
//           r_blnResult := r_blnResult AND gfncPostRemoteClientData(p_recImportLog, lrecImportLogSubsidiaryClient, p_blnDialog);
//         UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
//     end;

//    //
//     procedure gfncPostRemoteClientData(var p_recImportLog: Record "Import Log";var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecCountryDatabase: Record "Country Database";
//        // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//       //  lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//     begin
//         p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::"In Progress";
//         p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Record Creation/Update/Posting";
//         p_recImportLogSubsidiaryClient.MODIFY;
//         COMMIT;

//         IF NOT lrecCountryDatabase.GET(p_recImportLogSubsidiaryClient."Country Database Code") THEN BEGIN
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_014, p_recImportLogSubsidiaryClient."Country Database Code"));
//           EXIT(FALSE);
//         END;

//         // Delete old error entries
//         lmodDataImportManagementCommon.gfncDelSubsClientErrLogEntries(p_recImportLogSubsidiaryClient);

//         lmodDataImportSafeWScall.gfncSetDialog(p_blnDialog);
//         lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
//         lmodDataImportSafeWScall.gfncSetSubsImportLog(p_recImportLogSubsidiaryClient);

//         lmodDataImportSafeWScall.gfncSetAction(7); // Post Remote data
//         COMMIT;
//         IF lmodDataImportSafeWScall.RUN() THEN BEGIN
//           r_blnResult := lmodDataImportSafeWScall.gfncGetLastResult();
//           IF NOT r_blnResult THEN BEGIN
//             lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                            STRSUBSTNO(ERR_018, p_recImportLogSubsidiaryClient."Import Log Entry No.",
//                                            p_recImportLogSubsidiaryClient."Company Name"));
//           END;
//         END ELSE BEGIN
//           r_blnResult := FALSE;
//           lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                                          STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
//         END;

        //
        // Posting failed, get posting errors
        //
    //     IF NOT r_blnResult THEN BEGIN
    //       lmodDataImportSafeWScall.gfncSetAction(6); // Retrieve remote error log
    //       COMMIT;
    //       IF NOT lmodDataImportSafeWScall.RUN() THEN BEGIN
    //         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    //                                        STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
    //       END;
    //       p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Error;
    //     END ELSE BEGIN
    //       p_recImportLogSubsidiaryClient.Status := p_recImportLogSubsidiaryClient.Status::Processed;
    //     END;
    //     //p_recImportLogSubsidiaryClient.Stage := p_recImportLogSubsidiaryClient.Stage::"Record Creation/Update/Posting";
    //     p_recImportLogSubsidiaryClient.MODIFY;
    // end;

    //[Scope('Internal')]
//    procedure "<-- Stage 6 Related -->"()
//     begin
//     end;

    //[Scope('Internal')]
    // procedure gfncRunStage6(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
    // var
    //     lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
    //    // lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
    //    // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    // begin
    //     //
    //     // Archive
    //     //

    //     // Archive Master Data
    //     r_blnResult := gfncArchive(p_recImportLog, p_blnDialog);

    //     // Archive remote records
    //     //Import Log Entry No.,Parent Client No.,Country Database Code,Company Name
    //     lrecImportLogSubsidiaryClient.SETRANGE("Import Log Entry No.", p_recImportLog."Entry No.");

    // //     lmodDataImportSafeWScall.gfncSetDialog(p_blnDialog);
    // //     lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
    // //     // Copy log header
    // //     lmodDataImportSafeWScall.gfncSetAction(13); // Archive remote data
    // //     IF lrecImportLogSubsidiaryClient.FINDSET(FALSE) THEN REPEAT
    // //       lmodDataImportSafeWScall.gfncSetSubsImportLog(lrecImportLogSubsidiaryClient);
    // //       COMMIT;
    // //       IF lmodDataImportSafeWScall.RUN() THEN BEGIN
    // //         r_blnResult := lmodDataImportSafeWScall.gfncGetLastResult();
    // //       END ELSE BEGIN
    // //         r_blnResult := FALSE;
    // //         lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
    // //                                        STRSUBSTNO(ERR_016, GETLASTERRORTEXT));
    // //       END;
    // //     UNTIL lrecImportLogSubsidiaryClient.NEXT = 0;
    // // end;

    //[Scope('Internal')]
//     procedure gfncArchive(var p_recImportLog: Record "Import Log";p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lblnConfirm: Boolean;
//         // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
//         // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
//         // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
//         // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
// //lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
//     begin
//         r_blnResult := FALSE;
//         IF p_blnDialog THEN BEGIN
//           p_recImportLog.CALCFIELDS("Table Name");
//           lblnConfirm := CONFIRM(DLG_004, FALSE, p_recImportLog."Entry No.", p_recImportLog."Table Name");
//         END ELSE BEGIN
//           lblnConfirm := TRUE;
//         END;

//         IF lblnConfirm THEN BEGIN
//           CASE p_recImportLog."Table ID" OF
//             60009 : r_blnResult := lmodDataImportMgt_60009.gfncArchive(p_recImportLog, p_blnDialog);
//             60012 : r_blnResult := lmodDataImportMgt_60012.gfncArchive(p_recImportLog, p_blnDialog);
//             60018 : r_blnResult := lmodDataImportMgt_60018.gfncArchive(p_recImportLog, p_blnDialog);
//             60019 : r_blnResult := lmodDataImportMgt_60019.gfncArchive(p_recImportLog, p_blnDialog);
//             60020 : r_blnResult := lmodDataImportMgt_60020.gfncArchive(p_recImportLog, p_blnDialog);
//           END;
//         END ELSE BEGIN
//           EXIT(FALSE);
//         END;

//         IF p_blnDialog THEN BEGIN
//           IF r_blnResult THEN MESSAGE(MSG_020)
//                          ELSE MESSAGE(MSG_021);
//  
}

        
 



 