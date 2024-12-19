report 80005 Temp
{
    DefaultLayout = RDLC;
    RDLCLayout = './Temp.rdlc';
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.") WHERE("Journal Batch Name" = FILTER('PP000076Z'));

            trigger OnAfterGetRecord()
            begin
                //"Gen. Journal Line"."Payment in Process" := FALSE;
                //MODIFY;
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
}

