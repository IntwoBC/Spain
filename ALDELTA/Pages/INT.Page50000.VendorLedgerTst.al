page 50000 "Vendor LedgerTst"
{
    // SUP:ISSUE:#111525  09/09/2021 COSMO.ABT
    //    # Show two fields ""IBAN / Bank Account" and "URL".
    // SUP:ISSUE:#112374  14/10/2021 COSMO.ABT
    //    # Show new field "E-mail".

    Caption = 'Vendor Ledger Entries';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Autodocument No."; Rec."Autodocument No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field is used internally.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of document.';
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase document number.';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill number related to the vendor ledger entry.';
                }
                field("Document Situation"; Rec."Document Situation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document location.';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that the entry originally consisted of, in LCY.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount of in the local currency. The amount is calculated using the Remaining Quantity, Line Discount %, and Unit Price (LCY) fields.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    StyleExpr = StyleTxt;
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the purchase document is due.';
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';
                }
                field("Pmt. Disc. Rcd.(LCY)"; Rec."Pmt. Disc. Rcd.(LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment discount that has been received, in LCY.';
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open; Rec.Open)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                field(Reversed; Rec.Reversed)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.';
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.';
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    Editable = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.';
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions to.';
                }
                field("IBAN / Bank Account"; Rec."IBAN / Bank Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the IBAN / Bank Account field.';
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the URL field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                ApplicationArea = all;
            }
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
                Image = Entry;
                action("Applied E&ntries")
                {
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    RunObject = Page "Applied Vendor Entries";
                    RunPageOnRec = true;
                    Scope = Repeater;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Applied E&ntries action.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No." = FIELD("Entry No."),
                                  "Vendor No." = FIELD("Vendor No.");
                    RunPageView = SORTING("Vendor Ledger Entry No.", "Posting Date");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Detailed &Ledger Entries action.';
                }
                action("Custom. Det. Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Custom Det. Ledger Entries';
                    Image = View;
                    RunObject = Page "Cust. Det. Vend Ledg Entries";
                    RunPageLink = "Vendor Ledger Entry No." = field("Entry No."),
                                  "Vendor No." = field("Vendor No.");
                    RunPageView = sorting("Vendor Ledger Entry No.", "Posting Date");
                    //Scope = Repeater;
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ActionApplyEntries)
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F11';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Apply Entries action.';

                    trigger OnAction()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        VendEntryApplyPostEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendLedgEntry.Copy(Rec);
                        VendEntryApplyPostEntries.ApplyVendEntryFormEntry(VendLedgEntry);
                        VendLedgEntry.Get(VendLedgEntry."Entry No.");
                        Rec := VendLedgEntry;
                        CurrPage.Update();
                    end;
                }
                separator(Action66)
                {
                }
                action(UnapplyEntries)
                {
                    Caption = 'Unapply Entries';
                    Ellipsis = true;
                    Image = UnApply;
                    Scope = Repeater;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Unapply Entries action.';

                    trigger OnAction()
                    var
                        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    begin
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry(Rec."Entry No.");
                    end;
                }
                separator(Action68)
                {
                }
                action(ReverseTransaction)
                {
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;
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
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.");
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';
                        ApplicationArea = all;
                        ToolTip = 'Executes the View Incoming Document action.';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCard(Rec."Document No.", Rec."Posting Date");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document" = R;
                        Caption = 'Select Incoming Document';
                        Enabled = NOT HasIncomingDocument;
                        Image = SelectLineToApply;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Select Incoming Document action.';
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.SelectIncomingDocumentForPostedDocument(Rec."Document No.", Rec."Posting Date", Rec.RecordId);
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = NOT HasIncomingDocument;
                        Image = Attach;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Create Incoming Document from File action.';
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPostedDocument(Rec."Document No.", Rec."Posting Date");
                        end;
                    }
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ApplicationArea = all;
                ToolTip = 'Executes the &Navigate action.';
                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }
            action("Show Posted Document")
            {
                Caption = 'Show Posted Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ApplicationArea = all;
                ToolTip = 'Executes the Show Posted Document action.';
                trigger OnAction()
                begin
                    Rec.ShowDoc()
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists(Rec."Document No.", Rec."Posting Date");
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", Rec);
        exit(false);
    end;

    var
        Navigate: Page Navigate;
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
}

