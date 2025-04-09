pageextension 50112 pageextension50112 extends "Vendor Ledger Entries"
{
    // SUP:ISSUE:#111525  09/09/2021 COSMO.ABT
    //    # Show two fields ""IBAN / Bank Account" and "URL".
    // SUP:ISSUE:#112374  14/10/2021 COSMO.ABT
    //    # Show new field "E-mail".
    // SUP:ISSUE:#117922  24/08/2022 COSMO.ABT
    //    # Show new field "Purchase Order No.".
    // 
    // PK 02-09-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Action added
    //   - Batch Application
    layout
    {
        addafter("External Document No.")
        {
            field(URL; Rec.URL)
            {
                ApplicationArea = All;
                ToolTip = 'URL';
                Caption = 'URL';
            }
        }
    }
    actions
    {
        addafter(ActionApplyEntries)
        {
            action("Batch Application")
            {
                Caption = 'Batch Application';
                Description = 'EY-MYES0004';
                Image = ApplyEntries;
                ApplicationArea = All;
                ToolTip = 'Executes the Batch Application action.';

                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                begin
                    // EY-MYES0004 >>
                    VendLedgEntry.SetRange("Vendor No.", Rec."Vendor No.");
                    REPORT.Run(REPORT::"Batch Appl. Vendor Entries", true, true, VendLedgEntry);
                    // EY-MYES0004 <<
                end;
            }
        }
    }
}

