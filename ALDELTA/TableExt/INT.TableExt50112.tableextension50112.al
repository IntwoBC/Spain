tableextension 50112 tableextension50112 extends "Bank Acc. Reconciliation"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   New added key : "Statement Date"
    keys
    {
        key(PK; "Statement Date")
        {
        }
    }
}

