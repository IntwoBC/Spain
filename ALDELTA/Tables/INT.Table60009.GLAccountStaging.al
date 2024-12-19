table 60009 "G/L Account (Staging)"
{
    // 19-01-12 -mdan- New key
    //   Import Log Entry No.
    // 
    // 12-04-13 -mdan-
    //   New fields
    //     60180 Tax Return Code
    //     60181 Tax Return Description
    //     60182 Tax Return Desc. (English)
    // 
    // MP 30-04-14
    // Development taken from Core II
    // 
    // MP 18-11-14
    // NAV 2013 R2 Upgrade - extended Name field from 30
    // Extended User ID from 20

    Caption = 'G/L Account (Staging)';
    DrillDownPageID = "G/L Accounts (Staging)";
    LookupPageID = "G/L Accounts (Staging)";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            Description = 'MP 18-11-14 Extended from 30';
        }
        field(9; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance';
            OptionCaption = 'Income Statement,Balance Sheet';
            OptionMembers = "Income Statement","Balance Sheet";
        }
        field(43; "Gen. Bus. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }
        field(50; "Accounting Class"; Option)
        {
            Caption = 'Accounting Class';
            OptionCaption = ' ,Balance Sheet,Equity,P&L';
            OptionMembers = " ","Balance Sheet",Equity,"P&L";
        }
        field(60; "Name - ENU"; Text[50])
        {
            Caption = 'Name - ENU';
        }
        field(70; "Financial Statement Code"; Code[10])
        {
            Caption = 'Financial Statement Code';
        }
        field(60015; "FS Name"; Text[50])
        {
            Caption = 'FS Name';
        }
        field(60016; "FS Name (English)"; Text[50])
        {
            Caption = 'FS Name (English)';
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
        key(Key2; Status, "User ID")
        {
        }
        key(Key3; "Import Log Entry No.", "Company No.")
        {
        }
    }

    fieldgroups
    {
    }
}

