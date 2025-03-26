report 90000 "UpdateExternalDocumentNo"
{
    Caption = 'Update External Document No.';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where("External Document No." = filter(''), "Document Type" = filter(Invoice | "Credit Memo"));
            RequestFilterFields = "Document No.", "Posting Date";

            trigger OnPreDataItem()
            var
                TotalRecords: Integer;
            begin
                if not Confirm('Do you want to update External Document No. for Customer Ledger Entries where it is blank?', false) then
                    CurrReport.Quit();

                ProgressDialog.Open('Processing Entry No.: #1########');
            end;

            trigger OnAfterGetRecord()

            begin
                ProgressDialog.Update(1, "Entry No.");

                if "External Document No." = '' then begin
                    "External Document No." := "Document No.";
                    Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                ProgressDialog.Close();
                Message('External Document No. has been updated for applicable Customer Ledger Entries.');
            end;
        }
    }

    var
        ProgressDialog: Dialog;


    trigger OnInitReport()
    begin

    end;
}