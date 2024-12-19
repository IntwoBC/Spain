tableextension 50117 tableextension50117 extends "Reminder Level"
{
    // #MyTaxi.W1.CRE.ACREC.001 28/11/2017 CCFR.SDE : Print Level Custom Report Layout
    //   New added field : "Custom Report Selection ID"
    fields
    {
        field(70000; "Custom Report Selection ID"; Integer)
        {
            Caption = 'Custom Report Selection ID';
            Description = 'MyTaxi.W1.CRE.ACREC.001';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                CustomReportSelection.Reset();
                CustomReportSelection.SetRange("Source Type", DATABASE::"Reminder Level");
                CustomReportSelection.SetRange("Source No.", "Reminder Terms Code" + Format("No."));
                CustomReportSelection.SetRange(Usage, CustomReportSelection.Usage::Reminder);
                if PAGE.RunModal(PAGE::"MyTaxi Reminder Report Select.", CustomReportSelection) = ACTION::LookupOK then
                    "Custom Report Selection ID" := CustomReportSelection.Sequence;
            end;

            trigger OnValidate()
            begin
                if "Custom Report Selection ID" <> 0 then
                    CustomReportSelection.Get(DATABASE::"Reminder Level", "Reminder Terms Code" + Format("No."), CustomReportSelection.Usage::Reminder, "Custom Report Selection ID");
            end;
        }
    }

    var
        "--- MyTaxi.W1.CRE.ACREC.001 ---": Integer;
        CustomReportSelection: Record "Custom Report Selection";
}

