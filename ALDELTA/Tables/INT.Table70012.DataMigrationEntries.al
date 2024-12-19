table 70012 "Data Migration Entries"
{
    DataClassification = CustomerContent;
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Table Creation


    fields
    {
        field(1; SerialNo; Integer)
        {
        }
        field(2; EntryType; Text[30])
        {
        }
        field(3; Date; Date)
        {
        }
        field(4; AccountNo; Text[30])
        {
        }
        field(5; EntryNo; Text[30])
        {
        }
        field(6; Text; Text[250])
        {
        }
        field(7; AmountEUR; Decimal)
        {
        }
        field(8; Currency; Text[30])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; ProjectNo; Text[30])
        {
        }
        field(11; ActivityNo; Text[30])
        {
        }
        field(12; CustomerNo; Text[30])
        {
        }
        field(13; SupplierNo; Text[30])
        {
        }
        field(14; InvoiceNo; Text[30])
        {
        }
        field(15; SupplierInvoiceNo; Text[30])
        {
        }
        field(16; DueDate; Date)
        {
        }
        field(17; VATCode; Text[30])
        {
        }
        field(18; Department; Text[30])
        {
        }
        field(19; Unit1No; Text[30])
        {
        }
        field(20; Unit2No; Text[30])
        {
        }
        field(21; Quantity; Decimal)
        {
        }
        field(22; Quantity2; Decimal)
        {
        }
        field(70000; Processed; Boolean)
        {
        }
        field(70001; "Processed On"; DateTime)
        {
        }
        field(70002; "Processed By"; Code[50])
        {
        }
        field(70003; "Error Description 1"; Text[250])
        {
        }
        field(70004; "Error Description 2"; Text[250])
        {
        }
        field(70005; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(70006; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(70007; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(70008; "Process in Error"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; SerialNo)
        {
            Clustered = true;
        }
        key(Key2; EntryNo)
        {
        }
        key(Key3; "Process in Error")
        {
        }
    }

    fieldgroups
    {
    }
}

