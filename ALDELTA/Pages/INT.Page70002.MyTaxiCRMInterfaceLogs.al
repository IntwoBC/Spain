page 70002 "MyTaxi CRM Interface Logs"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation

    Caption = 'MyTaxi CRM Interface Logs';
    Editable = false;
    PageType = List;
    SourceTable = "MyTaxi CRM Interface Logs";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Batch No. field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time field.';
                }
                field("Interface Code"; Rec."Interface Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Code field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Table Position"; Rec."Table Position")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Position field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason Description field.';
                }
                field("File Link"; Rec."File Link")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Link field.';
                }
                field("Flow Type"; Rec."Flow Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Flow Type field.';
                }
                field("Sent by Email"; Rec."Sent by Email")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sent by Email field.';
                }
                field("Email Date"; Rec."Email Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Email Date field.';
                }
                field("Email Time"; Rec."Email Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Email Time field.';
                }
            }
        }
    }

    actions
    {
    }
}

