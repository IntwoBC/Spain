table 60033 "Financial Statement Line"
{
    // MP 02-12-13
    // Added field "Manual Entries Exist, added code to OnDelete() (CR 31 - Case 14140)

    Caption = 'Financial Statement Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Financial Stat. Structure Code"; Code[20])
        {
            Caption = 'Financial Stat. Structure Code';
            TableRelation = "Financial Statement Structure";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST("Financial Statement Code")) "Financial Statement Code"
            ELSE
            IF (Type = CONST("Corporate G/L Account Group")) "Corporate G/L Account Group";

            trigger OnValidate()
            var
                lrecFinancialStatementCode: Record "Financial Statement Code";
                lrecCorpGLAccGroup: Record "Corporate G/L Account Group";
            begin
                if Code <> '' then begin
                    if Type = Type::"Financial Statement Code" then begin
                        lrecFinancialStatementCode.Get(Code);
                        Description := lrecFinancialStatementCode.Description;
                        "Description (English)" := lrecFinancialStatementCode."Description (English)";
                    end else begin
                        lrecCorpGLAccGroup.Get(Code);
                        Description := lrecCorpGLAccGroup.Description;
                        "Description (English)" := lrecCorpGLAccGroup."Description (English)";
                    end;
                    "Line Type" := "Line Type"::Posting;
                end;
            end;
        }
        field(12; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Financial Statement Code,Corporate G/L Account Group';
            OptionMembers = " ","Financial Statement Code","Corporate G/L Account Group";
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(22; "Description (English)"; Text[250])
        {
            Caption = 'Description (English)';
        }
        field(30; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Heading,Begin-Total,Posting,End-Total,Totalling,Manual Entry,Formula';
            OptionMembers = " ",Heading,"Begin-Total",Posting,"End-Total",Totalling,"Manual Entry",Formula;

            trigger OnValidate()
            begin
                if "Line Type" in ["Line Type"::Posting, "Line Type"::Totalling] then
                    TestField(Type);
            end;
        }
        field(40; "Totalling/Formula"; Text[250])
        {
            Caption = 'Totalling/Formula';
        }
        field(50; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            CharAllowed = 'AZ09__';
        }
        field(90; "Prior Period Balance"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Prior Period Balance';
        }
        field(100; "Start Balance"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Start Balance';
        }
        field(120; "End Balance"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'End Balance';
        }
        field(130; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            TableRelation = "Corporate G/L Account";
        }
        field(140; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(150; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(160; "Show Opposite Sign"; Boolean)
        {
            Caption = 'Show Opposite Sign';
        }
        field(170; "Manual Entries Exist"; Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("Financial Stat. Manual Entry" WHERE("Financial Stat. Structure Code" = FIELD("Financial Stat. Structure Code"),
                                                                      "Financial Stat. Line No." = FIELD("Line No.")));
            Caption = 'Manual Entries Exist';
            Description = 'MP 02-12-13';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Financial Stat. Structure Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Code", "Corporate G/L Account No.", Type)
        {
            SumIndexFields = "Start Balance", "End Balance";
        }
        key(Key3; "Row No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrecFinStatManualEntry: Record "Financial Stat. Manual Entry";
    begin
        // MP 02-12-13 >>
        if "Line Type" = "Line Type"::"Manual Entry" then begin
            lrecFinStatManualEntry.SetRange("Financial Stat. Structure Code", "Financial Stat. Structure Code");
            lrecFinStatManualEntry.SetRange("Financial Stat. Line No.", "Line No.");
            lrecFinStatManualEntry.DeleteAll(true);
        end;
        // MP 02-12-13 <<
    end;
}

