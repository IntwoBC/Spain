tableextension 50110 tableextension50110 extends "Bank Account"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // PMT  01.11.08   OPplus Payment
    //                 - Lookup Bank Branch No.
    //                 - New Fields added
    // -----------------------------------------------------
    Caption = 'Bank Account';
    fields
    {
        modify("No.")
        {
            Caption = 'No.';
        }
        modify(Name)
        {
            Caption = 'Name';
        }
        modify("Search Name")
        {
            Caption = 'Search Name';
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
        modify("Bank Account No.")
        {
            Caption = 'Bank Account No.';
        }
        modify("Transit No.")
        {
            Caption = 'Transit No.';
        }
        modify("Territory Code")
        {
            Caption = 'Territory Code';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Chain Name")
        {
            Caption = 'Chain Name';
        }
        modify("Min. Balance")
        {
            Caption = 'Min. Balance';
        }
        modify("Currency Code")
        {
            Caption = 'Currency Code';
        }
        modify("Language Code")
        {
            Caption = 'Language Code';
        }
        modify("Statistics Group")
        {
            Caption = 'Statistics Group';
        }
        modify("Our Contact Code")
        {
            Caption = 'Our Contact Code';
        }
        modify("Country/Region Code")
        {
            Caption = 'Country/Region Code';
        }
        modify(Amount)
        {
            Caption = 'Amount';
        }
        modify(Comment)
        {
            Caption = 'Comment';
        }
        modify(Blocked)
        {
            Caption = 'Blocked';
        }
        modify("Last Statement No.")
        {
            Caption = 'Last Statement No.';
        }
        modify("Last Payment Statement No.")
        {
            Caption = 'Last Payment Statement No.';
        }
        modify("Last Date Modified")
        {
            Caption = 'Last Date Modified';
        }
        modify("Date Filter")
        {
            Caption = 'Date Filter';
        }
        modify("Global Dimension 1 Filter")
        {
            Caption = 'Global Dimension 1 Filter';
        }
        modify("Global Dimension 2 Filter")
        {
            Caption = 'Global Dimension 2 Filter';
        }
        modify(Balance)
        {
            Caption = 'Balance';
        }
        modify("Balance (LCY)")
        {
            Caption = 'Balance (LCY)';
        }
        modify("Net Change")
        {
            Caption = 'Net Change';
        }
        modify("Net Change (LCY)")
        {
            Caption = 'Net Change (LCY)';
        }
        modify("Total on Checks")
        {
            Caption = 'Total on Checks';
        }
        modify("Fax No.")
        {
            Caption = 'Fax No.';
        }
        modify("Telex Answer Back")
        {
            Caption = 'Telex Answer Back';
        }
        modify(County)
        {
            Caption = 'County';
        }
        modify("Last Check No.")
        {
            Caption = 'Last Check No.';
        }
        modify("Balance Last Statement")
        {
            Caption = 'Balance Last Statement';
        }
        modify("Balance at Date")
        {
            Caption = 'Balance at Date';
        }
        modify("Balance at Date (LCY)")
        {
            Caption = 'Balance at Date (LCY)';
        }
        modify("Debit Amount")
        {
            Caption = 'Debit Amount';
        }
        modify("Credit Amount")
        {
            Caption = 'Credit Amount';
        }
        modify("Debit Amount (LCY)")
        {
            Caption = 'Debit Amount (LCY)';
        }
        modify("Credit Amount (LCY)")
        {
            Caption = 'Credit Amount (LCY)';
        }
        modify("Bank Branch No.")
        {
            Caption = 'Bank Branch No.';
        }
        modify("Home Page")
        {
            Caption = 'Home Page';
        }
        modify("No. Series")
        {
            Caption = 'No. Series';
        }
        modify("Check Report ID")
        {
            Caption = 'Check Report ID';
        }
        modify("Check Report Name")
        {
            Caption = 'Check Report Name';
        }
        modify(IBAN)
        {
            Caption = 'IBAN';
        }
        modify("SWIFT Code")
        {
            Caption = 'SWIFT Code';
        }
        modify("Bank Statement Import Format")
        {
            Caption = 'Bank Statement Import Format';
        }
        modify("Credit Transfer Msg. Nos.")
        {
            Caption = 'Credit Transfer Msg. Nos.';
        }
        modify("Direct Debit Msg. Nos.")
        {
            Caption = 'Direct Debit Msg. Nos.';
        }
        modify("SEPA Direct Debit Exp. Format")
        {
            Caption = 'SEPA Direct Debit Exp. Format';
        }
        modify("Creditor No.")
        {
            Caption = 'Creditor No.';
        }
        modify("Payment Export Format")
        {
            Caption = 'Payment Export Format';
        }
        modify("Bank Clearing Code")
        {
            Caption = 'Bank Clearing Code';
        }
        modify("Bank Clearing Standard")
        {
            Caption = 'Bank Clearing Standard';
        }
        // modify("Bank Name - Data Conversion")
        // {
        //     Caption = 'Bank Name - Data Conversion';
        // }
        modify("Match Tolerance Type")
        {
            Caption = 'Match Tolerance Type';
            OptionCaption = 'Percentage,Amount';
        }
        modify("Match Tolerance Value")
        {
            Caption = 'Match Tolerance Value';
        }
        modify("Positive Pay Export Code")
        {
            Caption = 'Positive Pay Export Code';
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
        modify("E-Pay Export File Path")
        {
            Caption = 'E-Pay Export File Path';
        }
        modify("Last E-Pay Export File Name")
        {
            Caption = 'Last E-Pay Export File Name';
        }
        modify("Last Remittance Advice No.")
        {
            Caption = 'Last Remittance Advice No.';
        }
        modify("Las E-Pay File Creation No.")
        {
            Caption = 'Las E-Pay File Creation No.';
        }
        modify("Delay for Notices")
        {
            Caption = 'Delay for Notices';
        }
        modify("Credit Limit for Discount")
        {
            Caption = 'Credit Limit for Discount';
        }
        modify("Last Bill Gr. No.")
        {
            Caption = 'Last Bill Gr. No.';
        }
        modify("Date of Last Post. Bill Gr.")
        {
            Caption = 'Date of Last Post. Bill Gr.';
        }
        modify("Operation Fees Code")
        {
            Caption = 'Operation Fees Code';
        }
        modify("Posted Receiv. Bills Rmg. Amt.")
        {
            Caption = 'Posted Receiv. Bills Rmg. Amt.';
        }
        modify("Posted Receiv. Bills Amt.")
        {
            Caption = 'Posted Receiv. Bills Amt.';
        }
        modify("Closed Receiv. Bills Amt.")
        {
            Caption = 'Closed Receiv. Bills Amt.';
        }
        modify("Dealing Type Filter")
        {
            Caption = 'Dealing Type Filter';
            OptionCaption = 'Collection,Discount';
        }
        modify("Status Filter")
        {
            Caption = 'Status Filter';
            OptionCaption = 'Open,Honored,Rejected';
        }
        modify("Category Filter")
        {
            Caption = 'Category Filter';
        }
        modify("Due Date Filter")
        {
            Caption = 'Due Date Filter';
        }
        modify("Honored/Rejtd. at Date Filter")
        {
            Caption = 'Honored/Rejtd. at Date Filter';
        }
        modify("Posted R.Bills Rmg. Amt. (LCY)")
        {
            Caption = 'Posted R.Bills Rmg. Amt. (LCY)';
        }
        modify("Posted Receiv Bills Amt. (LCY)")
        {
            Caption = 'Posted Receiv Bills Amt. (LCY)';
        }
        modify("Closed Receiv Bills Amt. (LCY)")
        {
            Caption = 'Closed Receiv Bills Amt. (LCY)';
        }
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No.';
        }
        modify("Customer Ratings Code")
        {
            Caption = 'Customer Ratings Code';
        }
        modify("Posted Pay. Bills Rmg. Amt.")
        {
            Caption = 'Posted Pay. Bills Rmg. Amt.';
        }
        modify("Posted Pay. Bills Amt.")
        {
            Caption = 'Posted Pay. Bills Amt.';
        }
        modify("Closed Pay. Bills Amt.")
        {
            Caption = 'Closed Pay. Bills Amt.';
        }
        modify("Posted P.Bills Rmg. Amt. (LCY)")
        {
            Caption = 'Posted P.Bills Rmg. Amt. (LCY)';
        }
        modify("Posted Pay. Bills Amt. (LCY)")
        {
            Caption = 'Posted Pay. Bills Amt. (LCY)';
        }
        modify("Closed Pay. Bills Amt. (LCY)")
        {
            Caption = 'Closed Pay. Bills Amt. (LCY)';
        }
        modify("Post. Receivable Inv. Amt.")
        {
            Caption = 'Post. Receivable Inv. Amt.';
        }
        modify("Clos. Receivable Inv. Amt.")
        {
            Caption = 'Clos. Receivable Inv. Amt.';
        }
        modify("Posted Pay. Invoices Amt.")
        {
            Caption = 'Posted Pay. Invoices Amt.';
        }
        modify("Closed Pay. Invoices Amt.")
        {
            Caption = 'Closed Pay. Invoices Amt.';
        }
        modify("Posted Pay. Inv. Rmg. Amt.")
        {
            Caption = 'Posted Pay. Inv. Rmg. Amt.';
        }
        modify("Posted Pay. Documents Amt.")
        {
            Caption = 'Posted Pay. Documents Amt.';
        }
        modify("Closed Pay. Documents Amt.")
        {
            Caption = 'Closed Pay. Documents Amt.';
        }
    }


    //Unsupported feature: Property Modification (TextConstString) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : ENU=You cannot change %1 because there are one or more open ledger entries for this bank account.;ESP=No se puede cambiar el banco %1 porque tiene movimientos pendientes.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : ENU=You cannot change %1 because there are one or more open ledger entries for this bank account.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text003(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text003 : ENU=Do you wish to create a contact for %1 %2?;ESP=¿Confirma que desea crear un contacto para %1 %2?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text003 : ENU=Do you wish to create a contact for %1 %2?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text004(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text004 : ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.;ESP=Para poder usar Online Map, primero debe rellenar la ventana Configuración Online Map.\Consulte Configuración de Online Map en la Ayuda.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text004 : ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text1100000(Variable 1100007)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text1100000 : ENU=You cannot change %1 because there are one or more posted bill groups for this bank account.;ESP=No se puede cambiar el banco %1 porque tiene remesas registradas.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text1100000 : ENU=You cannot change %1 because there are one or more posted bill groups for this bank account.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text1100001(Variable 1100008)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text1100001 : ENU=You cannot change %1 because there are one or more posted payment orders for this bank account.;ESP=No se puede cambiar el banco %1 porque tiene órdenes pago registradas.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text1100001 : ENU=You cannot change %1 because there are one or more posted payment orders for this bank account.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "BankAccIdentifierIsEmptyErr(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //BankAccIdentifierIsEmptyErr : ENU=You must specify either a %1 or an %2.;ESP=Debe especificar %1 o %2.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BankAccIdentifierIsEmptyErr : ENU=You must specify either a %1 or an %2.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "InvalidPercentageValueErr(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvalidPercentageValueErr : @@@=%1 is "field caption and %2 is "Percentage";ENU=If %1 is %2, then the value must be between 0 and 99.;ESP=Si %1 es %2, entonces el valor debe ser entre 0 y 99.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvalidPercentageValueErr : @@@=%1 is "field caption and %2 is "Percentage";ENU=If %1 is %2, then the value must be between 0 and 99.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "InvalidValueErr(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvalidValueErr : ENU=The value must be positive.;ESP=El valor debe ser positivo.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvalidValueErr : ENU=The value must be positive.;
    //Variable type has not been exported.
}

