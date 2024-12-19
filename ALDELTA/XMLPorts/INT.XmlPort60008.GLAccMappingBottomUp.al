xmlport 60008 "G/L Acc. Mapping - Bottom-Up"
{
    // MP 04-12-13
    // New object (CR 30)

    Caption = 'Import G/L Acc. Mapping - Country Services';
    DefaultFieldsValidation = false;
    Direction = Import;
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("G/L Account"; "G/L Account")
            {
                XmlName = 'GLAcc';
                SourceTableView = SORTING("No.");
                UseTemporary = true;
                fieldelement(LocalGLAccNo; "G/L Account"."No.")
                {
                }
                fieldelement(CorpGLAccNo; "G/L Account"."Corporate G/L Account No.")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    "G/L Account".TestField("No.");
                    grecGLAcc.Get("G/L Account"."No.");
                    grecGLAcc.Validate("Corporate G/L Account No.", "G/L Account"."Corporate G/L Account No.");
                    grecGLAcc.Modify(true);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Import from tab-separated file, must be saved as ""Text (MS-DOS)"" in Excel.")
                {
                    Caption = 'Import from tab-separated file, must be saved as "Text (MS-DOS)" in Excel.';
                    group("Columns expected:")
                    {
                        Caption = 'Columns expected:';
                        group("1. Local G/L Account No.")
                        {
                            Caption = '1. Local G/L Account No.';
                        }
                        group("2. Corporate G/L Account No.")
                        {
                            Caption = '2. Corporate G/L Account No.';
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        grecGLAcc: Record "G/L Account";
}

