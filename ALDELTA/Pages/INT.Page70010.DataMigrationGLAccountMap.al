page 70010 "Data Migration GL Account Map"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Page Creation

    PageType = List;
    SourceTable = "Data Migration GL Account Map";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("MyTaxi Account"; Rec."MyTaxi Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the MyTaxi Account field.';
                }
                field("Group Account"; Rec."Group Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Group Account field.';
                }
                field("Local Account"; Rec."Local Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Local Account field.';
                }
            }
        }
    }

    actions
    {
    }
}

