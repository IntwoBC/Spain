table 60032 "Equity Recon. Entry Desc."
{
    Caption = 'Equity Reconciliation Entry Description';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Year; Integer)
        {
            BlankZero = true;
            Caption = 'Year';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code", Year, "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

