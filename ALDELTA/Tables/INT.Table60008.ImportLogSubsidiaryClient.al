table 60008 "Import Log - Subsidiary Client"
{
    Caption = 'Import Log - Subsidiary Client';
    DrillDownPageID = "Import Log List - Subs. Client";
    LookupPageID = "Import Log List - Subs. Client";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Import Log Entry No."; BigInteger)
        {
            Caption = 'Import Log Entry No.';
            TableRelation = "Import Log";
        }
        field(2; "Parent Client No."; Code[20])
        {
            Caption = 'Parent Client No.';
            TableRelation = "Parent Client";
        }
        field(3; "Country Database Code"; Code[20])
        {
            Caption = 'Country Database Code';
            TableRelation = "Country Database";
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(8; "Company No."; Code[20])
        {
            Caption = 'Company No.';
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Imported,In Progress,Error,Processed';
            OptionMembers = Imported,"In Progress",Error,Processed;
        }
        field(15; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            OptionCaption = 'Trial Balance,GL Transactions,AR Transactions,APTransactions,Chart Of Accounts,Corporate Chart Of Accounts,Customer,Vendor';
            OptionMembers = "Trial Balance","GL Transactions","AR Transactions",APTransactions,"Chart Of Accounts","Corporate Chart Of Accounts",Customer,Vendor;
        }
        field(20; Stage; Option)
        {
            Caption = 'Stage';
            OptionCaption = ' ,File Import,Post Import Validation,Data Transfer,Data Validation,Record Creation/Update/Posting';
            OptionMembers = " ","File Import","Post Import Validation","Data Transfer","Data Validation","Record Creation/Update/Posting";
        }
        field(30; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(40; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
        field(50; "First Entry Date"; Date)
        {
            Caption = 'First Entry Date';
        }
        field(52; "Last Entry Date"; Date)
        {
            Caption = 'Last Entry Date';
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
        field(120; "Picture (Stage-Data Transfer)"; BLOB)
        {
            Caption = 'Data Transfer';
            SubType = Bitmap;
        }
        field(130; "Picture (Stage-Data Validat.)"; BLOB)
        {
            Caption = 'Data Validation';
            SubType = Bitmap;
        }
        field(140; "Picture (Stage-Rec. CreUpdPos)"; BLOB)
        {
            Caption = 'Record Create/Update/Posting';
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Import Log Entry No.", "Parent Client No.", "Country Database Code", "Company Name")
        {
            Clustered = true;
        }
        key(Key2; "Parent Client No.", "Company No.", "Interface Type", "First Entry Date", "Last Entry Date")
        {
        }
    }

    fieldgroups
    {
    }


    procedure gfcnUpdateStagePicture(var ptmpStatusColor: array[4] of Record "Status Color" temporary)
    begin
        case Stage of
            Stage::" ",
            Stage::"File Import",
            Stage::"Post Import Validation":
                begin
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status::Imported + 1].Picture;
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status::Imported + 1].Picture;
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status::Imported + 1].Picture;
                end;
            Stage::"Data Transfer":
                begin
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status + 1].Picture;
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status::Imported + 1].Picture;
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status::Imported + 1].Picture;
                end;
            Stage::"Data Validation":
                begin
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status + 1].Picture;
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status::Imported + 1].Picture;
                end;
            Stage::"Record Creation/Update/Posting":
                begin
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status::Processed + 1].Picture;
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status + 1].Picture;
                end;
        end;
        /*
        IF Status = Status::Imported THEN
          EXIT;
        
        IF Status = Status::Processed THEN BEGIN
          "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status + 1].Picture;
          "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status + 1].Picture;
          "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status + 1].Picture;
        END ELSE BEGIN
          lfcnSetPicture(3,Stage >= Stage::"Data Transfer",ptmpStatusColor);
          lfcnSetPicture(4,Stage >= Stage::"Data Validation",ptmpStatusColor);
          lfcnSetPicture(5,Stage >= Stage::"Record Creation/Update/Posting",ptmpStatusColor);
        END;
        */

    end;

    local procedure lfcnSetPicture(pintStageNo: Integer; pblnCompleted: Boolean; var ptmpStatusColor: array[4] of Record "Status Color" temporary)
    begin
        if pblnCompleted then
            case pintStageNo of
                3:
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status::Processed + 1].Picture;
                4:
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status::Processed + 1].Picture;
                5:
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status::Processed + 1].Picture;
            end
        else
            case pintStageNo of
                3:
                    "Picture (Stage-Data Transfer)" := ptmpStatusColor[Status + 1].Picture;
                4:
                    "Picture (Stage-Data Validat.)" := ptmpStatusColor[Status + 1].Picture;
                5:
                    "Picture (Stage-Rec. CreUpdPos)" := ptmpStatusColor[Status + 1].Picture;
            end;
    end;
}

