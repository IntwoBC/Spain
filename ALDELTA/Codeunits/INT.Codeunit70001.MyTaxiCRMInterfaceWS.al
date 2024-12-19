codeunit 70001 "MyTaxi CRM Interface WS"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Codeunit Creation
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : New request
    //   Update bank details on customers
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New request
    //   Save the InvoiceDate in a new field "NAV Document Date" and assign to "Document Date" on the sales invoice/credit memo
    //   Retreive the payment method from the CRM App
    // #MyTaxi.W1.CRE.INT01.015 26/12/2018 CCFR.SDE : New request
    //   Follow the posting process of Invoice/Credit Memo/Payment
    // #MyTaxi.W1.CRE.INT01.017 25/03/2019 CCFR.SDE : New request
    //   Retreive the cost center 2 from the customer master data
    // #MyTaxi.W1.ISS.000081453 05/02/2020 CCFR.SDE : Change Request (Ticket 81453 TLS-NAV compliance)
    //   Modified function : CallRESTWebService
    // PK 12-08-24 EY-MYES0003 Case CS0806754 / Feature 6079423
    // Function added
    //   - GetMasterDataByID
    // Functions modified:
    //   - GetMasterData
    //   - TransfeInvJsonToTmpInv
    //   - TransfeInvJsonToTmpInv2


    trigger OnRun()
    begin
        case InterfaceType of
            InterfaceType::Customers:
                begin
                    GetMasterData(Today, Today);
                    exit;
                end;
            InterfaceType::"Sales Invoice":
                begin
                    case FlowType of
                        FlowType::Import:
                            GetInvoices(0, false);
                        FlowType::Export:
                            UpdateInvoice(MyTaxiCRMInterfaceRecords);
                    end;
                    exit;
                end;
        end;
    end;

    var
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        InterfaceType: Option " ",Customers,"Sales Invoice";
        FlowType: Option " ",Process,Import,Export;
        CalledFromMasterDataByID: Boolean;
        CommaSeparatedIDsLbl: Label 'Please provide comma separated Customer IDs';
        GetCustomersByIDLbl: Label 'Get Customers by ID';

    procedure SetParams(pInterfaceType: Option " ",Customers,"Sales Invoice"; pFlowType: Option " ",Process,Import,Export; pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    begin
        InterfaceType := pInterfaceType;
        FlowType := pFlowType;
        MyTaxiCRMInterfaceRecords := pMyTaxiCRMInterfaceRecords;
    end;

    procedure GetMasterDataByID()
    var
        CalledFromMasterDataByID: Boolean;
    begin
        // EY-MYIT0002 >>
        CalledFromMasterDataByID := true;
        GetMasterData(0D, 0D);
        CalledFromMasterDataByID := false;
        // EY-MYIT0002 <<
    end;

    // [TryFunction]

    procedure GetMasterData(FromDate: Date; ToDate: Date): Boolean
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary;
        Customer: Record Customer;
        Parameters: Dictionary of [Text, Text];
        HttpResponseMessage: HttpResponseMessage;
        JToken: JsonToken;
        CustomerList: JsonArray;
        CustomerContent: JsonObject;
        result: Text;
        bInsert: Boolean;
        LastEntryNo: Integer;
        CustomerBankAccount: Record "Customer Bank Account";
        BankAccountContent: JsonObject;
        CustomerIDsToGet: Text;
        CustomerIDDialog: Page "Master Data Input Request";
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
    //CalledFromMasterDataByID: Boolean;
    begin
        MyTaxiCRMInterfaceSetup.Get;
        // EY-MYIT0002 >>
        if CalledFromMasterDataByID then begin
            if GuiAllowed then begin
                CustomerIDDialog.SetVisible(false);
                // Request for Customer IDs and Date Range Input
                if CustomerIDDialog.RunModal() = Action::OK then // Retrieve the Customer IDs, From Date, and To Date from the dialog page
                    CustomerIDsToGet := CustomerIDDialog.GetCustomerIDsToGet();
            end;
            if CustomerIDsToGet = '' then exit;
        end
        else begin
            // EY-MYIT0002 <<
            if GuiAllowed then begin
                // Evaluate(FromDate, Window.InputBox('From Date', 'INPUT', Format(MyTaxiCRMInterfaceSetup."Master Data Last Max Date"), 20, 20));
                // Evaluate(ToDate, Window.InputBox('To Date', 'INPUT', Format(Today), 20, 20));
                FromDate := MyTaxiCRMInterfaceSetup."Master Data Last Max Date"; // Use default date from setup
                ToDate := Today; // Default to current date
            end;
            if (FromDate = 0D) or (ToDate = 0D) then exit;
        end;
        MyTaxiCRMInterfaceSetup."Master Data Last Max Date" := ToDate;
        MyTaxiCRMInterfaceSetup.Modify;
        Parameters.Add('baseurl', MyTaxiCRMInterfaceSetup."Web Service Base URL");
        // EY-MYIT0002 >>
        if CalledFromMasterDataByID then
            Parameters.Add('path', StrSubstNo(MyTaxiCRMInterfaceSetup."Master Data by ID WS", CustomerIDsToGet))
        else
            // EY-MYIT0002 <<
            Parameters.Add('path', StrSubstNo(MyTaxiCRMInterfaceSetup."Master Data WS", Format(FromDate, 0, '<Year4>-<Month,2>-<Day,2>'), Format(ToDate, 0, '<Year4>-<Month,2>-<Day,2>')));
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('accept', 'application/json');
        Parameters.Add('username', MyTaxiCRMInterfaceSetup.User);
        Parameters.Add('password', MyTaxiCRMInterfaceSetup.Password);
        CallRESTWebService(Parameters, HttpResponseMessage);
        HttpResponseMessage.Content.ReadAs(Result);
        CustomerList.ReadFrom(result);
        foreach JToken in CustomerList do begin
            CustomerContent := JToken.AsObject();
            Clear(MyTaxiCRMInterfaceRecords);
            MyTaxiCRMInterfaceRecords.SetFilter("Entry No.", '<>%1', 0);
            if MyTaxiCRMInterfaceRecords.FindLast() then
                LastEntryNo := MyTaxiCRMInterfaceRecords."Entry No." + 1
            else
                LastEntryNo := 1;
            TmpMyTaxiCRMInterfaceRecords.Init();
            TmpMyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo;
            TmpMyTaxiCRMInterfaceRecords."Interface Type" := TmpMyTaxiCRMInterfaceRecords."Interface Type"::Customer;
            // Use the JToken.AsValue().AsText() approach for parsing
            if CustomerContent.Get('company', JToken) then TmpMyTaxiCRMInterfaceRecords.company := JToken.AsValue().AsText();
            if CustomerContent.Get('id', JToken) then TmpMyTaxiCRMInterfaceRecords.id := JToken.AsValue().AsInteger();
            if CustomerContent.Get('number', JToken) then TmpMyTaxiCRMInterfaceRecords.number := JToken.AsValue().AsInteger();
            if CustomerContent.Get('name', JToken) then TmpMyTaxiCRMInterfaceRecords.name := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.name));
            if CustomerContent.Get('orgNo', JToken) then TmpMyTaxiCRMInterfaceRecords.orgNo := JToken.AsValue().AsText();
            if CustomerContent.Get('address1', JToken) then TmpMyTaxiCRMInterfaceRecords.address1 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.address1));
            if CustomerContent.Get('city', JToken) then TmpMyTaxiCRMInterfaceRecords.city := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.city));
            if CustomerContent.Get('zip', JToken) then TmpMyTaxiCRMInterfaceRecords.zip := JToken.AsValue().AsText();
            if CustomerContent.Get('country', JToken) then TmpMyTaxiCRMInterfaceRecords.country := JToken.AsValue().AsText();
            //Added Headquarter
            If CustomerContent.Get('headquarterID',JToken)then TmpMyTaxiCRMInterfaceRecords.headquarterID:=JToken.AsValue().AsText();
            if CustomerContent.Get('tele1', JToken) then TmpMyTaxiCRMInterfaceRecords.tele1 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.tele1));
            if CustomerContent.Get('email', JToken) then TmpMyTaxiCRMInterfaceRecords.email := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.email));
            if CustomerContent.Get('contact', JToken) then TmpMyTaxiCRMInterfaceRecords.contact := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.contact));
            if CustomerContent.Get('vatNo', JToken) then TmpMyTaxiCRMInterfaceRecords.vatNo := JToken.AsValue().AsText();
            //Added Customergroup
            If CustomerContent.Get('customerGroup',JToken)then TmpMyTaxiCRMInterfaceRecords.customerGroup:=JToken.AsValue().AsText();
            If CustomerContent.Get('Process Status Description',JToken)then TmpMyTaxiCRMInterfaceRecords."Process Status Description":=JToken.AsValue().AsText();
            // MyTaxi.W1.CRE.INT01.001 <<
            //TmpMyTaxiCRMInterfaceRecords.customerGroup := CustomerContent.GetValue('CustomerGroup').ToString;
            if CustomerContent.Get('address1', JToken) then TmpMyTaxiCRMInterfaceRecords.address2 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.address2));
            if CustomerContent.Get('address1', JToken) then TmpMyTaxiCRMInterfaceRecords.address3 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.address3));
            if CustomerContent.Get('contact', JToken) then TmpMyTaxiCRMInterfaceRecords.contact2 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.contact2));
            if CustomerContent.Get('contact', JToken) then TmpMyTaxiCRMInterfaceRecords.contact3 := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.contact3));
            // MyTaxi.W1.CRE.INT01.001 >>
            // MyTaxi.W1.CRE.INT01.009 <<
            // Additional fields
            if CustomerContent.Get('bankAccountDetails', JToken) then begin
                BankAccountContent := JToken.AsObject();
                if BankAccountContent.Get('accountHolder', JToken) then TmpMyTaxiCRMInterfaceRecords.accountHolder := JToken.AsValue().AsText();
                if BankAccountContent.Get('iban', JToken) then TmpMyTaxiCRMInterfaceRecords.iban := JToken.AsValue().AsText();
                if BankAccountContent.Get('bic', JToken) then TmpMyTaxiCRMInterfaceRecords.bic := JToken.AsValue().AsText();
                if BankAccountContent.Get('directDebitAllowed', JToken) then TmpMyTaxiCRMInterfaceRecords.directDebitAllowed := JToken.AsValue().AsText();
                If BankAccountContent.Get('businessAccountPaymentMethod',JToken)then TmpMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod:=JToken.AsValue().AsText();
                if BankAccountContent.Get('bankAccountNumber', JToken) then TmpMyTaxiCRMInterfaceRecords.bankAccountNumber := JToken.AsValue().AsText();
                if BankAccountContent.Get('sortCode', JToken) then TmpMyTaxiCRMInterfaceRecords.sortCode := JToken.AsValue().AsText();
                MyTaxiCRMInterfaceSetup.TestField("Bank Account No Start Position");
                MyTaxiCRMInterfaceSetup.TestField("Bank Account No Length");
                TmpMyTaxiCRMInterfaceRecords."NAV Bank Account Code" := CopyStr(TmpMyTaxiCRMInterfaceRecords.iban, MyTaxiCRMInterfaceSetup."Bank Account No Start Position", MyTaxiCRMInterfaceSetup."Bank Account No Length")
            end;
            // MyTaxi.W1.CRE.INT01.009 >>
            // MyTaxi.IT.CRE.INT01.005 <<
            //if CustomerContent.Get('italyCodiceUnivoco', JToken)then TmpMyTaxiCRMInterfaceRecords.headquarterID:=JToken.AsValue().AsText();
            //if CustomerContent.Get('italyPec', JToken)then TmpMyTaxiCRMInterfaceRecords.italyPec:=CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.italyPec));
            // MyTaxi.IT.CRE.INT01.005 >>
            TmpMyTaxiCRMInterfaceRecords.Insert;
        end;
        if TmpMyTaxiCRMInterfaceRecords.FindSet then
            repeat
                bInsert := false;
                if not Customer.Get(Format(MyTaxiCRMInterfaceRecords.id)) then
                    bInsert := true
                else begin
                    if TmpMyTaxiCRMInterfaceRecords.name <> Customer.Name then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.address1 <> Customer.Address then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.city <> Customer.City then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.zip <> Customer."Post Code" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.country <> Customer."Country/Region Code" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.tele1 <> Customer."Phone No." then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.email <> Customer."E-Mail" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.contact <> Customer.Contact then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.vatNo <> Customer."VAT Registration No." then bInsert := true;
                    // MyTaxi.W1.CRE.INT01.009 <<
                    if TmpMyTaxiCRMInterfaceRecords.bankAccountNumber <> '' then begin
                        if not CustomerBankAccount.Get(Format(MyTaxiCRMInterfaceRecords.id), TmpMyTaxiCRMInterfaceRecords."NAV Bank Account Code") then
                            bInsert := true
                        else begin
                            if TmpMyTaxiCRMInterfaceRecords.accountHolder <> CustomerBankAccount.Name then bInsert := true;
                            if TmpMyTaxiCRMInterfaceRecords.iban <> CustomerBankAccount.IBAN then bInsert := true;
                            if TmpMyTaxiCRMInterfaceRecords.bic <> CustomerBankAccount."SWIFT Code" then bInsert := true;
                            if TmpMyTaxiCRMInterfaceRecords.bankAccountNumber <> CustomerBankAccount."Bank Account No." then bInsert := true;
                            if TmpMyTaxiCRMInterfaceRecords.sortCode <> CustomerBankAccount."Bank Branch No." then bInsert := true;
                        end;
                    end;
                    // MyTaxi.W1.CRE.INT01.009 >>
                end;
                if bInsert then begin
                    if MyTaxiCRMInterfaceRecords.FindLast then
                        LastEntryNo := MyTaxiCRMInterfaceRecords."Entry No."
                    else
                        LastEntryNo := 1;
                    MyTaxiCRMInterfaceRecords.Init;
                    MyTaxiCRMInterfaceRecords.TransferFields(TmpMyTaxiCRMInterfaceRecords);
                    MyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo + 1;
                    MyTaxiCRMInterfaceRecords.Insert;
                end;
            until TmpMyTaxiCRMInterfaceRecords.Next = 0;
    end;

    //[TryFunction]

    procedure GetInvoices(pInvoiceNumber: Integer; bGetSingleInvoice: Boolean)
    var
        TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary;
        TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary;
        Parameters: Dictionary of [Text, Text];
        HttpResponseMessage: HttpResponseMessage;
        JToken: JsonToken;
        InvoiceList: JsonArray;
        Invoice: JsonObject;
        CreditList: JsonArray;
        Credit: JsonObject;
        result: Text;
        bInsert: Boolean;
        LastEntryNo: Integer;
        //[RunOnClient]
        // Window: DotNet Interaction;
        InvoiceInputRequest: Page "Invoice Input Request";
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";

    begin
        if bGetSingleInvoice then begin
            if GuiAllowed then begin
                InvoiceInputRequest.RunModal();
                //Evaluate(pInvoiceNumber, Window.InputBox('Invoice Number', 'INPUT', Format(pInvoiceNumber), 20, 20));
                Evaluate(pInvoiceNumber, Format(InvoiceInputRequest.GetInvoiceNumber()));
            end;
            if pInvoiceNumber = 0 then
                exit;
        end;

        MyTaxiCRMInterfaceSetup.Get;

        // Parameters := Parameters.Dictionary();
        Parameters.Add('baseurl', MyTaxiCRMInterfaceSetup."Web Service Base URL");
        if bGetSingleInvoice then
            Parameters.Add('path', MyTaxiCRMInterfaceSetup."Invoice WS" + Format(pInvoiceNumber))
        else
            Parameters.Add('path', MyTaxiCRMInterfaceSetup."Invoice List WS");
        Parameters.Add('restmethod', 'GET');
        Parameters.Add('accept', 'application/json');
        Parameters.Add('username', MyTaxiCRMInterfaceSetup.User);
        Parameters.Add('password', MyTaxiCRMInterfaceSetup.Password);
        CallRESTWebService(Parameters, HttpResponseMessage);

        HttpResponseMessage.Content.ReadAs(result);

        JToken.ReadFrom(result);
        LastEntryNo := 1;
        if bGetSingleInvoice then begin
            Invoice := JToken.AsObject();
            TransfeInvJsonToTmpInv(Invoice, TmpMyTaxiCRMInterfaceRecords, TmpMyTaxiCRMInterfSubRecords, LastEntryNo);
        end
        else begin
            InvoiceList.ReadFrom(result);
            foreach JToken in InvoiceList do begin
                Invoice := JToken.AsObject();
                TransfeInvJsonToTmpInv(Invoice, TmpMyTaxiCRMInterfaceRecords, TmpMyTaxiCRMInterfSubRecords, LastEntryNo);
            end;
        end;

        TransferTmpInvToInvoiceRec(TmpMyTaxiCRMInterfaceRecords, TmpMyTaxiCRMInterfSubRecords);
    end;

    //[TryFunction]
    local procedure TransfeInvJsonToTmpInv(Invoice: JsonObject; var TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary; var TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary; var LastEntryNo: Integer)
    var
        JToken: JsonToken;
        CreditList: JsonArray;
        Credit: JsonObject;
        SubLastEntryNo: Integer;
        "--- MyTaxi.W1.CRE.INT01.015 ---": Integer;
        MyTaxiCRMIntPostingMap: Record "MyTaxi CRM Int. Posting Map.";
        // MyTaxiCRMIntPostingMap: Record "MyTaxi CRM Int. Posting Map.";
        MyTaxiCRMInterfaceRecordsL: Record "MyTaxi CRM Interface Records";
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
    begin
        begin
            LastEntryNo += 1;
            TmpMyTaxiCRMInterfaceRecords.Init;
            TmpMyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo;

            TmpMyTaxiCRMInterfaceRecords."Interface Type" := TmpMyTaxiCRMInterfaceRecords."Interface Type"::Invoice;
            if Invoice.Get('id', JToken) then TmpMyTaxiCRMInterfaceRecords.id := JToken.AsValue().AsInteger();
            if Invoice.Get('countyCode', JToken) then TmpMyTaxiCRMInterfaceRecords.countryCode := JToken.AsValue().AsText();
            if Invoice.Get('statusCode', JToken) then TmpMyTaxiCRMInterfaceRecords.statusCode := JToken.AsValue().AsText();
            if Invoice.Get('dateStatusChanged', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.dateStatusChanged, JToken.AsValue().AsText());
            if Invoice.Get('additionalInformation', JToken) then TmpMyTaxiCRMInterfaceRecords.additionalInformation := JToken.AsValue().AsText();
            if not Invoice.Get('data', JToken) then Error('Missing "data" field in JSON.');
            Invoice := JToken.AsObject();
            if Invoice.Get('invoiceid', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.invoiceid, JToken.AsValue().AsText());
            if Invoice.Get('externalReference', JToken) then TmpMyTaxiCRMInterfaceRecords.externalReference := JToken.AsValue().AsText();
            if Invoice.Get('invoiceType', JToken) then TmpMyTaxiCRMInterfaceRecords.invoiceType := JToken.AsValue().AsText();
            if Invoice.Get('idCustomer', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.idCustomer, JToken.AsValue().AsText());
            if Invoice.Get('dateInvoice', JToken) then begin
                TmpMyTaxiCRMInterfaceRecords.dateInvoice := JToken.AsValue().AsDate();
                // MyTaxi.W1.CRE.INT01.013 <<
                TmpMyTaxiCRMInterfaceRecords."NAV Document Date" := TmpMyTaxiCRMInterfaceRecords.dateInvoice;
                // MyTaxi.W1.CRE.INT01.013 >>
            end;
            if Invoice.Get('dueDate', JToken) then begin
                TmpMyTaxiCRMInterfaceRecords.dueDate := JToken.AsValue().AsDate();
            end;
            // MyTaxi.W1.CRE.INT01.013 <<
            if Invoice.Get('businessAccountPaymentMethod', JToken) then TmpMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod := JToken.AsValue().AsText();
            // MyTaxi.W1.CRE.INT01.013 >>
            if Invoice.Get('countryCode', JToken) then TmpMyTaxiCRMInterfaceRecords.countryCode := JToken.AsValue().AsText();
            if Invoice.Get('currency', JToken) then TmpMyTaxiCRMInterfaceRecords.currency := JToken.AsValue().AsText();
            if Invoice.Get('sumNetValue', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.sumNetValue, JToken.AsValue().AsText());
                if Invoice.Get('sumTaxValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.sumTaxValue, JToken.AsValue().AsText());
                if Invoice.Get('sumGrossValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.sumGrossValue, JToken.AsValue().AsText());
            end;
            if Invoice.Get('discountCommissionNet', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionNet, JToken.AsValue().AsText());
                if Invoice.Get('discountCommissionTax', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionTax, JToken.AsValue().AsText());
                if Invoice.Get('discountCommissionGross', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionGross, JToken.AsValue().AsText());
            end;
            if Invoice.Get('netCommission', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.netCommission, JToken.AsValue().AsText());
                if Invoice.Get('taxCommission', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxCommission, JToken.AsValue().AsText());
                if Invoice.Get('grossCommission', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossCommission, JToken.AsValue().AsText());
            end;
            if Invoice.Get('netHotelValue', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.netHotelValue, JToken.AsValue().AsText());
                if Invoice.Get('taxHotelValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxHotelValue, JToken.AsValue().AsText());
                if Invoice.Get('grossHotelValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossHotelValue, JToken.AsValue().AsText());
            end;
            if Invoice.Get('netInvoicingFee', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.netInvoicingFee, JToken.AsValue().AsText());
                if Invoice.Get('taxInvoicingFee', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxInvoicingFee, JToken.AsValue().AsText());
                if Invoice.Get('grossInvoicingFee', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossInvoicingFee, JToken.AsValue().AsText());
            end;
            if Invoice.Get('netPayment', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.netPayment, JToken.AsValue().AsText());
            if Invoice.Get('netPaymentFeeMP', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.netPaymentFeeMP, JToken.AsValue().AsText());
                if Invoice.Get('taxPaymentFeeMP', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxPaymentFeeMP, JToken.AsValue().AsText());
                if Invoice.Get('grossPaymentFeeMP', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossPaymentFeeMP, JToken.AsValue().AsText());
            end;
            if Invoice.Get('netPaymentFeeBA', JToken) then begin
                Evaluate(TmpMyTaxiCRMInterfaceRecords.netPaymentFeeBA, JToken.AsValue().AsText());
                if Invoice.Get('taxPaymentFeeBA', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxPaymentFeeBA, JToken.AsValue().AsText());
                if Invoice.Get('grossPaymentFeeBA', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossPaymentFeeBA, JToken.AsValue().AsText());
            end;
            //MyTaxi.W1.CRE.INT01.015 <<
            TmpMyTaxiCRMInterfaceRecords."NAV Invoice Status" := TmpMyTaxiCRMInterfaceRecords."NAV Invoice Status"::Imported;
            if TmpMyTaxiCRMInterfaceRecords.netPayment <> 0 then TmpMyTaxiCRMInterfaceRecords."NAV Payment Status" := TmpMyTaxiCRMInterfaceRecords."NAV Payment Status"::Imported;
            // MyTaxi.W1.CRE.INT01.015 >>
            TmpMyTaxiCRMInterfaceRecords.Insert;
            if Invoice.Get('additionalNotes', JToken) then begin
                CreditList := JToken.AsArray();
                SubLastEntryNo := 0;
                foreach JToken in CreditList do begin
                    if JToken.IsObject() then begin
                        Credit := JToken.AsObject();
                        SubLastEntryNo += 1;
                        TmpMyTaxiCRMInterfSubRecords.Init;
                        TmpMyTaxiCRMInterfSubRecords."Records Entry No." := TmpMyTaxiCRMInterfaceRecords."Entry No.";
                        TmpMyTaxiCRMInterfSubRecords."Entry No." := SubLastEntryNo;
                        TmpMyTaxiCRMInterfSubRecords.invoiceid := TmpMyTaxiCRMInterfaceRecords.invoiceid;
                        if Credit.Get('typeOfAdditionalNote', JToken) then TmpMyTaxiCRMInterfSubRecords.typeOfAdditionalNote := JToken.AsValue().AsText();
                        if Credit.Get('accountNumber', JToken) then TmpMyTaxiCRMInterfSubRecords.accountNumber := JToken.AsValue().AsText();
                        if Credit.Get('netCredit', JToken) then begin
                            Evaluate(TmpMyTaxiCRMInterfSubRecords.netCredit, JToken.AsValue().AsText());
                            if Invoice.Get('taxCredit', JToken) then Evaluate(TmpMyTaxiCRMInterfSubRecords.taxCredit, JToken.AsValue().AsText());
                            if Invoice.Get('grossCredit', JToken) then Evaluate(TmpMyTaxiCRMInterfSubRecords.grossCredit, JToken.AsValue().AsText());
                        end;
                        TmpMyTaxiCRMInterfSubRecords.Insert;
                        SubLastEntryNo += 1;
                        // MyTaxi.W1.CRE.INT01.015 <<
                        if (TmpMyTaxiCRMInterfaceRecords."NAV Credit Memo Status" <> TmpMyTaxiCRMInterfaceRecords."NAV Credit Memo Status"::Imported) then
                            if (TmpMyTaxiCRMInterfSubRecords.netCredit > 0) and MyTaxiCRMIntPostingMap.Get(TmpMyTaxiCRMInterfaceRecords.invoiceType, TmpMyTaxiCRMInterfSubRecords.accountNumber) and (MyTaxiCRMIntPostingMap."Document Type" = MyTaxiCRMIntPostingMap."Document Type"::"Credit Memo") then begin
                                TmpMyTaxiCRMInterfaceRecords."NAV Credit Memo Status" := TmpMyTaxiCRMInterfaceRecords."NAV Credit Memo Status"::Imported;
                                TmpMyTaxiCRMInterfaceRecords.Modify;
                            end;
                        // MyTaxi.W1.CRE.INT01.015 >>
                    end;
                end;
            end;
        end;
    end;

    local procedure TransferTmpInvToInvoiceRec(var TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary; var TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary)
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LastEntryNo: Integer;
        bInsert: Boolean;
    begin
        LastEntryNo := 1;
        if MyTaxiCRMInterfaceRecords.FindLast() then
            LastEntryNo := MyTaxiCRMInterfaceRecords."Entry No.";

        MyTaxiCRMInterfaceRecords.SetCurrentKey(invoiceid);
        if TmpMyTaxiCRMInterfaceRecords.FindSet() then
            repeat
                bInsert := false;
                MyTaxiCRMInterfaceRecords.SetRange(invoiceid, TmpMyTaxiCRMInterfaceRecords.invoiceid);
                if not MyTaxiCRMInterfaceRecords.FindFirst() and
                   not SalesHeader.Get(SalesHeader."Document Type"::Invoice, TmpMyTaxiCRMInterfaceRecords.invoiceid) and
                   not SalesInvoiceHeader.Get(TmpMyTaxiCRMInterfaceRecords.invoiceid)
                then
                    bInsert := true
                else begin
                    if MyTaxiCRMInterfaceRecords.FindFirst() and (MyTaxiCRMInterfaceRecords.statusCode <> TmpMyTaxiCRMInterfaceRecords.statusCode) then begin
                        MyTaxiCRMInterfaceRecords.statusCode := TmpMyTaxiCRMInterfaceRecords.statusCode;
                        MyTaxiCRMInterfaceRecords.dateStatusChanged := TmpMyTaxiCRMInterfaceRecords.dateStatusChanged;
                        MyTaxiCRMInterfaceRecords.additionalInformation := TmpMyTaxiCRMInterfaceRecords.additionalInformation;
                        MyTaxiCRMInterfaceRecords.Modify();
                    end;
                end;
                if bInsert then begin
                    MyTaxiCRMInterfaceRecords.Init();
                    MyTaxiCRMInterfaceRecords.TransferFields(TmpMyTaxiCRMInterfaceRecords);
                    MyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo + 1;
                    LastEntryNo += 1;
                    MyTaxiCRMInterfaceRecords.Insert();
                    TmpMyTaxiCRMInterfSubRecords.SetRange("Records Entry No.", TmpMyTaxiCRMInterfaceRecords."Entry No.");
                    if TmpMyTaxiCRMInterfSubRecords.FindSet() then
                        repeat
                            MyTaxiCRMInterfSubRecords.Init();
                            MyTaxiCRMInterfSubRecords.TransferFields(TmpMyTaxiCRMInterfSubRecords);
                            MyTaxiCRMInterfSubRecords."Records Entry No." := MyTaxiCRMInterfaceRecords."Entry No.";
                            MyTaxiCRMInterfSubRecords.Insert();
                        until TmpMyTaxiCRMInterfSubRecords.Next() = 0;
                end;
            until TmpMyTaxiCRMInterfaceRecords.Next() = 0;
    end;

    // [TryFunction]

    procedure UpdateInvoice(var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        Parameters: Dictionary of[Text, Text];
        HttpResponseMessage: HttpResponseMessage;
        JsonBody: Text;
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
        DateStatusChanged: Text;
        str: HttpContent;
    begin
        // Check if invoice update needs to be sent
        if(pMyTaxiCRMInterfaceRecords."Interface Type" <> pMyTaxiCRMInterfaceRecords."Interface Type"::Invoice) or not pMyTaxiCRMInterfaceRecords."Send Update" then exit;
        // Get interface setup details
        MyTaxiCRMInterfaceSetup.Get;
        // Set up parameters
        //Parameters := Dictionary of [Text, Text];
        Parameters.Add('baseurl', MyTaxiCRMInterfaceSetup."Web Service Base URL");
        Parameters.Add('path', MyTaxiCRMInterfaceSetup."Invoice WS" + Format(pMyTaxiCRMInterfaceRecords.invoiceid));
        Parameters.Add('restmethod', 'PATCH');
        Parameters.Add('accept', 'application/json');
        Parameters.Add('username', MyTaxiCRMInterfaceSetup.User);
        Parameters.Add('password', MyTaxiCRMInterfaceSetup.Password);
        // Prepare the JSON body
        DateStatusChanged:=Format(pMyTaxiCRMInterfaceRecords.dateStatusChanged, 0, '<Year4>-<Month,2>-<Day,2> <Hours24>:<Minutes,2>:<Seconds,2>');
        JsonBody:='{';
        JsonBody+='"statusCode":' + Format(pMyTaxiCRMInterfaceRecords.statusCode) + ',';
        JsonBody+='"dateStatusChanged":"' + DateStatusChanged + '",';
        JsonBody+='"additionalInformation":"' + pMyTaxiCRMInterfaceRecords."Process Status Description" + '"';
        JsonBody+='}';
        // Add JSON body to the parameters
        Parameters.Add('httpcontent', JsonBody);
        // Call the REST web service
        CallRESTWebService(Parameters, HttpResponseMessage);
        // Update record to prevent further updates
        pMyTaxiCRMInterfaceRecords."Send Update":=false;
        pMyTaxiCRMInterfaceRecords.Modify;
    end;
        //Parameters: DotNet Dictionary_Of_T_U;
        // HttpResponseMessage: DotNet HttpResponseMessage;
        // XMLConvert: DotNet XmlConvert;
        //     StringContent: DotNet StringContent;
        //     //JsonConvert: DotNet JsonConvert;
        //     //JArray: DotNet JArray;
        //     //JObject: DotNet JObject;
        //     //JTokenWriter: DotNet JTokenWriter;
        //     //JToken: DotNet JToken;
        //     //Encoding: DotNet Encoding;
        // begin
        //     if (pMyTaxiCRMInterfaceRecords."Interface Type" <> pMyTaxiCRMInterfaceRecords."Interface Type"::Invoice) or not pMyTaxiCRMInterfaceRecords."Send Update" then
        //         exit;

        //     MyTaxiCRMInterfaceSetup.Get;
        //     //Parameters := Parameters.Dictionary();
        //     Parameters.Add('baseurl', MyTaxiCRMInterfaceSetup."Web Service Base URL");
        //     Parameters.Add('path', MyTaxiCRMInterfaceSetup."Invoice WS" + Format(pMyTaxiCRMInterfaceRecords.invoiceid));
        //     Parameters.Add('restmethod', 'PATCH');
        //     Parameters.Add('accept', 'application/json');
        //     Parameters.Add('username', MyTaxiCRMInterfaceSetup.User);
        //     Parameters.Add('password', MyTaxiCRMInterfaceSetup.Password);

        //     JTokenWriter := JTokenWriter.JTokenWriter;
        //     WriteStartObject;
        //     WritePropertyName('statusCode');
        //     WriteValue(pMyTaxiCRMInterfaceRecords.statusCode);
        //     WritePropertyName('dateStatusChanged');
        //     WriteValue(Format(pMyTaxiCRMInterfaceRecords.dateStatusChanged, 0, '<Year4>-<Month,2>-<Day,2> <Hours24>:<Minutes,2>:<Seconds,2>'));
        //     WritePropertyName('additionalInformation');
        //     WriteValue(pMyTaxiCRMInterfaceRecords."Process Status Description");
        //     WriteEndObject;
        //     JObject := Token;
        //     StringContent := StringContent.StringContent(JObject.ToString, Encoding.UTF8, 'application/json');
        //     Parameters.Add('httpcontent', StringContent);

        //     CallRESTWebService(Parameters, HttpResponseMessage);
        //     pMyTaxiCRMInterfaceRecords."Send Update" := false;
        //     pMyTaxiCRMInterfaceRecords.Modify;
        // end;

        // [TryFunction]

        // procedure CallRESTWebService(var Parameters: DotNet Dictionary_Of_T_U; var HttpResponseMessage: DotNet HttpResponseMessage)
        // var
        // HttpContent: DotNet HttpContent;
        // HttpClient: DotNet HttpClient;
        // AuthHeaderValue: DotNet AuthenticationHeaderValue;
        // HttpRequestMessage: DotNet HttpRequestMessage;
        // HttpMethod: DotNet HttpMethod;
        // Uri: DotNet Uri;
        // bytes: DotNet Array;
        // Encoding: DotNet Encoding;
        // Convert: DotNet Convert;
        // "--- MyTaxi.W1.ISS.000081453 ---": Integer;
        // ServicePointManger: DotNet ServicePointManager;
        // SecurityProtocol: DotNet SecurityProtocolType;
        // begin
        //     HttpClient := HttpClient.HttpClient();
        //     HttpClient.BaseAddress := Uri.Uri(Format(Parameters.Item('baseurl')));

        //     if Parameters.ContainsKey('accept') then
        //         HttpClient.DefaultRequestHeaders.Add('Accept', Format(Parameters.Item('accept')));

        //     if Parameters.ContainsKey('username') then begin
        //         bytes := Encoding.ASCII.GetBytes(StrSubstNo('%1:%2', Format(Parameters.Item('username')), Format(Parameters.Item('password'))));
        //         AuthHeaderValue := AuthHeaderValue.AuthenticationHeaderValue('Basic', Convert.ToBase64String(bytes));
        //         HttpClient.DefaultRequestHeaders.Authorization := AuthHeaderValue;
        //     end;

        // MyTaxi.W1.ISS.000081453 <<
        // ServicePointManger.SecurityProtocol := SecurityProtocol.Tls12;
        // // MyTaxi.W1.ISS.000081453 >>
        // case Format(Parameters.Item('restmethod')) of
        //     'GET':
        //         HttpResponseMessage := HttpClient.GetAsync(Format(Parameters.Item('path'))).Result;
        //     'PATCH':
        //         begin
        //             HttpMethod := HttpMethod.HttpMethod(Format(Parameters.Item('restmethod')));
        //             HttpRequestMessage := HttpRequestMessage.HttpRequestMessage(HttpMethod, Format(Parameters.Item('path')));
        //             if Parameters.ContainsKey('accept') then
        //                 HttpRequestMessage.Headers.Add('Accept', Format(Parameters.Item('accept')));
        //             if Parameters.ContainsKey('username') then begin
        //                 bytes := Encoding.ASCII.GetBytes(StrSubstNo('%1:%2', Format(Parameters.Item('username')), Format(Parameters.Item('password'))));
        //                 AuthHeaderValue := AuthHeaderValue.AuthenticationHeaderValue('Basic', Convert.ToBase64String(bytes));
        //                 HttpRequestMessage.Headers.Authorization := AuthHeaderValue;
        //             end;
        //             if Parameters.ContainsKey('httpcontent') then
        //                 HttpRequestMessage.Content := Parameters.Item('httpcontent');
        //             HttpResponseMessage := HttpClient.SendAsync(HttpRequestMessage).Result;
        //         end;
        //         'POST':
        //             HttpResponseMessage := HttpClient.PostAsync(Format(Parameters.Item('path')), HttpContent).Result;
        //         'PUT':
        //             HttpResponseMessage := HttpClient.PutAsync(Format(Parameters.Item('path')), HttpContent).Result;
        //         'DELETE':
        //             HttpResponseMessage := HttpClient.DeleteAsync(Format(Parameters.Item('path'))).Result;
        //     end;
        //     HttpResponseMessage.EnsureSuccessStatusCode();


    local procedure "----- TEMP UAT -----"()
    begin
    end;


    procedure ImportMasterData()
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary;
        Customer: Record Customer;
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob"; // Use TempBlob codeunit
        ReadStream: InStream;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        CustomerContent: JsonObject;
        FileName: Text;
        LastEntryNo: Integer;
        bInsert: Boolean;
        ImportJsonFile: Label 'Select a file to import';
        FileFilterTxt: Label 'All Files(*.*)|*.*|JSON Files(*.json)|*.json';
        FileFilterExtensionTxt: Label 'json', Locked = true;
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
    begin
        // Get MyTaxi CRM Interface setup
        MyTaxiCRMInterfaceSetup.Get;
        // Prompt the user to select a JSON file
        FileName := FileMgt.BLOBImportWithFilter(TempBlob, ImportJsonFile, '', FileFilterTxt, FileFilterExtensionTxt);
        if FileName = '' then exit;
        // Create a stream from the TempBlob codeunit
        TempBlob.CreateInStream(ReadStream);
        /*ReadStream.READTEXT(result);
        REPEAT
          ReadLen := ReadStream.READTEXT(ReadText);
          IF ReadLen > 0 THEN
            result += ReadText;
        UNTIL ReadLen = 0;*/
        // Parse the JSON content from the stream
        JsonObject.ReadFrom(ReadStream);
        // Validate and retrieve the customers array
        if not JsonObject.Get('customers', JsonToken) then Error('Invalid JSON format. "customers" array is missing.');
        LastEntryNo := 1;
        // Process each customer in the JSON array
        foreach JsonToken in JsonArray do begin
            CustomerContent := JsonToken.AsObject();
            TmpMyTaxiCRMInterfaceRecords.Init;
            TmpMyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo;
            LastEntryNo += 1;
            TmpMyTaxiCRMInterfaceRecords."Interface Type" := MyTaxiCRMInterfaceRecords."Interface Type"::Customer;
            // Use the 'if Get(...)' pattern for reading JSON values
            if CustomerContent.Get('company', JsonToken) then TmpMyTaxiCRMInterfaceRecords.company := JsonToken.AsValue().AsText();
            if CustomerContent.Get('id', JsonToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.id, JsonToken.AsValue().AsText());
            if CustomerContent.Get('number', JsonToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.number, JsonToken.AsValue().AsText());
            if CustomerContent.Get('name', JsonToken) then TmpMyTaxiCRMInterfaceRecords.name := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.name));
            if CustomerContent.Get('orgNo', JsonToken) then TmpMyTaxiCRMInterfaceRecords.orgNo := JsonToken.AsValue().AsText();
            if CustomerContent.Get('address1', JsonToken) then TmpMyTaxiCRMInterfaceRecords.address1 := JsonToken.AsValue().AsText();
            if CustomerContent.Get('city', JsonToken) then TmpMyTaxiCRMInterfaceRecords.city := JsonToken.AsValue().AsText();
            if CustomerContent.Get('zip', JsonToken) then TmpMyTaxiCRMInterfaceRecords.zip := JsonToken.AsValue().AsText();
            if CustomerContent.Get('country', JsonToken) then TmpMyTaxiCRMInterfaceRecords.country := JsonToken.AsValue().AsText();
            if CustomerContent.Get('tele1', JsonToken) then TmpMyTaxiCRMInterfaceRecords.tele1 := JsonToken.AsValue().AsText();
            if CustomerContent.Get('email', JsonToken) then TmpMyTaxiCRMInterfaceRecords.email := JsonToken.AsValue().AsText();
            if CustomerContent.Get('contact', JsonToken) then TmpMyTaxiCRMInterfaceRecords.contact := CopyStr(JsonToken.AsValue().AsText(), 1, MaxStrLen(TmpMyTaxiCRMInterfaceRecords.contact));
            if CustomerContent.Get('vatNo', JsonToken) then TmpMyTaxiCRMInterfaceRecords.vatNo := JsonToken.AsValue().AsText();
            TmpMyTaxiCRMInterfaceRecords.Insert();
        end;
        if TmpMyTaxiCRMInterfaceRecords.FindSet then
            repeat
                bInsert := false;
                if not Customer.Get(Format(MyTaxiCRMInterfaceRecords.id)) then
                    bInsert := true
                else begin
                    if TmpMyTaxiCRMInterfaceRecords.name <> Customer.Name then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.address1 <> Customer.Address then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.city <> Customer.City then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.zip <> Customer."Post Code" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.country <> Customer."Country/Region Code" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.tele1 <> Customer."Phone No." then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.email <> Customer."E-Mail" then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.contact <> Customer.Contact then bInsert := true;
                    if TmpMyTaxiCRMInterfaceRecords.vatNo <> Customer."VAT Registration No." then bInsert := true;
                end;
                if bInsert then begin
                    LastEntryNo := 1;
                    if MyTaxiCRMInterfaceRecords.FindLast then LastEntryNo := MyTaxiCRMInterfaceRecords."Entry No.";
                    MyTaxiCRMInterfaceRecords.Init;
                    MyTaxiCRMInterfaceRecords.TransferFields(TmpMyTaxiCRMInterfaceRecords);
                    MyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo + 1;
                    LastEntryNo += 1;
                    MyTaxiCRMInterfaceRecords.Insert;
                end;
            until TmpMyTaxiCRMInterfaceRecords.Next = 0;
    end;

    procedure ImportInvoices()
    var
        TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary;
        TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary;
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob"; // Use the TempBlob codeunit
        ReadStream: InStream;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        Invoice: JsonObject;
        FileName: Text;
        LastEntryNo: Integer;
        ImportJsonFile: Label 'Select a file to import';
        FileFilterTxt: Label 'All Files(*.*)|*.*|JSON Files(*.json)|*.json';
        FileFilterExtensionTxt: Label 'json', Locked = true;
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
    begin
        // Get MyTaxi CRM Interface setup
        MyTaxiCRMInterfaceSetup.Get;
        // Prompt the user to select a JSON file
        FileName := FileMgt.BLOBImportWithFilter(TempBlob, ImportJsonFile, '', FileFilterTxt, FileFilterExtensionTxt);
        if FileName = '' then exit;
        // Create a stream from the TempBlob codeunit
        TempBlob.CreateInStream(ReadStream);
        // Parse the JSON content from the stream
        JsonObject.ReadFrom(ReadStream);
        // Validate and retrieve the invoices array
        if not JsonObject.Get('invoices', JsonToken) then Error('Invalid JSON format. "invoices" array is missing.');
        LastEntryNo := 1;
        // Process each invoice in the JSON array
        foreach JsonToken in JsonArray do begin
            Invoice := JsonToken.AsObject();
            TransfeInvJsonToTmpInv2(Invoice, TmpMyTaxiCRMInterfaceRecords, TmpMyTaxiCRMInterfSubRecords, LastEntryNo);
        end;
        // Transfer temporary records to invoice records
        TransferTmpInvToInvoiceRec(TmpMyTaxiCRMInterfaceRecords, TmpMyTaxiCRMInterfSubRecords);
    end;



    local procedure TransfeInvJsonToTmpInv2(Invoice: JsonObject; var TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary; var TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary; var LastEntryNo: Integer)
    var
        JToken: JsonToken;
        CreditList: JsonArray;
        Credit: JsonObject;
        SubLastEntryNo: Integer;
    begin
        TmpMyTaxiCRMInterfaceRecords.Init;
        TmpMyTaxiCRMInterfaceRecords."Entry No." := LastEntryNo + 1;
        LastEntryNo += 1;
        TmpMyTaxiCRMInterfaceRecords."Interface Type" := TmpMyTaxiCRMInterfaceRecords."Interface Type"::Invoice;
        /*IF Invoice.TryGetValue('id', JToken) THEN
          EVALUATE(TmpMyTaxiCRMInterfaceRecords.id,JToken.ToString);
        TmpMyTaxiCRMInterfaceRecords.countryCode := Invoice.GetValue('countyCode').ToString;
        TmpMyTaxiCRMInterfaceRecords.statusCode := Invoice.GetValue('statusCode').ToString;
        EVALUATE(TmpMyTaxiCRMInterfaceRecords.dateStatusChanged,Invoice.GetValue('dateStatusChanged').ToString);
        IF Invoice.TryGetValue('additionalInformation', JToken) THEN
          TmpMyTaxiCRMInterfaceRecords.additionalInformation := JToken.ToString;
        Invoice := Invoice.SelectToken('data');*/
        if Invoice.Get('invoiceid', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.invoiceid, JToken.AsValue().AsText());
        if Invoice.Get('externalReference', JToken) then TmpMyTaxiCRMInterfaceRecords.externalReference := JToken.AsValue().AsText();
        if Invoice.Get('invoiceType', JToken) then TmpMyTaxiCRMInterfaceRecords.invoiceType := JToken.AsValue().AsText();
        if Invoice.Get('idCustomer', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.idCustomer, JToken.AsValue().AsText());
        if Invoice.Get('dateInvoice', JToken) then begin
            TmpMyTaxiCRMInterfaceRecords.dateInvoice := JToken.AsValue().AsDate();
        end;
        if Invoice.Get('dueDate', JToken) then begin
            TmpMyTaxiCRMInterfaceRecords.dueDate := JToken.AsValue().AsDate();
        end;
        if Invoice.Get('countryCode', JToken) then TmpMyTaxiCRMInterfaceRecords.countryCode := JToken.AsValue().AsText();
        if Invoice.Get('currency', JToken) then TmpMyTaxiCRMInterfaceRecords.currency := JToken.AsValue().AsText();
        if Invoice.Get('sumNetValue', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.sumNetValue, JToken.AsValue().AsText());
            if Invoice.Get('sumTaxValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.sumTaxValue, JToken.AsValue().AsText());
            if Invoice.Get('sumGrossValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.sumGrossValue, JToken.AsValue().AsText());
        end;
        if Invoice.Get('discountCommissionNet', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionNet, JToken.AsValue().AsText());
            if Invoice.Get('discountCommissionTax', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionTax, JToken.AsValue().AsText());
            if Invoice.Get('discountCommissionGross', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.discountCommissionGross, JToken.AsValue().AsText());
        end;
        if Invoice.Get('netCommission', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.netCommission, JToken.AsValue().AsText());
            if Invoice.Get('taxCommission', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxCommission, JToken.AsValue().AsText());
            if Invoice.Get('grossCommission', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossCommission, JToken.AsValue().AsText());
        end;
        if Invoice.Get('netHotelValue', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.netHotelValue, JToken.AsValue().AsText());
            if Invoice.Get('taxHotelValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxHotelValue, JToken.AsValue().AsText());
            if Invoice.Get('grossHotelValue', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossHotelValue, JToken.AsValue().AsText());
        end;
        if Invoice.Get('netInvoicingFee', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.netInvoicingFee, JToken.AsValue().AsText());
            if Invoice.Get('taxInvoicingFee', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxInvoicingFee, JToken.AsValue().AsText());
            if Invoice.Get('grossInvoicingFee', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossInvoicingFee, JToken.AsValue().AsText());
        end;
        if Invoice.Get('netPayment', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.netPayment, JToken.AsValue().AsText());
        if Invoice.Get('netPaymentFeeMP', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.netPaymentFeeMP, JToken.AsValue().AsText());
            if Invoice.Get('taxPaymentFeeMP', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxPaymentFeeMP, JToken.AsValue().AsText());
            if Invoice.Get('grossPaymentFeeMP', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossPaymentFeeMP, JToken.AsValue().AsText());
        end;
        if Invoice.Get('netPaymentFeeBA', JToken) then begin
            Evaluate(TmpMyTaxiCRMInterfaceRecords.netPaymentFeeBA, JToken.AsValue().AsText());
            if Invoice.Get('taxPaymentFeeBA', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.taxPaymentFeeBA, JToken.AsValue().AsText());
            if Invoice.Get('grossPaymentFeeBA', JToken) then Evaluate(TmpMyTaxiCRMInterfaceRecords.grossPaymentFeeBA, JToken.AsValue().AsText());
        end;
        TmpMyTaxiCRMInterfaceRecords.Insert;
        SubLastEntryNo := 0;
        if Invoice.Get('additionalNotes', JToken) then begin
            CreditList := JToken.AsArray();
            foreach JToken in CreditList do begin
                if JToken.IsObject() then begin
                    Credit := JToken.AsObject();
                    TmpMyTaxiCRMInterfSubRecords.Init;
                    TmpMyTaxiCRMInterfSubRecords."Records Entry No." := TmpMyTaxiCRMInterfaceRecords."Entry No.";
                    TmpMyTaxiCRMInterfSubRecords."Entry No." := SubLastEntryNo + 1;
                    SubLastEntryNo += 1;
                    TmpMyTaxiCRMInterfSubRecords.invoiceid := TmpMyTaxiCRMInterfaceRecords.invoiceid;
                    if Credit.Get('typeOfAdditionalNote', JToken) then TmpMyTaxiCRMInterfSubRecords.typeOfAdditionalNote := JToken.AsValue().AsText();
                    if Credit.Get('accountNumber', JToken) then TmpMyTaxiCRMInterfSubRecords.accountNumber := JToken.AsValue().AsText();
                    if Credit.Get('netCredit', JToken) then begin
                        Evaluate(TmpMyTaxiCRMInterfSubRecords.netCredit, JToken.AsValue().AsText());
                        if Invoice.Get('taxCredit', JToken) then Evaluate(TmpMyTaxiCRMInterfSubRecords.taxCredit, JToken.AsValue().AsText());
                        if Invoice.Get('grossCredit', JToken) then Evaluate(TmpMyTaxiCRMInterfSubRecords.grossCredit, JToken.AsValue().AsText());
                    end;
                    TmpMyTaxiCRMInterfSubRecords.Insert;
                end;
            end;
        end;
    end;

    local procedure TransferTmpInvToInvoiceRec2(var TmpMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records" temporary; var TmpMyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records" temporary)
    var
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        LastEntryNo: Integer;
        bInsert: Boolean;
    begin
        LastEntryNo := 1;
        if TmpMyTaxiCRMInterfSubRecords.FindSet() then
            repeat
                MyTaxiCRMInterfaceRecords.Reset();
                MyTaxiCRMInterfaceRecords.SetRange(invoiceid, TmpMyTaxiCRMInterfSubRecords.invoiceid);
                MyTaxiCRMInterfaceRecords.FindFirst();
                MyTaxiCRMInterfSubRecords.Reset();
                MyTaxiCRMInterfSubRecords.SetRange("Records Entry No.", MyTaxiCRMInterfaceRecords."Entry No.");
                MyTaxiCRMInterfSubRecords.SetRange("Entry No.", TmpMyTaxiCRMInterfSubRecords."Entry No.");
                MyTaxiCRMInterfSubRecords.TransferFields(TmpMyTaxiCRMInterfSubRecords);
                MyTaxiCRMInterfSubRecords."Records Entry No." := MyTaxiCRMInterfaceRecords."Entry No.";
                if not MyTaxiCRMInterfSubRecords.Insert() then
                    MyTaxiCRMInterfSubRecords.Modify();
            until TmpMyTaxiCRMInterfSubRecords.Next() = 0;
    end;

    procedure CallRESTWebService(var Parameters: Dictionary of [Text, Text]; var HttpResponseMessage: HttpResponseMessage)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpContent: HttpContent;
        JsonBody: Text;
        BaseUrl: Text;
        Path: Text;
        RestMethod: Text;
        Username: Text;
        Password: Text;
        FullUrl: Text;
        ResponseText: Text;
        StatusCode: Integer;
        Convert: Codeunit "Base64 Convert";
        HttpHeaders: HttpHeaders;
    begin
        // Extract parameters
        if not Parameters.Get('baseurl', BaseUrl) then Error('Base URL is required.');
        if not Parameters.Get('path', Path) then Error('Path is required.');
        if not Parameters.Get('restmethod', RestMethod) then Error('REST method is required.');
        FullUrl := BaseUrl + Path;
        // Initialize HttpClient (No need for HttpClient.HttpClient())
        HttpClient := HttpClient; // Simply use the HttpClient type
        // Set common headers
        if Parameters.Get('accept', JsonBody) then HttpClient.DefaultRequestHeaders.Add('Accept', JsonBody);
        // Set Authorization header for Basic Auth if username/password are provided
        if Parameters.Get('username', Username) and Parameters.Get('password', Password) then begin
            // Directly add Authorization header with username and password
            HttpClient.DefaultRequestHeaders.Add('Authorization', 'Basic ' + Convert.ToBase64(Username + ':' + Password));
        end;
        // Initialize HttpRequestMessage and set URL
        HttpRequestMessage.SetRequestUri(FullUrl);
        // Handle HTTP method
        case RestMethod of
            'GET':
                HttpRequestMessage.Method := 'GET';
            'POST':
                HttpRequestMessage.Method := 'POST';
            'PUT':
                HttpRequestMessage.Method := 'PUT';
            'PATCH':
                HttpRequestMessage.Method := 'PATCH';
            'DELETE':
                HttpRequestMessage.Method := 'DELETE';
            else
                Error('Invalid REST method: %1', RestMethod);
        end;
        // Add content if necessary for methods like POST, PUT, PATCH
        if RestMethod in ['POST', 'PUT', 'PATCH'] then begin
            if Parameters.Get('httpcontent', JsonBody) then begin
                HttpContent.WriteFrom(JsonBody);
                HttpContent.GetHeaders(HttpHeaders);
                HttpHeaders.Remove('Content-Type');
                HttpHeaders.Add('Content-Type', 'application/json');
                HttpRequestMessage.Content := HttpContent;
            end
            else
                Error('HTTP content is required for %1 method.', RestMethod);
        end;
        // Send the HTTP request and get the response
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then Error('Failed to send HTTP request.');
        // Check response status
        StatusCode := HttpResponseMessage.HttpStatusCode;
        if not HttpResponseMessage.IsSuccessStatusCode() then Error('HTTP request failed with status code %1.', StatusCode);
        // Process the response
        HttpResponseMessage.Content().ReadAs(ResponseText);
        // Further processing of the response can be done here as needed
    end;
}

