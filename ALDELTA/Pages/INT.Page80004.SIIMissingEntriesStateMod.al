page 80004 "SII Missing Entries State Mod"
{
    PageType = List;
    SourceTable = "SII Missing Entries State";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Primary Key field.';
                }
                field("Last CLE No."; Rec."Last CLE No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Cust. Ledg. Entry No. field.';
                }
                field("Last VLE No."; Rec."Last VLE No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Vend. Ledg. Entry No. field.';
                }
                field("Last DCLE No."; Rec."Last DCLE No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Dtld. Cust. Ledg. Entry No. field.';
                }
                field("Last DVLE No."; Rec."Last DVLE No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Dtld. Vend. Ledg. Entry No. field.';
                }
                field("Entries Missing"; Rec."Entries Missing")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entries Missing field.';
                }
                field("Last Missing Entries Check"; Rec."Last Missing Entries Check")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Missing Entries Check field.';
                }
            }
        }
    }

    actions
    {
    }
}

