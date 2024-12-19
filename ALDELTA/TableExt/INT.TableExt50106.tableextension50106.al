tableextension 50106 tableextension50106 extends "Cust. Ledger Entry"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // OPP  01.11.08   OPplus Granules
    //                 - New Keys added
    // -----------------------------------------------------
    Caption = 'Cust. Ledger Entry';
    fields
    {
        modify("Entry No.")
        {
            Caption = 'Entry No.';
        }
        modify("Customer No.")
        {
            Caption = 'Customer No.';
        }
        modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
        modify("Document Type")
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill';
        }
        modify("Document No.")
        {
            Caption = 'Document No.';
        }
        modify(Description)
        {
            Caption = 'Description';
        }
        modify("Currency Code")
        {
            Caption = 'Currency Code';
        }
        modify(Amount)
        {
            Caption = 'Amount';
        }
        modify("Remaining Amount")
        {
            Caption = 'Remaining Amount';
        }
        modify("Original Amt. (LCY)")
        {
            Caption = 'Original Amt. (LCY)';
        }
        modify("Remaining Amt. (LCY)")
        {
            Caption = 'Remaining Amt. (LCY)';
        }
        modify("Amount (LCY)")
        {
            Caption = 'Amount (LCY)';
        }
        modify("Sales (LCY)")
        {
            Caption = 'Sales (LCY)';
        }
        modify("Profit (LCY)")
        {
            Caption = 'Profit (LCY)';
        }
        modify("Inv. Discount (LCY)")
        {
            Caption = 'Inv. Discount (LCY)';
        }
        modify("Sell-to Customer No.")
        {
            Caption = 'Sell-to Customer No.';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Salesperson Code")
        {
            Caption = 'Salesperson Code';
        }
        modify("User ID")
        {
            Caption = 'User ID';
        }
        modify("Source Code")
        {
            Caption = 'Source Code';
        }
        modify("On Hold")
        {
            Caption = 'On Hold';
        }
        modify("Applies-to Doc. Type")
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill';
        }
        modify("Applies-to Doc. No.")
        {
            Caption = 'Applies-to Doc. No.';
        }
        modify(Open)
        {
            Caption = 'Open';
        }
        modify("Due Date")
        {
            Caption = 'Due Date';
        }
        modify("Pmt. Discount Date")
        {
            Caption = 'Pmt. Discount Date';
        }
        modify("Original Pmt. Disc. Possible")
        {
            Caption = 'Original Pmt. Disc. Possible';
        }
        modify("Pmt. Disc. Given (LCY)")
        {
            Caption = 'Pmt. Disc. Given (LCY)';
        }
        modify(Positive)
        {
            Caption = 'Positive';
        }
        modify("Closed by Entry No.")
        {
            Caption = 'Closed by Entry No.';
        }
        modify("Closed at Date")
        {
            Caption = 'Closed at Date';
        }
        modify("Closed by Amount")
        {
            Caption = 'Closed by Amount';
        }
        modify("Applies-to ID")
        {
            Caption = 'Applies-to ID';
        }
        modify("Journal Batch Name")
        {
            Caption = 'Journal Batch Name';
        }
        modify("Reason Code")
        {
            Caption = 'Reason Code';
        }
        modify("Bal. Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        modify("Bal. Account No.")
        {
            Caption = 'Bal. Account No.';
        }
        modify("Transaction No.")
        {
            Caption = 'Transaction No.';
        }
        modify("Closed by Amount (LCY)")
        {
            Caption = 'Closed by Amount (LCY)';
        }
        modify("Debit Amount")
        {
            Caption = 'Debit Amount';
        }
        modify("Credit Amount")
        {
            Caption = 'Credit Amount';
        }
        modify("Debit Amount (LCY)")
        {
            Caption = 'Debit Amount (LCY)';
        }
        modify("Credit Amount (LCY)")
        {
            Caption = 'Credit Amount (LCY)';
        }
        modify("Document Date")
        {
            Caption = 'Document Date';
        }
        modify("External Document No.")
        {
            Caption = 'External Document No.';
        }
        modify("Calculate Interest")
        {
            Caption = 'Calculate Interest';
        }
        modify("Closing Interest Calculated")
        {
            Caption = 'Closing Interest Calculated';
        }
        modify("No. Series")
        {
            Caption = 'No. Series';
        }
        modify("Closed by Currency Code")
        {
            Caption = 'Closed by Currency Code';
        }
        modify("Closed by Currency Amount")
        {
            Caption = 'Closed by Currency Amount';
        }
        modify("Adjusted Currency Factor")
        {
            Caption = 'Adjusted Currency Factor';
        }
        modify("Original Currency Factor")
        {
            Caption = 'Original Currency Factor';
        }
        modify("Original Amount")
        {
            Caption = 'Original Amount';
        }
        modify("Date Filter")
        {
            Caption = 'Date Filter';
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Caption = 'Remaining Pmt. Disc. Possible';
        }
        modify("Pmt. Disc. Tolerance Date")
        {
            Caption = 'Pmt. Disc. Tolerance Date';
        }
        modify("Max. Payment Tolerance")
        {
            Caption = 'Max. Payment Tolerance';
        }
        modify("Last Issued Reminder Level")
        {
            Caption = 'Last Issued Reminder Level';
        }
        modify("Accepted Payment Tolerance")
        {
            Caption = 'Accepted Payment Tolerance';
        }
        modify("Accepted Pmt. Disc. Tolerance")
        {
            Caption = 'Accepted Pmt. Disc. Tolerance';
        }
        modify("Pmt. Tolerance (LCY)")
        {
            Caption = 'Pmt. Tolerance (LCY)';
        }
        modify("Amount to Apply")
        {
            Caption = 'Amount to Apply';
        }
        modify("IC Partner Code")
        {
            Caption = 'IC Partner Code';
        }
        modify("Applying Entry")
        {
            Caption = 'Applying Entry';
        }
        modify(Reversed)
        {
            Caption = 'Reversed';
        }
        modify("Reversed Entry No.")
        {
            Caption = 'Reversed Entry No.';
        }
        modify(Prepayment)
        {
            Caption = 'Prepayment';
        }
        modify("Payment Terms Code")
        {
            Caption = 'Payment Terms Code';
        }
        modify("Payment Method Code")
        {
            Caption = 'Payment Method Code';
        }
        modify("Applies-to Ext. Doc. No.")
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        modify("Recipient Bank Account")
        {
            Caption = 'Recipient Bank Account';
        }
        modify("Message to Recipient")
        {
            Caption = 'Message to Recipient';
        }
        modify("Exported to Payment File")
        {
            Caption = 'Exported to Payment File';
        }
        modify("Dimension Set ID")
        {
            Caption = 'Dimension Set ID';
        }
        modify("Direct Debit Mandate ID")
        {
            Caption = 'Direct Debit Mandate ID';
        }
        modify("Invoice Type")
        {
            Caption = 'Invoice Type';
            OptionCaption = 'F1 Invoice,F2 Simplified Invoice,F3 Invoice issued to replace simplified invoices,F4 Invoice summary entry';
        }
        modify("Cr. Memo Type")
        {
            Caption = 'Cr. Memo Type';
            OptionCaption = 'R1 Corrected Invoice,R2 Corrected Invoice (Art. 80.3),R3 Corrected Invoice (Art. 80.4),R4 Corrected Invoice (Other),R5 Corrected Invoice in Simplified Invoices,F1 Invoice,F2 Simplified Invoice';
        }
        modify("Special Scheme Code")
        {
            Caption = 'Special Scheme Code';
            OptionCaption = '01 General,02 Export,03 Special System,04 Gold,05 Travel Agencies,06 Groups of Entities,07 Special Cash,08  IPSI / IGIC,09 Travel Agency Services,10 Third Party,11 Business Withholding,12 Business not Withholding,13 Business Withholding and not Withholding,14 Invoice Work Certification,15 Invoice of Consecutive Nature,16 First Half 2017';
        }
        modify("Correction Type")
        {
            Caption = 'Correction Type';
            OptionCaption = ' ,Replacement,Difference,Removal';
        }
        modify("Corrected Invoice No.")
        {
            Caption = 'Corrected Invoice No.';
        }
        modify("Succeeded Company Name")
        {
            Caption = 'Succeeded Company Name';
        }
        modify("Succeeded VAT Registration No.")
        {
            Caption = 'Succeeded VAT Registration No.';
        }
        modify("Applies-to Bill No.")
        {
            Caption = 'Applies-to Bill No.';
        }
        modify("Document Status")
        {
            Caption = 'Document Status';
            OptionCaption = ' ,Open,Honored,Rejected,Redrawn';
        }
        modify("Remaining Amount (LCY) stats.")
        {
            Caption = 'Remaining Amount (LCY) stats.';
        }
        modify("Amount (LCY) stats.")
        {
            Caption = 'Amount (LCY) stats.';
        }
    }
    // keys
    // {
    //     key(PK; "Customer No.", "Document No.")
    //     {
    //     }
    //     key(Key2; "Customer No.", Open, "Document Date")
    //     {
    //     }
    //     key(Key3; Open, "Customer No.", "Document Date")
    //     {
    //     }
    //     key(Key4; Open, "Document No.", "Customer No.")
    //     {
    //     }
    //     key(Key5; "Customer No.", "Posting Date")
    //     {
    //     }
    //     key(Key6; "External Document No.", "Document Type")
    //     {
    //     }


    //Unsupported feature: Property Modification (TextConstString) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : ENU=must have the same sign as %1;ESP=debe tener el mismo signo que %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : ENU=must have the same sign as %1;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text001(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : ENU=must not be larger than %1;ESP=no debe ser mayor que %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : ENU=must not be larger than %1;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text1100000(Variable 1100001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text1100000 : ENU=Payment Discount (VAT Excl.);ESP=% Dto. P.P. (IVA excluído);
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text1100000 : ENU=Payment Discount (VAT Excl.);
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text1100001(Variable 1100002)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text1100001 : ENU=Payment Discount (VAT Adjustment);ESP=% Dto. P.P. (IVA ajustado);
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text1100001 : ENU=Payment Discount (VAT Adjustment);
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "CannotChangePmtMethodErr(Variable 1100003)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotChangePmtMethodErr : ENU=For Cartera-based bills and invoices, you cannot change the Payment Method Code to this value.;ESP=Para los efectos y las facturas basadas en Cartera, no puede modificar el Código de forma de pago a este valor.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotChangePmtMethodErr : ENU=For Cartera-based bills and invoices, you cannot change the Payment Method Code to this value.;
    //Variable type has not been exported.
}

