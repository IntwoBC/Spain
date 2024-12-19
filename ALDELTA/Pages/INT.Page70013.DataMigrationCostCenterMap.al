page 70013 "Data Migration Cost Center Map"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Page Creation

    PageType = List;
    SourceTable = "Data Migration Cost Center Map";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("MyTaxi Cost Center"; Rec."MyTaxi Cost Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the MyTaxi Cost Center field.';
                }
                field("NAV Cost Center"; Rec."NAV Cost Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV Cost Center field.';
                }
            }
        }
    }

    actions
    {
    }
}

