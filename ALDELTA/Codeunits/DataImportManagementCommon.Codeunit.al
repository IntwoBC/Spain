// codeunit 60004 "Data Import Management Common"
// {
//     // Common functionality which can be used by master or by local procedures
//     // 
//     // MP 30-04-14
//     // Development taken from Core II
//     // 
//     // MP 19-11-14
//     // NAV 2013 R2 Upgrade


//     trigger OnRun()
//     begin
//         //MESSAGE(':'+gfncASCIIToText(9)+':');
//         //MESSAGE(':'+FORMAT(gfncTextToASCII('TAB'))+':')
//     end;

//     var
//         DLG_001: Label '#1################## \ Progress @2@@@@@@@@@@@@@@@@@@';
//         MSG_001: Label 'Deleting entries';
//         MSG_002: Label ' Country database record not found. ';
//         MSG_003: Label ' /WS are not last characters. ';
//         ERR_001: Label 'Cannot build URL. Local DB %1 Company %2 Type %3 Name %4. %5';
//         ERR_002: Label 'Account type "%1" No. "%2" does not exist in company "%3"';
//         ERR_003: Label 'Account type "%1" No. "%2" does not allow direct posting  in company "%3"';
//         ERR_004: Label 'Corporate Account %1 does not exist in company %2';
//         ERR_005: Label 'Unsupported type %1 of account No. %2 in company %3';
//         ERR_006: Label 'WS call error: %1';
//         ERR_007: Label 'Rollback data failed for local company %1';
//         gdlgDialog: Dialog;
//         ERR_008: Label 'EY Core setup does not exist';
//         ERR_009: Label '%1 must contain value';
//         ERR_010: Label 'Cannot create file %1';
//         txtTenant: Label '?tenant=';


//     procedure gfncDeleteEntries(p_binEntryNo: BigInteger; p_intTableNo: Integer; p_blnDialog: Boolean)
//     var
//         lrrRecRef: RecordRef;
//         lfrImportLog: FieldRef;
//         ldlgDialog: Dialog;
//         lintTotal: Integer;
//         lintPosition: Integer;
//         lintLastPct: Integer;
//     begin
//         lrrRecRef.Open(p_intTableNo);
//         lfrImportLog := lrrRecRef.Field(99998);
//         lfrImportLog.SetRange(p_binEntryNo);
//         if p_blnDialog then begin
//             ldlgDialog.Open(DLG_001);
//             ldlgDialog.Update(1, MSG_001);
//             lintTotal := lrrRecRef.Count;
//             lintPosition := 0;
//         end;

//         lintLastPct := 0;
//         if lrrRecRef.FindSet(true) then
//             repeat
//                 if p_blnDialog then begin
//                     lintPosition += 1;
//                     if Round((lintPosition / lintTotal) * 100, 1, '<') > lintLastPct then begin
//                         lintLastPct := Round((lintPosition / lintTotal) * 100, 1, '<');
//                         ldlgDialog.Update(2, lintLastPct * 100);
//                     end;
//                 end;
//                 lrrRecRef.Delete();
//             until lrrRecRef.Next() = 0;

//         if p_blnDialog then begin
//             ldlgDialog.Close();
//         end;
//     end;


//     procedure gfncUserPostingRangeValid(p_datStartDate: Date; p_datEndDate: Date; p_codUser: Code[50]) r_blnResult: Boolean
//     var
//         lrecUserSetup: Record "User Setup";
//         lrecGeneralLedgerSetup: Record "General Ledger Setup";
//     begin
//         //
//         // Checks if user can post within date range
//         //
//         // MP 19-11-14 Extended variable p_codUser from 20
//         lrecGeneralLedgerSetup.Get();
//         if ((lrecGeneralLedgerSetup."Allow Posting From" <> 0D) and (lrecGeneralLedgerSetup."Allow Posting From" > p_datStartDate))
//            or
//            ((lrecGeneralLedgerSetup."Allow Posting To" <> 0D) and (lrecGeneralLedgerSetup."Allow Posting To" < p_datEndDate))
//            then
//             exit(false);
//         if lrecUserSetup.Get(p_codUser) then begin
//             if ((lrecUserSetup."Allow Posting From" <> 0D) and (lrecUserSetup."Allow Posting From" > p_datStartDate))
//                or
//                ((lrecUserSetup."Allow Posting To" <> 0D) and (lrecUserSetup."Allow Posting To" < p_datEndDate))
//                then
//                 exit(false);
//         end else begin
//             ; //EXIT(FALSE); // user is not defined
//         end;
//         exit(true);
//     end;


//     procedure gfncCreateLogEntry(var p_recImportLog: Record "Import Log"; p_bintEntryNo: BigInteger; p_txtMessage: Text[1024])
//     var
//         lrecImportErrorLog: Record "Import Error Log";
//     begin
//         lrecImportErrorLog.Init();
//         lrecImportErrorLog."Import Log Entry No." := p_recImportLog."Entry No.";
//         lrecImportErrorLog."Staging Table Entry No." := p_bintEntryNo;
//         lrecImportErrorLog.Description := CopyStr(p_txtMessage, 1, 250);
//         lrecImportErrorLog."Date & Time" := CurrentDateTime;
//         lrecImportErrorLog.Insert();
//     end;


//     procedure gfncDeleteErrorLogEntries(var p_recImportLog: Record "Import Log")
//     var
//         lrecImportErrorLog: Record "Import Error Log";
//     begin
//         //
//         // Deletes all Import log entries related to Import log
//         //
//         lrecImportErrorLog.SetCurrentKey("Import Log Entry No.");
//         lrecImportErrorLog.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         lrecImportErrorLog.DeleteAll();
//     end;


//     procedure gfncDelSubsClientErrLogEntries(var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client")
//     var
//         lrecImportErrorLog: Record "Import Error Log";
//     begin
//         //
//         // Deletes all Import log entries related to Subs Client Import log
//         //
//         lrecImportErrorLog.SetCurrentKey("Import Log Entry No.", "Client No.", "Country Database Code", "Company Name");
//         lrecImportErrorLog.SetRange("Import Log Entry No.", p_recImportLogSubsidiaryClient."Import Log Entry No.");
//         lrecImportErrorLog.SetRange("Client No.", p_recImportLogSubsidiaryClient."Parent Client No.");
//         lrecImportErrorLog.SetRange("Country Database Code", p_recImportLogSubsidiaryClient."Country Database Code");
//         lrecImportErrorLog.SetRange("Company Name", p_recImportLogSubsidiaryClient."Company Name");
//         lrecImportErrorLog.DeleteAll();
//     end;


//     procedure gfncGetNoEntriesFromImportLog(p_recImportLog: Record "Import Log"; p_codSubClient: Code[20]): Integer
//     var
//         lrrRecRef: RecordRef;
//         lffFieldRef1: FieldRef;
//         lffFieldRef2: FieldRef;
//     begin
//         lrrRecRef.Open(p_recImportLog."Table ID");
//         lffFieldRef1 := lrrRecRef.Field(99998);
//         lffFieldRef1.SetFilter(Format(p_recImportLog."Entry No."));
//         if p_codSubClient <> '' then begin
//             lffFieldRef2 := lrrRecRef.Field(99994);
//             lffFieldRef2.SetFilter(p_codSubClient);
//         end;
//         exit(lrrRecRef.Count);
//     end;


//     procedure gfncShowEntriesFromImportLog(p_recImportLog: Record "Import Log"; p_codSubClient: Code[20])
//     var
//         lrrRecRef: RecordRef;
//         lrec60009: Record "G/L Account (Staging)";
//         lrec60012: Record "Gen. Journal Line (Staging)";
//         lrec60018: Record "Corporate G/L Acc (Staging)";
//         lrec60019: Record "Customer (Staging)";
//         lrec60020: Record "Vendor (Staging)";
//     begin
//         lrrRecRef.Open(p_recImportLog."Table ID");
//         case p_recImportLog."Table ID" of
//             60009:
//                 begin // G/L Account (Staging)
//                     lrrRecRef.SetTable(lrec60009);
//                     lrec60009.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//                     if p_codSubClient <> '' then begin
//                         lrec60009.SetRange("Company No.", p_codSubClient);
//                     end;
//                     PAGE.Run(0, lrec60009);
//                 end;
//             60012:
//                 begin //"Gen. Journal Line (Staging)"
//                     lrrRecRef.SetTable(lrec60012);
//                     lrec60012.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//                     if p_codSubClient <> '' then begin
//                         lrec60012.SetRange("Company No.", p_codSubClient);
//                     end;
//                     PAGE.Run(0, lrec60012);
//                 end;
//             60018:
//                 begin //"Corporate G/L Acc (Staging)"
//                     lrrRecRef.SetTable(lrec60018);
//                     lrec60018.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//                     if p_codSubClient <> '' then begin
//                         lrec60018.SetRange("Company No.", p_codSubClient);
//                     end;
//                     PAGE.Run(0, lrec60018);
//                 end;
//             60019:
//                 begin // "Customer (Staging)"
//                     lrrRecRef.SetTable(lrec60019);
//                     lrec60019.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//                     if p_codSubClient <> '' then begin
//                         lrec60019.SetRange("Company No.", p_codSubClient);
//                     end;
//                     PAGE.Run(0, lrec60019);
//                 end;
//             60020:
//                 begin // "Vendor (Staging)"
//                     lrrRecRef.SetTable(lrec60020);
//                     lrec60020.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//                     if p_codSubClient <> '' then begin
//                         lrec60020.SetRange("Company No.", p_codSubClient);
//                     end;
//                     PAGE.Run(0, lrec60020);
//                 end;
//         end;
//     end;


//     procedure gfncBuildURL(p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_txtWSType: Text[30]; p_txtWSName: Text[1024]; var p_txtURL: Text[1024]; var p_txtError: Text[1024]): Boolean
//     var
//         lrecCountryDatabase: Record "Country Database";
//     begin
//         //
//         // builds WS specific URL from information provided
//         //
//         // p_txtDatabaseWS expected in format:
//         // http://<server>[:<portNo>]/<database>/WS
//         //
//         //
//         // p_txtWSName ... name of the codeunit or page
//         //
//         // If error then p_txtURL returns error message
//         if not lrecCountryDatabase.Get(p_recImportLogSubsidiaryClient."Country Database Code") then begin
//             p_txtError := StrSubstNo(ERR_001, p_recImportLogSubsidiaryClient."Country Database Code",
//                                               p_recImportLogSubsidiaryClient."Company Name",
//                                               p_txtWSType, p_txtWSName, MSG_002);
//             exit(false);
//         end;
//         if (StrPos(lrecCountryDatabase."Server Address (Web Service)", 'WS') <>
//            (StrLen(lrecCountryDatabase."Server Address (Web Service)") - 1))
//           then begin
//             p_txtError := StrSubstNo(ERR_001, p_recImportLogSubsidiaryClient."Country Database Code",
//                                               p_recImportLogSubsidiaryClient."Company Name",
//                                               p_txtWSType, p_txtWSName, MSG_003);

//             exit(false); // Check if WS are last characters
//         end;
//         p_txtURL := lrecCountryDatabase."Server Address (Web Service)";
//         p_txtURL := p_txtURL + '/' + gfncCodeString(p_recImportLogSubsidiaryClient."Company Name");
//         p_txtURL := p_txtURL + '/' + p_txtWSType;
//         p_txtURL := p_txtURL + '/' + gfncCodeString(p_txtWSName);

//         // MP 19-11-14 >>
//         if lrecCountryDatabase."Tenant Id" <> '' then
//             p_txtURL += txtTenant + lrecCountryDatabase."Tenant Id";
//         // MP 19-11-14 <<

//         exit(true);
//     end;


//     procedure gfncCodeString(p_txtText: Text[250]) r_txtText: Text[250]
//     var
//         lchrChar: Char;
//         lintLength: Integer;
//         ltxtCoded: Text[10];
//     begin
//         //
//         // Code special characters like <space> ( ) into %20, ...
//         //
//         lintLength := StrLen(p_txtText);
//         while lintLength > 0 do begin
//             lchrChar := p_txtText[lintLength];
//             case lchrChar of
//                 32:
//                     ltxtCoded := '%20';  // space
//                 37:
//                     ltxtCoded := '%25';  // %
//                 40:
//                     ltxtCoded := '%28';  // (
//                 41:
//                     ltxtCoded := '%29';  // )
//                 47:
//                     ltxtCoded := '%2F';  // /
//                 63:
//                     ltxtCoded := '%3F';  // ?
//                 else
//                     ltxtCoded := Format(lchrChar);
//             end;
//             r_txtText := ltxtCoded + r_txtText;
//             lintLength -= 1;
//         end;
//     end;


//     procedure gfncCheckAccount(var p_recImportLog: Record "Import Log"; p_optAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; p_codAccountNo: Code[20]; p_blnCorporate: Boolean) r_blnResult: Boolean
//     var
//         lrecGLAccount: Record "G/L Account";
//         lrecCustomer: Record Customer;
//         lrecVendor: Record Vendor;
//         lrecBankAccount: Record "Bank Account";
//         lrecCorporateGLAccount: Record "Corporate G/L Account";
//         lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
//     begin
//         r_blnResult := true;
//         case p_optAccountType of
//             p_optAccountType::"G/L Account":
//                 begin
//                     if p_blnCorporate then begin
//                         if not lrecCorporateGLAccount.Get(p_codAccountNo) then begin
//                             // Corporate G/L account does not exist
//                             //lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                             // StrSubstNo(ERR_004, p_codAccountNo, CompanyName));
//                             exit(false);
//                         end else begin
//                             // Corporate exists, now check local G/L account
//                             p_codAccountNo := lrecCorporateGLAccount."Local G/L Account No.";
//                         end;
//                     end;
//                     if not lrecGLAccount.Get(p_codAccountNo) then begin
//                         // G/L account does not exist
//                         r_blnResult := false;
//                     end else begin
//                         if not lrecGLAccount."Direct Posting" then begin
//                             // Cannot post directly
//                             //  lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                             //                     StrSubstNo(ERR_003, Format(p_optAccountType), p_codAccountNo, CompanyName));
//                             exit(false);
//                         end;
//                     end;

//                 end;
//             p_optAccountType::Customer:
//                 r_blnResult := lrecCustomer.Get(p_codAccountNo);
//             p_optAccountType::Vendor:
//                 r_blnResult := lrecVendor.Get(p_codAccountNo);
//             p_optAccountType::"Bank Account":
//                 r_blnResult := lrecBankAccount.Get(p_codAccountNo);
//             else begin
//                 // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//                 // StrSubstNo(ERR_005, Format(p_optAccountType), p_codAccountNo, CompanyName));
//                 exit(false);
//             end;
//         end;

//         //if not r_blnResult then
//         // lmodDataImportManagementCommon.gfncCreateLogEntry(p_recImportLog, 0,
//         // StrSubstNo(ERR_002, Format(p_optAccountType), p_codAccountNo, CompanyName));
//     end;


//     procedure gfncResolveIncomeBalance(p_optAccountClass: Option " ","Balance Sheet",Equity,"P&L"): Integer
//     var
//         loptIncomeBalance: Option "Income Statement","Balance Sheet";
//     begin
//         case p_optAccountClass of
//             p_optAccountClass::" ":
//                 exit(-1);
//             p_optAccountClass::"Balance Sheet":
//                 exit(loptIncomeBalance::"Balance Sheet");
//             p_optAccountClass::Equity:
//                 exit(loptIncomeBalance::"Balance Sheet");
//             p_optAccountClass::"P&L":
//                 exit(loptIncomeBalance::"Income Statement");
//             else
//                 exit(-1);
//         end;
//     end;


//     procedure gfncRollBackRemoteData(var p_recImportLog: Record "Import Log"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
//     begin
//         lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.", p_recImportLog."Entry No.");
//         if lrecImportLogSubsidiaryClient.FindSet(false) then
//             repeat
//                 if not gfncRollBackRemoteDataOneComp(p_recImportLog, lrecImportLogSubsidiaryClient, p_blnDialog) then begin
//                     r_blnResult := false;
//                     gfncCreateLogEntry(p_recImportLog, 0, StrSubstNo(ERR_007, lrecImportLogSubsidiaryClient."Company Name"));
//                 end;
//             until lrecImportLogSubsidiaryClient.Next() = 0;
//     end;


//     procedure gfncRollBackRemoteDataOneComp(var p_recImportLog: Record "Import Log"; p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_blnDialog: Boolean) r_blnResult: Boolean
//     var
//         lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
//     begin
//         // lmodDataImportSafeWScall.gfncSetAction(2);
//         //lmodDataImportSafeWScall.gfncSetDialog(true);
//         // lmodDataImportSafeWScall.gfncSetImportLog(p_recImportLog);
//         //lmodDataImportSafeWScall.gfncSetSubsImportLog(p_recImportLogSubsidiaryClient);
//         Commit();
//         r_blnResult := lmodDataImportSafeWScall.Run();
//         if not r_blnResult then begin
//             gfncCreateLogEntry(p_recImportLog, 0, StrSubstNo(ERR_006, GetLastErrorText));
//         end;
//     end;


//     procedure gfncGetImportMgtWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Codeunit, 60007));
//     end;


//     procedure gfncGetImportLogWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60031));
//     end;


//     procedure gfncGetImportErrorLogWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60032));
//     end;


//     procedure gfncGetGenJnlStagPageWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60033));
//     end;


//     procedure gfncGetGLAccStgWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60034));
//     end;


//     procedure gfncGetCorpGLAccStgWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60035));
//     end;


//     procedure gfncGetCustomerStgWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60036));
//     end;


//     procedure gfncGetVendorStgWSName(): Text[240]
//     var
//         loptObjectType: Option ,,,,,"Codeunit",,,"Page";
//     begin
//         //
//         // proper solution would be to read from setup
//         //
//         exit(gfncGetWSName(loptObjectType::Page, 60037));
//     end;


//     procedure gfncGetWSName(p_optObjectType: Option ,,,,,"Codeunit",,,"Page"; p_intObjectID: Integer) r_txtValue: Text[240]
//     var
//     //lrecWebService: Record "Web Service";
//     begin
//         //
//         // Returns name of specified webservice
//         //
//         // lrecWebService.SetRange("Object Type", p_optObjectType);
//         // lrecWebService.SetRange("Object ID", p_intObjectID);
//         // lrecWebService.FindFirst;
//         // exit(lrecWebService."Service Name");
//     end;


//     procedure gfncGetNextToken(var p_txtString: Text[1024]; p_charDelimiter: Char; p_charTextQualifier: Char; var p_blnLast: Boolean) r_txtValue: Text[1024]
//     var
//         i: Integer;
//         lchrChar: Char;
//         lchrPrevChar: Char;
//         lblnDone: Boolean;
//         lblnQFlag: Boolean;
//     begin
//         lchrPrevChar := 0;
//         lblnDone := false;
//         lblnQFlag := false;
//         p_blnLast := false;
//         i := 1;

//         while not lblnDone do begin
//             lchrChar := p_txtString[i];
//             case lchrChar of
//                 0:
//                     begin
//                         lblnDone := true;
//                         p_blnLast := true;
//                     end;
//                 p_charDelimiter:
//                     if lblnQFlag then
//                         r_txtValue := r_txtValue + Format(lchrChar)
//                     else
//                         lblnDone := true;
//                 p_charTextQualifier:
//                     begin
//                         if (not lblnQFlag) and (lchrPrevChar = p_charTextQualifier) then
//                             r_txtValue := r_txtValue + Format(lchrChar);
//                         lblnQFlag := not lblnQFlag;
//                     end;
//                 else
//                     r_txtValue := r_txtValue + Format(lchrChar);
//             end;
//             lchrPrevChar := lchrChar;
//             i += 1;
//         end;

//         p_txtString := CopyStr(p_txtString, i);
//     end;


//     procedure gfncCodeStatus(p_intStatus: Integer) r_intStatus: Integer
//     var
//         lrecImportLog: Record "Import Log";
//     begin
//         // Code status into logical value
//         case p_intStatus of
//             lrecImportLog.Status::Error:
//                 r_intStatus := 0;
//             lrecImportLog.Status::"In Progress":
//                 r_intStatus := 1;
//             lrecImportLog.Status::Imported:
//                 r_intStatus := 2;
//             lrecImportLog.Status::Processed:
//                 r_intStatus := 3;
//         end;
//     end;


//     procedure gfncDeCodeStatus(p_intStatus: Integer) r_intStatus: Integer
//     var
//         lrecImportLog: Record "Import Log";
//     begin
//         // Code status into logical value
//         case p_intStatus of
//             0:
//                 r_intStatus := lrecImportLog.Status::Error;
//             1:
//                 r_intStatus := lrecImportLog.Status::"In Progress";
//             2:
//                 r_intStatus := lrecImportLog.Status::Imported;
//             3:
//                 r_intStatus := lrecImportLog.Status::Processed;
//         end;
//     end;


//     procedure gfncGetLowestStatus(var p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client") r_intStatus: Integer
//     var
//         lintSubsidiaryStatus: Integer;
//     begin
//         //
//         // Gets the lowest Status from Subs Client Import log
//         // Function assumes that filter is set before call
//         //
//         //MESSAGE(p_recImportLogSubsidiaryClient.GETFILTERS);
//         if not p_recImportLogSubsidiaryClient.FindSet(false) then exit(-1); //undetermined
//         r_intStatus := gfncCodeStatus(p_recImportLogSubsidiaryClient.Status);

//         repeat
//             lintSubsidiaryStatus := p_recImportLogSubsidiaryClient.Status;
//             if p_recImportLogSubsidiaryClient.Stage in
//               [p_recImportLogSubsidiaryClient.Stage::" ", p_recImportLogSubsidiaryClient.Stage::"File Import",
//               p_recImportLogSubsidiaryClient.Stage::"Post Import Validation", p_recImportLogSubsidiaryClient.Stage::"Data Transfer",
//               p_recImportLogSubsidiaryClient.Stage::"Data Validation"] then begin
//                 // These stages return anything but Processed
//                 if lintSubsidiaryStatus = p_recImportLogSubsidiaryClient.Status::Processed then
//                     lintSubsidiaryStatus := p_recImportLogSubsidiaryClient.Status::"In Progress";
//             end;
//             lintSubsidiaryStatus := gfncCodeStatus(lintSubsidiaryStatus);
//             if lintSubsidiaryStatus < r_intStatus then
//                 r_intStatus := lintSubsidiaryStatus;
//         until p_recImportLogSubsidiaryClient.Next() = 0;
//         exit(gfncDeCodeStatus(r_intStatus));
//     end;


//     procedure gfncASCIIToText(p_intASCII: Integer) r_txtText: Text[3]
//     begin
//         case p_intASCII of
//             0:
//                 r_txtText := 'NUL';
//             1:
//                 r_txtText := 'SOH';
//             2:
//                 r_txtText := 'STX';
//             3:
//                 r_txtText := 'ETX';
//             4:
//                 r_txtText := 'EOT';
//             5:
//                 r_txtText := 'ENQ';
//             6:
//                 r_txtText := 'ACK';
//             7:
//                 r_txtText := 'BEL';
//             8:
//                 r_txtText := 'BS';
//             9:
//                 r_txtText := 'TAB';
//             10:
//                 r_txtText := 'LF';
//             11:
//                 r_txtText := 'VT';
//             12:
//                 r_txtText := 'FF';
//             13:
//                 r_txtText := 'CR';
//             14:
//                 r_txtText := 'SO';
//             15:
//                 r_txtText := 'SI';
//             16:
//                 r_txtText := 'DLE';
//             17:
//                 r_txtText := 'DC1';
//             18:
//                 r_txtText := 'DC2';
//             19:
//                 r_txtText := 'DC3';
//             20:
//                 r_txtText := 'DC4';
//             21:
//                 r_txtText := 'NAK';
//             22:
//                 r_txtText := 'SYN';
//             23:
//                 r_txtText := 'ETB';
//             24:
//                 r_txtText := 'CAN';
//             25:
//                 r_txtText := 'EM';
//             26:
//                 r_txtText := 'SUB';
//             27:
//                 r_txtText := 'ESC';
//             28:
//                 r_txtText := 'FS';
//             29:
//                 r_txtText := 'GS';
//             30:
//                 r_txtText := 'RS';
//             31:
//                 r_txtText := 'US';
//             32:
//                 r_txtText := 'SPC';
//             127:
//                 r_txtText := 'DEL';
//             else begin
//                 r_txtText[1] := p_intASCII;
//             end;
//         end;
//     end;


//     procedure gfncTextToASCII(var p_txtText: Text[3]) r_intASCII: Integer
//     var
//         lintSpecialChar: Boolean;
//     begin
//         lintSpecialChar := true;
//         case UpperCase(p_txtText) of
//             'NUL':
//                 r_intASCII := 0;
//             'SOH':
//                 r_intASCII := 1;
//             'STX':
//                 r_intASCII := 2;
//             'ETX':
//                 r_intASCII := 3;
//             'EOT':
//                 r_intASCII := 4;
//             'ENQ':
//                 r_intASCII := 5;
//             'ACK':
//                 r_intASCII := 6;
//             'BEL':
//                 r_intASCII := 7;
//             'BS':
//                 r_intASCII := 8;
//             'TAB':
//                 r_intASCII := 9;
//             'LF':
//                 r_intASCII := 10;
//             'VT':
//                 r_intASCII := 11;
//             'FF':
//                 r_intASCII := 12;
//             'CR':
//                 r_intASCII := 13;
//             'SO':
//                 r_intASCII := 14;
//             'SI':
//                 r_intASCII := 15;
//             'DLE':
//                 r_intASCII := 16;
//             'DC1':
//                 r_intASCII := 17;
//             'DC2':
//                 r_intASCII := 18;
//             'DC3':
//                 r_intASCII := 19;
//             'DC4':
//                 r_intASCII := 20;
//             'NAK':
//                 r_intASCII := 21;
//             'SYN':
//                 r_intASCII := 22;
//             'ETB':
//                 r_intASCII := 23;
//             'CAN':
//                 r_intASCII := 24;
//             'EM':
//                 r_intASCII := 25;
//             'SUB':
//                 r_intASCII := 26;
//             'ESC':
//                 r_intASCII := 27;
//             'FS':
//                 r_intASCII := 28;
//             'GS':
//                 r_intASCII := 29;
//             'RS':
//                 r_intASCII := 30;
//             'US':
//                 r_intASCII := 31;
//             'SPC':
//                 r_intASCII := 32;
//             'DEL':
//                 r_intASCII := 127;
//             else begin
//                 lintSpecialChar := false;
//                 r_intASCII := p_txtText[1];
//             end;
//         end;
//         if lintSpecialChar then
//             p_txtText := UpperCase(p_txtText)
//         else
//             p_txtText := Format(p_txtText[1]);
//     end;


//     procedure gfncCreateServerFile(var p_filFile: File; p_recImportLog: Record "Import Log"; p_recImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client"; p_txtExtension: Text[30]) r_blnResult: Boolean
//     var
//         lrecEYCoreSetup: Record "EY Core Setup";
//         ltxtFileName: Text[1024];
//     begin
//         //
//         // Will create file with filename based on file type, transaction type etc.
//         // Calling procedure is resposible for closing the file
//         //
//         r_blnResult := true;

//         if not lrecEYCoreSetup.Get() then begin
//             gfncCreateLogEntry(p_recImportLog, 0, ERR_008);
//             exit(false);
//         end;

//         if lrecEYCoreSetup."OneSource File Path" = '' then begin
//             gfncCreateLogEntry(p_recImportLog, 0, StrSubstNo(ERR_009, lrecEYCoreSetup.FieldCaption("OneSource File Path")));
//             exit(false);
//         end;
//         // Get path
//         ltxtFileName := lrecEYCoreSetup."OneSource File Path";

//         if ltxtFileName[StrLen(ltxtFileName)] <> 92 then  // 92 ... \
//             ltxtFileName := ltxtFileName + '\';

//         ltxtFileName := ltxtFileName +
//           p_recImportLogSubsidiaryClient."Parent Client No." + '_' +
//           Format(p_recImportLogSubsidiaryClient."Interface Type") + '_' +
//           p_recImportLogSubsidiaryClient."Company No." + '_' +
//           Format(p_recImportLogSubsidiaryClient."Import Log Entry No.");

//         if p_txtExtension <> '' then
//             ltxtFileName := ltxtFileName + '.' + p_txtExtension;

//         // p_filFile.WriteMode(true);
//         // p_filFile.TextMode(true);
//         // if not p_filFile.Create(ltxtFileName) then begin
//         //     gfncCreateLogEntry(p_recImportLog, 0, StrSubstNo(ERR_010, ltxtFileName));
//         exit(false);
//     end;

// }

