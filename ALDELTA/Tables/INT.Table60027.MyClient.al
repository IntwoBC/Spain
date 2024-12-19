table 60027 "My Client"
{
    // MP 18-11-14
    // NAV 2013 R2 Upgrade - Extended User ID from 20

    Caption = 'My Client';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Description = 'MP 18-11-14 Extended from 20';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                lmdlLoginMgt: Codeunit "User Management";
            begin
                //lmdlLoginMgt.LookupUserID("User ID");
            end;
        }
        field(2; "Parent Client No."; Code[20])
        {
            Caption = 'Parent Client No.';
            TableRelation = "Parent Client";
        }
        field(10; "Parent Client Name"; Text[50])
        {
            CalcFormula = Lookup("Parent Client".Name WHERE("No." = FIELD("Parent Client No.")));
            Caption = 'Parent Client Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Chart of Acc. Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST("Chart Of Accounts")));
            Caption = 'Chart of Accounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Corp. Chart of Acc.Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST("Corporate Chart Of Accounts")));
            Caption = 'Corp. Chart of Accounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "TB Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST("Trial Balance")));
            Caption = 'TB';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "G/L Entries Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST("GL Transactions")));
            Caption = 'G/L Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Customer Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST(Customer)));
            Caption = 'Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "AR Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST("AR Transactions")));
            Caption = 'AR';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Vendor Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST(Vendor)));
            Caption = 'Vendors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "AP Import Date"; Date)
        {
            CalcFormula = Max("Import Log"."Import Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                "Interface Type" = CONST(APTransactions)));
            Caption = 'AP';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "User ID", "Parent Client No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

