table 70004 "MyTaxi CRM Interf Sub Records"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Table Creation

    Caption = 'MyTaxi CRM Interface Sub Records';
    DrillDownPageID = "MyTaxi CRM Interface Sub Doc.";
    LookupPageID = "MyTaxi CRM Interface Sub Doc.";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Records Entry No."; Integer)
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; invoiceid; Integer)
        {
        }
        field(4; typeOfAdditionalNote; Text[30])
        {
        }
        field(5; accountNumber; Text[30])
        {
        }
        field(6; netCredit; Decimal)
        {
        }
        field(7; taxCredit; Decimal)
        {
        }
        field(8; grossCredit; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Records Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

