page 60055 "Corporate Accounting Periods"
{
    Caption = 'Corporate Accounting Periods';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Corporate Accounting Period";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("New Fiscal Year"; Rec."New Fiscal Year")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Fiscal Year field.';

                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Closed field.';

                }
                field("Date Locked"; Rec."Date Locked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Locked field.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Create Year")
            {
                Caption = '&Create Year';
                Ellipsis = true;
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Create Corporate Fiscal Year";
                ToolTip = 'Executes the &Create Year action.';
            }
            action("C&lose Year")
            {
                Caption = 'C&lose Year';
                Image = CloseYear;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the C&lose Year action.';

                trigger OnAction()
                var
                    lmdlGAAPMgtRollForward: Codeunit "GAAP Mgt. - Roll Forward";
                begin
                    lmdlGAAPMgtRollForward.gfcnCloseYear(Rec);
                end;
            }
            action("Close Income Statement")
            {
                Caption = 'Close Income Statement';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Close Corporate Income Statmt.";
                ToolTip = 'Executes the Close Income Statement action.';
            }
        }
    }
}

