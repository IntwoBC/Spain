tableextension 50109 tableextension50109 extends "Vendor Ledger Entry"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // OPP  01.11.08   OPplus Modules
    //                 - New Keys added
    // -----------------------------------------------------
    // SUP:ISSUE:#111525  09/09/2021  COSMO.ABT
    //    # Added two new fields: 50000 "IBAN / Bank Account" Code[50].
    //                            50001 "URL" Text[250].
    //    # Updated function "CopyFromGenJnlLine".
    // 
    // SUP:ISSUE:#112374  14/10/2021  COSMO.ABT
    //    # Added new field: 50002 "E-Mail" Text[80].
    //    # Updated function "CopyFromGenJnlLine".
    // 
    // SUP:ISSUE:#117922  24/08/2022  COSMO.ABT
    //    # Added a new field: 50003 "Purchase Order No." Code[50].
    //    # Updated function "CopyFromGenJnlLine".
    Caption = 'Vendor Ledger Entry';
    fields
    {
        modify("Entry No.")
        {
            Caption = 'Entry No.';
        }
        modify("Vendor No.")
        {
            Caption = 'Vendor No.';
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
        modify("Purchase (LCY)")
        {
            Caption = 'Purchase (LCY)';
        }
        modify("Inv. Discount (LCY)")
        {
            Caption = 'Inv. Discount (LCY)';
        }
        modify("Buy-from Vendor No.")
        {
            Caption = 'Buy-from Vendor No.';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Purchaser Code")
        {
            Caption = 'Purchaser Code';
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
        modify("Pmt. Disc. Rcd.(LCY)")
        {
            Caption = 'Pmt. Disc. Rcd.(LCY)';
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
        modify("Creditor No.")
        {
            Caption = 'Creditor No.';
        }
        modify("Payment Reference")
        {
            Caption = 'Payment Reference';
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
        modify("Generated Autodocument")
        {
            Caption = 'Generated Autodocument';
        }
        modify("Autodocument No.")
        {
            Caption = 'Autodocument No.';
        }
        modify("Invoice Type")
        {
            Caption = 'Invoice Type';
            OptionCaption = 'F1 Invoice,F2 Simplified Invoice,F3 Invoice issued to replace simplified invoices,F4 Invoice summary entry,F5 Imports (DUA),F6 Accounting support material,Customs - Complementary Liquidation';
        }
        modify("Cr. Memo Type")
        {
            Caption = 'Cr. Memo Type';
            OptionCaption = 'R1 Corrected Invoice,R2 Corrected Invoice (Art. 80.3),R3 Corrected Invoice (Art. 80.4),R4 Corrected Invoice (Other),R5 Corrected Invoice in Simplified Invoices,F1 Invoice,F2 Simplified Invoice';
        }
        modify("Special Scheme Code")
        {
            Caption = 'Special Scheme Code';
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
        field(50000; "IBAN / Bank Account"; Code[50])
        {
            Caption = 'IBAN / Bank Account';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#111525';
            Editable = false;
        }
        field(50001; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#111525';
            ExtendedDatatype = URL;
        }
        field(50002; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#112374';
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(50003; "Purchase Order No."; Code[50])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#117922';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Vendor No.", "Document No.")
        {

        }
        // key(Key2; "Document Type", "External Document No.", "Vendor No.")
        // {
        // }
        // key(Key3; "Vendor No.", Open, "Document Date")
        // {
        // }
        // key(Key4; Open, "Vendor No.", "Document Date")
        // {
        // }
        // key(Key5; Open, "Document No.", "Vendor No.")
        // {
        // }
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Vendor No." := GenJnlLine."Account No.";
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    #4..47
    "Corrected Invoice No." := GenJnlLine."Corrected Invoice No.";
    "Succeeded Company Name" := GenJnlLine."Succeeded Company Name";
    "Succeeded VAT Registration No." := GenJnlLine."Succeeded VAT Registration No.";
    "ID Type" := GenJnlLine."ID Type";
    "Do Not Send To SII" := GenJnlLine."Do Not Send To SII";

    OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..50
    //{>>>>>>>} ORIGINAL
    //{=======} MODIFIED
    //>>SUP:ISSUE:#111525
    //"IBAN / Bank Account" := GenJnlLine."IBAN / Bank Account";
    //URL := GenJnlLine.URL;
    //<<SUP:ISSUE:#111525
    //>>SUP:ISSUE:#112374
    //"E-Mail" := GenJnlLine."E-Mail";
    //<<SUP:ISSUE:#112374
    //>>SUP:ISSUE:#117922
    //"Purchase Order No." := GenJnlLine."Purchase Order No.";
    //<<SUP:ISSUE:#117922
    //{=======} TARGET
    "ID Type" := GenJnlLine."ID Type";
    "Do Not Send To SII" := GenJnlLine."Do Not Send To SII";
    //{<<<<<<<}

    OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;


    //Unsupported feature: Property Modification (TextConstString) on "MustHaveSameSignErr(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //MustHaveSameSignErr : ENU=must have the same sign as %1;ESP=debe tener el mismo signo que %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MustHaveSameSignErr : ENU=must have the same sign as %1;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "MustNotBeLargerErr(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //MustNotBeLargerErr : ENU=must not be larger than %1;ESP=no debe ser mayor que %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MustNotBeLargerErr : ENU=must not be larger than %1;
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

