table 60004 "Subsidiary Client"
{
    Caption = 'Subsidiary Client';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Parent Client No."; Code[20])
        {
            Caption = 'Parent Client No.';
            TableRelation = "Parent Client";
        }
        field(2; "Country Database Code"; Code[20])
        {
            Caption = 'Country Database Code';
            TableRelation = "Country Database";
        }
        field(3; "Company Name"; Text[30])
        {
            Caption = 'Company Name';

            trigger OnLookup()
            var
               // lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
                lrecTmpSubsidiaryCompany: Record "Subsidiary Company" temporary;
                ldlgDialog: Dialog;
            begin
                ldlgDialog.Open(MSG_001);
                //lmodDataImportSafeWScall.gfncFillCompanyList(lrecTmpSubsidiaryCompany, "Country Database Code");
                ldlgDialog.Close();
                if PAGE.RunModal(60068, lrecTmpSubsidiaryCompany) = ACTION::LookupOK then
                    "Company Name" := lrecTmpSubsidiaryCompany.Name;
            end;

            trigger OnValidate()
            var
               // lmodDataImportSafeWScall: Codeunit "Data Import Safe WS call";
                lrecTmpSubsidiaryCompany: Record "Subsidiary Company" temporary;
                ldlgDialog: Dialog;
            begin
                ldlgDialog.Open(MSG_001);
                // lmodDataImportSafeWScall.gfncFillCompanyList(lrecTmpSubsidiaryCompany, "Country Database Code");
                ldlgDialog.Close();
                if not lrecTmpSubsidiaryCompany.Get("Company Name") then Error(ERR_001, "Company Name", "Country Database Code");
            end;
        }
        field(10; "Company No."; Code[20])
        {
            Caption = 'Company No.';
        }
        field(20; "Chart of Acc. Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST("Chart Of Accounts")));
            Caption = 'Chart of Accounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Corp. Chart of Acc.Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST("Corporate Chart Of Accounts")));
            Caption = 'Corp. Chart of Accounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "TB Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST("Trial Balance")));
            Caption = 'TB';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "G/L Entries Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST("GL Transactions")));
            Caption = 'G/L Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Customer Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST(Customer)));
            Caption = 'Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "AR Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST("AR Transactions")));
            Caption = 'AR';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Vendor Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST(Vendor)));
            Caption = 'Vendors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "AP Import Date"; Date)
        {
            CalcFormula = Max("Import Log - Subsidiary Client"."Creation Date" WHERE("Parent Client No." = FIELD("Parent Client No."),
                                                                                      "Company No." = FIELD("Company No."),
                                                                                      "Interface Type" = CONST(APTransactions)));
            Caption = 'AP';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "TB to TB client"; Boolean)
        {
            Caption = 'TB to TB client';
            Description = 'To Be Deleted';
        }
        field(96; "G/L Detail level"; Option)
        {
            Caption = 'G/L Detail level';
            OptionCaption = 'Transactional,Trial Balance';
            OptionMembers = Transactional,"Trial Balance";
        }
        field(97; "Statutory Reporting"; Boolean)
        {
            Caption = 'Statutory Reporting';
        }
        field(98; "Corp. Tax Reporting"; Boolean)
        {
            Caption = 'Corp. Tax Reporting';
        }
        field(99; "VAT Reporting level"; Option)
        {
            Caption = 'VAT Reporting level';
            OptionCaption = 'Create OneSource File,Process In NAV';
            OptionMembers = "Create OneSource File","Process In NAV";
        }
    }

    keys
    {
        key(Key1; "Parent Client No.", "Country Database Code", "Company Name")
        {
            Clustered = true;
        }
        key(Key2; "Company No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrecParentClient: Record "Parent Client";
    begin
        // Get header
        lrecParentClient.Get("Parent Client No.");
        Validate("G/L Detail level", lrecParentClient."G/L Detail Level");
    end;

    var
        MSG_001: Label 'Loading company list';
        ERR_001: Label 'Company %1 does not exist in country database %2.';
}

