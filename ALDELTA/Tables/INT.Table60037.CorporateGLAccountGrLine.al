table 60037 "Corporate G/L Account Gr. Line"
{
    Caption = 'Corporate G/L Account Group Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Corp. G/L Account Group Code"; Code[10])
        {
            Caption = 'Corp. G/L Account Group Code';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Corporate G/L Account Filter"; Text[250])
        {
            Caption = 'Corporate G/L Account Filter';
            TableRelation = "Corporate G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Corp. G/L Account Group Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

