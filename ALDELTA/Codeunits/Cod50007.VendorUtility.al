// codeunit 50007 "Vendor Utility"
// {
//     TableNo = "MyTaxi CRM Interface Records";

//     trigger OnRun()
//     var
//         myInt: Integer;
//     begin
//         CreateVendors(Rec);
//     end;

//     [TryFunction]
//     procedure CreateVendors(var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
//     var
//         Cust: Record Customer;
//         Vendor: Record Vendor;
//         TemplateHeader: Record "Config. Template Header";
//         TemplateMgt: Codeunit "Config. Template Management";
//         VendorBankAccount: Record "Vendor Bank Account";
//     begin
//         if pMyTaxiCRMInterfaceRecords."Interface Type" <> pMyTaxiCRMInterfaceRecords."interface type"::Customer then
//             Error('Vendor can be created only for interface type "Customer".');

//         if pMyTaxiCRMInterfaceRecords.id = 0 then
//             Error('Vendor ID is missing in staging record.');

//         if not Vendor.Get(pMyTaxiCRMInterfaceRecords.id) then begin
//             Vendor.Init;
//             Vendor.Validate("No.", Format(pMyTaxiCRMInterfaceRecords.id));
//             Vendor.Insert(true);
//         end;

//         Vendor.Validate(Name, CopyStr(pMyTaxiCRMInterfaceRecords.name, 1, MaxStrLen(Vendor.Name)));
//         Vendor.Validate("Name 2", CopyStr(pMyTaxiCRMInterfaceRecords.name, 51, MaxStrLen(Vendor."Name 2")));
//         Vendor.Validate(Address, CopyStr(pMyTaxiCRMInterfaceRecords.address1, 1, MaxStrLen(Vendor.Address)));
//         Vendor.Validate("Address 2", CopyStr(pMyTaxiCRMInterfaceRecords.address1, 51, MaxStrLen(Vendor."Address 2")));
//         Vendor.Validate("Phone No.", CopyStr(pMyTaxiCRMInterfaceRecords.tele1, 1, MaxStrLen(Vendor."Phone No.")));
//         Vendor."VAT Registration No." := CopyStr(pMyTaxiCRMInterfaceRecords.vatNo, 1, MaxStrLen(Vendor."VAT Registration No."));
//         Vendor.Validate("E-Mail", CopyStr(pMyTaxiCRMInterfaceRecords.email, 1, MaxStrLen(Vendor."E-Mail")));
//         Vendor.Validate("Post Code", CopyStr(pMyTaxiCRMInterfaceRecords.zip, 1, MaxStrLen(Vendor."Post Code")));
//         Vendor.Validate(City, CopyStr(pMyTaxiCRMInterfaceRecords.city, 1, MaxStrLen(Vendor.City)));
//         Vendor.Validate("Country/Region Code", CopyStr(pMyTaxiCRMInterfaceRecords.country, 1, MaxStrLen(Vendor."Country/Region Code")));
//         Vendor.Validate("Vendor Posting Group", 'SELFBILL');
//         Vendor.Validate("Gen. Bus. Posting Group", 'VENDOR_SELFBILL');
//         Vendor.Validate("Search Name", Vendor.Name);
//         if pMyTaxiCRMInterfaceRecords."NAV Bank Account Code" <> '' then begin
//             if not VendorBankAccount.Get(Vendor."No.", pMyTaxiCRMInterfaceRecords."NAV Bank Account Code") then begin
//                 VendorBankAccount.Validate("Vendor No.", Vendor."No.");
//                 VendorBankAccount.Validate(Code, pMyTaxiCRMInterfaceRecords."NAV Bank Account Code");
//                 VendorBankAccount.Insert(true);
//             end;
//             if CopyStr(pMyTaxiCRMInterfaceRecords.accountHolder, 1, MaxStrLen(VendorBankAccount.Contact)) <> VendorBankAccount.Contact then
//                 VendorBankAccount.Validate(Contact, CopyStr(pMyTaxiCRMInterfaceRecords.accountHolder, 1, MaxStrLen(VendorBankAccount.Contact)));
//             if pMyTaxiCRMInterfaceRecords.iban <> VendorBankAccount.Iban then
//                 VendorBankAccount.Validate(Iban, pMyTaxiCRMInterfaceRecords.iban);
//             if pMyTaxiCRMInterfaceRecords.bic <> VendorBankAccount."SWIFT Code" then
//                 VendorBankAccount.Validate("SWIFT Code", pMyTaxiCRMInterfaceRecords.bic);
//             if pMyTaxiCRMInterfaceRecords.bankAccountNumber <> VendorBankAccount."Bank Account No." then
//                 VendorBankAccount.Validate("Bank Account No.", CopyStr(pMyTaxiCRMInterfaceRecords.bankAccountNumber, 1, MaxStrLen(VendorBankAccount."Bank Account No.")));
//             if pMyTaxiCRMInterfaceRecords.sortCode <> VendorBankAccount."Bank Branch No." then
//                 VendorBankAccount.Validate("Bank Branch No.", pMyTaxiCRMInterfaceRecords.sortCode);
//             VendorBankAccount.Modify(true);
//             Vendor.Validate("Preferred Bank Account Code", VendorBankAccount.Code);
//         end;
//         Vendor."Last Date Modified" := Today;
//         Vendor.Modify(true);
//         UpdateVendorContact(Vendor, pMyTaxiCRMInterfaceRecords);
//         AutoLinkVendorCustomer(Vendor);
//         Cust.Get(pMyTaxiCRMInterfaceRecords.id);
//         Cust.Validate(Name, CopyStr(pMyTaxiCRMInterfaceRecords.name, 1, MaxStrLen(Cust.Name)));
//         Cust.Modify(true);
//         pMyTaxiCRMInterfaceRecords."Transfer Date" := Today;
//         pMyTaxiCRMInterfaceRecords."Transfer Time" := Time;
//         pMyTaxiCRMInterfaceRecords."I2I Vendor Created" := true;
//         pMyTaxiCRMInterfaceRecords.Modify;
//     end;

//     local procedure UpdateVendorContact(Vendor: Record Vendor; StagingRec: Record "MyTaxi CRM Interface Records")
//     var
//         ContBusRelVend: Record "Contact Business Relation";
//         Contact: Record Contact;
//         RMSetup: Record "Marketing Setup";
//         Noseries: Codeunit "No. Series";
//     begin
//         RMSetup.Get();
//         RMSetup.TestField("Bus. Rel. Code for Vendors");
//         // Find contact linked to Vendor
//         ContBusRelVend.Reset();
//         ContBusRelVend.SetRange("Link to Table", ContBusRelVend."Link to Table"::Vendor);
//         ContBusRelVend.SetRange("No.", Vendor."No.");
//         if not ContBusRelVend.FindFirst() then
//         //Error('No contact relation found for Vendor %1.', Vendor."No.")
//         begin
//             Contact.Init();
//             Contact.Validate("No.", Noseries.GetNextNo(RMSetup."Contact Nos.", WorkDate()));
//             Contact.Validate(Type, Contact.Type::Company);
//             Contact.Validate(Name, CopyStr(StagingRec.contact, 1, MaxStrLen(Contact.Name)));
//             Contact.Validate(Address, CopyStr(StagingRec.address1, 1, MaxStrLen(Contact.Address)));
//             Contact.Validate("Post Code", CopyStr(StagingRec.zip, 1, MaxStrLen(Contact."Post Code")));
//             Contact.Validate(City, CopyStr(StagingRec.city, 1, MaxStrLen(Contact.City)));
//             Contact.Validate("Phone No.", CopyStr(StagingRec.tele1, 1, MaxStrLen(Contact."Phone No.")));
//             Contact.Validate("E-Mail", CopyStr(StagingRec.email, 1, MaxStrLen(Contact."E-Mail")));
//             Contact.Insert(true);
//             ContBusRelVend.Init();
//             ContBusRelVend."Contact No." := Contact."No.";
//             ContBusRelVend."Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
//             ContBusRelVend."Link to Table" := ContBusRelVend."Link to Table"::Vendor;
//             ContBusRelVend."No." := Vendor."No.";
//             ContBusRelVend.Insert(true);
//         end
//         else begin
//             // Get Contact record
//             //No need of checking contact
//             if not Contact.Get(ContBusRelVend."Contact No.") then
//                 Error('Contact %1 not found for Vendor %2.', ContBusRelVend."Contact No.", Vendor."No.");
//             // Update fields using staging data
//             Contact.Validate(Name, CopyStr(StagingRec.contact, 1, MaxStrLen(Contact.Name)));
//             Contact.Validate(Address, CopyStr(StagingRec.address1, 1, MaxStrLen(Contact.Address)));
//             Contact.Validate("Post Code", CopyStr(StagingRec.zip, 1, MaxStrLen(Contact."Post Code")));
//             Contact.Validate(City, CopyStr(StagingRec.city, 1, MaxStrLen(Contact.City)));
//             Contact.Validate("Phone No.", CopyStr(StagingRec.tele1, 1, MaxStrLen(Contact."Phone No.")));
//             Contact.Validate("E-Mail", CopyStr(StagingRec.email, 1, MaxStrLen(Contact."E-Mail")));
//             Contact.Modify(true);
//         end;
//         Vendor.Validate("Primary Contact No.", Contact."No.");
//         Vendor.Contact := Contact.Name;
//         Vendor.Modify(true);
//     end;

//     local procedure AutoLinkVendorCustomer(Vendor: Record Vendor)
//     var
//         Cust: Record Customer;
//         ContBusRelVend: Record "Contact Business Relation";
//         ContBusRelCust: Record "Contact Business Relation";
//         Contact: Record Contact;
//         RMSetup: Record "Marketing Setup";
//     begin
//         // Ensure a Customer with same No. exists
//         if not Cust.Get(Vendor."No.") then
//             Error('Customer with same No. %1 not found.', Vendor."No.");
//         // Get Vendor contact from Contact Business Relation
//         ContBusRelVend.Reset();
//         ContBusRelVend.SetRange("Link to Table", ContBusRelVend."Link to Table"::Vendor);
//         ContBusRelVend.SetRange("No.", Vendor."No.");
//         if not ContBusRelVend.FindFirst() then
//             Error('No contact relation found for Vendor %1.', Vendor."No.");
//         // Get the Contact record linked to Vendor
//         if not Contact.Get(ContBusRelVend."Contact No.") then
//             Error('Contact %1 missing for Vendor %2.', ContBusRelVend."Contact No.", Vendor."No.");
//         // If Customer already has another Contact linked, remove it first
//         ContBusRelCust.Reset();
//         ContBusRelCust.SetRange("Link to Table", ContBusRelCust."Link to Table"::Customer);
//         ContBusRelCust.SetRange("No.", Cust."No.");
//         if ContBusRelCust.FindFirst() then begin
//             repeat
//                 ContBusRelCust.Delete(true);
//             until ContBusRelCust.Next() = 0;
//         end;
//         RMSetup.Get();
//         RMSetup.TestField("Bus. Rel. Code for Customers");
//         ContBusRelCust.Init();
//         ContBusRelCust."Contact No." := Contact."No.";
//         ContBusRelCust."Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
//         ContBusRelCust."Link to Table" := ContBusRelCust."Link to Table"::Customer;
//         ContBusRelCust."No." := Cust."No.";
//         ContBusRelCust.Insert(true);
//         Cust.Validate("Primary Contact No.", Contact."No.");
//         Cust.Contact := Contact.Name;
//         Cust.Modify(true);
//     end;
// }
