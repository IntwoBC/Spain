tableextension 50111 tableextension50111 extends "Bank Account Ledger Entry"
{
    // TEC 02-12-13 -mdan-
    //   + key
    //     Bank Account No.,Posting Date,Statement Status
    keys
    {
        key(PK; "Bank Account No.", "Posting Date", "Statement Status")
        {
        }
    }
}

