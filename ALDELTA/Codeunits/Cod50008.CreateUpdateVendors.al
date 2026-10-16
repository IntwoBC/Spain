// codeunit 50008 "Create_Update Vendors"
// {
//     trigger OnRun()
//     var
//         MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
//         VendorUtility: Codeunit "Vendor Utility";
//     begin
//         MyTaxiCRMInterfaceRecords.SetRange(customerGroup, '1');
//         MyTaxiCRMInterfaceRecords.SetRange("I2I Vendor Created", false);
//         MyTaxiCRMInterfaceRecords.SetRange("Process Status", MyTaxiCRMInterfaceRecords."Process Status"::" ");
//         MyTaxiCRMInterfaceRecords.SetRange("Process Status Description", '');
//         if MyTaxiCRMInterfaceRecords.FindFirst then begin
//             repeat
//                 ClearLastError;
//                 Clear(VendorUtility);
//                 if not VendorUtility.Run(MyTaxiCRMInterfaceRecords) then begin
//                     MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."process status"::Error;
//                     MyTaxiCRMInterfaceRecords."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
//                     MyTaxiCRMInterfaceRecords.Modify;
//                 end
//                 else begin
//                     MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."process status"::" ";
//                     MyTaxiCRMInterfaceRecords."Process Status Description" := '';
//                     MyTaxiCRMInterfaceRecords.Modify;
//                 end;
//                 Commit;
//             until MyTaxiCRMInterfaceRecords.Next = 0;
//         end
//     end;
// }