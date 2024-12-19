page 70001 "MyTaxi CRM Int. Posting Setup"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Page Creation
    // #MyTaxi.W1.CRE.INT01.012 18/05/2018 CCFR.SDE : Set a default value in field "Reminder Terms Code" when a customer is created
    //   New added field : 38 "Default Cust. Rem. Terms Code"

    Caption = 'MyTaxi CRM Interface Posting Setup';
    PageType = List;
    SourceTable = "MyTaxi CRM Int. Posting Setup";
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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field("Cash Rec. Jnl. Template Name"; Rec."Cash Rec. Jnl. Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cash Receipt Journal Template Name field.';
                }
                field("Cash Rec. Jnl. Batch Name"; Rec."Cash Rec. Jnl. Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cash Receipt Journal Batch Name field.';
                }
                field("Auto-Post Payment Journal"; Rec."Auto-Post Payment Journal")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Auto-Post Payment Journal field.';
                }
                field("Sum Gross Value GL Account"; Rec."Sum Gross Value GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sum Gross Value GL Account field.';
                }
                field("Sum Gross Value VAT Grp"; Rec."Sum Gross Value VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sum Gross Value VAT Prod. Posting Group field.';
                }
                field("Discount Commission GL Account"; Rec."Discount Commission GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Discount Commission GL Account field.';
                }
                field("Disc. Com. VAT Prod Post Group"; Rec."Disc. Com. VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Discount Commission VAT Prod. Posting Group field.';
                }
                field("Commission GL Account"; Rec."Commission GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Commission GL Account field.';
                }
                field("Commission VAT Prod Post Group"; Rec."Commission VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Commission VAT Prod. Posting Group field.';
                }
                field("Hotel Value GL Account"; Rec."Hotel Value GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Hotel Value GL Account field.';
                }
                field("Hotel Val VAT Prod Post Group"; Rec."Hotel Val VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Hotel Value VAT Prod. Posting Group field.';
                }
                field("Invoicing Fee GL Account"; Rec."Invoicing Fee GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoicing Fee GL Account field.';
                }
                field("Inv Fee VAT Prod Post Group"; Rec."Inv Fee VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoicing Fee VAT Prod. Posting Group field.';
                }
                field("Payment Fee MP GL Account"; Rec."Payment Fee MP GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Fee MP GL Account field.';
                }
                field("Pay Fee MP VAT Prod Post Group"; Rec."Pay Fee MP VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Fee MP VAT Prod. Posting Group field.';
                }
                field("Payment Fee BA GL Account"; Rec."Payment Fee BA GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Fee BA GL Account field.';
                }
                field("Pay Fee BA VAT Prod Post Group"; Rec."Pay Fee BA VAT Prod Post Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Fee BA VAT Prod. Posting Group field.';
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer Posting Group field.';
                }
                field("Default Cust. Rem. Terms Code"; Rec."Default Cust. Rem. Terms Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Customer Reminder Terms Code field.';
                }
                field("Automatic Posting"; Rec."Automatic Posting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Automatic Posting field.';
                }
                field("On Car Advert. Account"; Rec."On Car Advert. Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the On Car Advertisement Account field.';
                }
                field("On Car Advert. GL Account"; Rec."On Car Advert. GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the On Car Advertisement GL Account field.';
                }
                field("On Car Advert. VAT Grp"; Rec."On Car Advert. VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the On Car Advertisement VAT Product Posting Group field.';
                }
                field("Driver Ref. Prog. Account"; Rec."Driver Ref. Prog. Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Referral Program Account field.';
                }
                field("Driver Ref. Prog. GL Acc."; Rec."Driver Ref. Prog. GL Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Referral Program GL Account field.';
                }
                field("Driver Ref. Prog. VAT Grp"; Rec."Driver Ref. Prog. VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Referral Program VAT Product Posting Group field.';
                }
                field("Driver Incent. Prog. Account"; Rec."Driver Incent. Prog. Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Incentive Program Account field.';
                }
                field("Driver Incent. Prog. GL Acc."; Rec."Driver Incent. Prog. GL Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Incentive Program GL Account field.';
                }
                field("Driver Incent. Prog. VAT Grp"; Rec."Driver Incent. Prog. VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Incentive Program VAT Product Posting Group field.';
                }
                field("Driver Comp. Fee Account"; Rec."Driver Comp. Fee Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Compensation Fee Account field.';
                }
                field("Driver Comp. Fee GL Account"; Rec."Driver Comp. Fee GL Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Compensation Fee GL Account field.';
                }
                field("Driver Comp. Fee VAT Grp"; Rec."Driver Comp. Fee VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Driver Compensation Fee VAT Product Posting Group field.';
                }
                field("Commission Fee Corr. Account"; Rec."Commission Fee Corr. Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Commission Fee Correction Account field.';
                }
                field("Commission Fee Corr. GL Acc."; Rec."Commission Fee Corr. GL Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Commission Fee Correction GL Account field.';
                }
                field("Commission Fee Corr. VAT Grp"; Rec."Commission Fee Corr. VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Commission Fee Correction VAT Product Posting Group field.';
                }
                field("Mobile Pay. Fee Corr. Account"; Rec."Mobile Pay. Fee Corr. Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Mobile Payment Fee Correction Account field.';
                }
                field("Mobile Pay. Fee Corr. GL Acc."; Rec."Mobile Pay. Fee Corr. GL Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Mobile Payment Fee Correction GL Account field.';
                }
                field("Mobile Pay. Fee Corr. VAT Grp"; Rec."Mobile Pay. Fee Corr. VAT Grp")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Mobile Payment Fee Correction VAT Product Posting Group field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000017; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Account Mapping")
            {
                Caption = 'Account Mapping';
                Image = MapAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "MyTaxi CRM Int. Posting Map.";
                RunPageLink = "Invoice Type" = FIELD("Invoice Type");
                RunPageMode = Edit;
                ApplicationArea = all;
                ToolTip = 'Executes the Account Mapping action.';
            }
        }
    }
}

