tableextension 50130 tableextension50130 extends "Country/Region"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // OPP  01.02.13   OPplus Granule
    //                 - New Fields added
    // -----------------------------------------------------
    Caption = 'Country/Region';
    fields
    {
        modify("Code")
        {
            Caption = 'Code';
        }
        modify(Name)
        {
            Caption = 'Name';
        }
        modify("EU Country/Region Code")
        {
            Caption = 'EU Country/Region Code';
        }
        modify("Intrastat Code")
        {
            Caption = 'Intrastat Code';
        }
        modify("Address Format")
        {
            Caption = 'Address Format';
        }
        modify("Contact Address Format")
        {
            Caption = 'Contact Address Format';
            OptionCaption = 'First,After Company Name,Last';
        }
        modify("VAT Scheme")
        {
            Caption = 'VAT Scheme';
        }
        modify("VAT Registration No. digits")
        {
            Caption = 'VAT Registration No. digits';
        }
    }
}

