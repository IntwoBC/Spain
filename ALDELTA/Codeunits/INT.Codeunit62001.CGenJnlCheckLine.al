codeunit 62001 "C:Gen. Jnl.-Check Line"
{

    trigger OnRun()
    begin
    end;

    var
        grecGenJnlTemplate: Record "Gen. Journal Template";
        gmdlCompanyTypeMgt: Codeunit "Company Type Management";

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure levtOnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        lrecCorpAccountingPeriod: Record "Corporate Accounting Period";
    begin
        if GenJournalLine."Posting Date" <> NormalDate(GenJournalLine."Posting Date") then
            if GenJournalLine."Corporate G/L Account No." <> '' then begin
                lrecCorpAccountingPeriod.Get(NormalDate(GenJournalLine."Posting Date") + 1);
                lrecCorpAccountingPeriod.TestField("New Fiscal Year", true);
                lrecCorpAccountingPeriod.TestField("Date Locked", true);
            end;

        if grecGenJnlTemplate.Name <> GenJournalLine."Journal Template Name" then
            grecGenJnlTemplate.Get(GenJournalLine."Journal Template Name");

        if grecGenJnlTemplate.Type in [grecGenJnlTemplate.Type::"Tax Adjustments", grecGenJnlTemplate.Type::"Group Adjustments",
          grecGenJnlTemplate.Type::"Tax Adjustments", grecGenJnlTemplate.Type::"19"]
        then begin
            grecGenJnlTemplate.TestField("Shortcut Dimension 1 Code");

            if (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") and (GenJournalLine."Account No." <> '')
              and gmdlCompanyTypeMgt.gfcnCorpAccInUse()
            then
                GenJournalLine.TestField("Corporate G/L Account No.");

            if (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"G/L Account") and (GenJournalLine."Bal. Account No." <> '')
              and gmdlCompanyTypeMgt.gfcnCorpAccInUse()
            then
                GenJournalLine.TestField("Bal. Corporate G/L Account No.");

            GenJournalLine.TestField("GAAP Adjustment Reason");
            if grecGenJnlTemplate.Type = grecGenJnlTemplate.Type::"Group Adjustments" then
                GenJournalLine.TestField("Tax Adjustment Reason");
            GenJournalLine.TestField("Adjustment Role");

            if GenJournalLine."GAAP Adjustment Reason" <> GenJournalLine."GAAP Adjustment Reason"::Reclassification then
                GenJournalLine.TestField("Equity Correction Code");
        end;

        if grecGenJnlTemplate."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.TestField("Shortcut Dimension 1 Code", grecGenJnlTemplate."Shortcut Dimension 1 Code");
    end;
}

