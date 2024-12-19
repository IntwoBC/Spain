page 70018 "Bank State. Line Details Match"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Page creation

    Caption = 'Bank Statement Line Details Match';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Data Exch. Field";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.GetFieldName())
                {
                    Caption = 'Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Value field.';
                }
            }
        }
    }

    actions
    {
    }


    procedure SetGenJnlLine(pGenJournalLine: Record "Gen. Journal Line")
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconciliationLine.Reset();
        BankAccReconciliationLine.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
        BankAccReconciliationLine.SetRange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
        BankAccReconciliationLine.SetRange("Line No.", pGenJournalLine."Line No.");
        if BankAccReconciliationLine.FindFirst() then begin
            Rec.SetRange("Data Exch. No.", BankAccReconciliationLine."Data Exch. Entry No.");
            Rec.SetRange("Line No.", BankAccReconciliationLine."Data Exch. Line No.");
            if not Rec.FindFirst() then
                Rec.Init();
        end;
        CurrPage.Update(false);
    end;
}

