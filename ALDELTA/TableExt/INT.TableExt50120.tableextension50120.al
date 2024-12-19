tableextension 50120 tableextension50120 extends "Excel Buffer"
{
    // MP 18-11-15
    // Added function gfcnAddWorksheet (CB1 Enhancements)


    //Unsupported feature: Code Modification on "UpdateBookStream(PROCEDURE 3)".

    //procedure UpdateBookStream();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FileNameServer := FileManagement.InstreamExportToServerFile(ExcelStream,'xlsx');

    UpdateBookExcel(FileNameServer,SheetName,PreserveDataOnUpdate);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //{=======} MODIFIED
    // IF NOT ISNULL(XlApp) THEN BEGIN
     // XlApp.Visible := TRUE;
      //XlApp.UserControl := TRUE;
     // CLEAR(XlApp);
    // END;
    //{=======} TARGET
    #1..3
    //{<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "QuitExcel(PROCEDURE 29)".

    //procedure QuitExcel();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CloseBook;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CloseBook;

    //{=======} MODIFIED

    // Clear the worksheet automation
    // IF NOT ISNULL(XlWrkSht) THEN
     // CLEAR(XlWrkSht);

    // Clear the workbook automation
    //IF NOT ISNULL(XlWrkBk) THEN
     // CLEAR(XlWrkBk);

    // Clear and quit the Excel application automation
    // IF NOT ISNULL(XlApp) THEN BEGIN
     // XlHelper.CallQuit(XlApp);
    //  CLEAR(XlApp);
    // END;
    //{=======} TARGET
    //{<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "OpenExcel(PROCEDURE 31)".

    //procedure OpenExcel();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if OpenUsingDocumentService('') then
      exit;

    FileManagement.DownloadHandler(FileNameServer,'','',Text034,GetFriendlyFilename);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if OpenUsingDocumentService('') then
      exit;
    //MODIFIED
    //IF NOT PreOpenExcel THEN
     // EXIT;

    // rename the Temporary filename into a more UI friendly name in a new subdirectory
    //FileNameClient := FileManagement.DownloadTempFile(FileNameServer);
    // FileNameClient := FileManagement.MoveAndRenameClientFile(FileNameClient,GetFriendlyFilename,FORMAT(CREATEGUID));

    //XlWrkBk := XlHelper.CallOpen(XlApp,FileNameClient);

    // PostOpenExcel;
    // {=======} TARGET
    FileManagement.DownloadHandler(FileNameServer,'','',Text034,GetFriendlyFilename);
    // {<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "OpenExcelWithName(PROCEDURE 15)".

    //procedure OpenExcelWithName();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if FileName = '' then
      Error(Text001);

    if OpenUsingDocumentService(FileName) then
      exit;

    FileManagement.DownloadHandler(FileNameServer,'','',Text034,FileName);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    //MODIFIED
    //IF NOT PreOpenExcel THEN
      //EXIT;

    // FileManagement.DownloadToFile(FileNameServer,FileName);
    //XlWrkBk := XlHelper.CallOpen(XlApp,FileName);

    //PostOpenExcel;
    //{=======} TARGET
    FileManagement.DownloadHandler(FileNameServer,'','',Text034,FileName);
    {<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterAddColumnToBuffer(PROCEDURE 8)".

    //procedure OnAfterAddColumnToBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    // {=======} MODIFIED
    //XlWrkBk := XlApp.ActiveWorkbook;

    // IF ISNULL(XlWrkBk) THEN BEGIN
    //  ERROR(Text036);
     // END;

    // autofit all columns on all worksheets
    //XlHelper.AutoFitColumnsInAllWorksheets(XlWrkBk);

    // activate the previous saved sheet name in the workbook
    //XlHelper.ActivateSheet(XlWrkBk,ActiveSheetName);
    // {=======} TARGET
    //{<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "OnBeforeParseCellValue(PROCEDURE 7)".

    //procedure OnBeforeParseCellValue();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // MODIFIED
    // IF NOT EXISTS(FileNameServer) THEN
      //ERROR(Text003,FileNameServer);

    // Download file, if none RTC it should return a filename, and use client automation instead.
    //IF NOT FileManagement.CanRunDotNetOnClient THEN BEGIN
      //IF NOT FileManagement.DownloadHandler(FileNameServer,Text040,'',Text034,GetFriendlyFilename) THEN
       // ERROR(Text001);
     // EXIT(FALSE);
    // END;

    //XlApp := XlApp.ApplicationClass;
    //IF ISNULL(XlApp) THEN
     // ERROR(Text000);

    //EXIT(TRUE);
    // {=======} TARGET
    //{<<<<<<<}
    */
    //end;


    //Unsupported feature: Code Modification on "OnWriteCellValueOnBeforeSetCellValue(PROCEDURE 39)".

    //procedure OnWriteCellValueOnBeforeSetCellValue();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //{=======} MODIFIED
    // IF NOT ISNULL(XlWrkBk) THEN
     // XlHelper.BorderAroundRange(XlWrkBk,ActiveSheetName,RangeName,1);
    // {=======} TARGET
    //{<<<<<<<}
    */
    //end;

    // procedure gfcnAddWorksheet(ptxtSheetName: Text[250])
    // begin
    //     // MP 18-11-15

    //     XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(ptxtSheetName);
    // end;
}

