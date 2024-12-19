page 50005 "Yooz File - Import"
{
    ApplicationArea = All;
    Caption = 'Yooz File - Import';
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
                    YoozFileHand: XmlPort "Yooz File - Import";
                begin
                    YoozFileHand.Run();
                end;

            }
        }
    }
}
