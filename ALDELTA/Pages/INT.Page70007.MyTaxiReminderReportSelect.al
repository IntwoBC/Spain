page 70007 "MyTaxi Reminder Report Select."
{
    // #MyTaxi.W1.CRE.ACREC.001 28/11/2017 CCFR.SDE : Print Level Custom Report Layout
    //   Page Creation

    Caption = 'Document Layouts';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Custom Report Selection";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReportID; Rec."Report ID")
                {
                    Caption = 'Report ID';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Report ID field.';
                }
                field(ReportCaption; Rec."Report Caption")
                {
                    Caption = 'Report Caption';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Report Caption field.';
                }
                field(CustomReportDescription; Rec."Custom Report Description")
                {
                    Caption = 'Custom Layout Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Custom Layout Description field.';

                    trigger OnDrillDown()
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                        CustomReportLayouts: Page "Custom Report Layouts";
                    begin
                        CustomReportLayout.SetCurrentKey("Report ID", "Company Name", Type);
                        CustomReportLayout.SetRange("Report ID", Rec."Report ID");
                        CustomReportLayout.SetFilter("Company Name", '%1|%2', '', CompanyName);
                        CustomReportLayouts.SetTableView(CustomReportLayout);
                        if CustomReportLayouts.RunModal() = ACTION::OK then begin
                            CustomReportLayouts.GetRecord(CustomReportLayout);
                            //  "Custom Report Layout ID" := CustomReportLayout.ID;
                            Rec.Modify();
                            Rec.CalcFields("Custom Report Description");
                        end;
                    end;
                }
                field(SendToEmail; Rec."Send To Email")
                {
                    Caption = 'Send To Email';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Send To Email field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.Update(false);
    end;
}

