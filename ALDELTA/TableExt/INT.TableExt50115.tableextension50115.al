tableextension 50115 tableextension50115 extends "Vendor Bank Account"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // EA   01.11.08   Extended Application
    //                 - New Field added
    //                 - 2nd Key Field added :
    //                   Bank Branch No.,Bank Account No.
    //                 - 3rd Key added:
    //                   IBAN
    // PMT  01.11.08   OPplus Payment
    //                 - New Fields added
    //                 - Lookup Bank Branch No.
    // -----------------------------------------------------
    Caption = 'Vendor Bank Account';
    fields
    {
        modify("Vendor No.")
        {
            Caption = 'Vendor No.';
        }
        modify("Code")
        {
            Caption = 'Code';
        }
        modify(Name)
        {
            Caption = 'Name';
        }
        modify("Name 2")
        {
            Caption = 'Name 2';
        }
        modify(Address)
        {
            Caption = 'Address';
        }
        modify("Address 2")
        {
            Caption = 'Address 2';
        }
        modify(City)
        {
            Caption = 'City';
        }
        modify(Contact)
        {
            Caption = 'Contact';
        }
        modify("Phone No.")
        {
            Caption = 'Phone No.';
        }
        modify("Telex No.")
        {
            Caption = 'Telex No.';
        }
        modify("Bank Branch No.")
        {
            Caption = 'Bank Branch No.';
        }
        modify("Bank Account No.")
        {
            Caption = 'Bank Account No.';
        }
        modify("Transit No.")
        {
            Caption = 'Transit No.';
        }
        modify("Currency Code")
        {
            Caption = 'Currency Code';
        }
        modify("Country/Region Code")
        {
            Caption = 'Country/Region Code';
        }
        modify(County)
        {
            Caption = 'County';
        }
        modify("Fax No.")
        {
            Caption = 'Fax No.';
        }
        modify("Telex Answer Back")
        {
            Caption = 'Telex Answer Back';
        }
        modify("Language Code")
        {
            Caption = 'Language Code';
        }
        modify("Home Page")
        {
            Caption = 'Home Page';
        }
        modify(IBAN)
        {
            Caption = 'IBAN';
        }
        modify("SWIFT Code")
        {
            Caption = 'SWIFT Code';
        }
        modify("Bank Clearing Code")
        {
            Caption = 'Bank Clearing Code';
        }
        modify("Bank Clearing Standard")
        {
            Caption = 'Bank Clearing Standard';
        }
        modify("CCC Bank No.")
        {
            Caption = 'CCC Bank No.';
        }
        modify("CCC Bank Branch No.")
        {
            Caption = 'CCC Bank Branch No.';
        }
        modify("CCC Control Digits")
        {
            Caption = 'CCC Control Digits';
        }
        modify("CCC Bank Account No.")
        {
            Caption = 'CCC Bank Account No.';
        }
        modify("CCC No.")
        {
            Caption = 'CCC No.';
        }
        modify("Use For Electronic Payments")
        {
            Caption = 'Use For Electronic Payments';
        }
    }
    keys
    {
        key(PK; "Bank Branch No.", "Bank Account No.")
        {
        }
    }


    //Unsupported feature: Property Modification (TextConstString) on "BankAccIdentifierIsEmptyErr(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //BankAccIdentifierIsEmptyErr : ENU=You must specify either a Bank Account No. or an IBAN.;ESP=Debe especificar un n.º de cuenta bancaria o un IBAN.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BankAccIdentifierIsEmptyErr : ENU=You must specify either a Bank Account No. or an IBAN.;
    //Variable type has not been exported.
}

