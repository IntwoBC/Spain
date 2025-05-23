page 70006 "MyTaxi CRM Int. Posting Map."
{
    Caption = 'MyTaxi CRM Int. Posting Mapping';
    PageType = List;
    SourceTable = "MyTaxi CRM Int. Posting Map.";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice Type"; Rec."Invoice Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field(Account; Rec.Account)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account field.';
                }
                field("Type Of Additional Note"; Rec."Type Of Additional Note")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type Of Additional Note field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field("VAT Product Posting Group"; Rec."VAT Product Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Product Posting Group field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
            }
        }
    }

    actions
    {
    }
}

