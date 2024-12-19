page 60095 "Financial Stat. Manual Entries"
{
    // MP 04-12-13
    // Object created (CR 30)

    Caption = 'Financial Statement Manual Entries';
    PageType = List;
    SourceTable = "Financial Stat. Manual Entry";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Start Balance"; Rec."Start Balance")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Start Balance field.';
                }
                field("End Balance"; Rec."End Balance")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Balance field.';
                }
            }
        }
    }

    actions
    {
    }
}

