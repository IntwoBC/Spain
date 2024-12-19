table 60016 "Financial Statement Code"
{
    // MP 14-04-14
    // Extended field length for Description and "Description (English) from 50 to 100

    Caption = 'Financial Statement Code';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            Description = 'MP 14-04-14';
        }
        field(20; "Description (English)"; Text[100])
        {
            Caption = 'Description (English)';
            Description = 'MP 14-04-14';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Description (English)")
        {
        }
    }
}

