page 70005 "MyTaxi CRM Interface Sub Doc."
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation

    Caption = 'MyTaxi CRM Interface Sub Document';
    PageType = List;
    SourceTable = "MyTaxi CRM Interf Sub Records";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Records Entry No."; Rec."Records Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Records Entry No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(invoiceid; Rec.invoiceid)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the invoiceid field.';
                }
                field(typeOfAdditionalNote; Rec.typeOfAdditionalNote)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the typeOfAdditionalNote field.';
                }
                field(accountNumber; Rec.accountNumber)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the accountNumber field.';
                }
                field(netCredit; Rec.netCredit)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the netCredit field.';
                }
                field(taxCredit; Rec.taxCredit)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the taxCredit field.';
                }
                field(grossCredit; Rec.grossCredit)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the grossCredit field.';
                }
            }
        }
    }

    actions
    {
    }
}

