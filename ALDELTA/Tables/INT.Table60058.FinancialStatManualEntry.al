table 60058 "Financial Stat. Manual Entry"
{
    // MP 02-12-13
    // New table (CR 31 - Case 14140)

    Caption = 'Financial Statement Manual Entry';
    DataCaptionFields = "Financial Stat. Structure Code";
    DrillDownPageID = "Financial Stat. Manual Entries";
    LookupPageID = "Financial Stat. Manual Entries";
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Financial Stat. Structure Code"; Code[20])
        {
            Caption = 'Financial Stat. Structure Code';
            TableRelation = "Financial Statement Structure";
        }
        field(2; "Financial Stat. Line No."; Integer)
        {
            Caption = 'Financial Stat. Line No.';
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
        }
        field(10; "Start Balance"; Decimal)
        {
            Caption = 'Start Balance';
        }
        field(20; "End Balance"; Decimal)
        {
            Caption = 'End Balance';
        }
    }

    keys
    {
        key(Key1; "Financial Stat. Structure Code", "Financial Stat. Line No.", Date)
        {
            Clustered = true;
            SumIndexFields = "Start Balance", "End Balance";
        }
    }

    fieldgroups
    {
    }
}

