tableextension 50122 tableextension50122 extends "Detailed Vendor Ledg. Entry"
{
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Field added:
    //   - Applied by Batch Job
    fields
    {
        field(80100; "Applied by Batch Job"; Boolean)
        {
            Caption = 'Applied by Batch Job';
            DataClassification = CustomerContent;
            Description = 'EY-MYES0004';
        }
    }
}

