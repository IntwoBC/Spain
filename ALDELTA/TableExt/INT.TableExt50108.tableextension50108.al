tableextension 50108 tableextension50108 extends "Source Code Setup"
{
    // MP 06-03-12
    // Added fields "TB Reversal" and "Import Tool"
    // 
    // MP 02-05-14
    // Renumbered field "Bank Rec. Adjustment" from 60020 to 60030 due to conflict with Core II
    // Development taken from Core II for Reversal functionality
    fields
    {
        field(60000; "TB Reversal"; Code[10])
        {
            Caption = 'TB Reversal';
            Description = 'MP 06-03-12';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(60010; "Import Tool"; Code[10])
        {
            Caption = 'Import Tool';
            Description = 'MP 06-03-12';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(60020; "GAAP/Tax Reversal"; Code[10])
        {
            Caption = 'GAAP/Tax Reversal';
            Description = 'MD 25-09-12';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
    }
}

