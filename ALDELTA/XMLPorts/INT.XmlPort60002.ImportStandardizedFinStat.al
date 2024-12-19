xmlport 60002 "Import Standardized Fin. Stat."
{
    Caption = 'Import Standardized Financial Statement';
    Direction = Import;
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(financialstatementline; "Financial Statement Line")
            {
                XmlName = 'FinancialStatementLine';
                SourceTableView = SORTING("Financial Stat. Structure Code", "Line No.");
                fieldelement(Description; FinancialStatementLine.Description)
                {
                }
                fieldelement(DescriptionEnglish; FinancialStatementLine."Description (English)")
                {
                }
                fieldelement(FinancialStatementCode; FinancialStatementLine.Code)
                {

                    trigger OnAfterAssignField()
                    begin
                        if FinancialStatementLine.Code <> '' then
                            FinancialStatementLine.Type := FinancialStatementLine.Type::"Financial Statement Code";
                    end;
                }

                trigger OnBeforeInsertRecord()
                begin
                    FinancialStatementLine."Financial Stat. Structure Code" := gcodFinStatStructCode;
                    FinancialStatementLine."Line No." += gintLineNo;
                    gintLineNo += 10000;

                    if FinancialStatementLine.Code <> '' then
                        FinancialStatementLine."Line Type" := FinancialStatementLine."Line Type"::Posting;
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
                        group("1. Description")
                        {
                            Caption = '1. Description';
                        }
                        group("2. Description (English)")
                        {
                            Caption = '2. Description (English)';
                        }
                        group("3. Financial Statement Code")
                        {
                            Caption = '3. Financial Statement Code';
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        FinancialStatementLine.SetRange("Financial Stat. Structure Code", gcodFinStatStructCode);
        FinancialStatementLine.DeleteAll();

        gintLineNo := 10000;
    end;

    var
        gcodFinStatStructCode: Code[20];
        gintLineNo: Integer;


    procedure gfcnSetFinStatStructCode(pcodFinStatStructCode: Code[20])
    begin
        gcodFinStatStructCode := pcodFinStatStructCode;
    end;
}

