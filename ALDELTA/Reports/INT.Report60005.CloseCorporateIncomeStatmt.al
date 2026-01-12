report 60005 "Close Corporate Income Statmt."
{
    // MP 29-02-12
    // Added code to OnOpenPage, to populate "Journal Template Name" and "Retained Earnings Account"
    // 
    // MP 20-06-13
    // Now also closes S and T Adjustments, removed filter on Global Dimension 1 Code in DataItemTableView and
    // amended to split the retained earnings amount by Business Unit and Global Dimension 1 Code (Case 13851)
    // 
    // MP 30-10-13
    // Amended above to additionally close by Tax Adjustment Reason
    // 
    // MP 17-11-14
    // NAV 2013 R2 upgrade, based on Report 94
    // 
    // MP 04-02-16
    // Added condition in OnPostDataItem for "G/L Account" to cover the scenario where total balance on P&L is zero,
    // but where S adjustments (or other dimensions) exist (INC3967306)

    Caption = 'Close Corporate Income Statement';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Corporate G/L Account"; "Corporate G/L Account")
        {
            DataItemTableView = SORTING("No.") WHERE("Account Type" = CONST(Posting), "Income/Balance" = CONST("Income Statement"));
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Corporate G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("Corporate G/L Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    TempDimBuf: Record "Dimension Buffer" temporary;
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    EntryNo: Integer;
                begin
                    EntryCount := EntryCount + 1;
                    if Time - LastWindowUpdate > 1000 then begin
                        LastWindowUpdate := Time;
                        Window.Update(3, Round(EntryCount / MaxEntry * 10000, 1));
                    end;

                    if ClosePerGlobalDimOnly and (ClosePerBusUnit or ClosePerGlobalDim1) then begin
                        if ClosePerBusUnit then begin
                            SetRange("Business Unit Code", "Business Unit Code");
                            GenJnlLine."Business Unit Code" := "Business Unit Code";
                        end;
                        if ClosePerGlobalDim1 then begin
                            SetRange("Global Dimension 1 Code", "Global Dimension 1 Code");
                            if ClosePerGlobalDim2 then
                                SetRange("Global Dimension 2 Code", "Global Dimension 2 Code");
                        end;
                        CalcSumsInFilter();
                        EntryNo := "Entry No.";
                        GetGLEntryDimensions(EntryNo, TempDimBuf);
                    end;

                    if (Amount <> 0) or ("Additional-Currency Amount" <> 0) then begin
                        gcodTaxAdjmtReason := Format("Tax Adjustment Reason", 0, 2); // MP 30-10-13

                        if not (ClosePerGlobalDimOnly and (ClosePerBusUnit or ClosePerGlobalDim1)) then begin
                            TotalAmount := TotalAmount + Amount;
                            if GLSetup."Additional Reporting Currency" <> '' then
                                TotalAmountAddCurr := TotalAmountAddCurr + "Additional-Currency Amount";

                            GetGLEntryDimensions("Entry No.", TempDimBuf);

                            lfcnUpdRetainedEarningsBuffer(); // MP 20-06-13
                        end;

                        TempDimBuf2.DeleteAll();
                        if TempSelectedDim.Find('-') then
                            repeat
                                if TempDimBuf.Get(DATABASE::"G/L Entry", "Entry No.", TempSelectedDim."Dimension Code")
                                then begin
                                    TempDimBuf2."Table ID" := TempDimBuf."Table ID";
                                    TempDimBuf2."Dimension Code" := TempDimBuf."Dimension Code";
                                    TempDimBuf2."Dimension Value Code" := TempDimBuf."Dimension Value Code";
                                    TempDimBuf2.Insert();
                                end;
                            until TempSelectedDim.Next() = 0;

                        // MP 30-10-13 Insert "Tax Adjustment Reason" as Dim. >>

                        if gcodTaxAdjmtReason <> '0' then begin
                            TempDimBuf2."Table ID" := DATABASE::"G/L Entry";
                            TempDimBuf2."Dimension Code" := txtTaxAdjmtReason;
                            TempDimBuf2."Dimension Value Code" := gcodTaxAdjmtReason;
                            TempDimBuf2.Insert();
                        end;

                        // MP 30-10-13 <<

                        EntryNo := DimBufMgt.GetDimensionId(TempDimBuf2);

                        EntryNoAmountBuf.Reset();
                        if ClosePerBusUnit and FieldActive("Business Unit Code") then
                            EntryNoAmountBuf."Business Unit Code" := "Business Unit Code"
                        else
                            EntryNoAmountBuf."Business Unit Code" := '';
                        EntryNoAmountBuf."Entry No." := EntryNo;
                        if EntryNoAmountBuf.Find() then begin
                            EntryNoAmountBuf.Amount := EntryNoAmountBuf.Amount + Amount;
                            EntryNoAmountBuf.Amount2 := EntryNoAmountBuf.Amount2 + "Additional-Currency Amount";
                            EntryNoAmountBuf.Modify();
                        end else begin
                            EntryNoAmountBuf.Amount := Amount;
                            EntryNoAmountBuf.Amount2 := "Additional-Currency Amount";
                            EntryNoAmountBuf.Insert();
                        end;
                    end;

                    if ClosePerGlobalDimOnly and (ClosePerBusUnit or ClosePerGlobalDim1) then begin
                        Find('+');
                        if FieldActive("Business Unit Code") then
                            SetRange("Business Unit Code");
                        if FieldActive("Global Dimension 1 Code") then begin
                            SetRange("Global Dimension 1 Code");
                            if FieldActive("Global Dimension 2 Code") then
                                SetRange("Global Dimension 2 Code");
                        end
                    end;
                end;

                trigger OnPostDataItem()
                var
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    GlobalDimVal1: Code[20];
                    GlobalDimVal2: Code[20];
                    NewDimensionID: Integer;
                begin
                    EntryNoAmountBuf.Reset();
                    MaxEntry := EntryNoAmountBuf.Count;
                    EntryCount := 0;
                    Window.Update(2, Text012);
                    Window.Update(3, 0);

                    if EntryNoAmountBuf.Find('-') then
                        repeat
                            EntryCount := EntryCount + 1;
                            if Time - LastWindowUpdate > 1000 then begin
                                LastWindowUpdate := Time;
                                Window.Update(3, Round(EntryCount / MaxEntry * 10000, 1));
                            end;

                            if (EntryNoAmountBuf.Amount <> 0) or (EntryNoAmountBuf.Amount2 <> 0) then begin
                                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                GenJnlLine."Account No." := grecSuspenseGLAcc."No.";
                                GenJnlLine."Corporate G/L Account No." := "Corporate G/L Account No.";
                                GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                                GenJnlLine.Validate(Amount, -EntryNoAmountBuf.Amount);
                                GenJnlLine."Source Currency Amount" := -EntryNoAmountBuf.Amount2;
                                GenJnlLine."Business Unit Code" := EntryNoAmountBuf."Business Unit Code";

                                TempDimBuf2.DeleteAll();
                                DimBufMgt.RetrieveDimensions(EntryNoAmountBuf."Entry No.", TempDimBuf2);

                                // MP 30-10-13 >>

                                TempDimBuf2.SetRange("Dimension Code", txtTaxAdjmtReason);
                                if TempDimBuf2.FindFirst() then begin
                                    Evaluate(GenJnlLine."Tax Adjustment Reason", TempDimBuf2."Dimension Value Code");
                                    TempDimBuf2.Delete();
                                end else
                                    GenJnlLine."Tax Adjustment Reason" := GenJnlLine."Tax Adjustment Reason"::" ";
                                TempDimBuf2.SetRange("Dimension Code");

                                // MP 30-10-13 <<

                                NewDimensionID := DimMgt.CreateDimSetIDFromDimBuf(TempDimBuf2);
                                GenJnlLine."Dimension Set ID" := NewDimensionID;
                                DimMgt.UpdateGlobalDimFromDimSetID(NewDimensionID, GlobalDimVal1, GlobalDimVal2);
                                GenJnlLine."Shortcut Dimension 1 Code" := '';
                                if ClosePerGlobalDim1 then
                                    GenJnlLine."Shortcut Dimension 1 Code" := GlobalDimVal1;
                                GenJnlLine."Shortcut Dimension 2 Code" := '';
                                if ClosePerGlobalDim2 then
                                    GenJnlLine."Shortcut Dimension 2 Code" := GlobalDimVal2;

                                HandleGenJnlLine();
                            end;
                        until EntryNoAmountBuf.Next() = 0;

                    EntryNoAmountBuf.DeleteAll();
                end;

                trigger OnPreDataItem()
                begin
                    Window.Update(2, Text013);
                    Window.Update(3, 0);

                    if ClosePerGlobalDimOnly or ClosePerBusUnit then
                        case true of
                            ClosePerBusUnit and (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "Corporate G/L Account No.", "Business Unit Code",
                                  "Global Dimension 1 Code", "Global Dimension 2 Code");
                            ClosePerBusUnit and not (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "Corporate G/L Account No.", "Business Unit Code", "Posting Date");
                            not ClosePerBusUnit and (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                                SetCurrentKey(
                                  "Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
                        end;

                    SetRange("Posting Date", FiscalYearStartDate, FiscYearClosingDate);

                    MaxEntry := Count;

                    EntryNoAmountBuf.DeleteAll();
                    EntryCount := 0;

                    LastWindowUpdate := Time;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ThisAccountNo := ThisAccountNo + 1;
                Window.Update(1, "No.");
                Window.Update(4, Round(ThisAccountNo / NoOfAccounts * 10000, 1));
                Window.Update(2, '');
                Window.Update(3, 0);
            end;

            trigger OnPostDataItem()
            begin

                if (TotalAmount <> 0) or ((TotalAmountAddCurr <> 0) and (GLSetup."Additional Reporting Currency" <> ''))
                  or (not gtmpAmountBufRetainedEarnings.IsEmpty) // MP 04-02-16 Added condition
                then begin

                    // MP 20-06-13 >>

                    gtmpAmountBufRetainedEarnings.FindSet();
                    repeat
                        //GenJnlLine."Business Unit Code" := '';
                        //GenJnlLine."Business Unit Code" := gtmpAmountBufRetainedEarnings."Account No. 1"; // MP 20-06-13 Replaces above
                        GenJnlLine."Business Unit Code" := gtmpAmountBufRetainedEarnings."Analysis View Code"; // MP 30-10-13 Replaces above

                        // MP 20-06-13 <<

                        //GenJnlLine."Shortcut Dimension 1 Code" := '';
                        //GenJnlLine."Shortcut Dimension 1 Code" := gtmpAmountBufRetainedEarnings."Account No. 2"; // MP 20-06-13 Replaces above
                        GenJnlLine."Shortcut Dimension 1 Code" := gtmpAmountBufRetainedEarnings."Account No."; // MP 30-10-13 Replaces above

                        GenJnlLine."Shortcut Dimension 2 Code" := '';
                        GenJnlLine."Dimension Set ID" := 0;
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Account No." := grecSuspenseGLAcc."No.";
                        GenJnlLine."Corporate G/L Account No." := RetainedEarningsGLAcc."No.";
                        GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                        GenJnlLine."Currency Code" := '';
                        GenJnlLine."Additional-Currency Posting" :=
                        GenJnlLine."Additional-Currency Posting"::None;

                        // MP 20-06-13 >>

                        if GenJnlLine."Shortcut Dimension 1 Code" <> '' then begin
                            // MP 17-11-14 NAV 2013 R2 Upgrade >>
                            //TempJnlLineDim."Table ID" := DATABASE::"Gen. Journal Line";
                            //TempJnlLineDim."Journal Template Name" := GenJnlLine."Journal Template Name";
                            //TempJnlLineDim."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                            //TempJnlLineDim."Journal Line No." := GenJnlLine."Line No.";
                            //TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 1 Code";
                            //TempJnlLineDim."Dimension Value Code" := GenJnlLine."Shortcut Dimension 1 Code";
                            //TempJnlLineDim.INSERT;

                            GenJnlLine.Validate("Shortcut Dimension 1 Code"); // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                                                              // MP 17-11-14 NAV 2013 R2 Upgrade <<
                        end;

                        //GenJnlLine.VALIDATE(Amount,TotalAmount);
                        //GenJnlLine."Source Currency Amount" := TotalAmountAddCurr;

                        // MP 30-10-13 >>

                        //GenJnlLine.VALIDATE(Amount,gtmpAmountBufRetainedEarnings."Amount 1");
                        //GenJnlLine."Source Currency Amount" := gtmpAmountBufRetainedEarnings."Amount 2";
                        GenJnlLine.Validate(Amount, gtmpAmountBufRetainedEarnings.Amount);
                        GenJnlLine."Source Currency Amount" := gtmpAmountBufRetainedEarnings."Add.-Curr. Amount";

                        Evaluate(GenJnlLine."Tax Adjustment Reason", gtmpAmountBufRetainedEarnings."Dimension 1 Value Code");

                        // MP 30-10-13 <<

                        // MP 20-06-13 <<

                        HandleGenJnlLine();
                        Window.Update(1, GenJnlLine."Account No.");
                    until gtmpAmountBufRetainedEarnings.Next() = 0; // MP 20-06-13
                end;
            end;

            trigger OnPreDataItem()
            begin
                NoOfAccounts := Count;
            end;
        }
    }

    requestpage
    {
        Caption = 'Close Income Statement';
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FiscalYearEndingDate; EndDateReq)
                    {
                        Caption = 'Fiscal Year Ending Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Fiscal Year Ending Date field.';

                        trigger OnValidate()
                        begin
                            ValidateEndDate(true);
                        end;
                    }
                    field(GenJournalTemplate; GenJnlLine."Journal Template Name")
                    {
                        Caption = 'Gen. Journal Template';
                        Editable = false;
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Template field.';

                        trigger OnValidate()
                        begin
                            GenJnlLine."Journal Batch Name" := '';
                            DocNo := '';
                        end;
                    }
                    field(GenJournalBatch; GenJnlLine."Journal Batch Name")
                    {
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gen. Journal Batch field.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(2);
                            GenJnlBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(0);
                            GenJnlBatch."Journal Template Name" := GenJnlLine."Journal Template Name";
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            if PAGE.RunModal(0, GenJnlBatch) = ACTION::LookupOK then begin
                                Text := GenJnlBatch.Name;
                                exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if GenJnlLine."Journal Batch Name" <> '' then begin
                                GenJnlLine.TestField("Journal Template Name");
                                GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                            end;
                            ValidateJnl();
                        end;
                    }
                    field(DocumentNo; DocNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Document No. field.';
                    }
                    field(RetainedEarningsAcc; RetainedEarningsGLAcc."No.")
                    {
                        Caption = 'Retained Earnings Acc.';
                        Editable = false;
                        TableRelation = "Corporate G/L Account";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Retained Earnings Acc. field.';

                        trigger OnValidate()
                        begin
                            if RetainedEarningsGLAcc."No." <> '' then begin
                                RetainedEarningsGLAcc.Find();
                                RetainedEarningsGLAcc.CheckGLAcc();
                            end;
                        end;
                    }
                    field("grecSuspenseGLAcc.""No."""; grecSuspenseGLAcc."No.")
                    {
                        Caption = 'Local Suspense Acc.';
                        Editable = false;
                        TableRelation = "G/L Account";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Local Suspense Acc. field.';

                        trigger OnValidate()
                        begin
                            if grecSuspenseGLAcc."No." <> '' then begin
                                grecSuspenseGLAcc.Find();
                                grecSuspenseGLAcc.CheckGLAcc();
                            end;
                        end;
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        Caption = 'Posting Description';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Posting Description field.';
                    }
                    group("Close by")
                    {
                        Caption = 'Close by';
                        field(ClosePerBusUnit; ClosePerBusUnit)
                        {
                            Caption = 'Business Unit Code';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Business Unit Code field.';
                        }
                        field(Dimensions; ColumnDim)
                        {
                            Caption = 'Dimensions';
                            Editable = false;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Dimensions field.';

                            trigger OnAssistEdit()
                            var
                                TempSelectedDim2: Record "Selected Dimension" temporary;
                                s: Text[1024];
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Close Corporate Income Statmt.", ColumnDim);

                                SelectedDim.GetSelectedDim(UserId, 3, REPORT::"Close Corporate Income Statmt.", '', TempSelectedDim2);
                                s := CheckDimPostingRules(TempSelectedDim2);
                                if s <> '' then
                                    Message(s);
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDescription = '' then
                PostingDescription :=
                  CopyStr(ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Close Corporate Income Statmt."), 1, 30);
            EndDateReq := 0D;
            AccountingPeriod.SetRange("New Fiscal Year", true);
            AccountingPeriod.SetRange("Date Locked", true);
            if AccountingPeriod.Find('+') then begin
                EndDateReq := AccountingPeriod."Starting Date" - 1;
                if not ValidateEndDate(false) then
                    EndDateReq := 0D;
            end;
            ValidateJnl();
            ColumnDim := DimSelectionBuf.GetDimSelectionText(3, REPORT::"Close Corporate Income Statmt.", '');

            // MP 29-02-12 >>

            grecEYCoreSetup.Get();
            grecEYCoreSetup.TestField("Local Suspense Acc.");
            grecEYCoreSetup.TestField("Corp. Retained Earnings Acc.");

            grecSuspenseGLAcc."No." := grecEYCoreSetup."Local Suspense Acc.";
            RetainedEarningsGLAcc."No." := grecEYCoreSetup."Corp. Retained Earnings Acc.";

            GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
            GenJnlTemplate.FindFirst();
            GenJnlLine."Journal Template Name" := GenJnlTemplate.Name;

            // MP 29-02-12 <<
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        Window.Close();
        Commit();
        if GLSetup."Additional Reporting Currency" <> '' then begin
            Message(Text016);
            UpdateAnalysisView.UpdateAll(0, true);
        end else
            Message(Text017);
    end;

    trigger OnPreReport()
    var
        s: Text[1024];
    begin
        if EndDateReq = 0D then
            Error(Text000);
        ValidateEndDate(true);
        if DocNo = '' then
            Error(Text001);

        // Ensure "Global Dimension 1 Code" is selected in group by dimension
        GLSetup.Get();
        SelectedDim."User ID" := UserId;
        SelectedDim."Object Type" := 3; // Report
        SelectedDim."Object ID" := REPORT::"Close Corporate Income Statmt.";
        SelectedDim."Analysis View Code" := '';
        SelectedDim."Dimension Code" := GLSetup."Global Dimension 1 Code";
        if not SelectedDim.Find() then
            SelectedDim.Insert();

        SelectedDim.GetSelectedDim(UserId, 3, REPORT::"Close Corporate Income Statmt.", '', TempSelectedDim);
        s := CheckDimPostingRules(TempSelectedDim);
        if s <> '' then
            if not Confirm(s + Text007, false) then
                Error('');

        GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        SourceCodeSetup.Get();
        GLSetup.Get();
        if GLSetup."Additional Reporting Currency" <> '' then begin
            if RetainedEarningsGLAcc."No." = '' then
                Error(Text002);
            if not Confirm(
                 Text003 +
                 Text005 +
                 Text007, false)
            then
                Error('');
        end;

        Window.Open(Text008 + Text009 + Text019 + Text010 + Text011);

        ClosePerGlobalDim1 := false;
        ClosePerGlobalDim2 := false;
        ClosePerGlobalDimOnly := true;

        if TempSelectedDim.Find('-') then
            repeat
                if TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 1 Code" then
                    ClosePerGlobalDim1 := true;
                if TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 2 Code" then
                    ClosePerGlobalDim2 := true;
                if (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 1 Code") and
                   (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 2 Code")
                then
                    ClosePerGlobalDimOnly := false;
            until TempSelectedDim.Next() = 0;

        // MP 20-06-13 >>

        if not ClosePerGlobalDim1 then
            Error(txt60000, GLSetup."Global Dimension 1 Code");

        // MP 20-06-13 <<

        ClosePerGlobalDimOnly := false; // MP 30-10-13 Always close per Tax Adjustment Reason as well

        GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        if not GenJnlLine.FindLast() then;
        GenJnlLine.Init();
        GenJnlLine."Posting Date" := FiscYearClosingDate;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine.Description := PostingDescription;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
    end;

    var
        AccountingPeriod: Record "Corporate Accounting Period";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        RetainedEarningsGLAcc: Record "Corporate G/L Account";
        GLSetup: Record "General Ledger Setup";
        DimSelectionBuf: Record "Dimension Selection Buffer";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        EntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        grecSuspenseGLAcc: Record "G/L Account";
        grecEYCoreSetup: Record "EY Core Setup";
        gtmpAmountBufRetainedEarnings: Record "Analysis View Entry" temporary;
        NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        FiscalYearStartDate: Date;
        FiscYearClosingDate: Date;
        EndDateReq: Date;
        DocNo: Code[20];
        PostingDescription: Text[50];
        ClosePerBusUnit: Boolean;
        ClosePerGlobalDim1: Boolean;
        ClosePerGlobalDim2: Boolean;
        ClosePerGlobalDimOnly: Boolean;
        TotalAmount: Decimal;
        TotalAmountAddCurr: Decimal;
        ColumnDim: Text[250];
        ObjTransl: Record "Object Translation";
        NoOfAccounts: Integer;
        ThisAccountNo: Integer;
        Text000: Label 'Enter the ending date for the fiscal year.';
        Text001: Label 'Enter a Document No.';
        Text002: Label 'Enter Retained Earnings Account No.';
        Text003: Label 'By using an additional reporting currency, this batch job will post closing entries directly to the general ledger.  ';
        Text005: Label 'These closing entries will not be transferred to a general journal before the program posts them to the general ledger.\\ ';
        Text007: Label '\Do you want to continue?';
        Text008: Label 'Creating general journal lines...\\';
        Text009: Label 'Account No.         #1##################\';
        Text010: Label 'Now performing      #2##################\';
        Text011: Label '                    @3@@@@@@@@@@@@@@@@@@\';
        Text019: Label '                    @4@@@@@@@@@@@@@@@@@@\';
        Text012: Label 'Creating Gen. Journal lines';
        Text013: Label 'Calculating Amounts';
        Text014: Label 'The fiscal year must be closed before the income statement can be closed.';
        Text015: Label 'The fiscal year does not exist.';
        Text017: Label 'The journal lines have successfully been created.';
        Text016: Label 'The closing entries have successfully been posted.';
        Text020: Label 'The following G/L Accounts have mandatory dimension codes that have not been selected:';
        Text021: Label '\\In order to post to these accounts you must also select these dimensions:';
        MaxEntry: Integer;
        EntryCount: Integer;
        LastWindowUpdate: Time;
        txt60000: Label 'Closing by dimension %1 must be selected';
        txtTaxAdjmtReason: Label '#TAXADJMTREASON#';
        gcodTaxAdjmtReason: Code[20];

    local procedure ValidateEndDate(RealMode: Boolean): Boolean
    var
        OK: Boolean;
    begin
        if EndDateReq = 0D then
            exit;

        OK := AccountingPeriod.Get(EndDateReq + 1);
        if OK then
            OK := AccountingPeriod."New Fiscal Year";
        if OK then begin
            if not AccountingPeriod."Date Locked" then begin
                if not RealMode then
                    exit;
                Error(Text014);
            end;
            FiscYearClosingDate := ClosingDate(EndDateReq);
            AccountingPeriod.SetRange("New Fiscal Year", true);
            OK := AccountingPeriod.Find('<');
            FiscalYearStartDate := AccountingPeriod."Starting Date";
        end;
        if not OK then begin
            if not RealMode then
                exit;
            Error(Text015);
        end;
        exit(true);
    end;

    local procedure ValidateJnl()
    begin
        DocNo := '';
        if GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            if GenJnlBatch."No. Series" <> '' then
                //FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
                //Previous it was TryGetNextNo and replaced by GetNextNo
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq);
    end;

    local procedure HandleGenJnlLine()
    var
        NextNo: Code[20];//FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC
    begin
        GenJnlLine."Additional-Currency Posting" :=
          GenJnlLine."Additional-Currency Posting"::None;
        if GLSetup."Additional Reporting Currency" <> '' then begin
            GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
            if ZeroGenJnlAmount() then begin
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJnlLine.Validate(Amount, GenJnlLine."Source Currency Amount");
                GenJnlLine."Source Currency Amount" := 0;
            end;
            if GenJnlLine.Amount <> 0 then begin
                GenJnlPostLine.Run(GenJnlLine);
                //FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC-----Start
                // if DocNo = NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq, false) then
                //     NoSeriesMgt.SaveNoSeries();

                NextNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq, false);
                if DocNo = NextNo then
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq, true);
                //FreeNow: #69855:#511 Extension management compatibility with version 27.0.38460.38988 - BC-----End
            end;
        end else
            if not ZeroGenJnlAmount() then
                GenJnlLine.Insert();
    end;

    local procedure CalcSumsInFilter()
    begin
        "G/L Entry".CalcSums(Amount);
        TotalAmount := TotalAmount + "G/L Entry".Amount;
        if GLSetup."Additional Reporting Currency" <> '' then begin
            "G/L Entry".CalcSums("Additional-Currency Amount");
            TotalAmountAddCurr := TotalAmountAddCurr + "G/L Entry"."Additional-Currency Amount";
        end;

        lfcnUpdRetainedEarningsBuffer(); // MP 20-06-13
    end;

    local procedure GetGLEntryDimensions(EntryNo: Integer; var DimBuf: Record "Dimension Buffer")
    var
        GLEntry: Record "G/L Entry";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        DimBuf.DeleteAll();
        GLEntry.Get(EntryNo);
        DimSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
        if DimSetEntry.FindSet() then
            repeat
                DimBuf."Table ID" := DATABASE::"G/L Entry";
                DimBuf."Entry No." := EntryNo;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.Insert();
            until DimSetEntry.Next() = 0;
    end;

    local procedure CheckDimPostingRules(var SelectedDim: Record "Selected Dimension"): Text[1024]
    var
        DefaultDim: Record "Default Dimension";
        s: Text[1024];
        d: Text[1024];
        PrevAcc: Code[20];
    begin
        DefaultDim.SetRange("Table ID", DATABASE::"G/L Account");
        DefaultDim.SetFilter(
          "Value Posting", '%1|%2',
          DefaultDim."Value Posting"::"Same Code", DefaultDim."Value Posting"::"Code Mandatory");

        if DefaultDim.Find('-') then
            repeat
                SelectedDim.SetRange("Dimension Code", DefaultDim."Dimension Code");
                if not SelectedDim.Find('-') then begin
                    if StrPos(d, DefaultDim."Dimension Code") < 1 then
                        d := d + ' ' + Format(DefaultDim."Dimension Code");
                    if PrevAcc <> DefaultDim."No." then begin
                        PrevAcc := DefaultDim."No.";
                        if s = '' then
                            s := Text020;
                        s := s + ' ' + Format(DefaultDim."No.");
                    end;
                end;
                SelectedDim.SetRange("Dimension Code");
            until (DefaultDim.Next() = 0) or (StrLen(s) > MaxStrLen(s) - MaxStrLen(DefaultDim."No.") - StrLen(Text021) - 1);
        if s <> '' then
            s := CopyStr(s + Text021 + d, 1, MaxStrLen(s));
        exit(s);
    end;


    procedure InitializeRequestTest(EndDate: Date; GenJournalLine: Record "Gen. Journal Line"; GLAccount: Record "Corporate G/L Account"; CloseByBU: Boolean)
    begin
        EndDateReq := EndDate;
        GenJnlLine := GenJournalLine;
        ValidateJnl();
        RetainedEarningsGLAcc := GLAccount;
        ClosePerBusUnit := CloseByBU;
    end;

    local procedure ZeroGenJnlAmount(): Boolean
    begin
        exit((GenJnlLine.Amount = 0) and (GenJnlLine."Source Currency Amount" <> 0))
    end;

    local procedure lfcnUpdRetainedEarningsBuffer()
    var
        lblnEntryExists: Boolean;
    begin
        // MP 20-06-13
        // MP 30-10-13 Changed to use difference source record for gtmpAmountBufRetainedEarnings

        // MP 30-10-13 >>
        /*
        IF ClosePerBusUnit THEN
          lblnEntryExists := gtmpAmountBufRetainedEarnings.GET("G/L Entry"."Business Unit Code","G/L Entry"."Global Dimension 1 Code")
        ELSE
          lblnEntryExists := gtmpAmountBufRetainedEarnings.GET('',"G/L Entry"."Global Dimension 1 Code");
        
        IF lblnEntryExists THEN
          gtmpAmountBufRetainedEarnings."Amount 1" += "G/L Entry".Amount
        ELSE BEGIN
          IF ClosePerBusUnit THEN
            gtmpAmountBufRetainedEarnings."Account No. 1" := "G/L Entry"."Business Unit Code"
          ELSE
            gtmpAmountBufRetainedEarnings."Account No. 1" := '';
        
          gtmpAmountBufRetainedEarnings."Account No. 2" := "G/L Entry"."Global Dimension 1 Code";
          gtmpAmountBufRetainedEarnings."Amount 1" := "G/L Entry".Amount;
          gtmpAmountBufRetainedEarnings."Amount 2" := 0;
        END;
        
        IF GLSetup."Additional Reporting Currency" <> '' THEN
          IF lblnEntryExists THEN
            gtmpAmountBufRetainedEarnings."Amount 2" += "G/L Entry"."Additional-Currency Amount"
          ELSE
            gtmpAmountBufRetainedEarnings."Amount 2" := "G/L Entry"."Additional-Currency Amount";
        */

        if ClosePerBusUnit then
            lblnEntryExists := gtmpAmountBufRetainedEarnings.Get("G/L Entry"."Business Unit Code", "G/L Entry"."Global Dimension 1 Code", 0, // MP 17-11-14 Added 3rd parameter
              gcodTaxAdjmtReason)
        else
            lblnEntryExists := gtmpAmountBufRetainedEarnings.Get('', "G/L Entry"."Global Dimension 1 Code", 0, // MP 17-11-14 Added 3rd parameter
              gcodTaxAdjmtReason);

        if lblnEntryExists then
            gtmpAmountBufRetainedEarnings.Amount += "G/L Entry".Amount
        else begin
            if ClosePerBusUnit then
                gtmpAmountBufRetainedEarnings."Analysis View Code" := "G/L Entry"."Business Unit Code"
            else
                gtmpAmountBufRetainedEarnings."Analysis View Code" := '';

            gtmpAmountBufRetainedEarnings."Account No." := "G/L Entry"."Global Dimension 1 Code";
            gtmpAmountBufRetainedEarnings."Dimension 1 Value Code" := gcodTaxAdjmtReason;
            gtmpAmountBufRetainedEarnings.Amount := "G/L Entry".Amount;
            gtmpAmountBufRetainedEarnings."Add.-Curr. Amount" := 0;
        end;

        if GLSetup."Additional Reporting Currency" <> '' then
            if lblnEntryExists then
                gtmpAmountBufRetainedEarnings."Add.-Curr. Amount" += "G/L Entry"."Additional-Currency Amount"
            else
                gtmpAmountBufRetainedEarnings."Add.-Curr. Amount" := "G/L Entry"."Additional-Currency Amount";

        // MP 30-10-13 <<

        if lblnEntryExists then
            gtmpAmountBufRetainedEarnings.Modify()
        else
            gtmpAmountBufRetainedEarnings.Insert();

    end;
}

