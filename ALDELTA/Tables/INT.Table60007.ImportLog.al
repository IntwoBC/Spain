table 60007 "Import Log"
{
    // TEC 18-07-12 -mdan-
    //   PK autoincrement = false
    // TEC 23-10-12 -mdan-
    //   Removed field
    //     60000 Posting Method Option
    // MP 30-04-14
    // Development taken from Core II

    Caption = 'Import Log';
    DrillDownPageID = "Import Log List";
    LookupPageID = "Import Log List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
        }
        field(10; "Parent Client No."; Code[20])
        {
            Caption = 'Parent Client No.';
            TableRelation = "Parent Client";
            ValidateTableRelation = false;
        }
        field(15; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            OptionCaption = 'Trial Balance,GL Transactions,AR Transactions,APTransactions,Chart Of Accounts,Corporate Chart Of Accounts,Customer,Vendor';
            OptionMembers = "Trial Balance","GL Transactions","AR Transactions",APTransactions,"Chart Of Accounts","Corporate Chart Of Accounts",Customer,Vendor;
        }
        field(20; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(40; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(50; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Imported,In Progress,Error,Processed';
            OptionMembers = Imported,"In Progress",Error,Processed;
        }
        field(52; Stage; Option)
        {
            Caption = 'Stage';
            OptionCaption = ' ,File Import,Post Import Validation,Data Transfer,Data Validation,Record Creation/Update/Posting';
            OptionMembers = " ","File Import","Post Import Validation","Data Transfer","Data Validation","Record Creation/Update/Posting";
        }
        field(60; Errors; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("Import Error Log" WHERE("Import Log Entry No." = FIELD("Entry No.")));
            Caption = 'Errors';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Table ID"; Integer)
        {
            Caption = 'Table ID';

            trigger OnLookup()
            var
                //"Object": Record "Object";
                Objects: Page Objects;
            begin
                // Object.SetRange(Object.Type, Object.Type::Table);
                //Objects.SetTableView(Object);
                Objects.LookupMode := true;
                if Objects.RunModal() = ACTION::LookupOK then begin
                    // Objects.GetRecord(Object);
                    //Validate("Table ID", Object.ID);
                end;
            end;

            trigger OnValidate()
            begin
                CalcFields("Table Name");
            end;
        }
        field(80; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Table),
                                                                        "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Table Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "TB to TB client"; Boolean)
        {
            Caption = 'TB to TB client';
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
            OptionCaption = 'Create One Source File,Process In NAV';
            OptionMembers = "Create One Source File","Process In NAV";
        }
        field(100; "Picture (Status)"; BLOB)
        {
            Caption = 'Picture (Status)';
            SubType = Bitmap;
        }
        field(110; "Picture (Stage-File Import)"; BLOB)
        {
            Caption = 'File Import';
            SubType = Bitmap;
        }
        field(120; "Picture (Stage-Post Imp. Va)"; BLOB)
        {
            Caption = 'Import Validation';
            SubType = Bitmap;
        }
        field(130; "Import Date"; Date)
        {
            Caption = 'Import Date';
        }
        field(140; "Import Time"; Time)
        {
            Caption = 'Import Time';
        }
        field(60000; "Posting Method"; Option)
        {
            Caption = 'Posting Method';
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
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
        }
        key(Key3; "Parent Client No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrecImportErrorLog: Record "Import Error Log";
        lrecGLAccountStaging: Record "G/L Account (Staging)";
        lrecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";
        lrecCorporateGLAccStaging: Record "Corporate G/L Acc (Staging)";
        lrecCustomerStaging: Record "Customer (Staging)";
        lrecVendorStaging: Record "Vendor (Staging)";
    begin
        // Check if log can be deleted
        if Status <> Status::Imported then Error(ERR_001);

        // Delete related error log entries
        lrecImportErrorLog.SetCurrentKey("Import Log Entry No.");
        lrecImportErrorLog.SetRange("Import Log Entry No.", "Entry No.");
        lrecImportErrorLog.DeleteAll(true);
        // delete related staging entries
        case "Table ID" of
            60009:
                begin
                    lrecGLAccountStaging.SetCurrentKey("Import Log Entry No.", "Company No.");
                    lrecGLAccountStaging.SetRange("Import Log Entry No.", "Entry No.");
                    lrecGLAccountStaging.DeleteAll(true);
                end;
            60012:
                begin
                    lrecGenJournalLineStaging.SetCurrentKey("Import Log Entry No.", "Company No.", "Posting Date", "Currency Code");
                    lrecGenJournalLineStaging.SetRange("Import Log Entry No.", "Entry No.");
                    lrecGenJournalLineStaging.DeleteAll(true);
                end;
            60018:
                begin
                    lrecCorporateGLAccStaging.SetCurrentKey("Import Log Entry No.", "Company No.");
                    lrecCorporateGLAccStaging.SetRange("Import Log Entry No.", "Entry No.");
                    lrecCorporateGLAccStaging.DeleteAll(true);
                end;
            60019:
                begin
                    lrecCustomerStaging.SetCurrentKey("Import Log Entry No.");
                    lrecCustomerStaging.SetRange("Import Log Entry No.", "Entry No.");
                    lrecCustomerStaging.DeleteAll(true);
                end;
            60020:
                begin
                    lrecVendorStaging.SetCurrentKey("Import Log Entry No.");
                    lrecVendorStaging.SetRange("Import Log Entry No.", "Entry No.");
                    lrecVendorStaging.DeleteAll(true);
                end;
        end;
    end;

    var
        ERR_001: Label 'Only Import Logs with status Imported can be deleted';


    procedure gfcnUpdateStagePicture(var ptmpStatusColor: array[4] of Record "Status Color" temporary)
    begin
        case Stage of
            Stage::" ":
                begin
                    Clear("Picture (Status)");
                    Clear("Picture (Stage-File Import)");
                    Clear("Picture (Stage-Post Imp. Va)");
                end;
            Stage::"File Import":
                begin
                    "Picture (Status)" := ptmpStatusColor[Status + 1].Picture;
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status + 1].Picture;
                    Clear("Picture (Stage-Post Imp. Va)");
                end;
            Stage::"Post Import Validation":
                begin
                    "Picture (Status)" := ptmpStatusColor[Status + 1].Picture;
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status + 1].Picture;
                    ;
                end;
            Stage::"Data Transfer":
                begin
                    "Picture (Status)" := ptmpStatusColor[lfncGetLowestStatus() + 1].Picture;
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status::Processed + 1].Picture;
                end;
            Stage::"Data Validation":
                begin
                    "Picture (Status)" := ptmpStatusColor[lfncGetLowestStatus() + 1].Picture;
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status::Processed + 1].Picture;
                end;
            Stage::"Record Creation/Update/Posting":
                begin
                    "Picture (Status)" := ptmpStatusColor[lfncGetLowestStatus() + 1].Picture;
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status::Processed + 1].Picture;
                end;
        end;
    end;

    local procedure lfcnSetPicture(pintStageNo: Integer; pblnCompleted: Boolean; var ptmpStatusColor: array[4] of Record "Status Color" temporary)
    begin
        if pblnCompleted then
            case pintStageNo of
                1:
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status::Processed + 1].Picture;
                2:
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status::Processed + 1].Picture;
            end
        else
            case pintStageNo of
                1:
                    "Picture (Stage-File Import)" := ptmpStatusColor[Status + 1].Picture;
                2:
                    "Picture (Stage-Post Imp. Va)" := ptmpStatusColor[Status + 1].Picture;
            end;
    end;


    procedure lfncGetLowestStatus() r_intStatus: Integer
    var
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
        lrecImportLogSubsidiaryClient: Record "Import Log - Subsidiary Client";
        lintSubsidiaryStatus: Integer;
    begin
        lrecImportLogSubsidiaryClient.SetRange("Import Log Entry No.", "Entry No.");
        //r_intStatus := lmodDataImportManagementCommon.gfncGetLowestStatus(lrecImportLogSubsidiaryClient);
        if r_intStatus = -1 then r_intStatus := lrecImportLogSubsidiaryClient.Status::Imported;
    end;
}

