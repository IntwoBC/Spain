report 80001 "Update VAT Percentage"
{
    Permissions = TableData "Sales Cr.Memo Line" = rm,
                  TableData "VAT Entry" = rm,
                  TableData "Sales Invoice Line" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {

            trigger OnAfterGetRecord()
            begin
                if (Amount <> 0) and ("VAT %" = 0) and ("VAT Difference" <> 0) then begin
                    "VAT %" := 21;
                    "VAT Difference" := 0;
                    Modify();
                    nb += 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Document Type","Document Type"::"Credit Memo");
                SetRange("Document Type", "Document Type"::Invoice);
                SetRange(Type, Type::Sale);
                SetFilter("Posting Date", '%1..', 20190101D);
                SetRange("VAT Bus. Posting Group", 'DOMESTIC');
                SetRange("VAT Prod. Posting Group", '21 CN');
                //ERROR(FORMAT(COUNT));
            end;
        }
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {

            trigger OnAfterGetRecord()
            begin
                if ("VAT %" = 0) and ("VAT Difference" <> 0) then begin
                    "VAT %" := 21;
                    "VAT Difference" := 0;
                    Modify();
                    nb1 += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message(Format(nb) + Format(nb1));
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '%1..', 20190101D);
                SetRange("VAT Bus. Posting Group", 'DOMESTIC');
                SetRange("VAT Prod. Posting Group", '21 CN');
                //ERROR(FORMAT(COUNT));
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

    var
        nb: Integer;
        nb1: Integer;
}

