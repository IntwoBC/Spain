table 70003 "MyTaxi CRM Interface Records"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Table Creation
    // #MyTaxi.W1.CRE.INT01.009 02/01/2018 CCFR.SDE : New request
    //   New added fields : accountHolder,iban,bic,directDebitAllowed,bankAccountNumber,sortCode,statusCode
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New request
    //   New added fields : businessAccountPaymentMethod,NAV Document Date
    // #MyTaxi.W1.CRE.INT01.015 26/12/2018 CCFR.SDE : New request
    //   New added fields : NAV Invoice Posted,NAV Credit Memo Posted,NAV Payment Posted
    // #MyTaxi.W1.CRE.INT01.017 25/03/2019 CCFR.SDE : New request
    //   New added field : headquarterID

    Caption = 'MyTaxi CRM Interface Records';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(6; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            OptionCaption = ' ,Customer,Invoice,Credit Memo';
            OptionMembers = " ",Customer,Invoice,"Credit Memo";
        }
        field(7; company; Text[30])
        {
        }
        field(8; id; Integer)
        {
        }
        field(9; number; Integer)
        {
        }
        field(10; name; Text[250])
        {
        }
        field(11; orgNo; Text[50])
        {
        }
        field(12; address1; Text[250])
        {
        }
        field(13; city; Text[250])
        {
        }
        field(14; zip; Text[50])
        {
        }
        field(15; country; Text[10])
        {
        }
        field(16; tele1; Text[250])
        {
        }
        field(17; email; Text[250])
        {
        }
        field(18; contact; Text[250])
        {
        }
        field(19; vatNo; Text[20])
        {
        }
        field(20; customerGroup; Text[40])
        {
        }
        field(21; address2; Text[250])
        {
        }
        field(22; address3; Text[50])
        {
        }
        field(23; contact2; Text[250])
        {
        }
        field(24; contact3; Text[250])
        {
        }
        field(25; accountHolder; Text[250])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
            NotBlank = true;
        }
        field(26; iban; Text[30])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(27; bic; Text[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(28; directDebitAllowed; Text[5])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(29; bankAccountNumber; Text[34])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(30; sortCode; Text[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(31; "NAV Bank Account Code"; Code[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.009';
        }
        field(32; headquarterID; Code[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.017';
        }
        field(101; statusCode; Text[10])
        {
        }
        field(102; dateStatusChanged; DateTime)
        {
        }
        field(103; additionalInformation; Text[250])
        {
        }
        field(104; invoiceid; Integer)
        {
        }
        field(105; externalReference; Text[30])
        {
        }
        field(106; invoiceType; Text[30])
        {
        }
        field(107; idCustomer; Integer)
        {
        }
        field(108; dateInvoice; Date)
        {
        }
        field(109; dueDate; Date)
        {
        }
        field(110; countryCode; Text[10])
        {
        }
        field(111; currency; Text[10])
        {
        }
        field(112; sumNetValue; Decimal)
        {
        }
        field(113; sumTaxValue; Decimal)
        {
        }
        field(114; sumGrossValue; Decimal)
        {
        }
        field(115; discountCommissionNet; Decimal)
        {
        }
        field(116; discountCommissionTax; Decimal)
        {
        }
        field(117; discountCommissionGross; Decimal)
        {
        }
        field(118; netCommission; Decimal)
        {
        }
        field(119; taxCommission; Decimal)
        {
        }
        field(120; grossCommission; Decimal)
        {
        }
        field(121; netHotelValue; Decimal)
        {
        }
        field(122; taxHotelValue; Decimal)
        {
        }
        field(123; grossHotelValue; Decimal)
        {
        }
        field(124; netInvoicingFee; Decimal)
        {
        }
        field(125; taxInvoicingFee; Decimal)
        {
        }
        field(126; grossInvoicingFee; Decimal)
        {
        }
        field(127; netPayment; Decimal)
        {
        }
        field(128; netPaymentFeeMP; Decimal)
        {
        }
        field(129; taxPaymentFeeMP; Decimal)
        {
        }
        field(130; grossPaymentFeeMP; Decimal)
        {
        }
        field(131; netPaymentFeeBA; Decimal)
        {
        }
        field(132; taxPaymentFeeBA; Decimal)
        {
        }
        field(133; grossPaymentFeeBA; Decimal)
        {
        }
        field(134; businessAccountPaymentMethod; Text[50])
        {
            Description = 'MyTaxi.W1.CRE.INT01.013';
        }
        field(150; "NAV Document Date"; Date)
        {
            Description = 'MyTaxi.W1.CRE.INT01.013';
        }
        field(151; "NAV Invoice Status"; Option)
        {
            Description = 'MyTaxi.W1.CRE.INT01.015';
            OptionMembers = " ",Imported,Created,Posted;
        }
        field(152; "NAV Credit Memo Status"; Option)
        {
            Description = 'MyTaxi.W1.CRE.INT01.015';
            OptionMembers = " ",Imported,Created,Posted;
        }
        field(153; "NAV Payment Status"; Option)
        {
            Description = 'MyTaxi.W1.CRE.INT01.015';
            OptionMembers = " ",Imported,Created,Posted;
        }
        field(154; "NAV Document No."; Code[20])
        {
        }
        field(1000; additionalNotes; Integer)
        {
            CalcFormula = Count("MyTaxi CRM Interf Sub Records" WHERE("Records Entry No." = FIELD("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(100000; "Transfer Date"; Date)
        {
            Caption = 'Transfer Date';
        }
        field(100001; "Transfer Time"; Time)
        {
            Caption = 'Transfer Time';
        }
        field(100100; "Process Status"; Option)
        {
            Caption = 'Process Status';
            OptionMembers = " ",Error,Warning,Information;
        }
        field(100101; "Process Status Description"; Text[250])
        {
            Caption = 'Process Status Description';
        }
        field(100102; "Send Update"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Interface Type", "Process Status", "Transfer Date", "Transfer Time")
        {
        }
        key(Key3; invoiceid)
        {
        }
        key(Key4; externalReference)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        MyTaxiCRMInterfSubRecords.Reset();
        MyTaxiCRMInterfSubRecords.SetRange("Records Entry No.", "Entry No.");
        MyTaxiCRMInterfSubRecords.DeleteAll();
    end;

    var
        MyTaxiCRMInterfSubRecords: Record "MyTaxi CRM Interf Sub Records";
}

