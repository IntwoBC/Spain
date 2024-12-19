tableextension 50123 tableextension50123 extends Contact
{

    //Unsupported feature: Code Modification on "ShowCustVendBank(PROCEDURE 12)".

    //procedure ShowCustVendBank();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FormSelected := true;

    ContBusRel.Reset;
    #4..33
        ContBusRel."Link to Table"::"Bank Account":
          begin
            BankAcc.Get(ContBusRel."No.");
            BankAcc.SetRange("Date Filter",0D,WorkDate);
            PAGE.Run(PAGE::"Bank Account Card",BankAcc);
          end;
      end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..36
    // MODIFIED
           // PAGE.RUN(PAGE::Page370,BankAcc);
    //{=======} TARGET
            BankAcc.SetRange("Date Filter",0D,WorkDate);
            PAGE.Run(PAGE::"Bank Account Card",BankAcc);
    //{<<<<<<<}
          end;
      end;
    */
    //end;
}

