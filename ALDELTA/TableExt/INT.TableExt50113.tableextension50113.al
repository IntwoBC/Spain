tableextension 50113 tableextension50113 extends "Bank Acc. Reconciliation Line"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   New added fields : "Bank Acc. Ledg. Entry No.","Bal. Account Type","Bal. Account No.",Matched,"Journal Template Name","Journal Batch Name"
    //   "Line No.","New Bal. Account","New Bal. Account No.",Applied,"Applyment Confidence"
    fields
    {
        field(70000; "Bank Acc. Ledg. Entry No."; Integer)
        {
            Caption = 'Bank Account Ledger Entry No.';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            TableRelation = "Bank Account Ledger Entry";
            DataClassification = CustomerContent;
        }
        field(70001; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
            DataClassification = CustomerContent;
        }
        field(70002; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            DataClassification = CustomerContent;
        }
        field(70003; Matched; Boolean)
        {
            Caption = 'Matched';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            DataClassification = CustomerContent;
        }
        field(70004; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(70005; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(70006; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            DataClassification = CustomerContent;
        }
        field(70007; "New Bal. Account Type"; Option)
        {
            Caption = 'New Bal. Account Type';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
            DataClassification = CustomerContent;
        }
        field(70008; "New Bal. Account No."; Code[20])
        {
            Caption = 'New Bal. Account No.';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            DataClassification = CustomerContent;
        }
        field(70009; Applied; Boolean)
        {
            Caption = 'Applyment Status';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            DataClassification = CustomerContent;
        }
        field(70010; "Applyment Confidence"; Option)
        {
            Caption = 'Applyment Confidence';
            Description = 'MyTaxi.W1.CRE.BANKR.001';
            Editable = false;
            InitValue = "None";
            OptionCaption = 'None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted';
            OptionMembers = "None",Low,Medium,High,"High - Text-to-Account Mapping",Manual,Accepted;
            DataClassification = CustomerContent;
        }
    }
}

