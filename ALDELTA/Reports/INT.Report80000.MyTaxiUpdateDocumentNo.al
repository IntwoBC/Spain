report 80000 "MyTaxi Update Document No"
{
    Permissions = TableData "G/L Entry" = rm,
                  TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Invoice Line" = rm,
                  TableData "Sales Cr.Memo Header" = rm,
                  TableData "Sales Cr.Memo Line" = rm,
                  TableData "VAT Entry" = rm,
                  TableData "Detailed Cust. Ledg. Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {

            trigger OnAfterGetRecord()
            begin
                if (NewSalesInvoiceCompanyNoSeries = '') and (NewSalesInvoiceCreditToursNoSeries = '') and (NewSalesInvoiceOtherNoSeries = '') then
                    CurrReport.Break();

                Window.Update(2, "No.");
                Window.Update(4, Round(RecNo / TotalRecNo * 10000, 1));
                RecNo += 1;

                TmpSalesInvoiceHeader.Init();
                TmpSalesInvoiceHeader.TransferFields("Sales Invoice Header");
                if StrPos("No.", '-') <> 0 then
                    if StrLen("No.") < 10 then begin
                        TmpSalesInvoiceHeader."Quote No." := "No.";
                        TmpSalesInvoiceHeader."No." := CopyStr("No.", 1, 4) + PadStr('', 6 - StrLen(CopyStr("No.", 5, StrLen("No.") - 4)), '0') + CopyStr("No.", 5, StrLen("No.") - 4);
                    end;
                TmpSalesInvoiceHeader.Insert();
                SalesInvoiceLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                if SalesInvoiceLine.FindSet() then
                    repeat
                        TmpSalesInvoiceLine.Init();
                        TmpSalesInvoiceLine.TransferFields(SalesInvoiceLine);
                        TmpSalesInvoiceLine.Insert();
                    until SalesInvoiceLine.Next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                GLEntry.Reset();
                VATEntry.Reset();
                CustLedgerEntry.Reset();
                DetailedCustLedgEntry.Reset();
                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                VATEntry.SetCurrentKey("Document Type", "Posting Date", "Document No.");
                CustLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                DetailedCustLedgEntry.SetCurrentKey("Document No.", "Document Type", "Posting Date");
                CustLedgerEntry2.SetCurrentKey("External Document No.", "Document Type");
                //MyTaxiCRMInterfaceRecords.SETCURRENTKEY(externalReference);
                // RENAME
                Window.Update(1, 'Renumber Invoices');
                RecNo := 1;
                TotalRecNo := TmpSalesInvoiceHeader.Count;
                if TmpSalesInvoiceHeader.FindSet() then
                    repeat
                        Window.Update(2, TmpSalesInvoiceHeader."No.");
                        Window.Update(4, Round(RecNo / TotalRecNo * 10000, 1));
                        RecNo += 1;

                        OldInvoiceNo := TmpSalesInvoiceHeader."No.";
                        if TmpSalesInvoiceHeader."Quote No." <> '' then
                            OldInvoiceNo := TmpSalesInvoiceHeader."Quote No.";

                        NewDocNo := '';
                        if StrPos(OldInvoiceNo, '-') = 0 then
                            SetTargetDocumentNo(NewSalesInvoiceOtherNoSeries, NewDocNo, "Posting Date")
                        else
                            case TmpSalesInvoiceHeader."Customer Posting Group" of
                                'TAXI':
                                    SetTargetDocumentNo(NewSalesInvoiceCompanyNoSeries, NewDocNo, "Posting Date");
                                'BUSINESS':
                                    SetTargetDocumentNo(NewSalesInvoiceCreditToursNoSeries, NewDocNo, "Posting Date");
                            end;
                        if NewDocNo = '' then
                            Error(Text005, OldInvoiceNo);


                        /*MyTaxiCRMInterfaceRecords.SETRANGE(externalReference,OldInvoiceNo);
                        IF NOT MyTaxiCRMInterfaceRecords.ISEMPTY THEN
                          MyTaxiCRMInterfaceRecords.MODIFYALL("NAV Document No.",NewDocNo);*/

                        GLEntry.SetRange("Document No.", OldInvoiceNo);
                        GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
                        if not GLEntry.IsEmpty then begin
                            if TmpSalesInvoiceHeader."External Document No." = '' then
                                GLEntry.ModifyAll("External Document No.", OldInvoiceNo);
                            GLEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        VATEntry.SetRange("Document Type", VATEntry."Document Type"::Invoice);
                        VATEntry.SetRange("Document No.", OldInvoiceNo);
                        if not VATEntry.IsEmpty then begin
                            if TmpSalesInvoiceHeader."External Document No." = '' then
                                VATEntry.ModifyAll("External Document No.", OldInvoiceNo);
                            VATEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        CustLedgerEntry.SetRange("Document No.", OldInvoiceNo);
                        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                        if not CustLedgerEntry.IsEmpty then begin
                            if TmpSalesInvoiceHeader."External Document No." = '' then
                                CustLedgerEntry.ModifyAll("External Document No.", OldInvoiceNo);
                            CustLedgerEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        DetailedCustLedgEntry.SetRange("Document No.", OldInvoiceNo);
                        DetailedCustLedgEntry.SetRange("Document Type", DetailedCustLedgEntry."Document Type"::Invoice);
                        if not DetailedCustLedgEntry.IsEmpty then begin
                            DetailedCustLedgEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        if SalesInvoiceHeader.Get(OldInvoiceNo) then begin
                            if SalesInvoiceHeader."External Document No." = '' then
                                SalesInvoiceHeader."External Document No." := OldInvoiceNo
                            else
                                TmpSalesInvoiceHeader."Pre-Assigned No." := OldInvoiceNo;
                            SalesInvoiceHeader.Modify();
                            SalesInvoiceHeader.Rename(NewDocNo);
                        end;
                        TmpSalesInvoiceLine.SetRange("Document No.", OldInvoiceNo);
                        if TmpSalesInvoiceLine.FindSet() then
                            repeat
                                if SalesInvoiceLine.Get(TmpSalesInvoiceLine."Document No.", TmpSalesInvoiceLine."Line No.") then
                                    SalesInvoiceLine.Rename(NewDocNo, TmpSalesInvoiceLine."Line No.");
                            until TmpSalesInvoiceLine.Next() = 0;

                        SalesCrMemoHeader.Reset();
                        SalesCrMemoHeader.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.");
                        SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                        SalesCrMemoHeader.SetRange("Applies-to Doc. No.", OldInvoiceNo);
                        SalesCrMemoHeader.SetRange("Bill-to Customer No.", TmpSalesInvoiceHeader."Bill-to Customer No.");
                        if not SalesCrMemoHeader.IsEmpty then begin
                            SalesCrMemoHeader.ModifyAll("Corrected Invoice No.", NewDocNo);
                            SalesCrMemoHeader.ModifyAll("Applies-to Doc. No.", NewDocNo);
                        end;
                        SalesCrMemoHeader.Reset();

                        CustLedgerEntry2.SetRange("Customer No.", TmpSalesInvoiceHeader."Bill-to Customer No.");
                        CustLedgerEntry2.SetRange("External Document No.", OldInvoiceNo);
                        CustLedgerEntry2.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Payment, CustLedgerEntry."Document Type"::Refund);
                        if CustLedgerEntry2.FindFirst() then begin
                            CustLedgerEntry2."External Document No." := NewDocNo;
                            CustLedgerEntry2.Modify();
                        end;
                    until TmpSalesInvoiceHeader.Next() = 0;

            end;

            trigger OnPreDataItem()
            begin
                RecNo := 1;
                TotalRecNo := Count;
                Window.Update(1, 'Fill Temporary Records');
                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                VATEntry.SetCurrentKey("Document Type", "Posting Date", "Document No.");
                CustLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                DetailedCustLedgEntry.SetCurrentKey("Document No.", "Document Type", "Posting Date");
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {

            trigger OnAfterGetRecord()
            begin
                if (NewSalesCrMemoCompanyNoSeries = '') and (NewSalesCrMemoCreditToursNoSeries = '') and (NewSalesCrMemoOtherNoSeries = '') then
                    CurrReport.Break();

                Window.Update(3, "No.");
                Window.Update(4, Round(RecNo / TotalRecNo * 10000, 1));
                RecNo += 1;
                TmpSalesCrMemoHeader.Init();
                TmpSalesCrMemoHeader.TransferFields("Sales Cr.Memo Header");
                if StrPos("No.", '-') <> 0 then
                    if StrLen("No.") < 10 then begin
                        //TmpSalesCrMemoHeader."Credit Card No." := "No.";
                        TmpSalesCrMemoHeader."No." := CopyStr("No.", 1, 4) + PadStr('', 6 - StrLen(CopyStr("No.", 5, StrLen("No.") - 4)), '0') + CopyStr("No.", 5, StrLen("No.") - 4);
                    end;
                TmpSalesCrMemoHeader.Insert();
                // TEMPORARY
                SalesCrMemoLine.SetRange("Document No.", "Sales Cr.Memo Header"."No.");
                if SalesCrMemoLine.FindSet() then
                    repeat
                        TmpSalesCrMemoLine.Init();
                        TmpSalesCrMemoLine.TransferFields(SalesCrMemoLine);
                        TmpSalesCrMemoLine.Insert();
                    until SalesCrMemoLine.Next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                GLEntry.Reset();
                VATEntry.Reset();
                CustLedgerEntry.Reset();
                DetailedCustLedgEntry.Reset();
                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                VATEntry.SetCurrentKey("Document Type", "Posting Date", "Document No.");
                CustLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                DetailedCustLedgEntry.SetCurrentKey("Document No.", "Document Type", "Posting Date");
                CustLedgerEntry2.SetCurrentKey("External Document No.");
                // RENAME
                Window.Update(1, 'Renumber Credit Memos');
                RecNo := 1;
                TotalRecNo := TmpSalesCrMemoHeader.Count;
                if TmpSalesCrMemoHeader.FindSet() then
                    repeat
                        Window.Update(3, TmpSalesCrMemoHeader."No.");
                        Window.Update(4, Round(RecNo / TotalRecNo * 10000, 1));
                        RecNo += 1;

                        OldCrMemoNo := TmpSalesCrMemoHeader."No.";
                        //IF TmpSalesCrMemoHeader."Credit Card No."<>'' THEN
                        // OldCrMemoNo := TmpSalesCrMemoHeader."Credit Card No.";

                        NewDocNo := '';
                        if StrPos(OldCrMemoNo, '-') = 0 then
                            SetTargetDocumentNo(NewSalesCrMemoOtherNoSeries, NewDocNo, "Posting Date")
                        else
                            case TmpSalesCrMemoHeader."Customer Posting Group" of
                                'TAXI':
                                    SetTargetDocumentNo(NewSalesCrMemoCompanyNoSeries, NewDocNo, "Posting Date");
                                'BUSINESS':
                                    SetTargetDocumentNo(NewSalesCrMemoCreditToursNoSeries, NewDocNo, "Posting Date");
                            end;
                        if NewDocNo = '' then
                            Error(Text005, OldCrMemoNo);

                        /*MyTaxiCRMInterfaceRecords.RESET;
                        MyTaxiCRMInterfaceRecords.SETRANGE(externalReference,OldCrMemoNo);
                        IF NOT MyTaxiCRMInterfaceRecords.ISEMPTY THEN
                          MyTaxiCRMInterfaceRecords.MODIFYALL("NAV Document No.",NewDocNo);*/

                        GLEntry.SetRange("Document No.", OldCrMemoNo);
                        GLEntry.SetRange("Document Type", GLEntry."Document Type"::"Credit Memo");
                        if not GLEntry.IsEmpty then begin
                            if TmpSalesCrMemoHeader."External Document No." = '' then
                                GLEntry.ModifyAll("External Document No.", OldCrMemoNo);
                            GLEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        VATEntry.SetRange("Document Type", VATEntry."Document Type"::"Credit Memo");
                        VATEntry.SetRange("Document No.", OldCrMemoNo);
                        if not VATEntry.IsEmpty then begin
                            if TmpSalesCrMemoHeader."External Document No." = '' then
                                VATEntry.ModifyAll("External Document No.", OldCrMemoNo);
                            VATEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        CustLedgerEntry.SetRange("Document No.", OldCrMemoNo);
                        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
                        if not CustLedgerEntry.IsEmpty then begin
                            CustLedgerEntry.ModifyAll("Corrected Invoice No.", TmpSalesCrMemoHeader."Corrected Invoice No.");
                            if TmpSalesCrMemoHeader."External Document No." = '' then
                                CustLedgerEntry.ModifyAll("External Document No.", OldCrMemoNo);
                            CustLedgerEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        DetailedCustLedgEntry.SetRange("Document No.", OldCrMemoNo);
                        DetailedCustLedgEntry.SetRange("Document Type", DetailedCustLedgEntry."Document Type"::"Credit Memo");
                        if not DetailedCustLedgEntry.IsEmpty then begin
                            DetailedCustLedgEntry.ModifyAll("Document No.", NewDocNo);
                        end;

                        if SalesCrMemoHeader.Get(OldCrMemoNo) then begin
                            if SalesCrMemoHeader."External Document No." = '' then
                                SalesCrMemoHeader."External Document No." := OldCrMemoNo
                            else
                                SalesCrMemoHeader."Pre-Assigned No." := OldCrMemoNo;
                            SalesCrMemoHeader.Modify();
                            SalesCrMemoHeader.Rename(NewDocNo);
                        end;
                        TmpSalesCrMemoLine.SetRange("Document No.", OldCrMemoNo);
                        if TmpSalesCrMemoLine.FindSet() then
                            repeat
                                if SalesCrMemoLine.Get(TmpSalesCrMemoLine."Document No.", TmpSalesCrMemoLine."Line No.") then
                                    SalesCrMemoLine.Rename(NewDocNo, TmpSalesCrMemoLine."Line No.");
                            until TmpSalesCrMemoLine.Next() = 0;

                    until TmpSalesCrMemoHeader.Next() = 0;

            end;

            trigger OnPreDataItem()
            begin
                RecNo := 1;
                TotalRecNo := Count;
                Window.Update(1, 'Fill Temporary Records');
                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                VATEntry.SetCurrentKey("Document Type", "Posting Date", "Document No.");
                CustLedgerEntry.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                DetailedCustLedgEntry.SetCurrentKey("Document No.", "Document Type", "Posting Date");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewSalesInvoiceCompanyNoSeries; NewSalesInvoiceCompanyNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Invoice Company No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Invoice Company No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesInvoiceCompanyNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesInvoiceCompanyNoSeries <> '' then
                                NoSeries.Get(NewSalesInvoiceCompanyNoSeries);
                        end;
                    }
                    field(NewSalesCrMemoCompanyNoSeries; NewSalesCrMemoCompanyNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Cr Memo Company No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Cr Memo Company No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesCrMemoCompanyNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesCrMemoCompanyNoSeries <> '' then
                                NoSeries.Get(NewSalesCrMemoCompanyNoSeries);
                        end;
                    }
                    field(NewSalesInvoiceCreditToursNoSeries; NewSalesInvoiceCreditToursNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Invoice Credit Tours No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Invoice Credit Tours No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesInvoiceCreditToursNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesInvoiceCreditToursNoSeries <> '' then
                                NoSeries.Get(NewSalesInvoiceCreditToursNoSeries);
                        end;
                    }
                    field(NewSalesCrMemoCreditToursNoSeries; NewSalesCrMemoCreditToursNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Cr Memo Credit Tours No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Cr Memo Credit Tours No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesCrMemoCreditToursNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesCrMemoCreditToursNoSeries <> '' then
                                NoSeries.Get(NewSalesCrMemoCreditToursNoSeries);
                        end;
                    }
                    field(NewSalesInvoiceOtherNoSeries; NewSalesInvoiceOtherNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Invoice Other No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Invoice Other No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesInvoiceOtherNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesInvoiceOtherNoSeries <> '' then
                                NoSeries.Get(NewSalesInvoiceOtherNoSeries);
                        end;
                    }
                    field(NewSalesCrMemoOtherNoSeries; NewSalesCrMemoOtherNoSeries)
                    {
                        AssistEdit = true;
                        Caption = 'New Sales Cr Memo Other No. Series';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the New Sales Cr Memo Other No. Series field.';

                        trigger OnAssistEdit()
                        begin
                            if PAGE.RunModal(0, NoSeries) = ACTION::LookupOK then
                                NewSalesCrMemoOtherNoSeries := NoSeries.Code;
                        end;

                        trigger OnValidate()
                        begin
                            if NewSalesCrMemoOtherNoSeries <> '' then
                                NoSeries.Get(NewSalesCrMemoOtherNoSeries);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close();
    end;

    trigger OnPreReport()
    begin
        // Evaluate(Password, PassWindow.InputBox('Enter Password', 'INPUT', '', 20, 20));
        if Password <> '@3412@' then
            Error(Text006);
        Window.Open(Text001 + Text002 + Text003 + Text004);
    end;

    var
        TmpSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
        TmpSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TmpSalesCrMemoHeader: Record "Sales Cr.Memo Header" temporary;
        TmpSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        NoSeries: Record "No. Series";
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        NewSalesInvoiceCompanyNoSeries: Code[20];
        NewSalesCrMemoCompanyNoSeries: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewDocNo: Code[20];
        Text001: Label 'Step                       #1####################\\';
        Text002: Label 'Invoices                 #2####################\\';
        Text003: Label 'Credit Memo           #3####################\\';
        Text004: Label 'Update progess       @4@@@@@@@@@@@@@@@@';
        Window: Dialog;
        RecNo: Integer;
        TotalRecNo: Integer;
        NewSalesInvoiceCreditToursNoSeries: Code[20];
        NewSalesCrMemoCreditToursNoSeries: Code[20];
        NewSalesInvoiceOtherNoSeries: Code[20];
        NewSalesCrMemoOtherNoSeries: Code[20];
        OldInvoiceNo: Code[20];
        OldCrMemoNo: Code[20];
        Text005: Label 'New Document Number cannot be empty. %1';
        Text006: Label 'You are not allowed to run this report.';
        Password: Text;
    // [RunOnClient]
    //PassWindow: DotNet Interaction;

    local procedure SetTargetDocumentNo(NewDocumentNoSeries: Code[20]; var NewDocumentNo: Code[20]; PostingDate: Date)
    var
        NoSeriesCode: Code[20];
    begin
        NoSeriesMgt.InitSeries(NewDocumentNoSeries, '', PostingDate, NewDocumentNo, NoSeriesCode);
    end;
}

