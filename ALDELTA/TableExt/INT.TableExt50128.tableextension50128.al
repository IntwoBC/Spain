tableextension 50128 tableextension50128 extends "Cash Flow Worksheet Line"
{
    // T107800 001 06/04/2021 AMH : Code CC1 dimension name
    //                              * Add field 50000 - Corp. GL Acc. No.
    //                              * Add field 50001 - Corp. GL Acc. Name
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
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Corp. GL Acc. No.")));
            Caption = 'Corp. GL Acc. Name';
            Editable = false;
            FieldClass = FlowField;
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

