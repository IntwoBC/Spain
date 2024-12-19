tableextension 50118 tableextension50118 extends "Issued Reminder Header"
{
    //   #MyTaxi.W1.CRE.ACREC.001 28/11/2017 CCFR.SDE : Print Level Custom Report Layout
    //   Modified functions : PrintRecords,SendReport


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 1)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := false;
    OnBeforePrintRecords(Rec,ShowRequestForm,SendAsEmail,HideDialog,IsHandled);
    if IsHandled then
      exit;

    if SendAsEmail then begin
      IssuedReminderHeader.Copy(Rec);
      if (not HideDialog) and (IssuedReminderHeader.Count > 1) then
        if Confirm(SuppresSendDialogQst) then
          HideDialog := true;
      if IssuedReminderHeader.FindSet then
        repeat
          IssuedReminderHeaderToSend.Copy(IssuedReminderHeader);
          IssuedReminderHeaderToSend.SetRecFilter;
          DocumentSendingProfile.TrySendToEMail(
            DummyReportSelections.Usage::Reminder,IssuedReminderHeaderToSend,IssuedReminderHeaderToSend.FieldNo("No."),
            ReportDistributionMgt.GetFullDocumentTypeText(Rec),IssuedReminderHeaderToSend.FieldNo("Customer No."),not HideDialog)
        until IssuedReminderHeader.Next = 0;
    end else
      DocumentSendingProfile.TrySendToPrinter(
        DummyReportSelections.Usage::Reminder,Rec,
        IssuedReminderHeaderToSend.FieldNo("Customer No."),ShowRequestForm);

    OnAfterPrintRecords(Rec,ShowRequestForm,SendAsEmail,HideDialog);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // MODIFIED
          //WITH IssuedReminderHeader DO BEGIN
            //COPY(Rec);
          //  ReportSelection.SETRANGE(Usage,ReportSelection.Usage::Reminder);
           // ReportSelection.SETFILTER("Report ID",'<>0');
           // ReportSelection.FIND('-');
            //REPEAT
             // IF NOT SendAsEmail THEN
                // MyTaxi.W1.CRE.ACREC.001 >>
               // BEGIN
                 // CustomLayoutPresent := FALSE;
                 // ReminderLevel.RESET;
                 // IF ReminderLevel.FINDSET THEN
                   // REPEAT
                    //  IssuedReminderHeader.SETRANGE("Reminder Terms Code",ReminderLevel."Reminder Terms Code");
                     // IssuedReminderHeader.SETRANGE("Reminder Level",ReminderLevel."No.");
                     // IF NOT IssuedReminderHeader.ISEMPTY THEN
                      //  BEGIN
                        //  IF CustomReportSelection.GET(DATABASE::"Reminder Level",ReminderLevel."Reminder Terms Code"+FORMAT(ReminderLevel."No."),CustomReportSelection.Usage::Reminder,ReminderLevel."Custom Report Selection ID") THEN
                       //     CustomLayoutPresent := CustomReportLayout.GET(CustomReportSelection."Custom Report Layout ID");
                        //  IF CustomLayoutPresent THEN
                         //   ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.ID);
                         // REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,IssuedReminderHeader)
                       // END;
                      //IF CustomLayoutPresent THEN
                      //  ReportLayoutSelection.SetTempLayoutSelected(0);
                 // UNTIL ReminderLevel.NEXT=0;
               // END
                //REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,IssuedReminderHeader)
                // MyTaxi.W1.CRE.ACREC.001 <<
              //ELSE
              //  SendReport(ReportSelection."Report ID",HideDialog,IssuedReminderHeader);
           // UNTIL ReportSelection.NEXT = 0;
         //END;
         // {=======} TARGET
          IsHandled := false;
          OnBeforePrintRecords(Rec,ShowRequestForm,SendAsEmail,HideDialog,IsHandled);
          if IsHandled then
            exit;

          if SendAsEmail then begin
            IssuedReminderHeader.Copy(Rec);
            if (not HideDialog) and (IssuedReminderHeader.Count > 1) then
              if Confirm(SuppresSendDialogQst) then
                HideDialog := true;
            if IssuedReminderHeader.FindSet then
              repeat
                IssuedReminderHeaderToSend.Copy(IssuedReminderHeader);
                IssuedReminderHeaderToSend.SetRecFilter;
                DocumentSendingProfile.TrySendToEMail(
                  DummyReportSelections.Usage::Reminder,IssuedReminderHeaderToSend,IssuedReminderHeaderToSend.FieldNo("No."),
                  ReportDistributionMgt.GetFullDocumentTypeText(Rec),IssuedReminderHeaderToSend.FieldNo("Customer No."),not HideDialog)
              until IssuedReminderHeader.Next = 0;
          end else
            DocumentSendingProfile.TrySendToPrinter(
              DummyReportSelections.Usage::Reminder,Rec,
              IssuedReminderHeaderToSend.FieldNo("Customer No."),ShowRequestForm);

          OnAfterPrintRecords(Rec,ShowRequestForm,SendAsEmail,HideDialog);
          //{<<<<<<<}
    */
    //end;

    var
        "--- MyTaxi.W1.CRE.ACREC.001 ---": Integer;
        ReminderLevel: Record "Reminder Level";
        CustomReportLayout: Record "Custom Report Layout";
        ReportLayoutSelection: Record "Report Layout Selection";
        CustomReportSelection: Record "Custom Report Selection";
        IssuedReminder: Page "Issued Reminder";
        CustomLayoutPresent: Boolean;
}

