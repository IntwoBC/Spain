page 60044 "Financial Statement Codes"
{
    // MP 24-11-14
    // Upgraded to NAV 2013 R2

    Caption = 'Financial Statement Codes';
    PageType = List;
    SourceTable = "Financial Statement Code";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Description (English)"; Rec."Description (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description (English) field.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000006>")
            {
                Caption = 'Import/Export';
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Import/Export action.';

                trigger OnAction()
                begin
                    //XMLPORT.RUN(XMLPORT::"Financial Statement Code");
                    REPORT.Run(REPORT::"Import/Export Fin. Stat. Codes"); // MP 24-11-14 Replaces above
                    CurrPage.Update(false);
                end;
            }
        }
    }
}

