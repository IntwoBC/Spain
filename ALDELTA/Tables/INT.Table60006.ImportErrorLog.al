table 60006 "Import Error Log"
{
    Caption = 'Import Error Log';
    DrillDownPageID = "Import Error Log";
    LookupPageID = "Import Error Log";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Client No."; Code[20])
        {
            Caption = 'Client No.';
            TableRelation = "Parent Client";
        }
        field(3; "Country Database Code"; Code[20])
        {
            Caption = 'Country Database Code';
            TableRelation = "Country Database";
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(10; "Import Log Entry No."; BigInteger)
        {
            Caption = 'Import Log Entry No.';
            TableRelation = "Import Log";
        }
        field(20; "Staging Table Entry No."; BigInteger)
        {
            Caption = 'Staging Table Entry No.';
        }
        field(30; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(40; "Date & Time"; DateTime)
        {
            Caption = 'Date && Time';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Import Log Entry No.", "Client No.", "Country Database Code", "Company Name")
        {
        }
        key(Key3; "Import Log Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

