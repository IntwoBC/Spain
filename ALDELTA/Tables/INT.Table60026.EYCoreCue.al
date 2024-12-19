table 60026 "EY Core Cue"
{
    Caption = 'EY Core Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Stat./Group Adjmt. Entries"; Integer)
        {
            CalcFormula = Count("G/L Entry" WHERE("Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code (SG)"),
                                                   "Posting Date" = FIELD("Date Filter")));
            Caption = 'Statutory/Group Adjustments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Tax Adjmt. Entries"; Integer)
        {
            CalcFormula = Count("G/L Entry" WHERE("Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code (T)"),
                                                   "Posting Date" = FIELD("Date Filter")));
            Caption = 'Tax Adjustments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Local Adjmt. Entries"; Integer)
        {
            CalcFormula = Count("G/L Entry" WHERE("Global Dimension 1 Code" = FIELD(FILTER("Shortcut Dim. 1 Filter (Local)")),
                                                   "Posting Date" = FIELD("Date Filter")));
            Caption = 'Tax Adjustments';
            Description = 'MP 06-10-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Shortcut Dimension 1 Code (SG)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code (SG)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(40; "Shortcut Dimension 1 Code (T)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code (T)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(42; "Shortcut Dim. 1 Filter (Local)"; Code[40])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Filter (Local)';
            Description = 'MP 06-10-16';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(60; "Financial Statement"; Integer)
        {
            CalcFormula = Count("Financial Statement Structure" WHERE(Default = CONST(true)));
            Description = 'MP 06-10-16';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

