table 70011 "Data Migration VAT Group Map"
{
    DataClassification = CustomerContent;
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Table Creation


    fields
    {
        field(1; "MayTaxi VAT Prod Group"; Code[20])
        {
        }
        field(2; "NAV VAT Prod Group"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "MayTaxi VAT Prod Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

