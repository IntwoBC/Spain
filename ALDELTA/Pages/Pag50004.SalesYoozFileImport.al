page 50004 "Sales - Yooz File - Import"
{
    ApplicationArea = All;
    Caption = 'Sales - Yooz File - Import';
    PageType = List;
    UsageCategory = Lists;

    actions
    {
        area(processing)
        {
            action(SalesYoozFileImport)
            {
                ApplicationArea = all;
                Caption = 'Import Yooz File';


                trigger OnAction()
                var
                    YoozFileHandler: XmlPort "Sales - Yooz File - Import";
                begin
                    YoozFileHandler.Run();
                end;

            }
        }
    }
}

