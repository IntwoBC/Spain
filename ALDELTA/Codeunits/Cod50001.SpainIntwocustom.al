codeunit 50001 SpainIntwocustom
{
    trigger OnRun()
    var
        MytaxiCRminterfaceW: Codeunit "MyTaxi CRM Interface WS";
    begin
        MytaxiCRminterfaceW.GetInvoices(0, false);

    end;

}
