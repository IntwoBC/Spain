report 50001 "Customer Application"
{
    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // 01   22.08.2016 Object created
    // -----------------------------------------------------
    // 
    // // t84313.001 COSMO.ADT 16/04/20
    //   Not applying if different Cust. Posting Groups

    Caption = 'Automatic Application of Customers';
    Permissions = TableData "Cust. Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", Open, Positive, "Calculate Interest", "Due Date") WHERE(Open = CONST(true));
                RequestFilterFields = "Entry No.", "Document No.", "Posting Date", "Document Type";

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Document No.");
                    if not Open then
                        CurrReport.Skip();

                    for i := 1 to 4 do begin
                        // First and simple case: same document no.
                        PmtAmt := 0;
                        Total := 0;
                        PostingDate2 := PostingDate;
                        Done := false;
                        CustEntryTmp.Reset();
                        CustEntryTmp.DeleteAll();
                        EntryNo := "Entry No.";
                        CalcFields("Remaining Amount");

                        // Find all entries and cumulate
                        CustEntry.CopyFilters("Cust. Ledger Entry");
                        CustEntry.SetRange("Customer No.", "Customer No.");
                        // gbedv 01 -
                        if ("Currency Code" = '') or ("Currency Code" = LCY) then
                            CustEntry.SetFilter("Currency Code", '%1|%2', '', LCY)
                        else
                            // gbedv 01 +
                            CustEntry.SetRange("Currency Code", "Currency Code");
                        CustEntry.SetRange(Open, true);
                        CustEntry.SetRange("Document No.");
                        CustEntry.SetRange("External Document No.");
                        CustEntry.SetFilter("Remaining Amount", '');
                        //>>t84313.001
                        CustEntry.SetRange("Customer Posting Group", "Customer Posting Group");
                        //<<t84313.001
                        DoTheLoop := false;
                        if (i = 1) and AnalyzeDoc then begin
                            DoTheLoop := true;
                            CustEntry.SetRange("Document No.", "Document No.");
                        end;
                        if (i = 2) and AnalyzeExtDoc then begin
                            DoTheLoop := true;
                            CustEntry.SetRange("External Document No.", "External Document No.");
                        end;
                        if (i = 2) and AnalyzeExtDoc then begin
                            DoTheLoop := true;
                            CustEntry.SetFilter(Description, '*%1*', "External Document No.");
                        end;
                        if (i = 3) and AnalyzeAmt then begin
                            DoTheLoop := true;
                            CustEntry.SetFilter("Remaining Amount", '%1|%2', "Remaining Amount", -"Remaining Amount");
                        end;
                        if DoTheLoop then
                            if CustEntry.FindSet() then
                                repeat
                                    CustEntry.CalcFields("Remaining Amount");
                                    if CustEntry."Posting Date" > PostingDate2 then
                                        PostingDate2 := CustEntry."Posting Date";
                                    PmtAmt := PmtAmt + CustEntry."Remaining Amount";
                                    Total := Total + 1;
                                until CustEntry.Next() = 0;

                        // apply via amount only if it's a pair of two
                        if (i = 3) and (Total > 2) then
                            Total := 0;

                        // Do they apply?
                        if (PmtAmt = 0) and (Total > 1) then begin
                            // Delete existing Applies-to ID (if necessary)
                            CustEntry2.SetRange("Customer No.", "Customer No.");
                            CustEntry2.SetRange("Applies-to ID", "Document No.");
                            CustEntry2.SetRange(Open, true);
                            if CustEntry2.FindSet() then
                                CustEntry2.ModifyAll("Applies-to ID", '');

                            if CustEntry.FindSet() then
                                repeat
                                    CustEntry.CalcFields("Remaining Amount");
                                    CustEntry."Amount to Apply" := CustEntry."Remaining Amount";
                                    CustEntry."Applies-to ID" := "Document No.";
                                    CustEntry.Modify();
                                until CustEntry.Next() = 0;
                            if CustEntry.FindSet() then begin
                                CustEntryApply.Apply(CustEntry, ApplyParameters);
                                Counter += 1;
                                Done := true;
                                // set the loop counter out of range
                                i := 4;
                            end;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if PostingDate = 0D then
                        Error(EnterPostingDate);

                    // gbedv 01 -
                    GLSetup.Get();
                    LCY := GLSetup."LCY Code";
                    // gbedv 01 +
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                if Counter > 0 then
                    Message(EntriesApplied, Counter)
                else
                    Message(NoEntriesApplied);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Line1 +
                            Line2 +
                            Line3);

                CustEntry.SetCurrentKey("Customer No.", Open, Positive, "Calculate Interest", "Due Date");
                CustEntry2.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Posting Date field.';
                    }
                    field(AnalyzeDoc; AnalyzeDoc)
                    {
                        Caption = 'Analyze document no.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Analyze document no. field.';
                    }
                    field(AnalyzeExtDoc; AnalyzeExtDoc)
                    {
                        Caption = 'Analyze external document no.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Analyze external document no. field.';
                    }
                    field(AnalyzeAmt; AnalyzeAmt)
                    {
                        Caption = 'Analyze Remaining Amount';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Analyze Remaining Amount field.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EnterPostingDate: Label 'Please enter a posting date in <Options> first.';
        Line1: Label 'Open entries analyzed:           \';
        Line2: Label 'Account No.   #1#################\';
        Line3: Label 'Document No.  #2#################';
        EntriesApplied: Label '%1 entries have been applied.';
        NoEntriesApplied: Label 'No entries have been applied.';
        Window: Dialog;
        Counter: Integer;
        CustEntry2: Record "Cust. Ledger Entry";
        CustEntry: Record "Cust. Ledger Entry";
        CustEntryApply: Codeunit "CustEntry-Apply Posted Entries";
        PmtAmt: Decimal;
        Total: Integer;
        ApplyParameters: Record "Apply Unapply Parameters" temporary;
        CustEntryTmp: Record "CV Ledger Entry Buffer" temporary;
        Done: Boolean;
        OK: Boolean;
        i: Integer;
        EntryNo: Integer;
        AnalyzeExtDoc: Boolean;
        PostingDate: Date;
        PostingDate2: Date;
        AnalyzeDoc: Boolean;
        AnalyzeAmt: Boolean;
        CustEntryTest: Record "Cust. Ledger Entry";
        DoTheLoop: Boolean;
        GLSetup: Record "General Ledger Setup";
        LCY: Code[10];
        "--VAR.t84313.001--": Integer;
        DoNotApply: Boolean;

    local procedure LookUpField(var NewField: Integer; var NewFieldName: Text[250]; DoLookup: Boolean)
    var
        "Fields": Record "Field";
        //FieldPage: Page "Table Field List";
        Text001: Label 'Field %1 not defined in Table %2.';
    begin
        if DoLookup then begin
            Fields.SetRange(TableNo, 21);
            /// FieldPage.SetTableView(Fields);
            //FieldPage.LookupMode(true);
            //if FieldPage.RunModal <> ACTION::LookupOK then
            exit
            // else
            //  FieldPage.GetRecord(Fields);
        end else
            if NewField > 0 then
                if not Fields.Get(21, NewField) then
                    Error(Text001, NewField, 21);

        NewField := Fields."No.";
        NewFieldName := CopyStr(Fields."Field Caption", 1, MaxStrLen(NewFieldName))
    end;
}

