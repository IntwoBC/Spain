page 60038 "G/L Entries (incl. Un-posted)"
{
    // MP 11-11-14
    // Upgrade to NAV 2013 R2

    Caption = 'General Ledger Entries';
    DataCaptionExpression = GetCaption();
    Editable = false;
    PageType = List;
    SourceTable = "G/L Entry";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the entry''s posting date.';

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document type that the entry belongs to.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the entry''s Document No.';

                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';

                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    DrillDown = false;
                    ApplicationArea = all;

                    Visible = false;
                    ToolTip = 'Specifies the name of the account that the entry has been posted to.';
                }
                field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field("GAAP Adjustment Reason"; Rec."GAAP Adjustment Reason")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GAAP Adjustment Reason field.';

                }
                field("Adjustment Role"; Rec."Adjustment Role")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Adjustment Role field.';

                }
                field("Tax Adjustment Reason"; Rec."Tax Adjustment Reason")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Adjustment Reason field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the entry.';

                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the related project.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';

                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';

                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of transaction.';

                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate ledger account according to the general posting setup.';

                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate ledger account according to the general posting setup.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Amount of the entry.';

                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the general ledger entry that is posted if you post in an additional reporting currency.';

                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the amount of VAT that is included in the total amount.';

                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';

                }

                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';

                }
                field("Bal. Corporate G/L Account No."; Rec."Bal. Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bal. Corporate G/L Account No. field.';

                }
                field("User ID"; Rec."User ID")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';

                }
                field("Source Code"; Rec."Source Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';

                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';

                }
                field(Reversed; Rec.Reversed)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction (correction) made by the Reverse function.';


                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the correcting entry. If the field Specifies a number, the entry cannot be reversed again.';

                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';

                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the fixed asset entry.';

                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the fixed asset entry.';

                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';

                }
            }
            part(UnpostedEntries; "G/L Entries Subform")
            {
                Caption = 'Un-posted Entries';
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = all;

            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';


                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action("G/L Dimension Overview")
                {
                    Caption = 'G/L Dimension Overview';
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Dimension Overview action.';


                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"G/L Entries Dimension Overview", Rec);
                    end;
                }
                action("Value Entries")
                {
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Value Entries action.';


                    trigger OnAction()
                    begin
                        Rec.ShowValueEntries();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Reverse Transaction")
                {
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Reverse Transaction action.';


                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        Clear(ReversalEntry);
                        if Rec.Reversed then
                            ReversalEntry.AlreadyReversedEntry(Rec.TableCaption, Rec."Entry No.");
                        if Rec."Journal Batch Name" = '' then
                            ReversalEntry.TestFieldError();
                        Rec.TestField("Transaction No.");
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.")
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the &Navigate action.';


                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        lrecGenJnlLine: Record "Gen. Journal Line";
    begin
        CurrPage.UnpostedEntries.PAGE.gfcnSetFilters(Rec);
    end;

    var
        GLAcc: Record "G/L Account";

    local procedure GetCaption(): Text[250]
    begin
        if GLAcc."No." <> Rec."G/L Account No." then
            if not GLAcc.Get(Rec."G/L Account No.") then
                if Rec.GetFilter("G/L Account No.") <> '' then
                    if GLAcc.Get(Rec.GetRangeMin("G/L Account No.")) then;
        exit(StrSubstNo('%1 %2', GLAcc."No.", GLAcc.Name))
    end;
}

