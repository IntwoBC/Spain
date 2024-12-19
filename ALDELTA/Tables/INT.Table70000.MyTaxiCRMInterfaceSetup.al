table 70000 "MyTaxi CRM Interface Setup"
{
    DataClassification = CustomerContent;
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Table Creation
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : Retreive bank account details from CRM App
    //   New added fields : 9 "Bank Account No Start Position", 10 "Bank Account No Start Length"
    // #MyTaxi.W1.CRE.INT01.011 18/05/2018 CCFR.SDE : Set the cost center 2 dimension on sales header
    //   New added field : 11 "Cost Center 2 Dimension Code"
    // 
    // PK 12-08-24 EY-MYES0003 Case CS0806754 / Feature 6079423
    // Field added
    //  - Master Data by ID WS


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Web Service Base URL"; Text[250])
        {
            Caption = 'Web Service Base URL';
        }
        field(3; User; Text[30])
        {
            Caption = 'User';
        }
        field(4; Password; Text[100])
        {
            Caption = 'Password';
        }
        field(5; "Master Data WS"; Text[100])
        {
            Caption = 'Master Data WS';
        }
        field(6; "Invoice List WS"; Text[100])
        {
            Caption = 'Invoice List WS';
        }
        field(7; "Invoice WS"; Text[100])
        {
            Caption = 'Invoice WS';
        }
        field(8; "Master Data Last Max Date"; Date)
        {
        }
        field(9; "Bank Account No Start Position"; Integer)
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(10; "Bank Account No Length"; Integer)
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
            MaxValue = 10;
        }
        field(11; "Cost Center 2 Dimension Code"; Code[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.011';
            TableRelation = Dimension;
        }
        field(80000; "Master Data by ID WS"; Text[100])
        {
            Description = 'EY-MYES0003';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

