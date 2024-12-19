report 60012 "Upd. Corp. Acc. No.-Bottom-Up"
{
    Permissions = TableData "G/L Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                grecGLEntry.SetRange("G/L Account No.", "No.");
                grecGLEntry.SetFilter("Corporate G/L Account No.", '<>%1', "Corporate G/L Account No.");
                if not grecGLEntry.IsEmpty then
                    grecGLEntry.ModifyAll("Corporate G/L Account No.", "Corporate G/L Account No.");
            end;

            trigger OnPreDataItem()
            begin
                grecGLEntry.SetCurrentKey("G/L Account No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        lrecEYCoreSetup: Record "EY Core Setup";
    begin
        lrecEYCoreSetup.Get();
        lrecEYCoreSetup.TestField("Company Type", lrecEYCoreSetup."Company Type"::"Bottom-up");
    end;

    trigger OnPostReport()
    begin
        Message(txt60001, grecGLEntry.FieldCaption("Corporate G/L Account No."));
    end;

    trigger OnPreReport()
    begin
        if not Confirm(txt60000, false, grecGLEntry.FieldCaption("Corporate G/L Account No.")) then
            CurrReport.Quit();
    end;

    var
        grecGLEntry: Record "G/L Entry";
        txt60000: Label 'Are you sure you want to update the field %1 on all G/L entries?';
        txt60001: Label 'The field %1 has now been updated successfully on all G/L entries';
}

