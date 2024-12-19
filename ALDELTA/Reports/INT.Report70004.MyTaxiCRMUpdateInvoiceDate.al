report 70004 "MyTaxi CRM Update Invoice Date"
{
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New request
    //   Replace the InvoiceDate with the WorkDate on NEW Invoices/Credit Memo

    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("MyTaxi CRM Interface Records"; "MyTaxi CRM Interface Records")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            begin
                "MyTaxi CRM Interface Records"."NAV Document Date" := "MyTaxi CRM Interface Records".dateInvoice;
                "MyTaxi CRM Interface Records".Modify();
            end;

            trigger OnPostDataItem()
            begin
                "MyTaxi CRM Interface Records".ModifyAll(dateInvoice, NewInvoiceDate);
                Message(Format(icount));
            end;

            trigger OnPreDataItem()
            begin
                if (StartDateFilter = 0D) or (EndDateFilter = 0D) then
                    Error(Error70000);
                "MyTaxi CRM Interface Records".SetRange("Interface Type", "MyTaxi CRM Interface Records"."Interface Type"::Invoice);
                "MyTaxi CRM Interface Records".SetRange(dateInvoice, StartDateFilter, EndDateFilter);
                "MyTaxi CRM Interface Records".SetRange(statusCode, InvoiceStatusFilter);
                icount := "MyTaxi CRM Interface Records".Count;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        NewInvoiceDate := WorkDate();
        StartDateFilter := CalcDate('<-CY>', WorkDate());
        EndDateFilter := CalcDate('<-CM-1D>', WorkDate());
        InvoiceStatusFilter := 'NEW';
        if not Confirm(Text70000, false, NewInvoiceDate, InvoiceStatusFilter, StartDateFilter, EndDateFilter) then
            CurrReport.Quit();
    end;

    var
        Text70000: Label 'Do you want to set the invoice date to %1 for the %2 invoices between %3 and %4 date?  ';
        Error70000: Label 'The start date and end date filter must be filled';
        NewInvoiceDate: Date;
        StartDateFilter: Date;
        EndDateFilter: Date;
        InvoiceStatusFilter: Text[10];
        icount: Integer;
}

