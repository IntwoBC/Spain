page 70019 "Bank Acc. Recon. Lines M List"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Page creation

    Caption = 'Bank Account Reconciliation Match';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Acc. Reconciliation Line";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Matched; Rec.Matched)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Matched field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("New Bal. Account Type"; Rec."New Bal. Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Bal. Account Type field.';
                }
                field("New Bal. Account No."; Rec."New Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Bal. Account No. field.';
                }
                field(Applied; Rec.Applied)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applyment Status field.';
                }
                field("Applyment Confidence"; Rec."Applyment Confidence")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applyment Confidence field.';
                }
                field("Bank Acc. Ledg. Entry No."; Rec."Bank Acc. Ledg. Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account Ledger Entry No. field.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statement No. field.';
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statement Line No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Statement Amount"; Rec."Statement Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statement Amount field.';
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Difference field.';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applied Amount field.';
                }
                // field(Type; Rec.Type)
                // {ApplicationArea=all;
                // }
                field("Applied Entries"; Rec."Applied Entries")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applied Entries field.';
                }
                field("Value Date"; Rec."Value Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Value Date field.';
                }
                field("Ready for Application"; Rec."Ready for Application")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ready for Application field.';
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Check No. field.';
                }
                field("Related-Party Name"; Rec."Related-Party Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Related-Party Name field.';
                }
                field("Additional Transaction Info"; Rec."Additional Transaction Info")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Additional Transaction Info field.';
                }
                field("Data Exch. Entry No."; Rec."Data Exch. Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Data Exch. Entry No. field.';
                }
                field("Data Exch. Line No."; Rec."Data Exch. Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Data Exch. Line No. field.';
                }
                field("Statement Type"; Rec."Statement Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statement Type field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Transaction Text"; Rec."Transaction Text")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Text field.';
                }
                field("Related-Party Bank Acc. No."; Rec."Related-Party Bank Acc. No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Related-Party Bank Acc. No. field.';
                }
                field("Related-Party Address"; Rec."Related-Party Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Related-Party Address field.';
                }
                field("Related-Party City"; Rec."Related-Party City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Related-Party City field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Sorting Order"; Rec."Sorting Order")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sorting Order field.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowStatementLineDetails)
            {
                Caption = 'Details';
                RunObject = Page "Bank Statement Line Details";
                RunPageLink = "Data Exch. No." = FIELD("Data Exch. Entry No."),
                              "Line No." = FIELD("Data Exch. Line No.");
                ApplicationArea = all;
                ToolTip = 'Executes the Details action.';
            }
        }
    }


    procedure ToggleMatchedFilter(SetFilterOn: Boolean)
    begin
        if SetFilterOn then
            Rec.SetRange(Matched, true)
        else
            Rec.Reset();
        CurrPage.Update();
    end;


    procedure ToggleUnMatchedFilter(SetFilterOn: Boolean)
    begin
        if SetFilterOn then
            Rec.SetRange(Matched, false)
        else
            Rec.Reset();
        CurrPage.Update();
    end;
}

