codeunit 50002 "Auto. Suggest Worksheet Lines"
{
    // #107661.001  19/04/21  COSMO.AMH : New Object


    trigger OnRun()
    begin
        //>> 107661.001
        CashFlowSetup.Get();
        CashFlowSetup.TestField("Cash Flow Forecast");
        if CashFlowSetup."G/L Budget" then
            CashFlowSetup.TestField("G/L Budget Name");


        SuggestWorksheetLines.UseRequestPage(false);
        //SuggestWorksheetLines.SetHideMessage(TRUE);
        // SuggestWorksheetLines.SetWorksheetSetup(CashFlowSetup."Cash Flow Forecast",CashFlowSetup."Liquid Funds",CashFlowSetup.Receivables,
        //                                        CashFlowSetup."Sales Orders",CashFlowSetup."Service Orders",CashFlowSetup."Fixed Assets Disposal",
        //                                        CashFlowSetup."Cash Flow Manual Revenues",CashFlowSetup.Payables,CashFlowSetup."Purchase Orders",
        //                                        CashFlowSetup."Fixed Assets Budget",CashFlowSetup."Cash Flow Manual Expenses",CashFlowSetup."G/L Budget",
        //                                        CashFlowSetup."G/L Budget Name",CashFlowSetup."Group By Document Type");

        SuggestWorksheetLines.Run();

        //Register
        Clear(CashFlowWorksheetRegister);
        CashFlowWorksheetLine.Reset();
        // CashFlowWorksheetRegister.SetHideMessage(true);
        CashFlowWorksheetRegister.Run(CashFlowWorksheetLine);
        //<< 107661.001
    end;

    var
        CashFlowSetup: Record "Cash Flow Setup";
        SuggestWorksheetLines: Report "Suggest Worksheet Lines";
        CashFlowWorksheetLine: Record "Cash Flow Worksheet Line";
        CashFlowWorksheetRegister: Codeunit "Cash Flow Wksh. - Register";
}

