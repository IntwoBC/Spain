codeunit 50005 "Custom Events"
{
    var
        SpecifiqueEmailSubjectCapText: Label 'FREE NOW for Business - Payment Reminder - Cust. No. %1 - Reminder No. %2';
        DocumentMaiiling: Codeunit "Document-Mailing";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", OnBeforeGetEmailSubject, '', false, false)]
    local procedure OnBeforeGetEmailSubject(var EmailSubject: Text[250]; EmailDocumentName: Text[250]; PostedDocNo: Code[20]; ReportUsage: Integer)
    var
        Reminder: Record "Issued Reminder Header";
    begin
        Clear(Reminder);
        Reminder.SetRange("No.", PostedDocNo);
        if Reminder.FindFirst() then begin
            EmailSubject := COPYSTR(STRSUBSTNO(SpecifiqueEmailSubjectCapText, Reminder."Customer No.", PostedDocNo), 1,
                 MAXSTRLEN(EmailSubject));
        end;
    end;
}