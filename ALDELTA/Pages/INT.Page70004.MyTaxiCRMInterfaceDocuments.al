page 70004 "MyTaxi CRM Interface Documents"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation
    // #MyTaxi.W1.CRE.INT01.008 22/11/2017 CCFR.SDE : New request
    //   Credit Note creation without invoice : new added action "Posted Sales Credit Memo"
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New request
    //   New added fields : businessAccountPaymentMethod,NAV Document Date
    // #MyTaxi.W1.CRE.INT01.015 26/12/2018 CCFR.SDE : New request
    //   New added fields : NAV Invoice Posted,NAV Credit Memo Posted,NAV Payment Posted
    //   New added action : Payment Ledger Entry

    Caption = 'MyTaxi CRM Interface Documents';
    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "MyTaxi CRM Interface Records";
    SourceTableView = WHERE("Interface Type" = CONST(Invoice));
    ApplicationArea = All;
UsageCategory=lists;
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
                field(id; Rec.id)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the id field.';
                }
                field(country; Rec.country)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the country field.';
                }
                field("Send Update"; Rec."Send Update")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Send Update field.';
                }
                field(statusCode; Rec.statusCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the statusCode field.';
                }
                field(dateStatusChanged; Rec.dateStatusChanged)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the dateStatusChanged field.';
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
                field(invoiceid; Rec.invoiceid)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the invoiceid field.';
                }
                field(externalReference; Rec.externalReference)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the externalReference field.';
                }
                field(invoiceType; Rec.invoiceType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the invoiceType field.';
                }
                field(idCustomer; Rec.idCustomer)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the idCustomer field.';
                }
                field(dateInvoice; Rec.dateInvoice)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the dateInvoice field.';
                }
                field(dueDate; Rec.dueDate)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the dueDate field.';
                }
                field("NAV Document Date"; Rec."NAV Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV Document Date field.';
                }
                field(businessAccountPaymentMethod; Rec.businessAccountPaymentMethod)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the businessAccountPaymentMethod field.';
                }
                field(countryCode; Rec.countryCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the countryCode field.';
                }
                field(currency; Rec.currency)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the currency field.';
                }
                field(sumNetValue; Rec.sumNetValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the sumNetValue field.';
                }
                field(sumTaxValue; Rec.sumTaxValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the sumTaxValue field.';
                }
                field(sumGrossValue; Rec.sumGrossValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the sumGrossValue field.';
                }
                field(discountCommissionNet; Rec.discountCommissionNet)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the discountCommissionNet field.';
                }
                field(discountCommissionTax; Rec.discountCommissionTax)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the discountCommissionTax field.';
                }
                field(discountCommissionGross; Rec.discountCommissionGross)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the discountCommissionGross field.';
                }
                field(netCommission; Rec.netCommission)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netCommission field.';
                }
                field(taxCommission; Rec.taxCommission)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxCommission field.';
                }
                field(grossCommission; Rec.grossCommission)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossCommission field.';
                }
                field(netHotelValue; Rec.netHotelValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netHotelValue field.';
                }
                field(taxHotelValue; Rec.taxHotelValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxHotelValue field.';
                }
                field(grossHotelValue; Rec.grossHotelValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossHotelValue field.';
                }
                field(netInvoicingFee; Rec.netInvoicingFee)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netInvoicingFee field.';
                }
                field(taxInvoicingFee; Rec.taxInvoicingFee)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxInvoicingFee field.';
                }
                field(grossInvoicingFee; Rec.grossInvoicingFee)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossInvoicingFee field.';
                }
                field(netPayment; Rec.netPayment)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netPayment field.';
                }
                field(netPaymentFeeMP; Rec.netPaymentFeeMP)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netPaymentFeeMP field.';
                }
                field(taxPaymentFeeMP; Rec.taxPaymentFeeMP)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxPaymentFeeMP field.';
                }
                field(grossPaymentFeeMP; Rec.grossPaymentFeeMP)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossPaymentFeeMP field.';
                }
                field(netPaymentFeeBA; Rec.netPaymentFeeBA)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netPaymentFeeBA field.';
                }
                field(taxPaymentFeeBA; Rec.taxPaymentFeeBA)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxPaymentFeeBA field.';
                }
                field(grossPaymentFeeBA; Rec.grossPaymentFeeBA)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossPaymentFeeBA field.';
                }
                field(additionalInformation; Rec.additionalInformation)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the additionalInformation field.';
                }
                field(additionalNotes; Rec.additionalNotes)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the additionalNotes field.';
                }
                field("Process Status Description"; Rec."Process Status Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Process Status Description field.';
                }
                field("NAV Invoice Status"; Rec."NAV Invoice Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV Invoice Status field.';
                }
                field("NAV Credit Memo Status"; Rec."NAV Credit Memo Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV Credit Memo Status field.';
                }
                field("NAV Payment Status"; Rec."NAV Payment Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV Payment Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000042; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("Sales Invoice")
                {
                    Caption = 'Sales Invoice';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Sales Invoice action.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Get(SalesHeader."Document Type"::Invoice, Rec.externalReference);
                        PAGE.RunModal(PAGE::"Sales Invoice", SalesHeader);
                    end;
                }
                action("Sales Credit Memo")
                {
                    Caption = 'Sales Credit Memo';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Sales Credit Memo action.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Get(SalesHeader."Document Type"::"Credit Memo", Rec.externalReference);
                        PAGE.RunModal(PAGE::"Sales Credit Memo", SalesHeader);
                    end;
                }
                action("Cash Receipt Journal")
                {
                    Caption = 'Cash Receipt Journal';
                    Image = CashReceiptJournal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Cash Receipt Journal";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Cash Receipt Journal action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMIntPostingSetup: Record "MyTaxi CRM Int. Posting Setup";
                        GenJournalLine: Record "Gen. Journal Line";

                    begin
                        /*MyTaxiCRMIntPostingSetup.GET(invoiceType);
                        GenJournalLine.SETRANGE("Journal Template Name",MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Template Name");
                        GenJournalLine.SETRANGE("Journal Batch Name",MyTaxiCRMIntPostingSetup."Cash Rec. Jnl. Batch Name");
                        PAGE.RUNMODAL(PAGE::"Cash Receipt Journal",GenJournalLine);*/

                    end;
                }
                group("Posted Sales Document")
                {
                    Caption = 'Posted Sales Document';
                    Image = PostDocument;
                    action("Posted Sales Invoice")
                    {
                        Caption = 'Posted Sales Invoice';
                        Image = PostDocument;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Posted Sales Invoices";
                        RunPageLink = "No." = FIELD(externalReference);
                        ApplicationArea = all;
                        ToolTip = 'Executes the Posted Sales Invoice action.';
                    }
                    action("Posted Sales Credit Memo")
                    {
                        Caption = 'Posted Sales Credit Memo';
                        Description = 'MyTaxi.W1.CRE.INT01.008';
                        Image = PostDocument;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Posted Sales Credit Memos";
                        RunPageLink = "No." = FIELD(externalReference);
                        ApplicationArea = all;
                        ToolTip = 'Executes the Posted Sales Credit Memo action.';
                    }
                    action("<Payment Ledger Entry>")
                    {
                        Caption = 'Payment Ledger Entry';
                        Image = CustomerLedger;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Payment Ledger Entry action.';

                        trigger OnAction()
                        var
                            CustLedgerEntry: Record "Cust. Ledger Entry";
                        begin
                            CustLedgerEntry.Reset();
                            CustLedgerEntry.SetRange("Customer No.", Format(Rec.idCustomer));
                            CustLedgerEntry.SetRange("Posting Date", Rec.dateInvoice);
                            CustLedgerEntry.SetRange("External Document No.", Rec.externalReference);
                            PAGE.RunModal(PAGE::"Customer Ledger Entries", CustLedgerEntry);
                        end;
                    }
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Get MyTaxi Sales Documents")
                {
                    Caption = 'Get MyTaxi Sales Documents';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Get MyTaxi Sales Documents action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                    begin
                        MyTaxiCRMInterfaceWS.GetInvoices(0, false);
                    end;
                }
                action("Import MyTaxi Sales Documents File")
                {
                    Caption = 'Import MyTaxi Sales Documents File';
                    Image = FileContract;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Import MyTaxi Sales Documents File action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                    begin
                        MyTaxiCRMInterfaceWS.ImportInvoices;
                    end;
                }
                action("Create Sales Document")
                {
                    Caption = 'Create Sales Document';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Create Sales Document action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
                        MyTaxiCRMInterfaceProcess: Codeunit "MyTaxi CRM Interface Process";
                        MyTaxiCRMInterfaceRecords2: Record "MyTaxi CRM Interface Records";
                    begin
                        CurrPage.SetSelectionFilter(MyTaxiCRMInterfaceRecords);
                        if MyTaxiCRMInterfaceRecords.FindSet() then
                            repeat
                                ClearLastError();
                                Clear(MyTaxiCRMInterfaceProcess);
                                MyTaxiCRMInterfaceProcess.SetParams(2, MyTaxiCRMInterfaceRecords);
                                if not MyTaxiCRMInterfaceProcess.Run() then begin
                                    MyTaxiCRMInterfaceRecords2.Get(MyTaxiCRMInterfaceRecords."Entry No.");
                                    MyTaxiCRMInterfaceRecords2."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::Error;
                                    MyTaxiCRMInterfaceRecords2."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
                                    MyTaxiCRMInterfaceRecords2.statusCode := 'ERROR';
                                    MyTaxiCRMInterfaceRecords2.dateStatusChanged := CurrentDateTime;
                                    MyTaxiCRMInterfaceRecords2."Send Update" := true;
                                    MyTaxiCRMInterfaceRecords2.Modify();
                                end;
                                Commit();
                            until MyTaxiCRMInterfaceRecords.Next() = 0;
                    end;
                }
                action("Update MyTaxi Sales Documents")
                {
                    Caption = 'Update MyTaxi Sales Documents';
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Update MyTaxi Sales Documents action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
                        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                    begin
                        CurrPage.SetSelectionFilter(MyTaxiCRMInterfaceRecords);
                        if MyTaxiCRMInterfaceRecords.FindSet() then
                            repeat
                            MyTaxiCRMInterfaceWS.UpdateInvoice(MyTaxiCRMInterfaceRecords);
                            until MyTaxiCRMInterfaceRecords.Next() = 0;
                    end;
                }
                action("Get MyTaxi Sales Document")
                {
                    Caption = 'Get MyTaxi Sales Document';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Get MyTaxi Sales Document action.';

                    trigger OnAction()
                    var
                        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
                    begin
                        MyTaxiCRMInterfaceWS.GetInvoices(Rec.invoiceid, true);
                    end;
                }
            }
        }
    }

    local procedure ShowSalesDocument()
    begin
    end;
}

