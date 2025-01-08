page 50006 "I2I Input Date Range Dialog"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Enter Date Range';

    layout
    {
        area(content)
        {
            group("Date Range")
            {
                field(FromDate; FromDate)
                {
                    Caption = 'From Date';
                }
                field(ToDate; ToDate)
                {
                    Caption = 'To Date';
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
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }

            action(Cancel)
            {
                Caption = 'Cancel';
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        FromDate: Date;
        ToDate: Date;

    procedure SetDateRange(var pFromDate: Date; var pToDate: Date)
    begin
        FromDate := pFromDate;
        ToDate := pToDate;
    end;

    procedure GetFromDate(): Date
    begin
        exit(FromDate);
    end;

    procedure GetToDate(): Date
    begin
        exit(ToDate);
    end;
}
