table 60001 "Import Template Header"
{
    // MDAN 24-02-12
    //   New File Format option "Excel2007"

    Caption = 'Import Template Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(15; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            OptionCaption = 'Trial Balance,GL Transactions,AR Transactions,APTransactions,Chart Of Accounts,Corporate Chart Of Accounts,Customer,Vendor';
            OptionMembers = "Trial Balance","GL Transactions","AR Transactions",APTransactions,"Chart Of Accounts","Corporate Chart Of Accounts",Customer,Vendor;
        }
        field(20; "Table ID"; Integer)
        {
            Caption = 'Table ID';

            trigger OnLookup()
            var
                // "Object": Record Object;
                Objects: Page Objects;
            begin
                //  Object.SetRange(Object.Type, Object.Type::Table);
                //  Objects.SetTableView(Object);
                Objects.LookupMode := true;
                if Objects.RunModal() = ACTION::LookupOK then begin
                    //Objects.GetRecord(Object);
                    // Validate("Table ID", Object.ID);
                end;
            end;

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(30; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Table Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "File Format"; Option)
        {
            Caption = 'File Format';
            OptionCaption = 'Variable Delimited,Excel';
            OptionMembers = "Variable Delimited",Excel;
        }
        field(60; "Field Delimiter"; Text[3])
        {
            Caption = 'Field Delimiter';

            trigger OnValidate()
            var
               // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
            begin
                //"Field Delimiter ASCII" := lmodDataImportManagementCommon.gfncTextToASCII("Field Delimiter");
            end;
        }
        field(61; "Field Delimiter ASCII"; Integer)
        {
            Caption = 'Field Delimiter ASCII';

            trigger OnValidate()
            var
              //  lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
            begin
                //"Field Delimiter" := lmodDataImportManagementCommon.gfncASCIIToText("Field Delimiter ASCII");
            end;
        }
        field(65; "Text Qualifier"; Text[1])
        {
            Caption = 'Text Qualifier';
        }
        field(70; "Decimal Symbol"; Text[1])
        {
            Caption = 'Decimal Symbol';
            InitValue = ',';
            // ValuesAllowed = '.', '', '';
        }
        field(80; "Thousand Separator"; Text[1])
        {
            Caption = 'Thousand Separator';
            InitValue = '.';
            // ValuesAllowed = '', '', '.';
        }
        field(90; "Skip Header Lines"; Integer)
        {
            Caption = 'Skip Header Lines';
        }
        field(95; "XLS Worksheet No."; Integer)
        {
            Caption = 'XLS Worksheet No.';
            MinValue = 1;
        }
        field(100; "Date Format"; Text[30])
        {
            Caption = 'Date Format';
        }
        field(101; "Create VAT Entries"; Boolean)
        {
            Caption = 'Create VAT Entries';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

