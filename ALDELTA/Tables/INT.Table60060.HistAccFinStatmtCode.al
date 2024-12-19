table 60060 "Hist. Acc. Fin. Statmt. Code"
{
    Caption = 'Historic G/L Account Financial Statement Code';
    DrillDownPageID = "Hist. Acc. Fin. Statmt. Codes";
    LookupPageID = "Hist. Acc. Fin. Statmt. Codes";
    DataClassification = CustomerContent;


    fields
    {
        field(1; "G/L Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionMembers = "G/L Account","Corporate G/L Account";
        }
        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'Account No.';
            NotBlank = true;
            TableRelation = IF ("G/L Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("G/L Account Type" = CONST("Corporate G/L Account")) "Corporate G/L Account";
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            TableRelation = IF ("G/L Account Type" = CONST("G/L Account")) "Accounting Period"."Starting Date" WHERE("New Fiscal Year" = CONST(true))
            ELSE
            IF ("G/L Account Type" = CONST("Corporate G/L Account")) "Corporate Accounting Period"."Starting Date" WHERE("New Fiscal Year" = CONST(true));

            trigger OnValidate()
            var
                lrecAccPeriod: Record "Accounting Period";
                lrecCorpAccPeriod: Record "Corporate Accounting Period";
            begin
                if "Starting Date" <> 0D then begin
                    if "Starting Date" > Today then
                        Error(txtFutureDateError);

                    if "G/L Account Type" = "G/L Account Type"::"G/L Account" then begin
                        lrecAccPeriod.SetFilter("Starting Date", '%1..', "Starting Date");
                        lrecAccPeriod.SetRange("New Fiscal Year", true);
                        lrecAccPeriod.FindSet();
                        lrecAccPeriod.Next();
                        Validate("Ending Date", lrecAccPeriod."Starting Date" - 1);
                    end else begin
                        lrecCorpAccPeriod.SetFilter("Starting Date", '%1..', "Starting Date");
                        lrecCorpAccPeriod.SetRange("New Fiscal Year", true);
                        lrecCorpAccPeriod.FindSet();
                        lrecCorpAccPeriod.Next();
                        Validate("Ending Date", lrecCorpAccPeriod."Starting Date" - 1);
                    end;
                end;
            end;
        }
        field(10; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            var
                lrecAccPeriod: Record "Accounting Period";
                lrecCorpAccPeriod: Record "Corporate Accounting Period";
            begin
                if "Ending Date" <> 0D then begin
                    TestField("Starting Date");
                    if "Ending Date" < "Starting Date" then
                        FieldError("Ending Date");

                    if "G/L Account Type" = "G/L Account Type"::"G/L Account" then begin
                        lrecAccPeriod.SetRange("Starting Date", "Ending Date" + 1);
                        lrecAccPeriod.SetRange("New Fiscal Year", true);
                        lrecAccPeriod.FindFirst();
                    end else begin
                        lrecCorpAccPeriod.SetRange("Starting Date", "Ending Date" + 1);
                        lrecCorpAccPeriod.SetRange("New Fiscal Year", true);
                        lrecCorpAccPeriod.FindFirst();
                    end;
                end;
            end;
        }
        field(20; "Financial Statement Code"; Code[10])
        {
            Caption = 'Financial Statement Code';
            TableRelation = "Financial Statement Code";
        }
    }

    keys
    {
        key(Key1; "G/L Account Type", "G/L Account No.", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Ending Date");
        TestField("Financial Statement Code");
    end;

    trigger OnModify()
    begin
        TestField("Ending Date");
        TestField("Financial Statement Code");
    end;

    var
        txtFutureDateError: Label 'You cannot enter future periods. ';
}

