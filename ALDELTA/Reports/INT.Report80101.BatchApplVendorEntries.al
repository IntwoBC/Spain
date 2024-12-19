report 80101 "Batch Appl. Vendor Entries"
{
    // PK 02-09-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Object created
    // PK 02-09-24 EY-MYES0005 Feature 6050340: Job for settlement of open Transactions
    // Bug fixes:
    //  - Permissions property updated
    //  - Caption property updated

    Caption = 'Batch Appl. Vendor Entries';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code") WHERE(Open = CONST(true));
                RequestFilterFields = "Vendor No.";

                trigger OnAfterGetRecord()
                var
                    ApplyToVendLedgEntry: Record "Vendor Ledger Entry";
                    TempCommentLine: Record "Comment Line" temporary;
                    MatchedText: Text;
                begin
                    CalcFields("Remaining Amount");
                    if MatchingType = MatchingType::"Description + Amount" then
                        GetTextToMatch(TempCommentLine, Description);

                    EYMYProgressBar.Update();

                    ApplyToVendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                    ApplyToVendLedgEntry.SetRange("Vendor No.", "Vendor No.");
                    ApplyToVendLedgEntry.SetRange(Open, true);
                    ApplyToVendLedgEntry.SetRange(Positive, not Positive);
                    ApplyToVendLedgEntry.SetRange("Currency Code", "Currency Code");
                    ApplyToVendLedgEntry.SetRange("Remaining Amount", -"Remaining Amount");
                    if ApplyToVendLedgEntry.FindSet() then
                        case MatchingType of
                            MatchingType::"Description + Amount":
                                begin
                                    TempCommentLine.Reset();
                                    if not TempCommentLine.IsEmpty then begin
                                        BatchApplMatchingRule.SetRange("Use For Vend. Ledger Entries", true);
                                        if BatchApplMatchingRule.FindSet() then
                                            repeat
                                                MatchedText := BatchApplMatchingRule.MatchTextBasedOnPattern(Description);
                                                TempCommentLine.SetRange(Comment, MatchedText);
                                                if not TempCommentLine.IsEmpty then begin
                                                    SetApplID(ApplyToVendLedgEntry);
                                                    ApplyVendLedgEntry("Vendor Ledger Entry");
                                                end;
                                            until BatchApplMatchingRule.Next() = 0
                                    end
                                end;
                            MatchingType::"Amount Only":
                                begin
                                    SetApplID(ApplyToVendLedgEntry);
                                    ApplyVendLedgEntry("Vendor Ledger Entry");
                                end;
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    EYMYProgressBar.Open(Count, StrSubstNo(Text001, MatchingType));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MatchingType := Number;
            end;

            trigger OnPreDataItem()
            begin
                BatchApplMatchingRule.SetRange("Use For Vend. Ledger Entries", true);
                if BatchApplMatchingRule.IsEmpty then
                    Integer.SetRange(Number, 1)
                else
                    Integer.SetRange(Number, 0, 1);
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

    var
        BatchApplMatchingRule: Record "Batch Appl. Matching Rule";
        EYMYProgressBar: Codeunit "EYMY Progress Bar";
        MatchingType: Option "Description + Amount","Amount Only";
        Text001: Label 'Matching by %1...';

    local procedure GetTextToMatch(var TempCommentLine: Record "Comment Line" temporary; TextToMatch: Text)
    var
        LineNo: Integer;
        MatchedText: Text;
    begin
        LineNo := 0;
        TempCommentLine.Reset();
        TempCommentLine.DeleteAll();
        BatchApplMatchingRule.SetRange("Use For Vend. Ledger Entries", true);
        if BatchApplMatchingRule.FindSet() then
            repeat
                MatchedText := BatchApplMatchingRule.MatchTextBasedOnPattern(TextToMatch);
                if MatchedText <> '' then begin
                    LineNo += 1;
                    TempCommentLine.Init();
                    TempCommentLine."Line No." := LineNo;
                    TempCommentLine.Comment := MatchedText;
                    TempCommentLine.Insert();
                end;
            until BatchApplMatchingRule.Next() = 0
    end;

    local procedure ApplyVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
    begin
        SetApplID(VendLedgEntry);
        //VendEntryApplyPostedEntries.SetCalledFromBatchAppl(true);
        //VendEntryApplyPostedEntries.Apply(VendLedgEntry, VendLedgEntry."Document No.", WorkDate);
    end;

    local procedure SetApplID(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.CalcFields("Remaining Amount");
        VendLedgEntry."Applies-to ID" := CopyStr(UserId(), 1, MaxStrLen(VendLedgEntry."Applies-to ID"));
        VendLedgEntry."Applying Entry" := true;
        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
        VendLedgEntry.Modify();
    end;
}

