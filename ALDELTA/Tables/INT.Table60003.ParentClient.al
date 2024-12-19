table 60003 "Parent Client"
{
    // MP 19-04-12
    // Changed captions for "G/L Account Template Code" and "Corporate GL Acc. Templ. Code"
    // 
    // TEC 09-10-12 -mdan-
    //   New field
    //     60072 Posting Scenario Option
    //     60000 Posting Method Option
    // TEC 07-11-12 -mdan-
    //   Default posting Method to "Simulate"
    // 
    // MP 30-04-14
    // Development taken from Core II

    Caption = 'Parent Client';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(20; "G/L Account Template Code"; Code[20])
        {
            Caption = 'Local COA Template Code';
            TableRelation = "Import Template Header";
        }
        field(30; "Corporate GL Acc. Templ. Code"; Code[20])
        {
            Caption = 'Corporate COA Template Code';
            TableRelation = "Import Template Header";
        }
        field(40; "Trial Balance Template Code"; Code[20])
        {
            Caption = 'Trial Balance Template Code';
            TableRelation = "Import Template Header";
        }
        field(50; "G/L Entry Template Code"; Code[20])
        {
            Caption = 'G/L Entry Template Code';
            TableRelation = "Import Template Header";
        }
        field(60; "Customer Template Code"; Code[20])
        {
            Caption = 'Customer Template Code';
            TableRelation = "Import Template Header";
        }
        field(61; "Vendor Template Code"; Code[20])
        {
            Caption = 'Vendor Template Code';
            TableRelation = "Import Template Header";
        }
        field(62; "AR Template Code"; Code[20])
        {
            Caption = 'AR Template Code';
            TableRelation = "Import Template Header";
        }
        field(63; "AP Template Code"; Code[20])
        {
            Caption = 'AP Template Code';
            TableRelation = "Import Template Header";
        }
        field(70; "No. Of Transaction Files"; Integer)
        {
            Caption = 'No. Of Transaction Files';
        }
        field(71; "AP File Overlap GL File"; Boolean)
        {
            Caption = 'AP File Overlap GL File';
        }
        field(72; "AR File Overlap GL File"; Boolean)
        {
            Caption = 'AR File Overlap GL File';
        }
        field(100; "Import Logs"; Integer)
        {
            CalcFormula = Count("Import Log" WHERE("Parent Client No." = FIELD("No."),
                                                    Status = FIELD("Import Log Status Filter")));
            Caption = 'Import Logs';
            FieldClass = FlowField;
        }
        field(101; "Import Log Status Filter"; Option)
        {
            Caption = 'Import Log Status Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Imported,In Progress,Error,Processed';
            OptionMembers = Imported,"In Progress",Error,Processed;
        }
        field(200; "G/L Detail Level"; Option)
        {
            Caption = 'G/L Detail Level';
            OptionCaption = 'Transactional,Trial Balance';
            OptionMembers = Transactional,"Trial Balance";

            trigger OnValidate()
            var
                lrecEYCoreSetup: Record "EY Core Setup";
                lblnCarryOn: Boolean;
                lrecSubsidiaryClient: Record "Subsidiary Client";
            begin
                lrecEYCoreSetup.Get();
                lblnCarryOn := true;
                if (("G/L Account Template Code" <> '') or
                    ("Corporate GL Acc. Templ. Code" <> '') or
                    ("Trial Balance Template Code" <> '') or
                    ("G/L Entry Template Code" <> '') or
                    ("Customer Template Code" <> '') or
                    ("Vendor Template Code" <> '') or
                    ("AR Template Code" <> '') or
                    ("AP Template Code" <> '')) then begin

                    lblnCarryOn := Confirm(MSG_001, false);
                end;

                if lblnCarryOn then begin
                    case "G/L Detail Level" of
                        "G/L Detail Level"::Transactional:
                            begin
                                "G/L Account Template Code" := lrecEYCoreSetup."TR Local CoA Template";
                                "Corporate GL Acc. Templ. Code" := lrecEYCoreSetup."TR Corp. CoA Template";
                                "Trial Balance Template Code" := lrecEYCoreSetup."TR Trial Balance Template";
                                "G/L Entry Template Code" := lrecEYCoreSetup."TR G/L Transactions Template";
                                "Customer Template Code" := lrecEYCoreSetup."TR Customer Template";
                                "Vendor Template Code" := lrecEYCoreSetup."TR Vendor Template";
                                "AR Template Code" := lrecEYCoreSetup."TR A/R Trans. Template";
                                "AP Template Code" := lrecEYCoreSetup."TR A/P Trans. Template";
                            end;
                        "G/L Detail Level"::"Trial Balance":
                            begin
                                "G/L Account Template Code" := lrecEYCoreSetup."TB Local CoA Template";
                                "Corporate GL Acc. Templ. Code" := lrecEYCoreSetup."TB Corp. CoA Template";
                                "Trial Balance Template Code" := lrecEYCoreSetup."TB Trial Bal. Template";
                                "G/L Entry Template Code" := lrecEYCoreSetup."TB G/L Trans. Template";
                                "Customer Template Code" := '';
                                "Vendor Template Code" := '';
                                "AR Template Code" := '';
                                "AP Template Code" := '';
                            end;
                    end;

                    // Cascade change to the Lines
                    lrecSubsidiaryClient.SetRange("Parent Client No.", "No.");
                    if lrecSubsidiaryClient.FindSet(true, false) then
                        repeat
                            lrecSubsidiaryClient.Validate("G/L Detail level", "G/L Detail Level");
                            lrecSubsidiaryClient.Modify(true);
                        until lrecSubsidiaryClient.Next() = 0;
                end;
            end;
        }
        field(60000; "Posting Method"; Option)
        {
            Caption = 'Posting Method';
            Description = 'MD 10-10-12';
            OptionCaption = 'Post,Simulate';
            OptionMembers = Post,Simulate;
        }
        field(60073; "A/R Trans Posting Scenario"; Option)
        {
            Caption = 'A/R Trans Posting Scenario';
            OptionCaption = 'Update G/L,Do Not Update G/L';
            OptionMembers = "Update G/L","Do Not Update G/L";
        }
        field(60074; "A/P Trans Posting Scenario"; Option)
        {
            Caption = 'A/P Trans Posting Scenario';
            OptionCaption = 'Update G/L,Do Not Update G/L';
            OptionMembers = "Update G/L","Do Not Update G/L";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Validate("G/L Detail Level", "G/L Detail Level"::Transactional);
        Validate("Posting Method", "Posting Method"::Simulate); //TEC 07-11-12 -mdan-
    end;

    var
        MSG_001: Label 'Values already exist in the Template code fields, do you want to override with the default templates?';
}

