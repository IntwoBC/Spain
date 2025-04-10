//#66340
codeunit 50006 "Update Mytaxi Sales Documents"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        case Rec."Parameter String" of
            'SendSalesDocumentStatus':
                SendSalesDocumentStatus();
        end;
    end;


    internal procedure SendSalesDocumentStatus()
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
    begin
        MyTaxiCRMInterfaceRecords.SetRange(statusCode, 'DONE');
        MyTaxiCRMInterfaceRecords.SetRange("Send Update", true);
        if MyTaxiCRMInterfaceRecords.FindSet() then
            repeat
                MyTaxiCRMInterfaceWS.UpdateInvoice(MyTaxiCRMInterfaceRecords);
            until MyTaxiCRMInterfaceRecords.Next() = 0;
    end;
}