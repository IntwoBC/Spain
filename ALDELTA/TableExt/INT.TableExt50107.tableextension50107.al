tableextension 50107 tableextension50107 extends "Gen. Journal Batch"
{
    // MP 17-01-12
    // Added options "GAAP Adjustments" and "Tax Adjustments" to "Template Type" field
    // 
    // TEC 26-10-12 -mdan- Used to post TB to TB reversal
    //   New field
    //     61800  Reverse TB to TB Boolean
    // 
    // MP 18-11-13
    // Added option "Group Adjustments" to "Template Type" field (CR 30)
    // 
    // MP 30-04-14
    // Development taken from Core II for Import Tool Enhancements
    fields
    {
        modify("Template Type")
        {
            OptionCaption = 'General,Sales,Purchases,Cash Receipts,Payments,Assets,Intercompany,Jobs,,,,,Cartera,,,,,GAAP Adjustments,Tax Adjustments,Group Adjustments';

            //Unsupported feature: Property Modification (OptionString) on ""Template Type"(Field 21)".

        }
        field(61800; "Reverse TB to TB"; Boolean)
        {
            Caption = 'Reverse TB to TB';
            DataClassification = CustomerContent;
        }
    }
}

