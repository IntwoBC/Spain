report 80006 "SII Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SIIUpdate.rdlc';
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("SII Doc. Upload State"; "SII Doc. Upload State")
        {
            DataItemTableView = SORTING(Id) WHERE("Posting Date" = FILTER(20220401D .. 20220430D), Status = FILTER("Communication Error"));

            trigger OnAfterGetRecord()
            begin
                "SII Doc. Upload State".Validate("SII Doc. Upload State".Status, "SII Doc. Upload State".Status::Pending);
                "SII Doc. Upload State".Modify(true);
                SIIHistory.Reset();
                SIIHistory.SetRange(SIIHistory."Document State Id", "SII Doc. Upload State".Id);
                if SIIHistory.FindFirst() then begin
                    SIIHistory.Validate(Status, SIIHistory.Status::Pending);
                    SIIHistory.Modify(true);
                end;
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
        SIIHistory: Record "SII History";
}

