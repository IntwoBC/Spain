page 50003 "MyTaxi Posted Approval Entries"
{
    // #MyTaxi.W1.CRE.PURCH.017 07/06/2019 CCFR.SDE : P2P2 Approval Workflow Process (CRN201900012 Approval History View per approver)
    //   Page Creation
    // #MyTaxi.W1.CRE.PURCH.018 24/06/2019 CCFR.SDE : P2P2 Approval Workflow Process (CRN201900012 Approval History View per approver)
    //   New added fields : 70000 "Source Type", 70001 "Source No.", 70002 "Source Name"

    Caption = 'Posted Approval Entries';
    DataCaptionFields = "Document No.";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Approval Entry";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(PostedRecordID; PostedRecordID)
                {
                    Caption = 'Approved';
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Approved field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                // field(Details; Rec.RecordDetails)
                // {
                //     Caption = 'Details';
                //     Width = 50;
                // }
                field("Sender ID"; Rec."Sender ID")
                {
                    ToolTip = 'Specifies the value of the Sender ID field.';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the value of the Approver ID field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ToolTip = 'Specifies the value of the Sequence No. field.';
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ToolTip = 'Specifies the value of the Date-Time Sent for Approval field.';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date-Time Modified field.';
                }
                field("Last Modified By ID"; Rec."Last Modified By ID")
                {
                    ToolTip = 'Specifies the value of the Last Modified By ID field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                Image = View;
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Comments action.';

                    trigger OnAction()
                    var
                        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
                    begin
                        PostedApprovalCommentLine.FilterGroup(2);
                        PostedApprovalCommentLine.SetRange("Posted Record ID", Rec."Posted Record ID");
                        PostedApprovalCommentLine.FilterGroup(0);
                        PAGE.Run(PAGE::"Posted Approval Comments", PostedApprovalCommentLine);
                    end;
                }
                action("Record")
                {
                    Caption = 'Record';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Record action.';

                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PostedRecordID := Format(Rec."Posted Record ID", 0, 1);
    end;

    trigger OnAfterGetRecord()
    begin
        PostedRecordID := Format(Rec."Posted Record ID", 0, 1);
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Approver ID", UserId);
        Rec.SetRange(Status, Rec.Status::Approved);
        Rec.FilterGroup(0);
    end;

    var
        PostedRecordID: Text;
        RecNotExistTxt: Label 'The record does not exist.';


    procedure RecordCaption(): Text
    var
        // "Object": Record Object;
        RecRef: RecordRef;
        PageNo: Integer;
        PageManagement: Codeunit "Page Management";
    begin
        if not RecRef.Get(Rec."Posted Record ID") then
            exit;
        PageNo := PageManagement.GetPageID(RecRef);
        if PageNo = 0 then
            exit;
        // Object.Get(Object.Type::Page, '', PageNo);
        // Object.CalcFields(Caption);
        // exit(StrSubstNo('%1 %2', Object.Caption, Rec."Document No."));
    end;


    procedure RecordDetails(): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        RecRef: RecordRef;
        ChangeRecordDetails: Text;
    begin
        if not RecRef.Get(Rec."Posted Record ID") then
            exit(RecNotExistTxt);

        case RecRef.Number of
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    SalesInvoiceHeader.CalcFields(Amount);
                    exit(StrSubstNo('%1 %2 ; %2: %3 %4', SalesInvoiceHeader."External Document No.", SalesInvoiceHeader."Sell-to Customer Name",
                        SalesInvoiceHeader.FieldCaption(Amount), SalesInvoiceHeader.Amount, SalesInvoiceHeader."Currency Code"));
                end;
            DATABASE::"Purch. Inv. Header":
                begin
                    RecRef.SetTable(PurchInvHeader);
                    PurchInvHeader.CalcFields(Amount);
                    exit(StrSubstNo('%1 %2 ; %3 : %4 %5', PurchInvHeader."Vendor Invoice No.", PurchInvHeader."Buy-from Vendor Name",
                        PurchInvHeader.FieldCaption(Amount), PurchInvHeader.Amount, PurchInvHeader."Currency Code"));
                end;
            else
                exit(Format(Rec."Posted Record ID", 0, 1));
        end;
    end;


    procedure GetCustVendorDetails(var CustVendorNo: Code[20]; var CustVendorName: Text[50])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        Customer: Record Customer;
        RecRef: RecordRef;
    begin
        if not RecRef.Get(Rec."Posted Record ID") then
            exit;

        case Rec."Table ID" of
            DATABASE::"Purch. Inv. Header":
                begin
                    RecRef.SetTable(PurchInvHeader);
                    CustVendorNo := PurchInvHeader."Pay-to Vendor No.";
                    CustVendorName := PurchInvHeader."Pay-to Name";
                end;
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    CustVendorNo := SalesInvoiceHeader."Bill-to Customer No.";
                    CustVendorName := SalesInvoiceHeader."Bill-to Name";
                end;
            DATABASE::Customer:
                begin
                    RecRef.SetTable(Customer);
                    CustVendorNo := Customer."No.";
                    CustVendorName := Customer.Name;
                end;
        end;
    end;
}

