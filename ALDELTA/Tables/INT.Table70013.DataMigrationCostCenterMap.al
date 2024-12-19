table 70013 "Data Migration Cost Center Map"
{
    DataClassification = CustomerContent;
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Table Creation


    fields
    {
        field(1; "MyTaxi Cost Center"; Text[30])
        {
        }
        field(2; "NAV Cost Center"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "MyTaxi Cost Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

