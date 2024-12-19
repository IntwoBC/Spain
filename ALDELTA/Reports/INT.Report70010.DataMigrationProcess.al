report 70010 "Data Migration Process"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Report Creation
    // #MyTaxi.W1.CRE.DMIG.002 03/07/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Do not set VAT Information on transfered lines

    Permissions = TableData "Cust. Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Data Migration Entries"; "Data Migration Entries")
        {
            DataItemTableView = SORTING(SerialNo) WHERE(Processed = CONST(false));

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, (Jauge * 10000) div JaugeMax);
                Commit();
                UseOldDocumentNo := '';

                Clear(DataMigrationProcess);
                DataMigrationProcess.SetParams(BatchName, JournalTemplate, LineNo, BalanceByEntryNo, OldDocumentNo, UseOldDocumentNo);
                if not DataMigrationProcess.Run("Data Migration Entries") then begin
                    "Error Description 1" := CopyStr(GetLastErrorText, 1, 250);
                    "Error Description 2" := CopyStr(GetLastErrorText, 251, 250);
                    "Process in Error" := true;
                    Modify(true);
                    UseOldDocumentNo := OldDocumentNo;
                end
                else
                    if GenJnlLine.Get("Journal Template Name", "Journal Batch Name", "Line No.") then
                        OldDocumentNo := GenJnlLine."Document No.";

                if (OldEntryNo = EntryNo) or (OldEntryNo = '') then
                    BalanceByEntryNo += Amount
                else begin
                    BalanceByEntryNo := 0;
                    BalanceByEntryNo := Amount
                end;

                OldEntryNo := EntryNo;
                LineNo += 10;
                Jauge += 1;
            end;

            trigger OnPostDataItem()
            begin
                DataMigrationEntries2.SetCurrentKey("Process in Error");
                DataMigrationEntries2.SetRange("Process in Error", true);
                if DataMigrationEntries2.FindSet() then
                    repeat
                        DataMigrationEntries.SetRange(EntryNo, DataMigrationEntries2.EntryNo);
                        DataMigrationEntries.SetFilter("Journal Template Name", '<>%1', '');
                        if DataMigrationEntries.FindSet() then
                            repeat
                                if GenJnlLine.Get(DataMigrationEntries."Journal Template Name",
                                  DataMigrationEntries."Journal Batch Name", DataMigrationEntries."Line No.")
                                then
                                    GenJnlLine.Delete(true);
                                DataMigrationEntries.Processed := false;
                                DataMigrationEntries."Processed On" := 0DT;
                                DataMigrationEntries."Processed By" := '';
                                DataMigrationEntries.Modify();
                            until DataMigrationEntries.Next() = 0;
                    until DataMigrationEntries2.Next() = 0;
                DataMigrationEntries2.ModifyAll("Process in Error", false);
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Transfer to Journal Progress: @1@@@@@@@@@@@@@@@@@@');
                Jauge := 0;
                JaugeMax := Count;
                DataMigrationEntries.Reset();
                DataMigrationEntries.SetCurrentKey(EntryNo);
                DataMigrationEntries2.ModifyAll("Process in Error", false);
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
                field(JournalTemplate; JournalTemplate)
                {
                    Caption = 'Journal Template';
                    TableRelation = "Gen. Journal Batch".Name;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Template field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJnlTemplate: Record "Gen. Journal Template";
                        GenJnlTemplates: Page "General Journal Templates";
                    begin
                        GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
                        GenJnlTemplate.SetRange(Recurring, false);
                        GenJnlTemplates.SetTableView(GenJnlTemplate);

                        GenJnlTemplates.LookupMode := true;
                        GenJnlTemplates.Editable := false;
                        if GenJnlTemplates.RunModal() = ACTION::LookupOK then begin
                            GenJnlTemplates.GetRecord(GenJnlTemplate);
                            JournalTemplate := GenJnlTemplate.Name;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CheckJournalTemplate();
                    end;
                }
                field(BatchName; BatchName)
                {
                    Caption = 'Batch Name';
                    TableRelation = "Gen. Journal Batch".Name;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Name field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJnlBatches: Page "General Journal Batches";
                    begin
                        if JournalTemplate <> '' then begin
                            GenJnlBatch.SetRange("Journal Template Name", JournalTemplate);
                            GenJnlBatches.SetTableView(GenJnlBatch);
                        end;

                        GenJnlBatches.LookupMode := true;
                        GenJnlBatches.Editable := false;
                        if GenJnlBatches.RunModal() = ACTION::LookupOK then begin
                            GenJnlBatches.GetRecord(GenJnlBatch);
                            BatchName := GenJnlBatch.Name;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CheckBatchName();
                    end;
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

    trigger OnPreReport()
    begin
        CheckJournalTemplate();
        CheckBatchName();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
        GenJnlLine.SetRange("Journal Batch Name", BatchName);
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 10
        else
            LineNo := 10;

        GenJnlBatch.Get(JournalTemplate, BatchName);
    end;

    var
        DataMigrationEntries: Record "Data Migration Entries";
        DataMigrationEntries2: Record "Data Migration Entries";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        DataMigrationProcess: Codeunit "Data Migration Process";
        LineNo: Integer;
        BatchName: Code[10];
        JournalTemplate: Text[10];
        Text001: Label 'Gen. Journal Template name is blank.';
        Text002: Label 'Gen. Journal Batch name is blank.';
        Window: Dialog;
        JaugeMax: Integer;
        Jauge: Integer;
        UseOldDocumentNo: Code[20];
        OldDocumentNo: Code[20];
        BalanceByEntryNo: Decimal;
        OldEntryNo: Text;

    local procedure CheckBatchName()
    begin
        if BatchName = '' then
            Error(Text002);
    end;

    local procedure CheckJournalTemplate()
    begin
        if JournalTemplate = '' then
            Error(Text001);
    end;
}

