report 70011 "Data Migration - Update Doc Ty"
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
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, (Jauge * 10000) div JaugeMax);
                Jauge += 1;
                GenJnlLine.SetRange("Document No.", "Document No.");
                GenJnlLine.SetFilter("Document Type", '<>%1', "Document Type");
                if GenJnlLine.FindFirst() then begin
                    GenJnlLine.SetRange("Document Type");
                    GenJnlLine.ModifyAll("Pmt. Discount Date", 0D);
                    GenJnlLine.ModifyAll("Document Type", GenJnlLine."Document Type"::" ");
                end;

                //IF (("Document Type"="Document Type"::Payment) AND (GenJnlLine."Document Type"=GenJnlLine."Document Type"::Refund)) OR
                //(("Document Type"="Document Type"::Refund) AND (GenJnlLine."Document Type"=GenJnlLine."Document Type"::Payment)) THEN
                //GenJnlLine.MODIFYALL("Document Type",GenJnlLine."Document Type"::" ");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                GenJnlLine.SetCurrentKey("Document No.");
                GenJnlLine.SetRange("Journal Template Name", JournalTemplate);
                GenJnlLine.SetRange("Journal Batch Name", BatchName);
                SetRange("Journal Template Name", JournalTemplate);
                SetRange("Journal Batch Name", BatchName);
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

