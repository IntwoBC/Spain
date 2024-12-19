page 70011 "Data Migration VAT Group Map"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Page Creation

    PageType = List;
    SourceTable = "Data Migration VAT Group Map";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("MayTaxi VAT Prod Group"; Rec."MayTaxi VAT Prod Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the MayTaxi VAT Prod Group field.';
                }
                field("NAV VAT Prod Group"; Rec."NAV VAT Prod Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NAV VAT Prod Group field.';
                }
            }
        }
    }

    actions
    {
    }
}

