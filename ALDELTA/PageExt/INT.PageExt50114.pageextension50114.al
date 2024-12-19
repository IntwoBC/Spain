pageextension 50114 pageextension50114 extends "Bank Acc. Reconciliation"
{
    actions
    {
        modify("Transfer to General Journal")
        {
            Visible = false;
        }
        addafter("Transfer to General Journal")
        {
            action("Transfer to Payment Journal")
            {
                Caption = 'Transfer to Payment Journal';
                Ellipsis = true;
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Transfer to Payment Journal action.';

                trigger OnAction()
                var
                    TransBankRectoGenMyTaxi: Report "Trans. Bank Rec. to Gen. MyTax";
                begin
                    // >> MyTaxi.W1.EDD.AR01.002
                    // TransBankRectoGenMyTaxi.SetBankAccRecon(Rec);
                    TransBankRectoGenMyTaxi.Run();
                    // << MyTaxi.W1.EDD.AR01.002
                end;
            }
        }
    }
}

