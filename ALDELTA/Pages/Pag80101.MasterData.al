page 80101 "Master Data Input Request"
{
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Customer IDs"; CustomerIDsToGet)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the customer IDs as a comma-separated list.';
                }
                field("From Date"; FromDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the start date for the data range.';
                    Visible = SetVisiblity;
                }
                field("To Date"; ToDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the end date for the data range.';
                    Visible = SetVisiblity;
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
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                ApplicationArea = All;
            }
        }
    }
    var
        SetVisiblity: Boolean;
        CustomerIDsToGet: Text[250];
        FromDate: Date;
        ToDate: Date;

    procedure SetVisible(SetvisiblityP: Boolean)
    begin
        SetVisiblity := SetvisiblityP;
    end;

    procedure GetCustomerIDsToGet(): Text
    begin
        exit(CustomerIDsToGet);
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
