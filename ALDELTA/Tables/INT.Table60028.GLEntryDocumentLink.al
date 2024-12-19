table 60028 "G/L Entry Document Link"
{
    Caption = 'G/L Entry Document Link';
    DrillDownPageID = "G/L Entry Document Links";
    LookupPageID = "G/L Entry Document Links";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
    }

    keys
    {
        key(Key1; "Transaction No.", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

