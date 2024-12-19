page 60043 "Import Page"
{
    Caption = 'Import Page';
    PageType = Card;
    SourceTable = "Integer";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(gcodParentNumber; gcodParentNumber)
                {
                    Caption = 'Parent No.';
                    TableRelation = "Parent Client"."No.";
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent No. field.';

                }
            }
        }
    }

    actions
    {
    }

    var
        gcodParentNumber: Code[20];
        grecParentClient: Record "Parent Client";


    procedure gfncGetParentCustomerNo(): Code[20]
    begin
        exit(gcodParentNumber);
    end;
}

