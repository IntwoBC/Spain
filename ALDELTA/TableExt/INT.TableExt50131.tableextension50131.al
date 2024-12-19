tableextension 50131 tableextension50131 extends "Comment Line"
{
    // MP 18-01-12
    // Added option "Corporate G/L Account" to field "Table Name"
    fields
    {

        //Unsupported feature: Property Modification (OptionString) on ""Table Name"(Field 1)".

        modify("No.")
        {
            TableRelation = IF ("Table Name" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Table Name" = CONST(Customer)) Customer
            ELSE
            IF ("Table Name" = CONST(Vendor)) Vendor
            ELSE
            IF ("Table Name" = CONST(Item)) Item
            ELSE
            IF ("Table Name" = CONST(Resource)) Resource
            ELSE
            IF ("Table Name" = CONST(Job)) Job
            ELSE
            IF ("Table Name" = CONST("Resource Group")) "Resource Group"
            ELSE
            IF ("Table Name" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Table Name" = CONST(Campaign)) Campaign
            ELSE
            IF ("Table Name" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Table Name" = CONST(Insurance)) Insurance
            ELSE
            IF ("Table Name" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Table Name" = CONST("Corporate G/L Account")) "Corporate G/L Account";
        }
    }
}

