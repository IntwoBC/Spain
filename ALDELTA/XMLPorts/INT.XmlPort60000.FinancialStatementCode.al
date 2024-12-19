xmlport 60000 "Financial Statement Code"
{
    Caption = 'Financial Statement Code';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Financial Statement Code"; "Financial Statement Code")
            {
                XmlName = 'FinancialsStatmentCode';
                SourceTableView = SORTING(Code);
                fieldelement(Code; "Financial Statement Code".Code)
                {
                }
                fieldelement(Description; "Financial Statement Code".Description)
                {
                }
                fieldelement(DescriptionEnglish; "Financial Statement Code"."Description (English)")
                {
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

    var
        goptDirection: Option Import,Export;
}

