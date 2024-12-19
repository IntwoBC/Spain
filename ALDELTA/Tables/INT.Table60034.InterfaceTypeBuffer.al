table 60034 "Interface Type Buffer"
{
    Caption = 'Interface Type Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            Editable = false;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(10; "Parent Client"; Code[20])
        {
            Caption = 'Parent Client';
            FieldClass = FlowFilter;
            TableRelation = "Parent Client";
        }
        field(12; "Subsidiary Client"; Code[20])
        {
            Caption = 'Subsidiary Client';
            FieldClass = FlowFilter;
        }
        field(15; "Start Date"; Date)
        {
            Caption = 'Start Date';
            FieldClass = FlowFilter;
        }
        field(20; "Period Type"; Option)
        {
            Caption = 'Period Type';
            FieldClass = FlowFilter;
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(101; Status_01; BLOB)
        {
            Caption = 'Status_01';
            SubType = Bitmap;
        }
        field(102; Status_02; BLOB)
        {
            Caption = 'Status_02';
            SubType = Bitmap;
        }
        field(103; Status_03; BLOB)
        {
            Caption = 'Status_03';
            SubType = Bitmap;
        }
        field(104; Status_04; BLOB)
        {
            Caption = 'Status_04';
            SubType = Bitmap;
        }
        field(105; Status_05; BLOB)
        {
            Caption = 'Status_05';
            SubType = Bitmap;
        }
        field(106; Status_06; BLOB)
        {
            Caption = 'Status_06';
            SubType = Bitmap;
        }
        field(107; Status_07; BLOB)
        {
            Caption = 'Status_07';
            SubType = Bitmap;
        }
        field(108; Status_08; BLOB)
        {
            Caption = 'Status_08';
            SubType = Bitmap;
        }
        field(109; Status_09; BLOB)
        {
            Caption = 'Status_09';
            SubType = Bitmap;
        }
        field(110; Status_10; BLOB)
        {
            Caption = 'Status_10';
            SubType = Bitmap;
        }
        field(111; Status_11; BLOB)
        {
            Caption = 'Status_11';
            SubType = Bitmap;
        }
        field(112; Status_12; BLOB)
        {
            Caption = 'Status_12';
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

