tableextension 50126 tableextension50126 extends "Gen. Journal Line"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // OPP  01.11.08   - New Fields added
    //                 - New Keys added
    //                   ID Applied-Entry
    //                   Pmt. Import Entry No.
    //                 - New Functions
    // -----------------------------------------------------
    // SUP:ISSUE:#111525  09/09/2021  COSMO.ABT
    //    # Added two new fields: 50000 "IBAN / Bank Account" Code[50].
    //                            50001 "URL" Text[250].
    // SUP:ISSUE:#112374  14/10/2021  COSMO.ABT
    //    # Added new field: 50002 "E-Mail" Text[80].
    // 
    // SUP:ISSUE:#117922  24/08/2022  COSMO.ABT
    //    # Added a new field: 50003 "Purchase Order No." Code[50].
    // 
    // SUP:Ticket:#121664  09/05/2023  COSMO.ABT
    //    # Added a new field: 50004 "Sales Order No." Code[50].
    // 
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Field added:
    //   - Applied by Batch Job
    fields
    {


        //Unsupported feature: Code Modification on ""Account No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Account No." <> xRec."Account No." then begin
          ClearAppliedAutomatically;
          ClearApplication("Account Type");
          Validate("Job No.",'');
        end;

        if xRec."Account Type" in ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] then
          "IC Partner Code" := '';

        if "Account No." = '' then begin
          CleanLine;
          exit;
        end;

        OnValidateAccountNoOnBeforeAssignValue(Rec,xRec);

        case "Account Type" of
          "Account Type"::"G/L Account":
            GetGLAccount;
          "Account Type"::Customer:
            GetCustomerAccount;
          "Account Type"::Vendor:
            GetVendorAccount;
          "Account Type"::Employee:
            GetEmployeeAccount;
          "Account Type"::"Bank Account":
            GetBankAccount;
          "Account Type"::"Fixed Asset":
            GetFAAccount;
          "Account Type"::"IC Partner":
            GetICPartnerAccount;
        end;

        OnValidateAccountNoOnAfterAssignValue(Rec,xRec);

        Validate("Currency Code");
        Validate("VAT Prod. Posting Group");
        UpdateLineBalance;
        UpdateSource;
        CreateDim(
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");

        Validate("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        ValidateApplyRequirements(Rec);

        case "Account Type" of
          "Account Type"::"G/L Account":
            UpdateAccountID;
          "Account Type"::Customer:
            UpdateCustomerID;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //IF "Account No." <> xRec."Account No." THEN BEGIN
        //  ClearAppliedAutomatically;
        //  ClearApplication("Account Type");
        //  VALIDATE("Job No.",'');
        //END;
        //
        //IF xRec."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] THEN
        //  "IC Partner Code" := '';
        //
        //IF "Account No." = '' THEN BEGIN
        //  CleanLine;
        //  EXIT;
        //END;
        //
        //OnValidateAccountNoOnBeforeAssignValue(Rec,xRec);
        //
        //CASE "Account Type" OF
        //  "Account Type"::"G/L Account":

        // MODIFIED
        //    BEGIN
        //      GLAcc.GET("Account No.");
        //      CheckGLAcc;
        //      IF ReplaceDescription AND (NOT GLAcc."Omit Default Descr. in Jnl.") THEN
        //        UpdateDescription(GLAcc.Name)
        //      ELSE
        //        IF GLAcc."Omit Default Descr. in Jnl." THEN
        //          Description := '';
        //      IF ("Bal. Account No." = '') OR
        //         ("Bal. Account Type" IN
        //          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //        "Payment Method Code" := '';
        //      END;
        //      IF "Bal. Account No." = '' THEN
        //        "Currency Code" := '';
        //      IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
        //         GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        //      THEN BEGIN
        //        "Gen. Posting Type" := GLAcc."Gen. Posting Type";
        //        "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        //        "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //        "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        //        "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      END;
        //      "Tax Area Code" := GLAcc."Tax Area Code";
        //      "Tax Liable" := GLAcc."Tax Liable";
        //      "Tax Group Code" := GLAcc."Tax Group Code";
        //      IF "Posting Date" <> 0D THEN
        //        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
        //          ClearPostingGroups;
        //      VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
        //      // gbedv EA -------------------------------------------------- BEGIN
        //      //OPPBasisEvents.OnAfterValidateGLAccountNo(Rec,GLAcc);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
           GetGLAccount;
        //{<<<<<<<}
        //  "Account Type"::Customer:
        // MODIFIED
        //    BEGIN
        //      Cust.GET("Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '' ) AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //      UpdateDescription(Cust.Name);
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      Cust.TESTFIELD("Payment Terms Code");
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Account No.");
        //      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearPostingGroups;
        //      IF "Document Type" = "Document Type"::"Credit Memo" THEN
        //        "Payment Method Code" := ''
        //      ELSE BEGIN
        //        Cust.TESTFIELD("Payment Method Code");
        //        "Payment Method Code" := Cust."Payment Method Code";
        //      END;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //      //OPPBasisEvents.OnAfterValidateCustAccountNo(Rec,Cust);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
           GetCustomerAccount;
        //{<<<<<<<}
         "Account Type"::Vendor:
        // MODIFIED
        //    BEGIN
        //      Vend.GET("Account No.");
        //      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        //      IF Vend."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
        //          "IC Partner Code" := Vend."IC Partner Code";
        //        END;
        //      END;
        //      UpdateDescription(Vend.Name);
        //      "Payment Method Code" := Vend."Payment Method Code";
        //      "Creditor No." := Vend."Creditor No.";
        //      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
        //      "Posting Group" := Vend."Vendor Posting Group";
        //      "Salespers./Purch. Code" := Vend."Purchaser Code";
        //      Vend.TESTFIELD("Payment Terms Code");
        //      "Payment Terms Code" := Vend."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Account No.");
        //      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //        "Currency Code" := Vend."Currency Code";
        //      ClearPostingGroups;
        //      IF "Document Type" = "Document Type"::"Credit Memo" THEN
        //        "Payment Method Code" := ''
        //      ELSE BEGIN
        //        Vend.TESTFIELD("Payment Method Code");
        //        "Payment Method Code" := Vend."Payment Method Code";
        //      END;
        //      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Account No.") AND
        //         NOT HideValidationDialog
        //      THEN
        //        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
        //             Vend."Pay-to Vendor No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //     // OPPBasisEvents.OnAfterValidateVendAccountNo(Rec,Vend);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
          GetVendorAccount;
        "Account Type"::Employee:
          GetEmployeeAccount;
        //{<<<<<<<}
         "Account Type"::"Bank Account":

        ;
        //{=======} MODIFIED
        //    BEGIN
        //      BankAcc.GET("Account No.");
        //      BankAcc.TESTFIELD(Blocked,FALSE);
        //      IF ReplaceDescription THEN
        //        UpdateDescription(BankAcc.Name);
        //      IF ("Bal. Account No." = '') OR
        //         ("Bal. Account Type" IN
        //          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF BankAcc."Currency Code" = '' THEN BEGIN
        //        IF "Bal. Account No." = '' THEN
        //          "Currency Code" := '';
        //      END ELSE
        //        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //          BankAcc.TESTFIELD("Currency Code","Currency Code")
        //        ELSE
        //          "Currency Code" := BankAcc."Currency Code";
        //      ClearPostingGroups;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //     // OPPBasisEvents.OnAfterValidateBankAccountNo(Rec,BankAcc);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
          GetBankAccount;
        //{<<<<<<<}
        "Account Type"::"Fixed Asset":
       GetFAAccount;
       "Account Type"::"IC Partner":
         GetICPartnerAccount;
        END;
        //
        OnValidateAccountNoOnAfterAssignValue(Rec,xRec);
        //
        VALIDATE("Currency Code");
        VALIDATE("VAT Prod. Posting Group");
        UpdateLineBalance;
        //UpdateSource;
        //CreateDim(
        //  DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //  DATABASE::Campaign,"Campaign No.");
        //
        //VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        //ValidateApplyRequirements(Rec);
        //
        //CASE "Account Type" OF
        //  "Account Type"::"G/L Account":
        //    UpdateAccountID;
        //  "Account Type"::Customer:
        //    UpdateCustomerID;
        //END;
        */
        //end;


        //Unsupported feature: Code Modification on ""Bal. Account No."(Field 11).OnValidate".

        //trigger  Account No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Bal. Account No." <> xRec."Bal. Account No." then begin
          ClearApplication("Bal. Account Type");
          Validate("Job No.",'');
        end;

        if xRec."Bal. Account Type" in ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
                                        "Bal. Account Type"::"IC Partner"]
        then
          "IC Partner Code" := '';

        if "Bal. Account No." = '' then begin
          UpdateLineBalance;
          UpdateSource;
          CreateDim(
            DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
            DimMgt.TypeToTableID1("Account Type"),"Account No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
            DATABASE::Campaign,"Campaign No.");
          if not ("Account Type" in ["Account Type"::Customer,"Account Type"::Vendor]) then
            "Recipient Bank Account" := '';
          if xRec."Bal. Account No." <> '' then begin
            ClearBalancePostingGroups;
            "Bal. Tax Area Code" := '';
            "Bal. Tax Liable" := false;
            "Bal. Tax Group Code" := '';
            ClearCurrencyCode;
          end;
          exit;
        end;

        OnValidateBalAccountNoOnBeforeAssignValue(Rec,xRec);

        case "Bal. Account Type" of
          "Bal. Account Type"::"G/L Account":
            GetGLBalAccount;
          "Bal. Account Type"::Customer:
            GetCustomerBalAccount;
          "Bal. Account Type"::Vendor:
            GetVendorBalAccount;
          "Bal. Account Type"::Employee:
            GetEmployeeBalAccount;
          "Bal. Account Type"::"Bank Account":
            GetBankBalAccount;
          "Bal. Account Type"::"Fixed Asset":
            GetFABalAccount;
          "Bal. Account Type"::"IC Partner":
            GetICPartnerBalAccount;
        end;

        OnValidateBalAccountNoOnAfterAssignValue(Rec,xRec);

        Validate("Currency Code");
        Validate("Bal. VAT Prod. Posting Group");
        UpdateLineBalance;
        UpdateSource;
        CreateDim(
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");

        Validate("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        ValidateApplyRequirements(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //IF "Bal. Account No." <> xRec."Bal. Account No." THEN BEGIN
        //  ClearApplication("Bal. Account Type");
        //  VALIDATE("Job No.",'');
        //END;
        //
        //IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
        //                                "Bal. Account Type"::"IC Partner"]
        //THEN
        //  "IC Partner Code" := '';
        //
        //IF "Bal. Account No." = '' THEN BEGIN
        //  UpdateLineBalance;
        //  UpdateSource;
        //  CreateDim(
        //    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //    DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //    DATABASE::Job,"Job No.",
        //    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //    DATABASE::Campaign,"Campaign No.");
        //  IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
        //    "Recipient Bank Account" := '';
        //  IF xRec."Bal. Account No." <> '' THEN BEGIN
        //    ClearBalancePostingGroups;
        //    "Bal. Tax Area Code" := '';
        //    "Bal. Tax Liable" := FALSE;
        //    "Bal. Tax Group Code" := '';
        //    ClearCurrencyCode;
        //  END;
        //  EXIT;
        //END;
        //
        //OnValidateBalAccountNoOnBeforeAssignValue(Rec,xRec);
        //
        //CASE "Bal. Account Type" OF
        //  "Bal. Account Type"::"G/L Account":



        //    BEGIN
        //      GLAcc.GET("Bal. Account No.");
        //      CheckGLAcc;
        //      IF "Account No." = '' THEN BEGIN
        //        Description := GLAcc.Name;
        //        "Currency Code" := '';
        //      END;
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
        //         GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        //      THEN BEGIN
        //        "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
        //        "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        //        "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //        "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        //        "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      END;
        //      "Bal. Tax Area Code" := GLAcc."Tax Area Code";
        //      "Bal. Tax Liable" := GLAcc."Tax Liable";
        //      "Bal. Tax Group Code" := GLAcc."Tax Group Code";
        //      IF "Posting Date" <> 0D THEN
        //        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
        //          ClearBalancePostingGroups;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //      //OPPBasisEvents.OnAfterValidateGLBalAccountNo(Rec,GLAcc);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
        //    GetGLBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::Customer:
        //{>>>>>>>} ORIGINAL
        // MODIFIED
        //    BEGIN
        //      Cust.GET("Bal. Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //
        //      IF "Account No." = '' THEN
        //        Description := Cust.Name;
        //
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //     // OPPBasisEvents.OnAfterValidateCustBalAccountNo(Rec,Cust);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
        //    GetCustomerBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::Vendor:
        //{>>>>>>>} ORIGINAL
        // MODIFIED
        //    BEGIN
        //      Vend.GET("Bal. Account No.");
        //      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        //      IF Vend."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Vend."IC Partner Code";
        //        END;
        //      END;
        //
        //      IF "Account No." = '' THEN
        //        Description := Vend.Name;
        //
        //      "Payment Method Code" := Vend."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
        //      "Posting Group" := Vend."Vendor Posting Group";
        //      "Salespers./Purch. Code" := Vend."Purchaser Code";
        //      "Payment Terms Code" := Vend."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Vend."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Vend."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
        //             Vend."Pay-to Vendor No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //     // OPPBasisEvents.OnAfterValidateVendBalAccountNo(Rec,Vend);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
        //    GetVendorBalAccount;
        //  "Bal. Account Type"::Employee:
        //    GetEmployeeBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::"Bank Account":
        //{>>>>>>>} ORIGINAL
        //MODIFIED
        //    BEGIN
        //      BankAcc.GET("Bal. Account No.");
        //      BankAcc.TESTFIELD(Blocked,FALSE);
        //      IF "Account No." = '' THEN
        //        Description := BankAcc.Name;
        //
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF BankAcc."Currency Code" = '' THEN BEGIN
        //        IF "Account No." = '' THEN
        //          "Currency Code" := '';
        //      END ELSE
        //        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //          BankAcc.TESTFIELD("Currency Code","Currency Code")
        //        ELSE
        //          "Currency Code" := BankAcc."Currency Code";
        //      ClearBalancePostingGroups;
        //      // gbedv EA -------------------------------------------------- BEGIN
        //      //OPPBasisEvents.OnAfterValidateBankBalAccountNo(Rec,BankAcc);
        //      // gbedv EA -------------------------------------------------- END
        //    END;
        //{=======} TARGET
           GetBankBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::"Fixed Asset":
        //    GetFABalAccount;
        //  "Bal. Account Type"::"IC Partner":
        //    GetICPartnerBalAccount;
        //END;
        //
        //OnValidateBalAccountNoOnAfterAssignValue(Rec,xRec);
        //
        //VALIDATE("Currency Code");
        //VALIDATE("Bal. VAT Prod. Posting Group");
        //UpdateLineBalance;
        //UpdateSource;
        //CreateDim(
        //  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //  DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //  DATABASE::Campaign,"Campaign No.");
        //
        //VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        //ValidateApplyRequirements(Rec);
        */
        //end;
        field(50000; "IBAN / Bank Account"; Code[50])
        {
            Caption = 'IBAN / Bank Account';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#111525';
            Editable = false;
        }
        field(50001; URL; Text[250])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#111525';
            ExtendedDatatype = URL;
        }
        field(50002; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#112374';
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(50003; "Purchase Order No."; Code[50])
        {
            Caption = 'Purchase Order No.';
            DataClassification = CustomerContent;
            Description = 'SUP:ISSUE:#117922';
        }
        field(50004; "Sales Order No."; Code[50])
        {
            DataClassification = CustomerContent;
            Description = 'SUP:Ticket:#121664';
        }
        field(60000; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            Description = 'MP 18-01-12';
            TableRelation = IF (BottomUp = CONST(false),
                                "Account No." = FILTER(<> '')) "Corporate G/L Account" WHERE("Local G/L Account No." = FIELD("Account No."))
            ELSE
            "Corporate G/L Account";
            DataClassification = CustomerContent;
        }
        field(60010; "Bal. Corporate G/L Account No."; Code[20])
        {
            Caption = 'Bal. Corporate G/L Account No.';
            Description = 'MP 18-01-12';
            TableRelation = IF (BottomUp = CONST(false),
                                "Bal. Account No." = FILTER(<> '')) "Corporate G/L Account" WHERE("Local G/L Account No." = FIELD("Bal. Account No."))
            ELSE
            "Corporate G/L Account";
            DataClassification = CustomerContent;
        }
        field(60020; "GAAP Adjustment Reason"; Option)
        {
            Caption = 'GAAP Adjustment Reason';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,Timing,GAAP,Reclassification,Tax';
            OptionMembers = " ",Timing,GAAP,Reclassification,Tax;
            DataClassification = CustomerContent;
        }
        field(60030; "Adjustment Role"; Option)
        {
            Caption = 'Adjustment Role';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,EY,Client,Auditor';
            OptionMembers = " ",EY,Client,Auditor;
            DataClassification = CustomerContent;
        }
        field(60040; "Tax Adjustment Reason"; Option)
        {
            Caption = 'Tax Adjustment Reason';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,P&L,Equity,,Non Temporary,Other P&L,Other Equity,Other Non Temporary';
            OptionMembers = " ","P&L",Equity,"<Obsolete>","Non Temporary","Other P&L","Other Equity","Other Non Temporary";
            DataClassification = CustomerContent;
        }
        field(60050; "Ready to Post"; Boolean)
        {
            Caption = 'Ready to Post';
            Description = 'MP 18-01-12';
            DataClassification = CustomerContent;
        }
        field(60060; "Equity Correction Code"; Code[10])
        {
            Caption = 'Equity Correction Code';
            Description = 'MP 18-01-12';
            TableRelation = "Equity Correction Code" WHERE("Shortcut Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"));
            DataClassification = CustomerContent;
        }
        field(60070; "Interface Type"; Option)
        {
            Caption = 'Interface Type';
            Description = 'MD 01-10-12';
            OptionCaption = ' ,AR Transactions,AP Transactions';
            OptionMembers = " ","AR Transactions","AP Transactions";
            DataClassification = CustomerContent;
        }
        field(60073; "A/R Trans Posting Scenario"; Option)
        {
            Caption = 'A/R Trans Posting Scenario';
            OptionCaption = 'Update G/L,Do Not Update G/L';
            OptionMembers = "Update G/L","Do Not Update G/L";
            DataClassification = CustomerContent;
        }
        field(60074; "A/P Trans Posting Scenario"; Option)
        {
            Caption = 'A/P Trans Posting Scenario';
            OptionCaption = 'Update G/L,Do Not Update G/L';
            OptionMembers = "Update G/L","Do Not Update G/L";
            DataClassification = CustomerContent;
        }
        field(60075; "Custom VAT Posting"; Boolean)
        {
            Caption = 'Custom VAT Posting';
            DataClassification = CustomerContent;
        }
        field(60080; "Description (English)"; Text[50])
        {
            Caption = 'Description (English)';
            Description = 'MP 18-01-12';
            DataClassification = CustomerContent;
        }
        field(60110; Reversible; Boolean)
        {
            Caption = 'Reversible';
            Description = 'MD 25-09-12';
            DataClassification = CustomerContent;
        }
        field(60120; "Entry No. to Reverse"; Integer)
        {
            Caption = 'Entry No. to Reverse';
            Description = 'MP 23-11-15';
            TableRelation = "G/L Entry";
            DataClassification = CustomerContent;
        }
        field(60200; "Corporate G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Corporate G/L Account No.")));
            Caption = 'Corporate G/L Account Name';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60210; "Bal. Corp. G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Bal. Corporate G/L Account No.")));
            Caption = 'Bal. Corporate G/L Account Name';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60300; BottomUp; Boolean)
        {
            CalcFormula = Exist("EY Core Setup" WHERE("Company Type" = CONST("Bottom-up")));
            Caption = 'Country Services';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60310; CorpAccInUse; Boolean)
        {
            CalcFormula = Exist("Corporate G/L Account");
            Caption = 'Corporate Accounts In Use';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60320; UseReadyToPost; Boolean)
        {
            CalcFormula = Lookup("Gen. Journal Template"."Use Ready to Post" WHERE(Name = FIELD("Journal Template Name")));
            Caption = 'Use Ready to Post';
            Description = 'MP 12-May-16';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80100; "Applied by Batch Job"; Boolean)
        {
            Caption = 'Applied by Batch Job';
            DataClassification = CustomerContent;
            Description = 'EY-MYES0004';
        }
        field(99090; "Client Entry No."; BigInteger)
        {
            Caption = 'Client Entry No.';
            DataClassification = CustomerContent;
        }
    }
    // keys
    // {
    //     key(PK; "Journal Template Name", "Journal Batch Name", "Account Type", "Account No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Business Unit Code", "GAAP Adjustment Reason", "Posting Date")
    //     {
    //         MaintainSIFTIndex = false;
    //         SumIndexFields = "Amount (LCY)";
    //     }
    //     key(Key2; "Journal Template Name", "Journal Batch Name", "Bal. Account Type", "Bal. Account No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Business Unit Code", "GAAP Adjustment Reason", "Posting Date")
    //     {
    //         MaintainSIFTIndex = false;
    //         SumIndexFields = "Amount (LCY)";
    //     }
    //     key(Key3; "Journal Template Name", "Journal Batch Name", "Corporate G/L Account No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Business Unit Code", "GAAP Adjustment Reason", "Posting Date")
    //     {
    //         MaintainSIFTIndex = false;
    //         SumIndexFields = "Amount (LCY)";
    //     }
    //     key(Key4; "Journal Template Name", "Journal Batch Name", "Bal. Corporate G/L Account No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Business Unit Code", "GAAP Adjustment Reason", "Posting Date")
    //     {
    //         MaintainSIFTIndex = false;
    //         SumIndexFields = "Amount (LCY)";
    //     }
    //     key(Key5; "Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.", "Bal. Account No.", "GAAP Adjustment Reason", "Adjustment Role", "Tax Adjustment Reason", "Equity Correction Code")
    //     {
    //         MaintainSIFTIndex = false;
    //         MaintainSQLIndex = false;
    //         SumIndexFields = "Amount (LCY)";
    //     }
    //     key(Key6; "Journal Template Name", "Journal Batch Name", "Document No.")
    //     {
    //     }



    //Unsupported feature: Code Modification on "SetUpNewLine(PROCEDURE 9)".

    //procedure SetUpNewLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GenJnlTemplate.Get("Journal Template Name");
    GenJnlBatch.Get("Journal Template Name","Journal Batch Name");
    GenJnlLine.SetRange("Journal Template Name","Journal Template Name");
    #4..43
      "Account Type" := "Account Type"::"G/L Account";
    Validate("Bal. Account No.",GenJnlBatch."Bal. Account No.");
    Description := '';
    if GenJnlBatch."Suggest Balancing Amount" then
      SuggestBalancingAmount(LastGenJnlLine,BottomLine);

    UpdateJournalBatchID;

    OnAfterSetupNewLine(Rec,GenJnlTemplate,GenJnlBatch,LastGenJnlLine,Balance,BottomLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..46
    //{>>>>>>>} ORIGINAL
    // {=======} MODIFIED
    // gpubOnSetUpNewLine(LastGenJnlLine,Balance,BottomLine); // MP 29-04-16
    // gbedv EA -------------------------------------------------- BEGIN
    //OPPBasisEvents.OnAfterSetupNewLine(Rec,GenJnlTemplate,GenJnlBatch,LastGenJnlLine,Balance,BottomLine);
    // gbedv EA -------------------------------------------------- END
    //{=======} TARGET
    #47..52
    // {<<<<<<<}
    */
    //end;

    [IntegrationEvent(TRUE, TRUE)]
    procedure gpubOnSetUpNewLine(LastGenJnlLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    begin
    end;
}

