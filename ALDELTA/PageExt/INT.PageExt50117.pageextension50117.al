pageextension 50117 pageextension50117 extends "Reminder Levels"
{
    // #MyTaxi.W1.CRE.ACREC.001 28/11/2017 CCFR.SDE : Print Level Custom Report Layout
    //   New added field : "Custom Report Selection ID"
    layout
    {
        addafter("Add. Fee per Line Description")
        {
            field("Custom Report Selection ID"; Rec."Custom Report Selection ID")
            {
                Description = 'MyTaxi.W1.CRE.ACREC.001';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Custom Report Selection ID field.';
            }
        }
    }
}

