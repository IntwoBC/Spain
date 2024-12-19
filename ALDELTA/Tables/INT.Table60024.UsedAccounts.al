table 60024 "Used Accounts"
{
    Caption = 'Used Accounts';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(2; No; Code[20])
        {
            Caption = 'No';
        }
        field(10; Corporate; Boolean)
        {
            Caption = 'Corporate';
        }
    }

    keys
    {
        key(Key1; Type, No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

