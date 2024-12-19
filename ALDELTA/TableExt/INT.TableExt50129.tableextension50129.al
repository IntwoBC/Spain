tableextension 50129 tableextension50129 extends "Cash Flow Forecast Entry"
{
    // SUP:ISSUE:109077  04/05/2021 COSMO.ABT
    //    # Added two new fields: 50000 "Corp. GL Acc. No." Code[20].
    //                            50001 "Corp. GL Acc. Name" Text[50].
    // 
    // SUP:ISSUE:108784 06/05/2021 COSMO.ABT
    //    # Added three new fields: 50002 "Company Name"  Text[50].
    //                              50003 "Country Name"  Text[50].
    //                              50004 "Currency Code" Code[10].
    fields
    {
        field(50000; "Corp. GL Acc. No."; Code[20])
        {
            Caption = 'Corp. GL Acc. No.';
            DataClassification = CustomerContent;
            TableRelation = "Corporate G/L Account"."No.";
        }
        field(50001; "Corp. GL Acc. Name"; Text[50])
        {
            Caption = 'Corp. GL Acc. Name';
            DataClassification = CustomerContent;
        }
        field(50002; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(50003; "Country Name"; Text[50])
        {
            Caption = 'Country Name';
            DataClassification = CustomerContent;
        }
        field(50004; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
    }
}

