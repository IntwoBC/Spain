table 60011 "Status Color"
{
    Caption = 'Status Color';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Imported,In Progress,Error,Processed';
            OptionMembers = Imported,"In Progress",Error,Processed;
        }
        field(10; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; Status)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

