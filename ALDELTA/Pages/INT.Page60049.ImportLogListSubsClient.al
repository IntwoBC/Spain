page 60049 "Import Log List - Subs. Client"
{
    Caption = 'Import Log List - Subsidiary Clients';
    Editable = false;
    PageType = List;
    SourceTable = "Import Log - Subsidiary Client";
    SourceTableView = ORDER(Descending);
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';

                }
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //
                    end;
                }
                field("Country Database Code"; Rec."Country Database Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country Database Code field.';


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //
                    end;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';

                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';

                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stage field.';

                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Creation Date field.';

                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Creation Time field.';

                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Rec.FindFirst() then;
    end;
}

