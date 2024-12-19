xmlport 60005 "AR Transactions - OneSource"
{
    Caption = 'AR Transactions - OneSource';
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
                textelement(DATE_OF_SUPPLY)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DATE_OF_SUPPLY := 'DATE OF SUPPLY';
                    end;
                }
                textelement(PAYMENT_DUE_DATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PAYMENT_DUE_DATE := 'PAYMENT DUE DATE';
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
                textelement(RECTDATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        RECTDATE := 'RECTDATE';
                    end;
                }
                textelement(RECTAMOUNT)
                {

                    trigger OnBeforePassVariable()
                    begin
                        RECTAMOUNT := 'RECTAMOUNT';
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
                textelement(COUNTRY_OF_DESTINATION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_DESTINATION := 'COUNTRY OF DESTINATION';
                    end;
                }
                textelement(COUNTRY_OF_ORIGIN)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_ORIGIN := 'COUNTRY OF ORIGIN';
                    end;
                }
                textelement(COUNTRY_OF_DISPATCH)
                {

                    trigger OnBeforePassVariable()
                    begin
                        COUNTRY_OF_DISPATCH := 'COUNTRY OF DISPATCH';
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
                textelement(PROVINCE_CODE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PROVINCE_CODE := 'PROVINCE CODE';
                    end;
                }
                textelement(PORT_PLACE_OF_DISPATCH)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PORT_PLACE_OF_DISPATCH := 'PORT/PLACE OF DISPATCH';
                    end;
                }
                textelement(CODE_OF_STATISTICAL_CONDITION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CODE_OF_STATISTICAL_CONDITION := 'CODE OF STATISTICAL CONDITION';
                    end;
                }
                textelement(INCOTERMS_DELIVERY_TERMS)
                {

                    trigger OnBeforePassVariable()
                    begin
                        INCOTERMS_DELIVERY_TERMS := 'INCOTERMS/DELIVERY TERMS';
                    end;
                }
                textelement(REGION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        REGION := 'REGION';
                    end;
                }
                textelement(DATE_EXCHANGE_RATE)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DATE_EXCHANGE_RATE := 'DATE EXCHANGE RATE';
                    end;
                }
                textelement(ANNOUNCEMENT_38_DECLARATION)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ANNOUNCEMENT_38_DECLARATION := 'ANNOUNCEMENT 38 DECLARATION (Y/N/NA)';
                    end;
                }
            }
            tableelement(genjnllinestaging; "Gen. Journal Line (Staging)")
            {
                XmlName = 'GenJnlLineStaging';
                SourceTableView = SORTING("Import Log Entry No.", "Company No.", "Posting Date", "Currency Code") WHERE("Interface Type" = CONST("A/R Transactions"), "VAT Code" = FILTER(<> ''));
                fieldelement(MREF; GenJnlLineStaging."Account No.")
                {
                }
                fieldelement(INVREF; GenJnlLineStaging."Document No.")
                {
                }
                fieldelement(INVDATE; GenJnlLineStaging."Document Date")
                {
                }
                textelement(optional1)
                {
                    XmlName = 'DATE_OF_SUPPLY';
                }
                textelement(optional2)
                {
                    XmlName = 'PAYMENT_DUE_DATE';
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
                textelement(optional3)
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
                fieldelement(RECTDATE; GenJnlLineStaging."Payment Date")
                {
                }
                textelement(optional5)
                {
                    XmlName = 'RECTAMOUNT';
                }
                textelement(optional6)
                {
                    XmlName = 'TREF';
                }
                textelement(optional7)
                {
                    XmlName = 'GL';
                }
                textelement(intrastat1)
                {
                    XmlName = 'COUNTRY_OF_DESTINATION';
                }
                textelement(intrastat2)
                {
                    XmlName = 'COUNTRY_OF_ORIGIN';
                }
                textelement(intrastat3)
                {
                    XmlName = 'COUNTRY_OF_DISPATCH';
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
                    XmlName = 'PROVINCE_CODE';
                }
                textelement(intrastat16)
                {
                    XmlName = 'PORT_PLACE_OF_DISPATCH';
                }
                textelement(intrastat17)
                {
                    XmlName = 'CODE_OF_STATISTICAL_CONDITION';
                }
                textelement(intrastat18)
                {
                    XmlName = 'INCOTERMS_DELIVERY_TERMS';
                }
                textelement(intrastat19)
                {
                    XmlName = 'REGION';
                }
                textelement(intrastat20)
                {
                    XmlName = 'DATE_EXCHANGE_RATE';
                }
                textelement(intrastat21)
                {
                    XmlName = 'ANNOUNCEMENT_38_DECLARATION';
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

