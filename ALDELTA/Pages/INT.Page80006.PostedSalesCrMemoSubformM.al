page 80006 "Posted Sales Cr. Memo SubformM"
{
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = List;
    Permissions = TableData "Sales Cr.Memo Line" = rm;
    SourceTable = "Sales Cr.Memo Line";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the credit memo number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                // field("Cross-Reference No."; Rec."Cross-Reference No.")
                // {
                //     Visible = false;
                //     ApplicationArea=all;
                // }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the item or general ledger account, or some descriptive text.';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code explaining why the item was returned.';
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    BlankZero = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    BlankZero = true;
                    ApplicationArea = all;
                    Visible = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    BlankZero = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT % field.';
                }
                field("VAT Clause Code"; Rec."VAT Clause Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Clause Code field.';
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the related project.';
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied to.';
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
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
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Difference field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
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
                    ShortCutKey = 'Shift+Ctrl+D';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Dimensions action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action(Comments)
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Co&mments action.';

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }
                action(ItemTrackingEntries)
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Item &Tracking Entries action.';

                    trigger OnAction()
                    begin
                        Rec.ShowItemTrackingLines();
                    end;
                }
                action(ItemReturnReceiptLines)
                {
                    AccessByPermission = TableData "Return Shipment Header" = R;
                    Caption = 'Item Return Receipt &Lines';
                    ApplicationArea = all;
                    ToolTip = 'Executes the Item Return Receipt &Lines action.';

                    trigger OnAction()
                    begin
                        PageShowItemReturnRcptLines();
                    end;
                }
                action(DeferralSchedule)
                {
                    Caption = 'Deferral Schedule';
                    Image = PaymentPeriod;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Deferral Schedule action.';

                    trigger OnAction()
                    begin
                        Rec.ShowDeferrals();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedSalesCreditMemoTotals(TotalSalesCrMemoHeader, VATAmount, Rec);
    end;

    var
        TotalSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;

    local procedure PageShowItemReturnRcptLines()
    begin
        if not (Rec.Type in [Rec.Type::Item, Rec.Type::"Charge (Item)"]) then
            Rec.TestField(Type);
        Rec.ShowItemReturnRcptLines();
    end;
}

