table 70001 "MyTaxi CRM Int. Posting Setup"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Table Creation
    // #MyTaxi.W1.CRE.INT01.012 18/05/2018 CCFR.SDE : Set a default value in field "Reminder Terms Code" when a customer is created
    //   New added field : 38 "Default Cust. Rem. Terms Code"

    Caption = 'MyTaxi CRM Interface Posting Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Invoice Type"; Code[20])
        {
        }
        field(2; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(3; "Discount Commission GL Account"; Code[20])
        {
            Caption = 'Discount Commission GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Discount Commission GL Account");
            end;
        }
        field(4; "Disc. Com. VAT Prod Post Group"; Code[10])
        {
            Caption = 'Discount Commission VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(5; "Commission GL Account"; Code[20])
        {
            Caption = 'Commission GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Commission GL Account");
            end;
        }
        field(6; "Commission VAT Prod Post Group"; Code[10])
        {
            Caption = 'Commission VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(7; "Hotel Value GL Account"; Code[20])
        {
            Caption = 'Hotel Value GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Hotel Value GL Account");
            end;
        }
        field(8; "Hotel Val VAT Prod Post Group"; Code[10])
        {
            Caption = 'Hotel Value VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(9; "Invoicing Fee GL Account"; Code[20])
        {
            Caption = 'Invoicing Fee GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Invoicing Fee GL Account");
            end;
        }
        field(10; "Inv Fee VAT Prod Post Group"; Code[10])
        {
            Caption = 'Invoicing Fee VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(11; "Payment Fee MP GL Account"; Code[20])
        {
            Caption = 'Payment Fee MP GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee MP GL Account");
            end;
        }
        field(12; "Pay Fee MP VAT Prod Post Group"; Code[10])
        {
            Caption = 'Payment Fee MP VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(13; "Payment Fee BA GL Account"; Code[20])
        {
            Caption = 'Payment Fee BA GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(14; "Pay Fee BA VAT Prod Post Group"; Code[10])
        {
            Caption = 'Payment Fee BA VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(15; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(16; "Automatic Posting"; Boolean)
        {
            Caption = 'Automatic Posting';
        }
        field(17; "On Car Advert. Account"; Code[20])
        {
            Caption = 'On Car Advertisement Account';
        }
        field(18; "On Car Advert. GL Account"; Code[20])
        {
            Caption = 'On Car Advertisement GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(19; "On Car Advert. VAT Grp"; Code[10])
        {
            Caption = 'On Car Advertisement VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(20; "Driver Ref. Prog. Account"; Code[20])
        {
            Caption = 'Driver Referral Program Account';
        }
        field(21; "Driver Ref. Prog. GL Acc."; Code[20])
        {
            Caption = 'Driver Referral Program GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(22; "Driver Ref. Prog. VAT Grp"; Code[10])
        {
            Caption = 'Driver Referral Program VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(23; "Driver Incent. Prog. Account"; Code[20])
        {
            Caption = 'Driver Incentive Program Account';
        }
        field(24; "Driver Incent. Prog. GL Acc."; Code[20])
        {
            Caption = 'Driver Incentive Program GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(25; "Driver Incent. Prog. VAT Grp"; Code[10])
        {
            Caption = 'Driver Incentive Program VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(26; "Driver Comp. Fee Account"; Code[20])
        {
            Caption = 'Driver Compensation Fee Account';
        }
        field(27; "Driver Comp. Fee GL Account"; Code[20])
        {
            Caption = 'Driver Compensation Fee GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(28; "Driver Comp. Fee VAT Grp"; Code[10])
        {
            Caption = 'Driver Compensation Fee VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(29; "Commission Fee Corr. Account"; Code[20])
        {
            Caption = 'Commission Fee Correction Account';
        }
        field(30; "Commission Fee Corr. GL Acc."; Code[20])
        {
            Caption = 'Commission Fee Correction GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(31; "Commission Fee Corr. VAT Grp"; Code[10])
        {
            Caption = 'Commission Fee Correction VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(32; "Mobile Pay. Fee Corr. Account"; Code[20])
        {
            Caption = 'Mobile Payment Fee Correction Account';
        }
        field(33; "Mobile Pay. Fee Corr. GL Acc."; Code[20])
        {
            Caption = 'Mobile Payment Fee Correction GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Payment Fee BA GL Account");
            end;
        }
        field(34; "Mobile Pay. Fee Corr. VAT Grp"; Code[10])
        {
            Caption = 'Mobile Payment Fee Correction VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(35; "Sum Gross Value GL Account"; Code[20])
        {
            Caption = 'Sum Gross Value GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Commission GL Account");
            end;
        }
        field(36; "Sum Gross Value VAT Grp"; Code[10])
        {
            Caption = 'Sum Gross Value VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(38; "Default Cust. Rem. Terms Code"; Code[10])
        {
            Caption = 'Default Customer Reminder Terms Code';
            Description = 'MyTaxi.W1.CRE.INT01.012';
            TableRelation = "Reminder Terms";
        }
        field(100; "Cash Rec. Jnl. Template Name"; Code[10])
        {
            Caption = 'Cash Receipt Journal Template Name';
            TableRelation = "Gen. Journal Template" WHERE(Type = CONST("Cash Receipts"));
        }
        field(101; "Cash Rec. Jnl. Batch Name"; Code[10])
        {
            Caption = 'Cash Receipt Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cash Rec. Jnl. Template Name"));
        }
        field(102; "Auto-Post Payment Journal"; Boolean)
        {
            Caption = 'Auto-Post Payment Journal';
        }
    }

    keys
    {
        key(Key1; "Invoice Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc();
            GLAcc.TestField("Account Type", GLAcc."Account Type"::Posting);
            GLAcc.TestField(Blocked, false);
            GLAcc.TestField("Direct Posting");
        end;
    end;
}

