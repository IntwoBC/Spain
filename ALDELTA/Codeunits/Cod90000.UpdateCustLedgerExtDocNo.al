codeunit 90000 "MyTaxi CRM Extensions"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterSalesHeaderInsert(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
    begin
        if Rec."External Document No." = '' then begin
            MyTaxiCRMInterfaceRecords.SetCurrentKey(externalReference);
            MyTaxiCRMInterfaceRecords.SetRange(externalReference, Rec."No.");
            if not MyTaxiCRMInterfaceRecords.IsEmpty() then begin
                Rec."External Document No." := Rec."No.";
                Rec.Modify();
            end;
        end;
    end;
}