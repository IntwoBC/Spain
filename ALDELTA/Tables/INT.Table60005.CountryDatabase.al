table 60005 "Country Database"
{
    // MP 26-11-14
    // NAV 2013 R2 Upgrade - added field "Tenant Id"

    Caption = 'Country Database';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Country Database Code"; Code[10])
        {
            Caption = 'Country Database Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "Server Address (Web Service)"; Text[250])
        {
            Caption = 'Server Address (Web Service)';
            ExtendedDatatype = URL;
        }
        field(30; "Tenant Id"; Text[30])
        {
            Caption = 'Tenant Id';
            Description = 'MP 26-11-14';
        }
    }

    keys
    {
        key(Key1; "Country Database Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

