xmlport 60001 "Financial Statement Structure"
{
    Caption = 'Financial Statement Structure';

    schema
    {
        textelement(FinancialStatement)
        {
            MaxOccurs = Once;
            tableelement("Financial Statement Structure"; "Financial Statement Structure")
            {
                RequestFilterFields = Code;
                XmlName = 'FinancialStatementStructure';
                SourceTableView = SORTING(Code);
                fieldelement(Code; "Financial Statement Structure".Code)
                {
                }
                fieldelement(Description; "Financial Statement Structure".Description)
                {
                }
                fieldelement(DescriptionEnglish; "Financial Statement Structure"."Description (English)")
                {
                }
                fieldelement(Default; "Financial Statement Structure".Default)
                {
                }
                tableelement("Financial Statement Line"; "Financial Statement Line")
                {
                    LinkFields = "Financial Stat. Structure Code" = FIELD(Code);
                    LinkTable = "Financial Statement Structure";
                    XmlName = 'FinancialStatementLine';
                    SourceTableView = SORTING("Financial Stat. Structure Code", "Line No.");
                    fieldelement(LineNo; "Financial Statement Line"."Line No.")
                    {
                    }
                    fieldelement(RowNo; "Financial Statement Line"."Row No.")
                    {
                    }
                    fieldelement(Type; "Financial Statement Line".Type)
                    {
                    }
                    fieldelement(Code; "Financial Statement Line".Code)
                    {
                    }
                    fieldelement(Description; "Financial Statement Line".Description)
                    {
                    }
                    fieldelement(DescriptionEnglish; "Financial Statement Line"."Description (English)")
                    {
                    }
                    fieldelement(LineType; "Financial Statement Line"."Line Type")
                    {
                    }
                    fieldelement(Totalling; "Financial Statement Line"."Totalling/Formula")
                    {
                    }
                    fieldelement(StartBalance; "Financial Statement Line"."Start Balance")
                    {
                    }
                    fieldelement(EndBalance; "Financial Statement Line"."End Balance")
                    {
                    }
                    fieldelement(ShowOppositeSign; "Financial Statement Line"."Show Opposite Sign")
                    {
                    }
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

