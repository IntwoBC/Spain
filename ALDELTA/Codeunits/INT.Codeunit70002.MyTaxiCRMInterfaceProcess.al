codeunit 70002 "MyTaxi CRM Interface Process"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Codeunit Creation
    // #MyTaxi.W1.CRE.INT01.007 02/10/2017 CCFR.SDE : Bug fixing
    //   Wrong VAT Difference calculation formula on invoice/credit note
    // #MyTaxi.W1.CRE.INT01.008 22/11/2017 CCFR.SDE : New request
    //   Credit Note creation without invoice : Do not set the applyment information
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : New request
    //   Update bank details on customers
    // #MyTaxi.W1.CRE.INT01.011 18/05/2018 CCFR.SDE : New request
    //   Set the cost center 2 dimension on sales header
    // #MyTaxi.W1.CRE.INT01.012 18/05/2018 CCFR.SDE : New request
    //   Set a default value in field "Reminder Terms Code" when a customer is created
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New request
    //   Save the InvoiceDate in a new field "NAV Document Date" and assign to "Document Date" on the sales invoice/credit memo
    //   Retreive the payment method from the CRM App
    //   Post the payment with the Invoice Date from the CRM App record
    // #MyTaxi.W1.CRE.INT01.014 21/12/2018 CCFR.SDE : New request
    //   Handle negative NetPayments as refunds
    // #MyTaxi.W1.CRE.INT01.015 26/12/2018 CCFR.SDE : New request
    //   Follow the posting process of Invoice/Credit Memo/Payment
    // #MyTaxi.ES.CRE.INT01.001 07/02/2019 CCFR.SDE : New request
    //   Do not show the confirmation dialog related to spanish localization "Corrected Invoice No."
    // #MyTaxi.W1.CRE.INT01.016 15/02/2019 CCFR.SDE : Bug fixing
    //   Wrong VAT Difference calculation in case of multiple VAT identifier
    // #MyTaxi.W1.CRE.INT01.017 25/03/2019 CCFR.SDE : New request
    //   Retreive the cost center 2 from the customer master data
    // #MyTaxi.W1.ISS.000078616 26/02/2020 CCFR.SDE : Change Request (Ticket 78616 Blocking check on Additional Note Setup)
    //   Modified functions : CreateSalesInvoice, CreateSalesCrMemo


    trigger OnRun()
    begin
        case InterfaceType of
            InterfaceType::Customers:
                begin
                    CreateCustomers(MyTaxiCRMInterfaceRecords);
                    exit;
                end;
            InterfaceType::"Sales Invoice":
                begin
                    CreateSalesInvoice(MyTaxiCRMInterfaceRecords);
                    exit;
                end;
        end;
    end;

    var
        MyTaxiCRMIntPostingSetup: Record "MyTaxi CRM Int. Posting Setup";
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        VATPostingSetup: Record "VAT Posting Setup";
        InterfaceType: Option " ",Customers,"Sales Invoice";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;//NoSeriesManagement;//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
        LastLine: Integer;
        InvoiceAmount: Decimal;
        CreditMemoAmount: Decimal;
        "--- MyTaxi.W1.CRE.INT01.001 ---": Integer;
        MyTaxiCRMIntPostingMap: Record "MyTaxi CRM Int. Posting Map.";
        "--- MyTaxi.W1.CRE.INT01.008 ---": Integer;
        bInvoiceExist: Boolean;
        "--- Var.MyTaxi.W1.CRE.INT01.011 ---": Integer;
        HasGotGLSetup: Boolean;
        GLSetupShortcutDimCode: array[8] of Code[20];
        //  "--- Cons.MyTaxi.W1.CRE.INT01.011 ---": ;
        Err70000: Label 'Cost Center 2 mapping was not found. Code %1 is not set up in table "%2" field "%3". ';


    procedure SetParams(pInterfaceType: Option " ",Customers,"Sales Invoice"; var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    begin
        InterfaceType := pInterfaceType;
        MyTaxiCRMInterfaceRecords := pMyTaxiCRMInterfaceRecords;
    end;


    procedure CreateCustomers(var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        Customer: Record Customer;
        TemplateHeader: Record "Config. Template Header";
        TemplateMgt: Codeunit "Config. Template Management";
        "--- MyTaxi.W1.CRE.INT01.009 ---": Integer;
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        if MyTaxiCRMInterfaceRecords."Interface Type" <> MyTaxiCRMInterfaceRecords."Interface Type"::Customer then
            exit;
        if not Customer.Get(pMyTaxiCRMInterfaceRecords.id) then begin
            Customer.Init();
            Customer.Validate("No.", Format(pMyTaxiCRMInterfaceRecords.id));
            Customer.Insert(true);
        end;
        Customer.Validate(Name, CopyStr(pMyTaxiCRMInterfaceRecords.name, 1, MaxStrLen(Customer.Name)));
        Customer.Validate("Name 2", CopyStr(pMyTaxiCRMInterfaceRecords.name, 51, MaxStrLen(Customer."Name 2")));
        Customer.Validate(Address, CopyStr(pMyTaxiCRMInterfaceRecords.address1, 1, MaxStrLen(Customer.Address)));
        Customer.Validate("Address 2", CopyStr(pMyTaxiCRMInterfaceRecords.address1, 51, MaxStrLen(Customer."Address 2")));
        // MyTaxi.W1.CRE.INT01.001 <<
        /*
        IF Customer.Contact<>pMyTaxiCRMInterfaceRecords.contact THEN
          IF STRLEN(DELCHR(pMyTaxiCRMInterfaceRecords.contact, '=', DELCHR(pMyTaxiCRMInterfaceRecords.contact,'=', ' ')))=1 THEN
            Customer.VALIDATE(Contact,pMyTaxiCRMInterfaceRecords.contact)
          ELSE
            Customer.Contact := pMyTaxiCRMInterfaceRecords.contact;
        Customer.VALIDATE("Phone No.",pMyTaxiCRMInterfaceRecords.tele1);
        Customer."VAT Registration No." := pMyTaxiCRMInterfaceRecords.vatNo;
        Customer.VALIDATE("E-Mail",pMyTaxiCRMInterfaceRecords.email);
        Customer.VALIDATE("Post Code",pMyTaxiCRMInterfaceRecords.zip);
        Customer.VALIDATE(City,pMyTaxiCRMInterfaceRecords.city);
        Customer.VALIDATE("Country/Region Code",pMyTaxiCRMInterfaceRecords.country);
        */
        if Customer.Contact <> pMyTaxiCRMInterfaceRecords.contact then
            if StrLen(DelChr(pMyTaxiCRMInterfaceRecords.contact, '=', DelChr(pMyTaxiCRMInterfaceRecords.contact, '=', ' '))) = 1 then
                Customer.Validate(Contact, CopyStr(pMyTaxiCRMInterfaceRecords.contact, 1, MaxStrLen(Customer.Contact)))
            else
                Customer.Contact := CopyStr(pMyTaxiCRMInterfaceRecords.contact, 1, MaxStrLen(Customer.Contact));
        Customer.Validate("Phone No.", CopyStr(pMyTaxiCRMInterfaceRecords.tele1, 1, MaxStrLen(Customer."Phone No.")));
        Customer."VAT Registration No." := CopyStr(pMyTaxiCRMInterfaceRecords.vatNo, 1, MaxStrLen(Customer."VAT Registration No."));
        Customer.Validate("E-Mail", CopyStr(pMyTaxiCRMInterfaceRecords.email, 1, MaxStrLen(Customer."E-Mail")));
        Customer.Validate("Post Code", CopyStr(pMyTaxiCRMInterfaceRecords.zip, 1, MaxStrLen(Customer."Post Code")));
        Customer.Validate(City, CopyStr(pMyTaxiCRMInterfaceRecords.city, 1, MaxStrLen(Customer.City)));
        Customer.Validate("Country/Region Code", CopyStr(pMyTaxiCRMInterfaceRecords.country, 1, MaxStrLen(Customer."Country/Region Code")));
        // MyTaxi.W1.CRE.INT01.001 >>
        // MyTaxi.W1.CRE.INT01.009 <<
        if pMyTaxiCRMInterfaceRecords."NAV Bank Account Code" <> '' then begin
            if not CustomerBankAccount.Get(Customer."No.", pMyTaxiCRMInterfaceRecords."NAV Bank Account Code") then begin
                CustomerBankAccount.Validate("Customer No.", Customer."No.");
                CustomerBankAccount.Validate(Code, pMyTaxiCRMInterfaceRecords."NAV Bank Account Code");
                CustomerBankAccount.Insert(true);
            end;
            if CopyStr(pMyTaxiCRMInterfaceRecords.accountHolder, 1, MaxStrLen(CustomerBankAccount.Contact)) <> CustomerBankAccount.Contact then
                CustomerBankAccount.Validate(Contact, CopyStr(pMyTaxiCRMInterfaceRecords.accountHolder, 1, MaxStrLen(CustomerBankAccount.Contact)));
            if pMyTaxiCRMInterfaceRecords.iban <> CustomerBankAccount.IBAN then
                CustomerBankAccount.Validate(IBAN, pMyTaxiCRMInterfaceRecords.iban);
            if pMyTaxiCRMInterfaceRecords.bic <> CustomerBankAccount."SWIFT Code" then
                CustomerBankAccount.Validate("SWIFT Code", pMyTaxiCRMInterfaceRecords.bic);
            if pMyTaxiCRMInterfaceRecords.bankAccountNumber <> CustomerBankAccount."Bank Account No." then
                CustomerBankAccount.Validate("Bank Account No.", pMyTaxiCRMInterfaceRecords.bankAccountNumber);
            if pMyTaxiCRMInterfaceRecords.sortCode <> CustomerBankAccount."Bank Branch No." then
                CustomerBankAccount.Validate("Bank Branch No.", pMyTaxiCRMInterfaceRecords.sortCode);
            CustomerBankAccount.Modify(true);
            // Customer.VALIDATE("Preferred Bank Account",CustomerBankAccount.Code);
        end;
        // MyTaxi.W1.CRE.INT01.009 >>
        // MyTaxi.W1.CRE.INT01.017 <<
        SetDimensionsOnCustomer(Customer, pMyTaxiCRMInterfaceRecords);
        // MyTaxi.W1.CRE.INT01.017 >>
        Customer."Last Date Modified" := Today;
        Customer.Modify(true);
        pMyTaxiCRMInterfaceRecords."Transfer Date" := Today;
        pMyTaxiCRMInterfaceRecords."Transfer Time" := Time;
        pMyTaxiCRMInterfaceRecords.Modify();

    end;


    procedure CreateSalesInvoice(var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TmpSalesHeader: Record "Sales Header" temporary;
        Customer: Record Customer;
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
        GenJnlLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        LastLineNo: Integer;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        "--- MyTaxi.W1.CRE.INT01.001 ---": Integer;
        TotalTaxAmount: Decimal;
        TotalGrossAmount: Decimal;
        TotalNetAmount: Decimal;
        "--- MyTaxi.W1.CRE.INT01.013 ---": Integer;
        PaymentMethod: Record "Payment Method";
    begin
        pMyTaxiCRMInterfaceRecords.TestField("Transfer Date", 0D);
        pMyTaxiCRMInterfaceRecords.TestField("Process Status", pMyTaxiCRMInterfaceRecords."Process Status"::" ");
        InvoiceAmount := 0;
        // MyTaxi.W1.CRE.INT01.001 <<
        TotalTaxAmount := 0;
        TotalGrossAmount := 0;
        TotalNetAmount := 0;
        // MyTaxi.W1.CRE.INT01.001 >>
        // MyTaxi.W1.CRE.INT01.008 <<
        bInvoiceExist := false;
        // MyTaxi.W1.CRE.INT01.008 >>
        MyTaxiCRMIntPostingSetup.Get(pMyTaxiCRMInterfaceRecords.invoiceType);
        Customer.Get(Format(pMyTaxiCRMInterfaceRecords.idCustomer));

        if Customer."Gen. Bus. Posting Group" = '' then begin
            Customer.Validate("Gen. Bus. Posting Group", MyTaxiCRMIntPostingSetup."Gen. Bus. Posting Group");
            Customer.Modify(true);
        end;

        if Customer."Customer Posting Group" = '' then begin
            Customer.Validate("Customer Posting Group", MyTaxiCRMIntPostingSetup."Customer Posting Group");
            Customer.Modify(true);
        end;

        // MyTaxi.W1.CRE.INT01.012 <<
        if Customer."Reminder Terms Code" = '' then begin
            Customer.Validate("Reminder Terms Code", MyTaxiCRMIntPostingSetup."Default Cust. Rem. Terms Code");
            Customer.Modify(true);
        end;
        // MyTaxi.W1.CRE.INT01.012 >>

        if not SalesInvoiceHeader.Get(pMyTaxiCRMInterfaceRecords.externalReference) then begin
            SalesHeader.Init();
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."No." := pMyTaxiCRMInterfaceRecords.externalReference;
            SalesHeader.Insert(true);
            // MyTaxi.W1.CRE.INT01.003 <<
            //SalesHeader."Posting No." :=  pMyTaxiCRMInterfaceRecords.externalReference;
            // MyTaxi.W1.CRE.INT01.003 >>
            SalesHeader.Validate("Sell-to Customer No.", Format(pMyTaxiCRMInterfaceRecords.idCustomer));
            SalesHeader."Your Reference" := Format(pMyTaxiCRMInterfaceRecords.invoiceid);
            SalesHeader.Validate("Posting Date", pMyTaxiCRMInterfaceRecords.dateInvoice);
            // MyTaxi.W1.CRE.INT01.013 <<
            SalesHeader.Validate("Document Date", pMyTaxiCRMInterfaceRecords."NAV Document Date");
            if (pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod <> '') and
               PaymentMethod.Get(pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod)
            then
                SalesHeader.Validate("Payment Method Code", pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod);
            // MyTaxi.W1.CRE.INT01.013 >>
            // MyTaxi.W1.CRE.INT01.003 <<
            SalesHeader."Posting No." := pMyTaxiCRMInterfaceRecords.externalReference;
            // MyTaxi.W1.CRE.INT01.003 >>
            // MyTaxi.W1.CRE.INT01.005 <<
            SalesHeader."Due Date" := pMyTaxiCRMInterfaceRecords.dueDate;
            // MyTaxi.W1.CRE.INT01.005 >>
            // MyTaxi.W1.CRE.INT01.011 <<
            // MyTaxi.W1.CRE.INT01.017 <<
            //SetDimensionsOnSalesHeader(SalesHeader,pMyTaxiCRMInterfaceRecords);
            // MyTaxi.W1.CRE.INT01.017 >>
            // MyTaxi.W1.CRE.INT01.011 >>
            SalesHeader.Modify(false);
            LastLineNo := 10000;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.discountCommissionNet<>0) AND (MyTaxiCRMIntPostingSetup."Discount Commission GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.discountCommissionNet <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Discount Commission GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.discountCommissionTax;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.discountCommissionGross;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.discountCommissionNet;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Discount Commission GL Account",
                                        MyTaxiCRMIntPostingSetup."Disc. Com. VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.discountCommissionNet);
            end;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.netCommission<>0) AND (MyTaxiCRMIntPostingSetup."Commission GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.netCommission <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Commission GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.taxCommission;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.grossCommission;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.netCommission;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Commission GL Account",
                                        MyTaxiCRMIntPostingSetup."Commission VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.netCommission);
            end;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.netHotelValue<>0) AND (MyTaxiCRMIntPostingSetup."Hotel Value GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.netHotelValue <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Hotel Value GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.taxHotelValue;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.grossHotelValue;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.netHotelValue;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Hotel Value GL Account",
                                        MyTaxiCRMIntPostingSetup."Hotel Val VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.netHotelValue);
            end;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.netInvoicingFee<>0) AND (MyTaxiCRMIntPostingSetup."Invoicing Fee GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.netInvoicingFee <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Invoicing Fee GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.taxInvoicingFee;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.grossInvoicingFee;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.netInvoicingFee;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Invoicing Fee GL Account",
                                        MyTaxiCRMIntPostingSetup."Inv Fee VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.netInvoicingFee);
            end;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.netPaymentFeeMP<>0) AND (MyTaxiCRMIntPostingSetup."Payment Fee MP GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.netPaymentFeeMP <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Payment Fee MP GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.taxPaymentFeeMP;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.grossPaymentFeeMP;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.netPaymentFeeMP;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Payment Fee MP GL Account",
                                        MyTaxiCRMIntPostingSetup."Pay Fee MP VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.netPaymentFeeMP);
            end;
            // MyTaxi.W1.ISS.000078616 <<
            //IF (pMyTaxiCRMInterfaceRecords.netPaymentFeeBA<>0) AND (MyTaxiCRMIntPostingSetup."Payment Fee BA GL Account"<>'') THEN BEGIN
            if (pMyTaxiCRMInterfaceRecords.netPaymentFeeBA <> 0) then begin
                MyTaxiCRMIntPostingSetup.TestField("Payment Fee BA GL Account");
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                TotalTaxAmount += pMyTaxiCRMInterfaceRecords.taxPaymentFeeBA;
                TotalGrossAmount += pMyTaxiCRMInterfaceRecords.grossPaymentFeeBA;
                TotalNetAmount += pMyTaxiCRMInterfaceRecords.netPaymentFeeBA;
                // MyTaxi.W1.CRE.INT01.001 >>
                CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Payment Fee BA GL Account",
                                        MyTaxiCRMIntPostingSetup."Pay Fee BA VAT Prod Post Group", pMyTaxiCRMInterfaceRecords.netPaymentFeeBA);
            end;
            // MyTaxi.W1.CRE.INT01.001 <<
            MyTaxiCRMInterfSubRecords.Reset();
            MyTaxiCRMInterfSubRecords.SetRange("Records Entry No.", pMyTaxiCRMInterfaceRecords."Entry No.");
            if MyTaxiCRMInterfSubRecords.FindSet() then
                repeat
                    // MyTaxi.W1.ISS.000078616 <<
                    MyTaxiCRMIntPostingMap.Get(MyTaxiCRMIntPostingSetup."Invoice Type", MyTaxiCRMInterfSubRecords.accountNumber);
                    // MyTaxi.W1.ISS.000078616 >>
                    if (MyTaxiCRMInterfSubRecords.netCredit <> 0) and
                         // MyTaxi.W1.ISS.000078616 <<
                         //MyTaxiCRMIntPostingMap.GET(MyTaxiCRMIntPostingSetup."Invoice Type",MyTaxiCRMInterfSubRecords.accountNumber) AND
                         // MyTaxi.W1.ISS.000078616 >>
                         ((MyTaxiCRMIntPostingMap."Document Type" = MyTaxiCRMIntPostingMap."Document Type"::Invoice) or
                         // MyTaxi.W1.CRE.INT01.002 <<
                         (MyTaxiCRMInterfSubRecords.netCredit < 0)) then
                    // MyTaxi.W1.CRE.INT01.002 >>
                    begin
                        // MyTaxi.W1.CRE.INT01.002 <<
                        if (MyTaxiCRMInterfSubRecords.netCredit < 0) then
                            MyTaxiCRMInterfSubRecords.netCredit := -MyTaxiCRMInterfSubRecords.netCredit;
                        if (MyTaxiCRMInterfSubRecords.taxCredit < 0) then
                            MyTaxiCRMInterfSubRecords.taxCredit := -MyTaxiCRMInterfSubRecords.taxCredit;
                        // MyTaxi.W1.CRE.INT01.002 >>
                        TotalTaxAmount += MyTaxiCRMInterfSubRecords.taxCredit;
                        TotalGrossAmount += MyTaxiCRMInterfSubRecords.grossCredit;
                        TotalNetAmount += MyTaxiCRMInterfSubRecords.netCredit;
                        CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingMap."GL Account",
                                                MyTaxiCRMIntPostingMap."VAT Product Posting Group", MyTaxiCRMInterfSubRecords.netCredit);
                    end;
                until MyTaxiCRMInterfSubRecords.Next() = 0;
            // MyTaxi.W1.CRE.INT01.001 >>
            if (pMyTaxiCRMInterfaceRecords.sumNetValue <> 0) and (MyTaxiCRMIntPostingSetup."Sum Gross Value GL Account" <> '') then begin
                VATPostingSetup.Get(SalesInvoiceHeader."VAT Bus. Posting Group", MyTaxiCRMIntPostingSetup."Sum Gross Value VAT Grp");
                if VATPostingSetup."VAT %" <> 0 then begin
                    // MyTaxi.W1.CRE.INT01.001 <<
                    TotalTaxAmount += pMyTaxiCRMInterfaceRecords.sumTaxValue;
                    // MyTaxi.W1.CRE.INT01.001 >>
                    CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Sum Gross Value GL Account",
                                            MyTaxiCRMIntPostingSetup."Sum Gross Value VAT Grp", pMyTaxiCRMInterfaceRecords.sumNetValue - TotalNetAmount)
                end
                else
                    CreateSalesInvoiceLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingSetup."Sum Gross Value GL Account",
                                            MyTaxiCRMIntPostingSetup."Sum Gross Value VAT Grp", pMyTaxiCRMInterfaceRecords.sumGrossValue - TotalGrossAmount);
            end;

            SalesLine.CalcVATAmountLines(1, SalesHeader, SalesLine, TempVATAmountLine);
            // MyTaxi.W1.CRE.INT01.001 <<
            // MyTaxi.W1.CRE.INT01.016 <<
            //IF (TotalTaxAmount-TempVATAmountLine."VAT Amount"<>0) THEN
            if (TotalTaxAmount - TempVATAmountLine.GetTotalVATAmount() <> 0) then
            // MyTaxi.W1.CRE.INT01.016 >>
            //IF (pMyTaxiCRMInterfaceRecords.sumTaxValue-TempVATAmountLine."VAT Amount"<>0) AND bVATCalculation THEN
            // MyTaxi.W1.CRE.INT01.001 >>
              begin
                // MyTaxi.W1.CRE.INT01.007 <<
                //TempVATAmountLine.VALIDATE("VAT Difference",pMyTaxiCRMInterfaceRecords.sumTaxValue-TempVATAmountLine."VAT Amount");
                // MyTaxi.W1.CRE.INT01.016 <<
                //TempVATAmountLine.VALIDATE("VAT Difference",TotalTaxAmount-TempVATAmountLine."VAT Amount");
                TempVATAmountLine.Validate("VAT Difference", TotalTaxAmount - TempVATAmountLine.GetTotalVATAmount());
                // MyTaxi.W1.CRE.INT01.016 >>
                // MyTaxi.W1.CRE.INT01.007 >>
                TempVATAmountLine.Modify();
                SalesLine.UpdateVATOnLines(1, SalesHeader, SalesLine, TempVATAmountLine);
            end;
            TmpSalesHeader.Init();
            TmpSalesHeader.TransferFields(SalesHeader);
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if not SalesLine.FindFirst() then begin
                // MyTaxi.W1.CRE.INT01.006 <<
                SalesHeader."Posting No." := '';
                SalesHeader.Modify(false);
                // MyTaxi.W1.CRE.INT01.006 >>
                SalesHeader.Delete(true);
            end
            else begin
                Clear(ReleaseSalesDocument);
                ReleaseSalesDocument.Run(SalesHeader);
                SalesHeader.CalcFields("Amount Including VAT");
                InvoiceAmount := SalesHeader."Amount Including VAT";
                // MyTaxi.W1.CRE.INT01.008 <<
                bInvoiceExist := true;
                // MyTaxi.W1.CRE.INT01.008 >>
                // MyTaxi.W1.CRE.INT01.015 <<
                pMyTaxiCRMInterfaceRecords."NAV Invoice Status" := pMyTaxiCRMInterfaceRecords."NAV Invoice Status"::Created;
                pMyTaxiCRMInterfaceRecords.Modify();
                // MyTaxi.W1.CRE.INT01.015 >>
                if MyTaxiCRMIntPostingSetup."Automatic Posting" then begin
                    SalesHeader.Ship := true;
                    SalesHeader.Invoice := true;
                    Clear(SalesPost);
                    // MyTaxi.W1.CRE.INT01.015 <<
                    pMyTaxiCRMInterfaceRecords."NAV Invoice Status" := pMyTaxiCRMInterfaceRecords."NAV Invoice Status"::Posted;
                    pMyTaxiCRMInterfaceRecords.Modify();
                    // MyTaxi.W1.CRE.INT01.015 >>
                    SalesPost.Run(SalesHeader);
                end;
            end;
        end
        else begin
            TmpSalesHeader.Init();
            TmpSalesHeader.TransferFields(SalesInvoiceHeader);
            SalesInvoiceHeader.CalcFields("Amount Including VAT");
            InvoiceAmount := SalesInvoiceHeader."Amount Including VAT";
            // MyTaxi.W1.CRE.INT01.015 <<
            pMyTaxiCRMInterfaceRecords."NAV Invoice Status" := pMyTaxiCRMInterfaceRecords."NAV Invoice Status"::Posted;
            pMyTaxiCRMInterfaceRecords.Modify();
            // MyTaxi.W1.CRE.INT01.015 >>
        end;

        if not SalesCrMemoHeader.Get(pMyTaxiCRMInterfaceRecords.externalReference) then begin
            MyTaxiCRMInterfSubRecords.Reset();
            MyTaxiCRMInterfSubRecords.SetRange(MyTaxiCRMInterfSubRecords."Records Entry No.", pMyTaxiCRMInterfaceRecords."Entry No.");
            if MyTaxiCRMInterfSubRecords.FindSet() then
                CreateSalesCrMemo(pMyTaxiCRMInterfaceRecords);
        end
        else begin
            SalesCrMemoHeader.CalcFields("Amount Including VAT");
            CreditMemoAmount := SalesCrMemoHeader."Amount Including VAT";
            // MyTaxi.W1.CRE.INT01.015 <<
            pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status" := pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status"::Posted;
            pMyTaxiCRMInterfaceRecords.Modify();
            // MyTaxi.W1.CRE.INT01.015 >>
        end;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", Format(pMyTaxiCRMInterfaceRecords.idCustomer));
        CustLedgerEntry.SetRange("Posting Date", pMyTaxiCRMInterfaceRecords.dateInvoice);
        CustLedgerEntry.SetRange("External Document No.", pMyTaxiCRMInterfaceRecords.externalReference);
        // MyTaxi.W1.CRE.INT01.014 <<
        if pMyTaxiCRMInterfaceRecords.netPayment > 0 then
            // MyTaxi.W1.CRE.INT01.014 >>
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Payment)
        // MyTaxi.W1.CRE.INT01.014 <<
        else
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Refund);
        // MyTaxi.W1.CRE.INT01.014 >>
        if not CustLedgerEntry.FindFirst() then begin
            LastLine := 10000;
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Template Name");
            GenJnlLine.SetRange("Journal Batch Name", MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Batch Name");
            GenJnlLine.SetRange("External Document No.", pMyTaxiCRMInterfaceRecords.externalReference);
            GenJnlLine.DeleteAll();
            GenJnlLine.SetRange("External Document No.");
            if GenJnlLine.FindLast() then
                LastLine := GenJnlLine."Line No.";
            if pMyTaxiCRMInterfaceRecords.netPayment <> 0 then begin
                // MyTaxi.W1.CRE.INT01.013 <<
                //PostNetPaymentAndPayoutEntry(TmpSalesHeader,-pMyTaxiCRMInterfaceRecords.netPayment,InvoiceAmount-CreditMemoAmount>0);
                PostNetPaymentAndPayoutEntry(TmpSalesHeader, -pMyTaxiCRMInterfaceRecords.netPayment, InvoiceAmount - CreditMemoAmount > 0, pMyTaxiCRMInterfaceRecords.dateInvoice);
                // MyTaxi.W1.CRE.INT01.013 >>
                // MyTaxi.W1.CRE.INT01.015 <<
                pMyTaxiCRMInterfaceRecords."NAV Payment Status" := pMyTaxiCRMInterfaceRecords."NAV Payment Status"::Created;
                pMyTaxiCRMInterfaceRecords.Modify();
                // MyTaxi.W1.CRE.INT01.015 >>
            end;
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Template Name");
            GenJnlLine.SetRange("Journal Batch Name", MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Batch Name");
            GenJnlLine.SetRange("External Document No.", pMyTaxiCRMInterfaceRecords.externalReference);
            if MyTaxiCRMIntPostingSetup."Auto-Post Payment Journal" then
                if GenJnlLine.FindFirst() then begin
                    // MyTaxi.W1.CRE.INT01.015 <<
                    pMyTaxiCRMInterfaceRecords."NAV Payment Status" := pMyTaxiCRMInterfaceRecords."NAV Payment Status"::Posted;
                    pMyTaxiCRMInterfaceRecords.Modify();
                    // MyTaxi.W1.CRE.INT01.015 >>
                    GenJnlPostBatch.Run(GenJnlLine);
                end;
        end
        // MyTaxi.W1.CRE.INT01.015 <<
        else begin
            pMyTaxiCRMInterfaceRecords."NAV Payment Status" := pMyTaxiCRMInterfaceRecords."NAV Payment Status"::Posted;
            pMyTaxiCRMInterfaceRecords.Modify();
        end;
        // MyTaxi.W1.CRE.INT01.015 >>

        if MyTaxiCRMIntPostingSetup."Automatic Posting" then
            pMyTaxiCRMInterfaceRecords.statusCode := 'DONE'
        else
            pMyTaxiCRMInterfaceRecords.statusCode := 'OPEN';
        pMyTaxiCRMInterfaceRecords.dateStatusChanged := CurrentDateTime;
        pMyTaxiCRMInterfaceRecords."Send Update" := true;
        pMyTaxiCRMInterfaceRecords."Transfer Date" := Today;
        pMyTaxiCRMInterfaceRecords."Transfer Time" := Time;
        pMyTaxiCRMInterfaceRecords.Modify();
    end;


    procedure CreateSalesInvoiceLine(pSalesHeader: Record "Sales Header"; var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records"; var pLastLineNo: Integer; GLAccountNo: Code[20]; VATProdPostGroup: Code[10]; LineAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := pSalesHeader."Document Type";
        SalesLine."Document No." := pSalesHeader."No.";
        SalesLine."Line No." := pLastLineNo + 10000;
        pLastLineNo += 10000;
        SalesLine.Insert(true);
        SalesLine.Type := SalesLine.Type::"G/L Account";
        SalesLine.Validate("No.", GLAccountNo);
        SalesLine.Validate("VAT Prod. Posting Group", VATProdPostGroup);
        if LineAmount < 0 then
            SalesLine.Validate(Quantity, -1)
        else
            SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", LineAmount);
        SalesLine.Modify(false);
    end;


    procedure CreateSalesCrMemo(var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        LastLineNo: Integer;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
        TotalTaxAmount: Decimal;
        "--- MyTaxi.W1.CRE.INT01.013 ---": Integer;
        PaymentMethod: Record "Payment Method";
    begin
        pMyTaxiCRMInterfaceRecords.TestField("Transfer Date", 0D);
        pMyTaxiCRMInterfaceRecords.TestField("Process Status", pMyTaxiCRMInterfaceRecords."Process Status"::" ");
        CreditMemoAmount := 0;
        TotalTaxAmount := 0;
        MyTaxiCRMIntPostingSetup.Get(pMyTaxiCRMInterfaceRecords.invoiceType);
        Customer.Get(Format(pMyTaxiCRMInterfaceRecords.idCustomer));

        if Customer."Gen. Bus. Posting Group" = '' then begin
            Customer.Validate("Gen. Bus. Posting Group", MyTaxiCRMIntPostingSetup."Gen. Bus. Posting Group");
            Customer.Modify(true);
        end;

        if Customer."Customer Posting Group" = '' then begin
            Customer.Validate("Customer Posting Group", MyTaxiCRMIntPostingSetup."Customer Posting Group");
            Customer.Modify(true);
        end;

        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader."No." := pMyTaxiCRMInterfaceRecords.externalReference;
        SalesHeader.Insert(true);
        // MyTaxi.W1.CRE.INT01.003 <<
        //SalesHeader."Posting No." :=  pMyTaxiCRMInterfaceRecords.externalReference;
        // MyTaxi.W1.CRE.INT01.003 >>
        SalesHeader.Validate("Sell-to Customer No.", Format(pMyTaxiCRMInterfaceRecords.idCustomer));
        SalesHeader."Your Reference" := Format(pMyTaxiCRMInterfaceRecords.invoiceid);
        SalesHeader.Validate("Posting Date", pMyTaxiCRMInterfaceRecords.dateInvoice);
        // MyTaxi.W1.CRE.INT01.013 <<
        SalesHeader.Validate("Document Date", pMyTaxiCRMInterfaceRecords."NAV Document Date");
        if (pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod <> '') and
            PaymentMethod.Get(pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod)
        then
            SalesHeader.Validate("Payment Method Code", pMyTaxiCRMInterfaceRecords.businessAccountPaymentMethod);
        // MyTaxi.W1.CRE.INT01.013 >>
        // MyTaxi.W1.CRE.INT01.008 <<
        if bInvoiceExist then begin
            // MyTaxi.W1.CRE.INT01.008 >>
            SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
            SalesHeader."Applies-to Doc. No." := pMyTaxiCRMInterfaceRecords.externalReference;
            // MyTaxi.W1.CRE.INT01.008 <<
            // MyTaxi.IB.CRE.INT01.001 >>
            SalesHeader.Validate("Corrected Invoice No.", pMyTaxiCRMInterfaceRecords.externalReference);
            // MyTaxi.IB.CRE.INT01.001 <<
        end;
        // MyTaxi.W1.CRE.INT01.008 >>
        // MyTaxi.W1.CRE.INT01.003 <<
        SalesHeader."Posting No." := pMyTaxiCRMInterfaceRecords.externalReference;
        // MyTaxi.W1.CRE.INT01.003 >>
        // MyTaxi.W1.CRE.INT01.011 <<
        // MyTaxi.W1.CRE.INT01.017 <<
        //SetDimensionsOnSalesHeader(SalesHeader,pMyTaxiCRMInterfaceRecords);
        // MyTaxi.W1.CRE.INT01.017 >>
        // MyTaxi.W1.CRE.INT01.011 >>
        SalesHeader.Modify(false);
        LastLineNo := 10000;
        MyTaxiCRMInterfSubRecords.Reset();
        MyTaxiCRMInterfSubRecords.SetRange(MyTaxiCRMInterfSubRecords."Records Entry No.", pMyTaxiCRMInterfaceRecords."Entry No.");
        if MyTaxiCRMInterfSubRecords.FindSet() then
            repeat
                // MyTaxi.W1.CRE.INT01.004 <<
                /*IF MyTaxiCRMInterfSubRecords.netCredit<>0 THEN BEGIN
                  TotalTaxAmount += MyTaxiCRMInterfSubRecords.taxCredit;
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."On Car Advert. Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."On Car Advert. GL Account",
                                            MyTaxiCRMIntPostingSetup."On Car Advert. VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."Driver Ref. Prog. Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."Driver Ref. Prog. GL Acc.",
                                            MyTaxiCRMIntPostingSetup."Driver Ref. Prog. VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."Driver Incent. Prog. Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."Driver Incent. Prog. GL Acc.",
                                            MyTaxiCRMIntPostingSetup."Driver Incent. Prog. VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."Driver Comp. Fee Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."Driver Comp. Fee GL Account",
                                            MyTaxiCRMIntPostingSetup."Driver Comp. Fee VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."Commission Fee Corr. Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."Commission Fee Corr. GL Acc.",
                                            MyTaxiCRMIntPostingSetup."Commission Fee Corr. VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                  IF MyTaxiCRMInterfSubRecords.accountNumber=MyTaxiCRMIntPostingSetup."Mobile Pay. Fee Corr. Account" THEN
                    CreateSalesCrMemoLine(SalesHeader,pMyTaxiCRMInterfaceRecords,LastLineNo,MyTaxiCRMIntPostingSetup."Mobile Pay. Fee Corr. GL Acc.",
                                            MyTaxiCRMIntPostingSetup."Mobile Pay. Fee Corr. VAT Grp",MyTaxiCRMInterfSubRecords.netCredit);
                */
                // MyTaxi.W1.CRE.INT01.004 >>
                // MyTaxi.W1.ISS.000078616 <<
                MyTaxiCRMIntPostingMap.Get(MyTaxiCRMIntPostingSetup."Invoice Type", MyTaxiCRMInterfSubRecords.accountNumber);
                // MyTaxi.W1.ISS.000078616 >>
                // MyTaxi.W1.CRE.INT01.001 <<
                // MyTaxi.W1.CRE.INT01.002 <<
                //IF (MyTaxiCRMInterfSubRecords.netCredit<>0) AND
                if (MyTaxiCRMInterfSubRecords.netCredit > 0) and
                    // MyTaxi.W1.CRE.INT01.002 >>
                    // MyTaxi.W1.ISS.000078616 <<
                    //MyTaxiCRMIntPostingMap.GET(MyTaxiCRMIntPostingSetup."Invoice Type",MyTaxiCRMInterfSubRecords.accountNumber) AND
                    // MyTaxi.W1.ISS.000078616 >>
                    // MyTaxi.W1.CRE.INT01.002 <<
                    (MyTaxiCRMIntPostingMap."Document Type" = MyTaxiCRMIntPostingMap."Document Type"::"Credit Memo") then
                // MyTaxi.W1.CRE.INT01.002 >>
                begin
                    // MyTaxi.W1.CRE.INT01.004 <<
                    TotalTaxAmount += MyTaxiCRMInterfSubRecords.taxCredit;
                    // MyTaxi.W1.CRE.INT01.004 >>
                    CreateSalesCrMemoLine(SalesHeader, pMyTaxiCRMInterfaceRecords, LastLineNo, MyTaxiCRMIntPostingMap."GL Account",
                                            MyTaxiCRMIntPostingMap."VAT Product Posting Group", MyTaxiCRMInterfSubRecords.netCredit);
                end;
            // MyTaxi.W1.CRE.INT01.001 >>
            // MyTaxi.W1.CRE.INT01.004 <<
            //END;
            // MyTaxi.W1.CRE.INT01.004 >>
            until MyTaxiCRMInterfSubRecords.Next() = 0;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if not SalesLine.FindFirst() then begin
            SalesHeader."Posting No." := '';
            SalesHeader.Modify(false);
            SalesHeader.Delete(true)
        end
        else begin
            SalesLine.CalcVATAmountLines(1, SalesHeader, SalesLine, TempVATAmountLine);
            // MyTaxi.W1.CRE.INT01.016 <<
            //IF (TotalTaxAmount-TempVATAmountLine."VAT Amount"<>0) THEN
            if (TotalTaxAmount - TempVATAmountLine.GetTotalVATAmount() <> 0) then
            // MyTaxi.W1.CRE.INT01.016 >>
              begin
                // MyTaxi.W1.CRE.INT01.007 <<
                //TempVATAmountLine.VALIDATE("VAT Difference",pMyTaxiCRMInterfaceRecords.sumTaxValue-TempVATAmountLine."VAT Amount");
                // MyTaxi.W1.CRE.INT01.016 <<
                //TempVATAmountLine.VALIDATE("VAT Difference",TotalTaxAmount-TempVATAmountLine."VAT Amount");
                TempVATAmountLine.Validate("VAT Difference", TotalTaxAmount - TempVATAmountLine.GetTotalVATAmount());
                // MyTaxi.W1.CRE.INT01.016 >>
                // MyTaxi.W1.CRE.INT01.007 >>
                TempVATAmountLine.Modify();
                SalesLine.UpdateVATOnLines(1, SalesHeader, SalesLine, TempVATAmountLine);
            end;
            Clear(ReleaseSalesDocument);
            ReleaseSalesDocument.Run(SalesHeader);
            SalesHeader.CalcFields("Amount Including VAT");
            CreditMemoAmount := SalesHeader."Amount Including VAT";
            // MyTaxi.W1.CRE.INT01.015 <<
            pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status" := pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status"::Created;
            pMyTaxiCRMInterfaceRecords.Modify();
            // MyTaxi.W1.CRE.INT01.015 >>
            if MyTaxiCRMIntPostingSetup."Automatic Posting" then begin
                SalesHeader.Ship := true;
                SalesHeader.Invoice := true;
                Clear(SalesPost);
                // MyTaxi.W1.CRE.INT01.015 <<
                pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status" := pMyTaxiCRMInterfaceRecords."NAV Credit Memo Status"::Posted;
                pMyTaxiCRMInterfaceRecords.Modify();
                // MyTaxi.W1.CRE.INT01.015 >>
                SalesPost.Run(SalesHeader);
            end;
        end;

    end;


    procedure CreateSalesCrMemoLine(pSalesHeader: Record "Sales Header"; var pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records"; var pLastLineNo: Integer; GLAccountNo: Code[20]; VATProdPostGroup: Code[10]; LineAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := pSalesHeader."Document Type";
        SalesLine."Document No." := pSalesHeader."No.";
        SalesLine."Line No." := pLastLineNo + 10000;
        pLastLineNo += 10000;
        SalesLine.Insert(true);
        SalesLine.Type := SalesLine.Type::"G/L Account";
        SalesLine.Validate("No.", GLAccountNo);
        SalesLine.Validate("VAT Prod. Posting Group", VATProdPostGroup);
        if LineAmount < 0 then
            SalesLine.Validate(Quantity, -1)
        else
            SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", LineAmount);
        SalesLine.Modify(false);
    end;

    local procedure PostNetPaymentAndPayoutEntry(pSalesHeader: Record "Sales Header"; pAmount: Decimal; pApplyToInvoice: Boolean; pPostingDate: Date)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        SourceCodeSetup: Record "Source Code Setup";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Template Name";
        GenJnlLine."Journal Batch Name" := MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Batch Name";
        GenJnlLine."Line No." := LastLine + 10000;
        // MyTaxi.W1.CRE.INT01.013 <<
        //GenJnlLine."Posting Date" := "Posting Date";
        GenJnlLine."Posting Date" := pPostingDate;
        // MyTaxi.W1.CRE.INT01.013 >>
        GenJnlLine."Document Date" := pSalesHeader."Document Date";
        GenJnlLine.Description := pSalesHeader."Posting Description";
        GenJnlLine."Shortcut Dimension 1 Code" := pSalesHeader."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := pSalesHeader."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := pSalesHeader."Dimension Set ID";
        GenJnlLine."Reason Code" := pSalesHeader."Reason Code";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := pSalesHeader."Bill-to Customer No.";
        if pAmount > 0 then
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund
        else
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;

        GenJnlBatch.Get(MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Template Name", MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Batch Name");
        if GenJnlBatch."No. Series" <> '' then
            GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(
                GenJnlBatch."No. Series", pSalesHeader."Posting Date", false)
        else
            GenJnlLine."Document No." := pSalesHeader."No.";
        GenJnlLine."External Document No." := pSalesHeader."No.";
        GenJnlLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        GenJnlLine."Bal. Account No." := GenJnlBatch."Bal. Account No.";
        // MyTaxi.W1.CRE.INT01.014 <<
        if GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment then
            // MyTaxi.W1.CRE.INT01.014 >>
            if pApplyToInvoice and SalesInvoiceHeader.Get(pSalesHeader."No.") then begin
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := pSalesHeader."No.";
            end;
        GenJnlLine."Currency Code" := pSalesHeader."Currency Code";
        if pSalesHeader."Currency Code" = '' then
            GenJnlLine."Currency Factor" := 1
        else
            GenJnlLine."Currency Factor" := pSalesHeader."Currency Factor";
        GenJnlLine.Validate(Amount, pAmount);
        GenJnlLine."Source Currency Code" := pSalesHeader."Currency Code";
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        GenJnlLine.Correction := pSalesHeader.Correction;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := pSalesHeader."Bill-to Customer No.";
        SourceCodeSetup.Get();
        GenJnlLine."Source Code" := SourceCodeSetup."Cash Receipt Journal";
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJnlLine."Salespers./Purch. Code" := pSalesHeader."Salesperson Code";
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlLine.Insert(true);
    end;

    local procedure "--- Fun.MyTaxi.W1.CRE.INT01.011 ---"()
    begin
    end;

    local procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if not HasGotGLSetup then begin
            GLSetup.Get();
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := true;
        end;
    end;

    local procedure SetDimensionsOnSalesHeader(var SalesHeader: Record "Sales Header"; pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
        CostCenter2: Code[20];
        vLength: Integer;
    begin
        MyTaxiCRMInterfaceSetup.Get();
        GetGLSetup();

        if MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = '' then
            exit;

        vLength := StrPos(pMyTaxiCRMInterfaceRecords.externalReference, '-') - 3;
        CostCenter2 := '';
        if vLength > 0 then
            CostCenter2 := CopyStr(pMyTaxiCRMInterfaceRecords.externalReference, 2, vLength);

        if CostCenter2 <> '' then begin
            DimensionValue.Reset();
            DimensionValue.SetRange("Dimension Code", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code");
            DimensionValue.SetRange("MyTaxi CRM Interace Code", CostCenter2);
            if not DimensionValue.FindFirst() then
                Error(Err70000, CostCenter2, DimensionValue.TableCaption, DimensionValue.FieldCaption("MyTaxi CRM Interace Code"));
            case true of
                MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = GLSetupShortcutDimCode[1]:
                    SalesHeader.Validate("Shortcut Dimension 1 Code", DimensionValue.Code);
                MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = GLSetupShortcutDimCode[2]:
                    SalesHeader.Validate("Shortcut Dimension 2 Code", DimensionValue.Code);
                else begin
                    DimensionManagement.GetDimensionSet(TempDimSetEntry, SalesHeader."Dimension Set ID");
                    if TempDimSetEntry.Get(TempDimSetEntry."Dimension Set ID", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code") then
                        if TempDimSetEntry."Dimension Value Code" <> DimensionValue.Code then
                            TempDimSetEntry.Delete();
                    if MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" <> '' then begin
                        TempDimSetEntry."Dimension Code" := DimensionValue."Dimension Code";
                        TempDimSetEntry."Dimension Value Code" := DimensionValue.Code;
                        TempDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        if TempDimSetEntry.Insert() then;
                    end;
                    SalesHeader."Dimension Set ID" := DimensionManagement.GetDimensionSetID(TempDimSetEntry);
                end;
            end;
        end;
    end;

    local procedure SetDimensionsOnCustomer(var pCustomer: Record Customer; pMyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records")
    var
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        DimVal: Record "Dimension Value";
        DefaultDim: Record "Default Dimension";
        DimensionValueCode: Code[20];
    begin
        MyTaxiCRMInterfaceSetup.Get();
        GetGLSetup();

        if MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = '' then
            exit;


        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code");
        DimensionValue.SetRange("MyTaxi CRM Interace Code", pMyTaxiCRMInterfaceRecords.headquarterID);
        if not DimensionValue.FindFirst() or (pMyTaxiCRMInterfaceRecords.headquarterID = '') then
            Error(Err70000, pMyTaxiCRMInterfaceRecords.headquarterID, DimensionValue.TableCaption, DimensionValue.FieldCaption("MyTaxi CRM Interace Code"));
        case true of
            MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = GLSetupShortcutDimCode[1]:
                pCustomer.Validate("Global Dimension 1 Code", DimensionValue.Code);
            MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code" = GLSetupShortcutDimCode[2]:
                pCustomer.Validate("Global Dimension 2 Code", DimensionValue.Code);
            else begin
                if DimensionValue.Code <> '' then begin
                    if DefaultDim.Get(DATABASE::Customer, pCustomer."No.", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code")
                    then begin
                        DefaultDim.Validate("Dimension Value Code", DimensionValue.Code);
                        DefaultDim.Modify();
                    end else begin
                        DefaultDim.Init();
                        DefaultDim.Validate("Table ID", DATABASE::Customer);
                        DefaultDim.Validate("No.", pCustomer."No.");
                        DefaultDim.Validate("Dimension Code", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code");
                        DefaultDim.Validate("Dimension Value Code", DimensionValue.Code);
                        DefaultDim.Insert();
                    end;
                end else
                    if DefaultDim.Get(DATABASE::Customer, pCustomer."No.", MyTaxiCRMInterfaceSetup."Cost Center 2 Dimension Code") then
                        DefaultDim.Delete();
            end;
        end;
    end;
}

