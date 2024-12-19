table 60012 "Gen. Journal Line (Staging)"
{
    // MDAN 15-02-12
    // New fields
    //   24 Shortcut Dimension 1 CodeCode20
    //   60020 GAAP Adjustment ReasonOption
    //   60030 Adjustment RoleOption
    //   60040 Tax Adjustment ReasonOption
    //   60060 Equity Correction CodeCode10
    // MDAN 12-11-12
    // New fields
    //   60070 Description (English)  Text  50
    // 
    // MP 12-11-12
    // Added ENU caption for "Description (English)"
    // 
    // MP 30-04-14
    // Development taken from Core II
    // Amended options for "Tax Adjmt Reason"
    // 
    // MP 18-11-14
    // NAV 2013 R2 Upgrade - Extended User ID from 20
    // 
    // MP 03-11-15
    // Added option "Tax" to field "GAAP Adjmt Reason" (CB1 Enhancements)

    Caption = 'Gen. Journal Line (Staging)';
    DrillDownPageID = "Gen. Journal Line (Staging)";
    LookupPageID = "Gen. Journal Line (Staging)";
    DataClassification = CustomerContent;

    fields
    {
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo';
            OptionMembers = " ",Payment,Invoice,"Credit Memo";
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(11; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(24; "Shortcut Dim 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dim 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(38; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(44; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
        }
        field(76; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(77; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(90; "VAT Code"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(60020; "GAAP Adjmt Reason"; Option)
        {
            Caption = 'GAAP Adjmt Reason';
            OptionCaption = ' ,Timing,GAAP,Reclassification,Tax';
            OptionMembers = " ",Timing,GAAP,Reclassification,Tax;
        }
        field(60030; "Adjustment Role"; Option)
        {
            Caption = 'Adjustment Role';
            OptionCaption = ' ,EY,Client,Auditor';
            OptionMembers = " ",EY,Client,Auditor;
        }
        field(60040; "Tax Adjmt Reason"; Option)
        {
            Caption = 'Tax Adjmt Reason';
            OptionCaption = ' ,P&L,Equity,,Non Temporary,Other P&L,Other Equity,Other Non Temporary';
            OptionMembers = " ","P&L",Equity,"<Obsolete>","Non Temporary","Other P&L","Other Equity","Other Non Temporary";
        }
        field(60060; "Equity Corr Code"; Code[10])
        {
            Caption = 'Equity Corr Code';
            TableRelation = "Equity Correction Code";
        }
        field(60070; "Description (English)"; Text[50])
        {
            Caption = 'Description (English)';
            Description = 'MDAN 12-11-12';
        }
        field(99000; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            OptionCaption = 'Trial Balance,G/L Transactions,A/R Transactions,A/P Transactions';
            OptionMembers = "Trial Balance","G/L Transactions","A/R Transactions","A/P Transactions";
        }
        field(99005; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
        }
        field(99010; "Debit/Credit Indicator"; Code[1])
        {
            Caption = 'Debit/Credit Indicator';
        }
        field(99020; "Additional Curr Amnt"; Decimal)
        {
            Caption = 'Additional Currency Amount';
        }
        field(99030; "Supply Date"; Date)
        {
            Caption = 'Supply Date';
        }
        field(99040; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
        }
        field(99050; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
        }
        field(99060; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(99070; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(99080; "Transaction Ref. No."; Code[30])
        {
            Caption = 'Transaction Ref. No.';
        }
        field(99090; "Client Entry No."; BigInteger)
        {
            Caption = 'Client Entry No.';
        }
        field(99100; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(99110; "Place of Establishment"; Text[50])
        {
            Caption = 'Place of Establishment';
        }
        field(99120; "Invoice Received Date"; Date)
        {
            Caption = 'Invoice Received Date';
        }
        field(99130; "Payment Method"; Text[30])
        {
            Caption = 'Payment Method';
        }
        field(99140; "VAT Payment Date"; Date)
        {
            Caption = 'VAT Payment Date';
        }
        field(99150; "VAT Payment Amount"; Decimal)
        {
            Caption = 'VAT Payment Amount';
            Description = 'MP 03-04-12';
        }
        field(99994; "Company No."; Code[20])
        {
            Caption = 'Company No.';
        }
        field(99995; "Client No."; Code[20])
        {
            Caption = 'Client No.';
        }
        field(99996; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Description = 'MP 18-11-14 Extended from 20';
        }
        field(99997; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Imported,In Progress,Error,Processed';
            OptionMembers = Imported,"In Progress",Error,Processed;
        }
        field(99998; "Import Log Entry No."; BigInteger)
        {
            Caption = 'Import Log Entry No.';
            TableRelation = "Import Log";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(99999; "Entry No."; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Import Log Entry No.", "Company No.", "Posting Date", "Currency Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Client Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

