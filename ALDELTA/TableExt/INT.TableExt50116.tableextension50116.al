tableextension 50116 tableextension50116 extends "Payment Method"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // PMT  01.11.08   OPplus Payment
    //                 - New Fields added
    // -----------------------------------------------------
    Caption = 'Payment Method';
    fields
    {
        modify("Code")
        {
            Caption = 'Code';
        }
        modify(Description)
        {
            Caption = 'Description';
        }
        modify("Bal. Account Type")
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
        }
        modify("Bal. Account No.")
        {
            Caption = 'Bal. Account No.';
        }
        modify("Direct Debit")
        {
            Caption = 'Direct Debit';
        }
        modify("Direct Debit Pmt. Terms Code")
        {
            Caption = 'Direct Debit Pmt. Terms Code';
        }
        modify("Pmt. Export Line Definition")
        {
            Caption = 'Pmt. Export Line Definition';
        }
        // modify("Bank Data Conversion Pmt. Type")
        // {
        //     Caption = 'Bank Data Conversion Pmt. Type';
        // }
        modify("SII Payment Method Code")
        {
            Caption = 'SII Payment Method Code';
            OptionCaption = ' ,01,02,03,04,05';
        }
        modify("Create Bills")
        {
            Caption = 'Create Bills';
        }
        modify("Collection Agent")
        {
            Caption = 'Collection Agent';
            OptionCaption = 'Direct,Bank';
        }
        modify("Submit for Acceptance")
        {
            Caption = 'Submit for Acceptance';
        }
        modify("Bill Type")
        {
            Caption = 'Bill Type';
            OptionCaption = ' ,Bill of Exchange,Receipt,IOU,Check,Transfer';
        }
        modify("Invoices to Cartera")
        {
            Caption = 'Invoices to Cartera';
        }
    }


    //Unsupported feature: Property Modification (TextConstString) on "Text1100000(Variable 1100000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text1100000 : ENU=%1 must be set equal to False;ESP=%1 debe estar desactivado;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text1100000 : ENU=%1 must be set equal to False;
    //Variable type has not been exported.
}

