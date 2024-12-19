page 80102 "Invoice Input Request"
{
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Invoice Number"; InvoiceNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the invoice number you want to retrieve.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(OK)
            {
                Caption = 'OK';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Confirmed:=true;
                    CurrPage.Close();
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Confirmed:=false;
                    CurrPage.Close();
                end;
            }
        }
    }
    var InvoiceNumber: Integer;
    Confirmed: Boolean;
    procedure IsConfirmed(): Boolean begin
        exit(Confirmed);
    end;
    procedure GetInvoiceNumber(): Integer begin
        exit(InvoiceNumber);
    end;
}
