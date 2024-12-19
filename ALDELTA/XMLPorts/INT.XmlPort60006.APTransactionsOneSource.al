xmlport 60006 "AP Transactions - OneSource"
{
    Caption = 'AP Transactions - OneSource';
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
                textelement(PLACE_OF_ESTABLISHMENT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PLACE_OF_ESTABLISHMENT := 'PLACE OF ESTABLISHMENT';
                    end;
                }
                textelement(INVREF)
                {

                    trigger OnBeforePassVariable()
                    begin
                        INVREF := 'INVREF';
                    end;
                }
                textelement(INVDATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        INVDATE := 'INVDATE';
                    end;
                }
                textelement(VATPCT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VATPCT := 'VAT %';
                    end;
                }
                textelement(NET)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NET := 'NET';
                    end;
                }
                textelement(VAT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VAT := 'VAT';
                    end;
                }
                textelement(GROSS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        GROSS := 'GROSS';
                    end;
                }
                textelement(CURRENCY)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CURRENCY := 'CURRENCY';
                    end;
                }
                textelement(EXCHANGE_RATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        EXCHANGE_RATE := 'EXCHANGE RATE';
                    end;
                }
                textelement(TYPE_OF_TRANSACTION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TYPE_OF_TRANSACTION := 'TYPE OF TRANSACTION';
                    end;
                }
                textelement(DESC)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DESC := 'DESC';
                    end;
                }
                textelement(TAXCODE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TAXCODE := 'TAXCODE';
                    end;
                }
                textelement(POSTDATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        POSTDATE := 'POSTDATE';
                    end;
                }
                textelement(PAYMDATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PAYMDATE := 'PAYMDATE';
                    end;
                }
                textelement(PAYAMOUNT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PAYAMOUNT := 'PAYAMOUNT';
                    end;
                }
                textelement(PAYMETHOD)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PAYMETHOD := 'PAYMETHOD';
                    end;
                }
                textelement(TREF)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TREF := 'TREF';
                    end;
                }
                textelement(GL)
                {

                    trigger OnBeforePassVariable()
                    begin
                        GL := 'GL';
                    end;
                }
                textelement(DATE_OF_PAYMENT_OF_THE_VAT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DATE_OF_PAYMENT_OF_THE_VAT := 'DATE OF PAYMENT OF THE VAT';
                    end;
                }
                textelement(AMOUNT_OF_IMPORT_VAT_PAID)
                {

                    trigger OnBeforePassVariable()
                    begin
                        AMOUNT_OF_IMPORT_VAT_PAID := 'AMOUNT OF IMPORT VAT PAID';
                    end;
                }
                textelement(COUNTRY_OF_DISPATCH)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_DISPATCH := 'COUNTRY OF DISPATCH';
                    end;
                }
                textelement(COUNTRY_OF_ORIGIN)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_ORIGIN := 'COUNTRY OF ORIGIN';
                    end;
                }
                textelement(COUNTRY_OF_DESTINATION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_DESTINATION := 'COUNTRY OF DESTINATION';
                    end;
                }
                textelement(SIMPLIFIED_TRIANGUL_ABC)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SIMPLIFIED_TRIANGUL_ABC := 'SIMPLIFIED TRIANGUL (A-B-C)';
                    end;
                }
                textelement(HS_CODE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        HS_CODE := 'HS CODE (8 digits)';
                    end;
                }
                textelement(INVOICED_AMOUNT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        INVOICED_AMOUNT := 'INVOICED AMOUNT';
                    end;
                }
                textelement(STATISTICAL_VALUE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        STATISTICAL_VALUE := 'STATISTICAL VALUE';
                    end;
                }
                textelement(QUANTITY)
                {

                    trigger OnBeforePassVariable()
                    begin
                        QUANTITY := 'QUANTITY';
                    end;
                }
                textelement(SUPLEMENTRAY_UNITS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SUPLEMENTRAY_UNITS := 'SUPLEMENTRAY UNITS';
                    end;
                }
                textelement(AMOUNT_INVOICED_PER_SUPPLY_OF)
                {

                    trigger OnBeforePassVariable()
                    begin
                        AMOUNT_INVOICED_PER_SUPPLY_OF := 'AMOUNT INVOICED PER SUPPLY OF COMMODITY CODE';
                    end;
                }
                textelement(NET_WEIGHT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NET_WEIGHT := 'NET WEIGHT';
                    end;
                }
                textelement(NATURE_OF_TRANSACTIONS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        NATURE_OF_TRANSACTIONS := 'NATURE OF TRANSACTIONS';
                    end;
                }
                textelement(TRANSACTION_CODE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TRANSACTION_CODE := 'TRANSACTION CODE';
                    end;
                }
                textelement(MEANS_OF_TRANSPORT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        MEANS_OF_TRANSPORT := 'MEANS OF TRANSPORT';
                    end;
                }
                textelement(PLACE_PORT_OF_ARRIVAL)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PLACE_PORT_OF_ARRIVAL := 'PLACE/PORT OF ARRIVAL';
                    end;
                }
                textelement(CODE_OF_STATISTICAL_CONDITION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CODE_OF_STATISTICAL_CONDITION := 'CODE OF STATISTICAL CONDITION';
                    end;
                }
                textelement(LOCATION_OF_THE_OPERATIONS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        LOCATION_OF_THE_OPERATIONS := 'LOCATION OF THE OPERATIONS';
                    end;
                }
                textelement(INCOTERMS_DELIVERY_TERMS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        INCOTERMS_DELIVERY_TERMS := 'INCOTERMS/DELIVERY TERMS';
                    end;
                }
                textelement(DATE_EXCHANGE_RATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DATE_EXCHANGE_RATE := 'DATE EXCHANGE RATE';
                    end;
                }
            }
            tableelement(genjnllinestaging; "Gen. Journal Line (Staging)")
            {
                XmlName = 'GenJnlLineStaging';
                SourceTableView = SORTING("Import Log Entry No.", "Company No.", "Posting Date", "Currency Code") WHERE("Interface Type" = CONST("A/P Transactions"), "VAT Code" = FILTER(<> ''));
                fieldelement(MREF; GenJnlLineStaging."Account No.")
                {
                }
                fieldelement(PLACE_OF_ESTABLISHMENT; GenJnlLineStaging."Place of Establishment")
                {
                }
                fieldelement(INVREF; GenJnlLineStaging."Document No.")
                {
                }
                fieldelement(INVDATE; GenJnlLineStaging."Document Date")
                {
                }
                fieldelement(VATPCT; GenJnlLineStaging."VAT %")
                {
                }
                fieldelement(NET; GenJnlLineStaging."Net Amount")
                {
                }
                fieldelement(VAT; GenJnlLineStaging."VAT Amount")
                {
                }
                textelement(optional1)
                {
                    XmlName = 'GROSS';
                }
                fieldelement(CURRENCY; GenJnlLineStaging."Currency Code")
                {
                }
                fieldelement(EXCHANGE_RATE; GenJnlLineStaging."Currency Factor")
                {
                }
                fieldelement(TYPE_OF_TRANSACTION; GenJnlLineStaging."Transaction Type")
                {
                }
                fieldelement(DESC; GenJnlLineStaging.Description)
                {
                }
                fieldelement(TAXCODE; GenJnlLineStaging."VAT Code")
                {
                }
                fieldelement(POSTDATE; GenJnlLineStaging."Posting Date")
                {
                }
                fieldelement(PAYMDATE; GenJnlLineStaging."Payment Date")
                {
                }
                textelement(optional2)
                {
                    XmlName = 'PAYAMOUNT';
                }
                textelement(optional3)
                {
                    XmlName = 'PAYMETHOD';
                }
                textelement(optional4)
                {
                    XmlName = 'TREF';
                }
                textelement(optional5)
                {
                    XmlName = 'GL';
                }
                fieldelement(DATE_OF_PAYMENT_OF_THE_VAT; GenJnlLineStaging."VAT Payment Date")
                {
                }
                fieldelement(AMOUNT_OF_IMPORT_VAT_PAID; GenJnlLineStaging."VAT Payment Amount")
                {
                }
                textelement(intrastat1)
                {
                    XmlName = 'COUNTRY_OF_DISPATCH';
                }
                textelement(intrastat2)
                {
                    XmlName = 'COUNTRY_OF_ORIGIN';
                }
                textelement(intrastat3)
                {
                    XmlName = 'COUNTRY_OF_DESTINATION';
                }
                textelement(intrastat4)
                {
                    XmlName = 'SIMPLIFIED_TRIANGUL_ABC';
                }
                textelement(intrastat5)
                {
                    XmlName = 'HS_CODE';
                }
                textelement(intrastat6)
                {
                    XmlName = 'INVOICED_AMOUNT';
                }
                textelement(intrastat7)
                {
                    XmlName = 'STATISTICAL_VALUE';
                }
                textelement(intrastat8)
                {
                    XmlName = 'QUANTITY';
                }
                textelement(intrastat9)
                {
                    XmlName = 'SUPLEMENTRAY_UNITS';
                }
                textelement(intrastat10)
                {
                    XmlName = 'AMOUNT_INVOICED_PER_SUPPLY_OF';
                }
                textelement(intrastat11)
                {
                    XmlName = 'NET_WEIGHT';
                }
                textelement(intrastat12)
                {
                    XmlName = 'NATURE_OF_TRANSACTIONS';
                }
                textelement(intrastat13)
                {
                    XmlName = 'TRANSACTION_CODE';
                }
                textelement(intrastat14)
                {
                    XmlName = 'MEANS_OF_TRANSPORT';
                }
                textelement(intrastat15)
                {
                    XmlName = 'PLACE_PORT_OF_ARRIVAL';
                }
                textelement(intrastat16)
                {
                    XmlName = 'CODE_OF_STATISTICAL_CONDITION';
                }
                textelement(intrastat17)
                {
                    XmlName = 'LOCATION_OF_THE_OPERATIONS';
                }
                textelement(intrastat18)
                {
                    XmlName = 'INCOTERMS_DELIVERY_TERMS';
                }
                textelement(intrastat19)
                {
                    XmlName = 'DATE_EXCHANGE_RATE';
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

