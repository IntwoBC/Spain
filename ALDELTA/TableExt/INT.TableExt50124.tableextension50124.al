tableextension 50124 tableextension50124 extends "Standard General Journal Line"
{
    // MP 21-02-12
    // Added fields "Corporate G/L Account No." and "Bal. Corporate G/L Account No."
    // 
    // MP 12-May-16
    // Added field BottomUp (NAV 2016 Upgrade)
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account"),
                                BottomUp = CONST(true),
                                "Corporate G/L Account No." = FILTER(<> '')) "G/L Account" WHERE("Corporate G/L Account No." = FIELD("Corporate G/L Account No."))
            ELSE
            IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account"),
                                BottomUp = CONST(true),
                                "Bal. Corporate G/L Account No." = FILTER(<> '')) "G/L Account" WHERE("Corporate G/L Account No." = FIELD("Bal. Corporate G/L Account No."))
            ELSE
            IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(60000; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            Description = 'MP 21-02-12';
            TableRelation = IF (BottomUp = CONST(false),
                                "Account No." = FILTER(<> '')) "Corporate G/L Account" WHERE("Local G/L Account No." = FIELD("Account No."))
            ELSE
            "Corporate G/L Account";
            DataClassification = CustomerContent;
        }
        field(60010; "Bal. Corporate G/L Account No."; Code[20])
        {
            Caption = 'Bal. Corporate G/L Account No.';
            Description = 'MP 21-02-12';
            TableRelation = IF (BottomUp = CONST(false),
                                "Bal. Account No." = FILTER(<> '')) "Corporate G/L Account" WHERE("Local G/L Account No." = FIELD("Bal. Account No."))
            ELSE
            "Corporate G/L Account";
            DataClassification = CustomerContent;
        }
        field(60300; BottomUp; Boolean)
        {
            CalcFormula = Exist("EY Core Setup" WHERE("Company Type" = CONST("Bottom-up")));
            Caption = 'Country Services';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

