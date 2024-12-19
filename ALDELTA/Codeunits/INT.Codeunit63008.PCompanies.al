codeunit 63008 "P:Companies"
{

    trigger OnRun()
    begin
    end;

    var
        txtCompanyTypeSelection: Label 'Global Services,Country Services';
        txtCompanyTypeInstruction: Label 'Please select the type of company you want to create:';
        txtCompanyTypeConfirm: Label 'You have selected the Company Type %1.\\This cannot be changed at a later stage.\\Are you sure you want to continue?';

    [EventSubscriber(ObjectType::Page, 357, 'OnInsertRecordEvent', '', false, false)]
    local procedure levtOnInsertRecord(var Rec: Record Company; BelowxRec: Boolean; var xRec: Record Company; var AllowInsert: Boolean)
    var
        lintOptionNumber: Integer;
    begin
        lintOptionNumber := StrMenu(txtCompanyTypeSelection, 2, txtCompanyTypeInstruction);

        if lintOptionNumber = 0 then
            AllowInsert := false
        else begin
            // Rec."Company Type" := lintOptionNumber - 1;

            // IF NOT CONFIRM(txtCompanyTypeConfirm,FALSE,Rec."Company Type") THEN
            //   AllowInsert := FALSE
            //ELSE
            AllowInsert := true;
        end;
    end;
}

