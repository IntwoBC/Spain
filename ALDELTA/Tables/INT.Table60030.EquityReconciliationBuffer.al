table 60030 "Equity Reconciliation Buffer"
{
    // MP 06-12-12
    // Added field "Start Balance"

    Caption = 'Equity Reconciliation Buffer';
    DataClassification = CustomerContent;


    fields
    {
        field(1; Year; Integer)
        {
            Caption = 'Year';
        }
        field(2; "Equity Correction Code"; Code[10])
        {
            Caption = 'Equity Correction Code';
            TableRelation = "Equity Correction Code";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "Net Change (P&L)"; Decimal)
        {
            Caption = 'Net Change (P&L)';
        }
        field(20; "Net Change (Equity)"; Decimal)
        {
            Caption = 'Net Change (Equity)';
        }
        field(30; "Year Start Date"; Date)
        {
            Caption = 'Year Start Date';
        }
        field(40; "Year End Date"; Date)
        {
            Caption = 'Year End Date';
        }
        field(50; "Entry Description"; Text[50])
        {
            Caption = 'Entry Description';
        }
        field(80; "Start Balance"; Decimal)
        {
            Caption = 'Start Balance';
            Description = 'MP 06-12-12';
        }
    }

    keys
    {
        key(Key1; Year, "Equity Correction Code", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

