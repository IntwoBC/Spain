page 70017 "Payment Journal Match"
{
    // #MyTaxi.W1.CRE.BANKR.001 29/01/2018 CCFR.SDE : Unmatched entries update history
    //   Page creation

    AutoSplitKey = true;
    Caption = 'Payment Journal Match';
    DataCaptionExpression = Rec.DataCaption();
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Bank,Prepare,Approve';
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Batch Name field.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ApplicationArea = all;
                    ToolTip = 'Specifies when the journal line will be posted.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date when the document represented by the journal line was created.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of document in question.';
                }
                field("Document No."; Rec."Document No.")
                {
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the document in a posted bill group/payment order, from which this document was generated.';
                }
                field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the incoming document that this general journal line is created for.';

                    trigger OnAssistEdit()
                    begin
                        if Rec."Incoming Document Entry No." > 0 then
                            HyperLink(Rec.GetIncomingDocumentURL());
                    end;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the account type, such as Customer.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the account number of the customer/vendor.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the posting group that will be used in posting the journal line.The field is used only if the account type is either customer or vendor.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Recipient Bank Account"; Rec."Recipient Bank Account")
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the bank account that the amount will be transferred to after it has been exported from the journal.';
                }
                field("Message to Recipient"; Rec."Message to Recipient")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(Description; Rec.Description)
                {
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the record.';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the campaign that the journal line is linked to.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    AssistEdit = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RunModal() = ACTION::OK then
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());

                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the typical posting type for the historical general ledger account.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies how payment for the document must be submitted, such as bank transfer or check.';
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                }
                field(Amount; Rec.Amount)
                {
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = HasPmtFileErr;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total on the journal line.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the amount of VAT that is included in the total amount.';
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.';
                }
                field("Bal. VAT Amount"; Rec."Bal. VAT Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the amount of Bal. VAT included in the total amount.';
                }
                field("Bal. VAT Difference"; Rec."Bal. VAT Difference")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted.';

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the general posting type that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("Bal. VAT Bus. Posting Group"; Rec."Bal. VAT Bus. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.';
                }
                field("Bal. VAT Prod. Posting Group"; Rec."Bal. VAT Prod. Posting Group")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[3] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[4] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[5] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[6] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[7] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ShortcutDimCode[8] field.';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Applied (Yes/No)"; Rec.IsApplied())
                {
                    Caption = 'Applied (Yes/No)';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applied (Yes/No) field.';
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    StyleExpr = StyleTxt;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                }
                field(GetAppliesToDocDueDate; Rec.GetAppliesToDocDueDate())
                {
                    Caption = 'Applies-to Doc. Due Date';
                    StyleExpr = StyleTxt;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Due Date field.';
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the payment type, for the entry on the payment journal line.';
                }
                field("Check Printed"; Rec."Check Printed")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether a check has been printed for the amount on the payment journal line.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies why the entry is created. When reason codes are assigned to journal line or sales and purchase documents, all entries with a reason code will be marked during posting.';
                }
                field(Control3; Rec.Comment)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies a comment about the activity on the journal line. Note that the comment is not carried forward to posted entries.';
                }
                field("Exported to Payment File"; Rec."Exported to Payment File")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies that the payment journal line was exported to a payment file.';
                }
                field(TotalExportedAmount; Rec.TotalExportedAmount())
                {
                    Caption = 'Total Exported Amount';
                    DrillDown = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Exported Amount field.';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownExportedAmount()
                    end;
                }
                field("Has Payment Export Error"; Rec."Has Payment Export Error")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies that an error occurred when you used the Export Payments to File function in the Payment Journal window.';
                }
            }
            group(Control24)
            {
                ShowCaption = false;
                fixed(Control80)
                {
                    ShowCaption = false;

                    group(Control82)
                    {
                        ShowCaption = false;
                        field(OverdueWarningText; OverdueWarningText)
                        {
                            Style = Unfavorable;
                            StyleExpr = TRUE;
                            ToolTip = 'Specifies the value of the OverdueWarningText field.';
                        }
                    }
                }
                fixed(Control1903561801)
                {
                    ShowCaption = false;

                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            Editable = false;
                            ApplicationArea = all;
                            ToolTip = 'Specifies the value of the AccName field.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName; BalAccName)
                        {
                            Caption = 'Bal. Account Name';
                            Editable = false;
                            ApplicationArea = all;
                            ToolTip = 'Specifies the value of the Bal. Account Name field.';
                        }
                    }
                    group(Control1900545401)
                    {
                        Caption = 'Balance';
                        field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            Visible = BalanceVisible;
                            ApplicationArea = all;
                            ToolTip = 'Specifies the value of the Balance field.';
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            Visible = TotalBalanceVisible;
                            ApplicationArea = all;
                            ToolTip = 'Specifies the value of the Total Balance field.';
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(BankStateLineDetailsMatch; "Bank State. Line Details Match")
            {
                Caption = 'Bank Statement Line Details Match';
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                        CurrPage.SaveRecord();
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Incoming Document action.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        Rec.Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Card action.';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
                action(SuggestVendorPayments)
                {
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Suggest Vendor Payments action.';

                    trigger OnAction()
                    var
                        SuggestVendorPayments: Report "Suggest Vendor Payments";
                    begin
                        Clear(SuggestVendorPayments);
                        SuggestVendorPayments.SetGenJnlLine(Rec);
                        SuggestVendorPayments.RunModal();
                    end;
                }
                action(PreviewCheck)
                {
                    Caption = 'P&review Check';
                    Image = ViewCheck;
                    RunObject = Page "Check Preview";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Line No." = FIELD("Line No.");
                    ApplicationArea = all;
                    ToolTip = 'Executes the P&review Check action.';
                }
                action(PrintCheck)
                {
                    AccessByPermission = TableData "Check Ledger Entry" = R;
                    Caption = 'Print Check';
                    Ellipsis = true;
                    Image = PrintCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Print Check action.';

                    trigger OnAction()
                    begin
                        GenJnlLine.Reset();
                        GenJnlLine.Copy(Rec);
                        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        DocPrint.PrintCheck(GenJnlLine);
                        CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                    end;
                }
                action("Void Check")
                {
                    Caption = 'Void Check';
                    Image = VoidCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Void Check action.';

                    trigger OnAction()
                    begin
                        Rec.TestField("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                        Rec.TestField("Check Printed", true);
                        if Confirm(Text000, false, Rec."Document No.") then
                            CheckManagement.VoidCheck(Rec);
                    end;
                }
                action("Void &All Checks")
                {
                    Caption = 'Void &All Checks';
                    Image = VoidAllChecks;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Void &All Checks action.';

                    trigger OnAction()
                    begin
                        if Confirm(Text001, false) then begin
                            GenJnlLine.Reset();
                            GenJnlLine.Copy(Rec);
                            GenJnlLine.SetRange("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                            GenJnlLine.SetRange("Check Printed", true);
                            if GenJnlLine.Find('-') then
                                repeat
                                    GenJnlLine2 := GenJnlLine;
                                    CheckManagement.VoidCheck(GenJnlLine2);
                                until GenJnlLine.Next() = 0;
                        end;
                    end;
                }
                action(CreditTransferRegEntries)
                {
                    Caption = 'Credit Transfer Reg. Entries';
                    Image = ExportReceipt;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-Show CT Entries";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Credit Transfer Reg. Entries action.';
                }
                action(CreditTransferRegisters)
                {
                    Caption = 'Credit Transfer Registers';
                    Image = ExportElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Credit Transfer Registers";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Credit Transfer Registers action.';
                }
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                ApplicationArea = all;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action("Renumber Document Numbers")
                {
                    Caption = 'Renumber Document Numbers';
                    Image = EditLines;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Renumber Document Numbers action.';

                    trigger OnAction()
                    begin
                        Rec.RenumberDocumentNo()
                    end;
                }
                action(ApplyEntries)
                {
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Apply Entries action.';
                }
                action(ExportPaymentsToFile)
                {
                    Caption = 'Export Payments to File';
                    Ellipsis = true;
                    Image = ExportFile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Export Payments to File action.';

                    trigger OnAction()
                    var
                        GenJnlLine: Record "Gen. Journal Line";
                    begin
                        GenJnlLine.CopyFilters(Rec);
                        GenJnlLine.FindFirst();
                        GenJnlLine.ExportPaymentFile();
                    end;
                }
                action(CalculatePostingDate)
                {
                    Caption = 'Calculate Posting Date';
                    Image = CalcWorkCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Calculate Posting Date action.';

                    trigger OnAction()
                    begin
                        Rec.CalculatePostingDate();
                    end;
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    Caption = 'Insert Conv. LCY Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ApplicationArea = all;
                    ToolTip = 'Executes the Insert Conv. LCY Rndg. Lines action.';
                }
                action(PositivePayExport)
                {
                    Caption = 'Positive Pay Export';
                    Image = Export;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Positive Pay Export action.';

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        BankAcc: Record "Bank Account";
                    begin
                        GenJnlBatch.Get(Rec."Journal Template Name", CurrentJnlBatchName);
                        if GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"Bank Account" then begin
                            BankAcc."No." := GenJnlBatch."Bal. Account No.";
                            PAGE.Run(PAGE::"Positive Pay Export", BankAcc);
                        end;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;

                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Ctrl+F11';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Reconcile action.';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run();
                    end;
                }
                action(PreCheck)
                {
                    Caption = 'Vendor Pre-Payment Journal';
                    Image = PreviewChecks;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vendor Pre-Payment Journal action.';

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Init();
                        GenJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                        REPORT.Run(REPORT::"Vendor Pre-Payment Journal", true, false, GenJournalBatch);
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Test Report action.';
                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                    ToolTip = 'Executes the P&ost action.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(Preview)
                {
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Preview Posting action.';

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Post and &Print action.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        Caption = 'Journal Batch';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrAnyJnlLineExist;
                        Image = SendApprovalRequest;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Journal Batch action.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearance();
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        Caption = 'Selected Journal Lines';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrCurrJnlLineExist;
                        Image = SendApprovalRequest;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Selected Journal Lines action.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        Caption = 'Journal Batch';
                        Enabled = OpenApprovalEntriesOnJnlBatchExist;
                        Image = Cancel;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Journal Batch action.';

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance();
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        Caption = 'Selected Journal Lines';
                        Enabled = OpenApprovalEntriesOnJnlLineExist;
                        Image = Cancel;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Selected Journal Lines action.';

                        trigger OnAction()
                        var
                            GenJournalLine: Record "Gen. Journal Line";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Approve action.';
                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        //IF NOT ApprovalsMgmt.ApproveRecordApprovalRequest(GenJournalBatch.RECORDID) THEN
                        // ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Reject action.';
                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        //IF NOT ApprovalsMgmt.RejectRecordApprovalRequest(GenJournalBatch.RECORDID) THEN
                        //  ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category6;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Delegate action.';

                    trigger OnAction()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                        //IF NOT ApprovalsMgmt.DelegateRecordApprovalRequest(GenJournalBatch.RECORDID) THEN
                        // ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(81),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("Document No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Comments action.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        StyleTxt := Rec.GetOverdueDateInteractions(OverdueWarningText);
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance();
        CurrPage.BankStateLineDetailsMatch.PAGE.SetGenJnlLine(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.GetOverdueDateInteractions(OverdueWarningText);
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        HasPmtFileErr := Rec.HasPaymentFileErrors();
        SetControlAppearance();
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CheckForPmtJnlErrors();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HasPmtFileErr := false;
        UpdateBalance();
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        BalAccName := '';

        if Rec.IsOpenedFromBatch() then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            SetControlAppearance();
            exit;
        end;
        GenJnlManagement.TemplateSelection(PAGE::"Payment Journal", 4, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        SetControlAppearance();
    end;

    var
        Text000: Label 'Void Check %1?';
        Text001: Label 'Void all printed checks?';
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        CheckManagement: Codeunit CheckManagement;
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        HasPmtFileErr: Boolean;
        ShortcutDimCode: array[8] of Code[20];

        BalanceVisible: Boolean;

        TotalBalanceVisible: Boolean;
        StyleTxt: Text;
        OverdueWarningText: Text;
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;

    local procedure CheckForPmtJnlErrors()
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        if HasPmtFileErr then
            if (Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account") and BankAccount.Get(Rec."Bal. Account No.") then
                if BankExportImportSetup.Get(BankAccount."Payment Export Format") then
                    if BankExportImportSetup."Check Export Codeunit" > 0 then
                        CODEUNIT.Run(BankExportImportSetup."Check Export Codeunit", Rec);
    end;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet());
    end;

    local procedure SetControlAppearance()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then;
        OpenApprovalEntriesExistForCurrUser :=
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RecordId) or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");
    end;
}

