table 60000 "Import Tool Cue"
{
    Caption = 'Import Tool Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(10; "G/L Accounts (Imported)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST(Imported),
                                                               "User ID" = FIELD("User ID Filter")));
            Caption = 'G/L Accounts (Imported)';
            Editable = false;
            FieldClass = FlowField;


        }
        field(20; "G/L Accounts (Errors)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST(Error),
                                                               "User ID" = FIELD("User ID Filter")));
            Caption = 'G/L Accounts (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Corporate Accounts (Imported)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST(Imported),
                                                               "User ID" = FIELD("User ID Filter")));
            Caption = 'Corporate Accounts (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Corporate Accounts (Errors)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST("In Progress")));
            Caption = 'Corporate Accounts (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "G/L Entries (Imported)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Imported),
                                                                     "Interface Type" = CONST("G/L Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'G/L Entries (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "G/L Entries (Errors)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Error),
                                                                     "Interface Type" = CONST("G/L Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'G/L Entries (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "TB (Imported)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Imported),
                                                                     "Interface Type" = CONST("Trial Balance"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'TB (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "TB (Errors)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Error),
                                                                     "Interface Type" = CONST("Trial Balance"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'TB (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Customers (Imported)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST(Imported),
                                                               "User ID" = FIELD("User ID Filter")));
            Caption = 'Customers (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Customers (Errors)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST("In Progress")));
            Caption = 'Customers (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "AR (Imported)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Imported),
                                                                     "Interface Type" = CONST("A/R Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'AR (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "AR (Errors)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Error),
                                                                     "Interface Type" = CONST("A/R Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'AR (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Vendors (Imported)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST(Imported),
                                                               "User ID" = FIELD("User ID Filter")));
            Caption = 'Vendors (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(140; "Vendors (Errors)"; Integer)
        {
            CalcFormula = Count("G/L Account (Staging)" WHERE(Status = CONST("In Progress")));
            Caption = 'Vendors (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(150; "AP (Imported)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Imported),
                                                                     "Interface Type" = CONST("A/P Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'AP (Imported)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(160; "AP (Errors)"; Integer)
        {
            CalcFormula = Count("Gen. Journal Line (Staging)" WHERE(Status = CONST(Error),
                                                                     "Interface Type" = CONST("A/P Transactions"),
                                                                     "User ID" = FIELD("User ID Filter")));
            Caption = 'AP (Errors)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10000; "User ID Filter"; Code[20])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
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

