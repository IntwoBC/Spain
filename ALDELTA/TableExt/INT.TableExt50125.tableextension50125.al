tableextension 50125 tableextension50125 extends "Gen. Journal Template"
{
    fields
    {
        modify(Type)
        {
            OptionCaption = 'General,Sales,Purchases,Cash Receipts,Payments,Assets,Intercompany,Jobs,,,,,Cartera,,,,GAAP Adjustments,Tax Adjustments,Group Adjustments';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 9)".

        }
        field(60000; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(60020; "Use Ready to Post"; Boolean)
        {
            Caption = 'Use Ready to Post';
            Description = 'MP 17-01-12';
            DataClassification = CustomerContent;
        }
    }
}

