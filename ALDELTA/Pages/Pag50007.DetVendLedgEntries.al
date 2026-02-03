page 50007 "Cust. Det. Vend Ledg Entries"
{
    ApplicationArea = All;
    Caption = 'Cust. Det. Vend Ledg Entries';
    PageType = List;
    SourceTable = "Detailed Vendor Ledg. Entry";
    SourceTableView = where("Entry Type" = const(Application));
    UsageCategory = Lists;
    Permissions = tabledata "Detailed Vendor Ledg. Entry" = rmid;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the posting date of the detailed vendor ledger entry.';
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the entry type of the detailed vendor ledger entry.';
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the document type of the detailed vendor ledger entry.';
                    Editable = false;
                }
                field("Excluded from calculation"; Rec."Excluded from calculation")
                {
                    ToolTip = 'Specifies what to exclude so that if you have to track the different actions performed with the documents in the portfolio, such as settle, reject, redraw, etc., this field is needed to ensure that the balance in the Pending Amount and Pending Amount LCY fields in the Cust. Ledger Entries window is correct.';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number of the transaction that created the entry.';
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the number of the vendor account to which the entry is posted.';
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the code for the currency if the amount is in a foreign currency.';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount of the detailed vendor ledger entry.';
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                    Editable = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                    Editable = false;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in LCY.';
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                    Editable = false;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent credits, expressed in LCY.';
                    Editable = false;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ToolTip = 'Specifies the date on which the initial entry is due for payment.';
                    Editable = false;
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    ToolTip = 'Specifies initial Document Type';
                    Editable = InitialDocEditable;
                }
                field("Applied by Batch Job"; Rec."Applied by Batch Job")
                {
                    ToolTip = 'Specifies the value of the Applied by Batch Job field.';
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                    Editable = false;
                }

                field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
                {
                    ToolTip = 'Specifies the value of the Applied Vend. Ledger Entry No. field.', Comment = '%';
                    Editable = false;
                }



            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();
    end;

    procedure SetControlAppearance()
    var
        DetailRec: Record "Detailed Vendor Ledg. Entry";
    begin
        if Rec."Document Type" = DetailRec."Document Type"::" " then
            InitialDocEditable := true
        else
            InitialDocEditable := false;
    end;

    var
        InitialDocEditable: Boolean;
}
