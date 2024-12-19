table 60002 "Import Template Line"
{
    Caption = 'Import Template Line';
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Template Header Code"; Code[20])
        {
            Caption = 'Import Template Code';
            TableRelation = "Import Template Header";
        }
        field(2; Column; Text[2])
        {
            Caption = 'Column';

            trigger OnValidate()
            begin
                Column := UpperCase(Column);
            end;
        }
        field(10; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(20; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));

            trigger OnLookup()
            var
                lrecField: Record "Field";
            begin
                lrecField.SetRange(TableNo, "Table ID");
                if IsServiceTier then begin
                    if PAGE.RunModal(6218, lrecField) = ACTION::LookupOK then begin
                        "Field ID" := lrecField."No.";
                    end;
                end else begin
                    if Page.RUNMODAL(6218, lrecField) = ACTION::LookupOK then begin
                        "Field ID" := lrecField."No.";
                    end;
                end;
            end;
        }
        field(30; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"),
                                                        "No." = FIELD("Field ID")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Template Header Code", Column)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrecImportTemplateHdr: Record "Import Template Header";
    begin
        lrecImportTemplateHdr.Get("Template Header Code");
        "Table ID" := lrecImportTemplateHdr."Table ID";
    end;
}

