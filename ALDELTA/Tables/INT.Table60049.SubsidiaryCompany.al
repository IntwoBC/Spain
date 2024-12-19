table 60049 "Subsidiary Company"
{
    Caption = 'Subsidiary Company';
    DrillDownPageID = "Subsidiary Company";
    LookupPageID = "Subsidiary Company";
    DataClassification = CustomerContent;


    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

