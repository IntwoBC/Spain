page 70000 "MyTaxi CRM Interface Setup"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : Retreive bank account details from CRM App
    //   New added fields : 9 "Bank Account No Start Position", 10 "Bank Account No Start Length"
    // #MyTaxi.W1.CRE.INT01.011 18/05/2018 CCFR.SDE : Set the cost center 2 dimension on sales header
    //   New added field : 11 "Cost Center 2 Dimension Code"
    // 
    // PK 12-08-24 EY-MYES0003 Case CS0806754 / Feature 6079423
    // Field added
    //   - Master Data by ID WS

    PageType = Card;
    SourceTable = "MyTaxi CRM Interface Setup";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Web Service Base URL"; Rec."Web Service Base URL")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Web Service Base URL field.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Password; Rec.Password)
                {
                    ExtendedDatatype = Masked;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Password field.';
                }
                field("Master Data WS"; Rec."Master Data WS")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Master Data WS field.';
                }
                field("Master Data by ID WS"; Rec."Master Data by ID WS")
                {
                    Description = 'EY-MYES0003';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Master Data by ID WS field.';
                }
                field("Invoice List WS"; Rec."Invoice List WS")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice List WS field.';
                }
                field("Invoice WS"; Rec."Invoice WS")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice WS field.';
                }
                field("Master Data Last Max Date"; Rec."Master Data Last Max Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Master Data Last Max Date field.';
                }
                field("Bank Account No Start Position"; Rec."Bank Account No Start Position")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No Start Position field.';
                }
                field("Bank Account No Length"; Rec."Bank Account No Length")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No Length field.';
                }
                field("Cost Center 2 Dimension Code"; Rec."Cost Center 2 Dimension Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cost Center 2 Dimension Code field.';
                }
            }
        }
    }

    actions
    {
    }
}

