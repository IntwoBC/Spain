xmlport 60003 "Customer - OneSource"
{
    Caption = 'Customer - OneSource';
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '|';
    Format = VariableText;
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(MREF)
                {

                    trigger OnBeforePassVariable()
                    begin
                        MREF := 'MREF';
                    end;
                }
                textelement(NAME)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NAME := 'NAME';
                    end;
                }
                textelement(COUNTRY)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY := 'COUNTRY';
                    end;
                }
                textelement(ADDRESS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ADDRESS := 'ADDRESS';
                    end;
                }
                textelement(PCODE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PCODE := 'PCODE';
                    end;
                }
                textelement(VATRegnNumber)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VATRegnNumber := 'VAT Regn Number';
                    end;
                }
                textelement(VATRATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VATRATE := 'VATRATE';
                    end;
                }
            }
            tableelement(customerstaging; "Customer (Staging)")
            {
                XmlName = 'CustomerStaging';
                SourceTableView = SORTING("Import Log Entry No.", "Company No.");
                fieldelement(MREF; CustomerStaging."No.")
                {
                }
                fieldelement(NAME; CustomerStaging.Name)
                {
                }
                fieldelement(COUNTRY; CustomerStaging."Country/Region Code")
                {
                }
                fieldelement(ADDRESS; CustomerStaging.Address)
                {
                }
                fieldelement(PCODE; CustomerStaging."Post Code")
                {
                }
                fieldelement(VATRegnNumber; CustomerStaging."VAT Registration No.")
                {
                }
                textelement(optional)
                {
                    XmlName = 'VATRATE';
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

