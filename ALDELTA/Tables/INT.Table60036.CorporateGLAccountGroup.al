table 60036 "Corporate G/L Account Group"
{
    Caption = 'Corporate G/L Account Group';
    DrillDownPageID = "Corporate G/L Acc. Group List";
    LookupPageID = "Corporate G/L Acc. Group List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "Description (English)"; Text[50])
        {
            Caption = 'Description (English)';
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
        fieldgroup(DropDown; "Code", Description, "Description (English)")
        {
        }
    }

    trigger OnDelete()
    var
        lrecCorpGLAccGrLine: Record "Corporate G/L Account Gr. Line";
    begin
        lrecCorpGLAccGrLine.SetRange("Corp. G/L Account Group Code", Code);
        lrecCorpGLAccGrLine.DeleteAll(true);
    end;
}

