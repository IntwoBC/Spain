tableextension 50103 tableextension50103 extends "Data Exch."
{
    // #MyTaxi.W1.ISS.BANKR.001 11/10/2018 CCFR.SDE : MS Bug fixing - Cannot import the bank statement file using the new objects for OCR included in build 49424
    //     Modified function : ImportFileContent


    //Unsupported feature: Code Modification on "ImportFileContent(PROCEDURE 5)".

    //procedure ImportFileContent();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RelatedRecord := "Related Record";
    DataExchLineDef.SetRange("Data Exch. Def Code",DataExchDef.Code);
    if DataExchLineDef.FindFirst then;

    Init;
    "Data Exch. Def Code" := DataExchDef.Code;
    "Data Exch. Line Def Code" := DataExchLineDef.Code;
    "Related Record" := RelatedRecord;

    DataExchDef.TestField("Ext. Data Handling Codeunit");
    CODEUNIT.Run(DataExchDef."Ext. Data Handling Codeunit",Rec);

    if not "File Content".HasValue then
      exit(false);

    Insert;
    exit(true);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //{>>>>>>>} ORIGINAL
    //{=======} MODIFIED
    // MyTaxi.W1.ISS.BANKR.001 <<
    //{
    // {=======} TARGET
    RelatedRecord := "Related Record";
    // {<<<<<<<}
    #2..7


    // {=======} MODIFIED
    //}
    // MyTaxi.W1.ISS.BANKR.001 >>
    //{=======} TARGET
    "Related Record" := RelatedRecord;

    //  {<<<<<<<}
    #10..14
    // MyTaxi.W1.ISS.BANKR.001 <<
    DataExchLineDef.SetRange("Data Exch. Def Code",DataExchDef.Code);
    DataExchLineDef.FindFirst;
    "Data Exch. Def Code" := DataExchDef.Code;
    "Data Exch. Line Def Code" := DataExchLineDef.Code;
    // MyTaxi.W1.ISS.BANKR.001 >>
    Insert;
    exit(true);
    */
    //end;
}

