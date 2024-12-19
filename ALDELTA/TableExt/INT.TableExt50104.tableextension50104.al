tableextension 50104 tableextension50104 extends "G/L Account"
{
    fields
    {
        field(60000; "Account Class"; Option)
        {
            Caption = 'Account Class';
            OptionCaption = ' ,Balance Sheet,Equity,P&L';
            OptionMembers = " ","Balance Sheet",Equity,"P&L";
            DataClassification = CustomerContent;
        }
        field(60010; "Financial Statement Code"; Code[10])
        {
            Caption = 'Financial Statement Code';
            TableRelation = "Financial Statement Code";
            DataClassification = CustomerContent;
        }
        field(60040; "Name (English)"; Text[50])
        {
            Caption = 'Name (English)';
            Description = 'MP 02-02-12';
            DataClassification = CustomerContent;
        }
        field(60080; "Preposted Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Account No." = FIELD("No."),
                                                                        "Account No." = FIELD(FILTER(Totaling)),
                                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                        "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Preposted Net Change';
            Description = 'MP 19-11-13';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60090; "Preposted Net Change (Bal.)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Bal. Account No." = FIELD("No."),
                                                                         "Bal. Account No." = FIELD(FILTER(Totaling)),
                                                                         "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                         "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                         "Posting Date" = FIELD("Date Filter")));
            Caption = 'Preposted Net Change (Bal.)';
            Description = 'MP 19-11-13';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60200; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            Description = 'MP 19-11-13';
            TableRelation = "Corporate G/L Account";
            DataClassification = CustomerContent;
        }
        field(60210; "Corporate G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Corporate G/L Account No.")));
            Caption = 'Corporate G/L Account Name';
            Description = 'MP 19-02-14';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60300; BottomUp; Boolean)
        {
            CalcFormula = Exist("EY Core Setup" WHERE("Company Type" = CONST("Bottom-up")));
            Caption = 'Country Services';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60310; CorpAccInUse; Boolean)
        {
            CalcFormula = Exist("Corporate G/L Account");
            Caption = 'Corporate Accounts In Use';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Financial Statement Code")
        {
        }
        key(Key2; "Corporate G/L Account No.")
        {
        }
        key(Key3; "Financial Statement Code", "Corporate G/L Account No.")
        {
            MaintainSQLIndex = false;
        }
    }
}

