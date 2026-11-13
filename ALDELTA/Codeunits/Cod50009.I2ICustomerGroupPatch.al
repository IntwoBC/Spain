// codeunit 50009 "I2I Customer Group Patch"
// {
//     trigger OnRun()
//     begin
//         UpdateCRMTaxiCustomerGroups();
//     end;


//     local procedure UpdateCRMTaxiCustomerGroups()
//     var
//         CRMCustomers: Record "MyTaxi CRM Interface Records";
//         UpdateValue: Text[40];
//     begin
//         UpdateValue := '1';

//         CRMCustomers.SetRange("Process Status", CRMCustomers."Process Status"::" ");
//         CRMCustomers.SetRange(customerGroup, '');
//         if CRMCustomers.FindSet() then begin
//             repeat
//                 if IsTaxiPostingGroupCustomer(CRMCustomers.id) then begin
//                     CRMCustomers.customerGroup := UpdateValue;
//                     CRMCustomers.Modify();
//                 end;
//             until CRMCustomers.Next() = 0;
//         end;
//     end;

//     local procedure IsTaxiPostingGroupCustomer(CustomerID: Integer): Boolean
//     var
//         Customer: Record Customer;
//     begin
//         Clear(Customer);

//         Customer.SetRange("No.", Format(CustomerID));
//         Customer.SetRange("Customer Posting Group", 'TAXI');
//         if not Customer.FindFirst() then
//             exit(false);

//         exit(true);
//     end;
// }
