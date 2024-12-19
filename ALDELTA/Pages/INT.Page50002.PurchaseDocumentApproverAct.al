page 50002 "Purchase Document Approver Act"
{
    // #MyTaxi.W1.CRE.PURCH.017 07/06/2019 CCFR.SDE : P2P2 Approval Workflow Process (CRN201900011 Requests to approver per approver in cue)
    //   Modified trigger : OnOpenPage

    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Finance Cue";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            cuegroup("Requests to Approve")
            {
                Caption = 'Requests to Approve';


                // field(Control14; "Requests to Approve")
                // {
                //     DrillDownPageID = "Requests to Approve";
                // }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetFilter("Due Date Filter", '<=%1', WorkDate());
        Rec.SetFilter("Overdue Date Filter", '<%1', WorkDate());
        // MyTaxi.W1.CRE.PURCH.017 <<
        // Rec.SetRange(Rec."User ID Filter", UserId);
        // MyTaxi.W1.CRE.PURCH.017 >>
    end;
}

