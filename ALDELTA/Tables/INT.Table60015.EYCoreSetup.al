table 60015 "EY Core Setup"
{
    // MP 18-11-13
    // Added fields "Company Type" and "Corp. Accounts In use" (CR 30)

    Caption = 'EY Core Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "OneSource File Path"; Text[250])
        {
            Caption = 'OneSource File Path';
        }
        field(60000; "Disable GAAP-to-GAAP"; Boolean)
        {
            Caption = 'Disable GAAP-to-GAAP';
        }
        field(60010; "Local Retained Earnings Acc."; Code[20])
        {
            Caption = 'Local Retained Earnings Acc.';
            TableRelation = "G/L Account";
        }
        field(60020; "Local Suspense Acc."; Code[20])
        {
            Caption = 'Local Suspense Acc.';
            TableRelation = "G/L Account";
        }
        field(60030; "Corp. Retained Earnings Acc."; Code[20])
        {
            Caption = 'Corp. Retained Earnings Acc.';
            TableRelation = "Corporate G/L Account";
        }
        field(60040; "TB Local CoA Template"; Code[20])
        {
            Caption = 'TB Local CoA Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60041; "TB Corp. CoA Template"; Code[20])
        {
            Caption = 'TB Corp. CoA Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60042; "TB Trial Bal. Template"; Code[20])
        {
            Caption = 'TB Trial Bal. Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60043; "TB G/L Trans. Template"; Code[20])
        {
            Caption = 'TB G/L Trans. Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60044; "TR Local CoA Template"; Code[20])
        {
            Caption = 'TR Local CoA Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60045; "TR Corp. CoA Template"; Code[20])
        {
            Caption = 'TR Corp. CoA Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60046; "TR Trial Balance Template"; Code[20])
        {
            Caption = 'TR Trial Balance Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60047; "TR G/L Transactions Template"; Code[20])
        {
            Caption = 'TR G/L Transactions Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60048; "TR Customer Template"; Code[20])
        {
            Caption = 'TR Customer Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60049; "TR Vendor Template"; Code[20])
        {
            Caption = 'TR Vendor Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60050; "TR A/R Trans. Template"; Code[20])
        {
            Caption = 'TR A/R Trans. Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60051; "TR A/P Trans. Template"; Code[20])
        {
            Caption = 'TR A/P Trans. Template';
            TableRelation = "Import Template Header".Code;
        }
        field(60060; "Custom AR posting"; Boolean)
        {
            Caption = 'Custom AR posting';
            Description = 'MD 20-09-12';
        }
        field(60061; "Custom AP posting"; Boolean)
        {
            Caption = 'Custom AP posting';
            Description = 'MD 20-09-12';
        }
        field(60080; "Company Type"; Option)
        {
            Caption = 'Company Type';
            Description = 'MP 18-11-13';
            OptionCaption = 'Global Services,Country Services';
            OptionMembers = "Top-down","Bottom-up","Import Tool";
        }
        field(60090; "Corp. Accounts In use"; Boolean)
        {
            CalcFormula = Exist("Corporate G/L Account");
            Caption = 'Corp. Accounts In use';
            Description = 'MP 18-11-13';
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

    trigger OnDelete()
    begin
        TestField("Company Type", "Company Type"::"Top-down"); // MP 18-11-13
    end;
}

