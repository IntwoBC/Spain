table 60017 "G/L Account Prepost Balance"
{
    Caption = 'G/L Account Net Change';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Net Change in Jnl."; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Net Change in Jnl.';
        }
        field(4; "Balance after Posting"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance after Posting';
        }
        field(10; "G/L Account No. (Local)"; Code[20])
        {
            Caption = 'G/L Account No. (Local)';
        }
        field(20; "Start Balance"; Decimal)
        {
            Caption = 'Start Balance';
        }
        field(30; "Posted Adjustments"; Decimal)
        {
            Caption = 'Posted Adjustments';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

