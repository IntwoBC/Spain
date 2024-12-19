page 70003 "MyTaxi CRM Interface Customers"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : New request
    //   New added fields : accountHolder,iban,bic,directDebitAllowed,bankAccountNumber,sortCode,statusCode
    // #MyTaxi.W1.CRE.INT01.017 25/03/2019 CCFR.SDE : New request
    //   New added field : headquarterID
    // 
    // PK 12-08-24 EY-MYES0003 Case CS0806754 / Feature 6079423
    // Action added:
    //   - Get MyTaxi Customers by ID

    Caption = 'MyTaxi CRM Interface Customers';
    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "MyTaxi CRM Interface Records";
    SourceTableView = WHERE("Interface Type" = CONST(Customer));
    ApplicationArea = All;
    UsageCategory = lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Interface Type"; Rec."Interface Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transfer Date field.';
                }
                field("Transfer Time"; Rec."Transfer Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transfer Time field.';
                }
                field("Process Status"; Rec."Process Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Process Status field.';
                }
                field(company; Rec.company)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the company field.';
                }
                field(id; Rec.id)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the id field.';
                }
                field(number; Rec.number)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the number field.';
                }
                field(name; Rec.name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the name field.';
                }
                field(orgNo; Rec.orgNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the orgNo field.';
                }
                field(address1; Rec.address1)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the address1 field.';
                }
                field(city; Rec.city)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the city field.';
                }
                field(zip; Rec.zip)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the zip field.';
                }
                field(country; Rec.country)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the country field.';
                }
                field(headquarterID; Rec.headquarterID)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the headquarterID field.';
                }
                field(tele1; Rec.tele1)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the tele1 field.';
                }
                field(email; Rec.email)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the email field.';
                }
                field(contact; Rec.contact)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the contact field.';
                }
                field(vatNo; Rec.vatNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the vatNo field.';
                }
                field(customerGroup; Rec.customerGroup)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the customerGroup field.';
                }
                field("Process Status Description"; Rec."Process Status Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Process Status Description field.';
                }
                field(address2; Rec.address2)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the address2 field.';
                }
                field(address3; Rec.address3)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the address3 field.';
                }
                field(contact2; Rec.contact2)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the contact2 field.';
                }
                field(contact3; Rec.contact3)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the contact3 field.';
                }
                field(accountHolder; Rec.accountHolder)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the accountHolder field.';
                }
                field(iban; Rec.iban)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the iban field.';
                }
                field(bic; Rec.bic)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the bic field.';
                }
                field(directDebitAllowed; Rec.directDebitAllowed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the directDebitAllowed field.';
                }
                field(businessAccountPaymentMethod; Rec.businessAccountPaymentMethod)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the businessAccountPaymentMethod field.';
                }
                field(bankAccountNumber; Rec.bankAccountNumber)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the bankAccountNumber field.';
                }
                field(sortCode; Rec.sortCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the sortCode field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000018; Notes)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Customer Card")
            {
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = Page "Customer Card";
                //RunPageLink = "No." = FIELD(id);
                ApplicationArea = all;
                ToolTip = 'Executes the Customer Card action.';
            }
            action("Get MyTaxi Customers")
            {
                Caption = 'Get MyTaxi Customers';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Get MyTaxi Customers action.';

                trigger OnAction()
                var
                    MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                begin

                    MyTaxiCRMInterfaceWS.GetMasterData(Today, Today);
                end;
            }
            action("Get MyTaxi Customers by ID")
            {
                Caption = 'Get MyTaxi Customers by ID';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Get MyTaxi Customers by ID action.';

                trigger OnAction()
                var
                    MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                begin
                    // EY-MYES0003 >>
                    MyTaxiCRMInterfaceWS.GetMasterDataByID;
                    // EY-MYES0003 <<
                end;
            }
            action("Import MyTaxi Customers File")
            {
                Caption = 'Import MyTaxi Customers File';
                Image = FileContract;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Import MyTaxi Customers File action.';

                trigger OnAction()
                var
                    MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                begin
                    MyTaxiCRMInterfaceWS.ImportMasterData;
                end;
            }
            action("Create Customers")
            {
                Caption = 'Create Customers';
                Image = EditCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Create Customers action.';

                trigger OnAction()
                var
                    MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
                    MyTaxiCRMInterfaceProcess: Codeunit "MyTaxi CRM Interface Process";
                begin
                    CurrPage.SetSelectionFilter(MyTaxiCRMInterfaceRecords);
                    MyTaxiCRMInterfaceRecords.SetRange("Transfer Date", 0D);
                    if MyTaxiCRMInterfaceRecords.FindFirst() then
                        repeat
                            ClearLastError();
                            Clear(MyTaxiCRMInterfaceProcess);
                            MyTaxiCRMInterfaceProcess.SetParams(1, MyTaxiCRMInterfaceRecords);
                            if not MyTaxiCRMInterfaceProcess.Run() then begin
                                MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::Error;
                                MyTaxiCRMInterfaceRecords."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
                                MyTaxiCRMInterfaceRecords.Modify();
                            end;
                            Commit();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                end;
            }
        }
    }
}

