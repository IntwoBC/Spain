table 60059 "Adjustment Entry Buffer"
{
    Caption = 'Adjustment Entry Buffer';
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(17; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(60000; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            TableRelation = "Corporate G/L Account";
        }
        field(60020; "GAAP Adjustment Reason"; Option)
        {
            Caption = 'GAAP Adjustment Reason';
            OptionCaption = ' ,Timing,GAAP,Reclassification,Tax';
            OptionMembers = " ",Timing,GAAP,Reclassification,Tax;
        }
        field(60030; "Adjustment Role"; Option)
        {
            Caption = 'Adjustment Role';
            OptionCaption = ' ,EY,Client,Auditor';
            OptionMembers = " ",EY,Client,Auditor;
        }
        field(60060; "Equity Correction Code"; Code[10])
        {
            Caption = 'Equity Correction Code';
            TableRelation = "Equity Correction Code";
        }
        field(60110; Reversible; Boolean)
        {
            Caption = 'Reversible';
        }
        field(60111; "Reversed at"; Date)
        {
            Caption = 'Reversed at';
        }
        field(60112; "Reversal Entry No."; Integer)
        {
            Caption = 'Reversal Entry No.';
            TableRelation = "G/L Entry";
        }
        field(61000; "G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61010; "Corporate G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Corporate G/L Account No.")));
            Caption = 'Corporate G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61020; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            TableRelation = "G/L Entry";
        }
        field(61030; "Equity Corr. Code Description"; Text[50])
        {
            CalcFormula = Lookup("Equity Correction Code".Description WHERE(Code = FIELD("Equity Correction Code")));
            Caption = 'Equity Corr. Code Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

