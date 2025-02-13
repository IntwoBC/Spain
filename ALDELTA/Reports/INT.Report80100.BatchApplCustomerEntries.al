report 80100 "Batch Appl. Customer Entries"
{
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Object created

    Caption = 'Batch Appl. Customer Entries';
    Permissions = TableData "Cust. Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code") WHERE(Open = CONST(true));
                RequestFilterFields = "Customer No.";

                trigger OnAfterGetRecord()
                var
                    ApplyToCustLedgEntry: Record "Cust. Ledger Entry";
                    TempCommentLine: Record "Comment Line" temporary;
                    MatchedText: Text;
                begin
                    CalcFields("Remaining Amount");
                    if MatchingType = MatchingType::"Description + Amount" then
                        GetTextToMatch(TempCommentLine, Description);

                    EYMYProgressBar.Update();

                    ApplyToCustLedgEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
                    ApplyToCustLedgEntry.SetRange("Customer No.", "Customer No.");
                    ApplyToCustLedgEntry.SetRange(Open, true);
                    ApplyToCustLedgEntry.SetRange(Positive, not Positive);
                    ApplyToCustLedgEntry.SetRange("Currency Code", "Currency Code");
                    ApplyToCustLedgEntry.SetRange("Remaining Amount", -"Remaining Amount");
                    if ApplyToCustLedgEntry.FindSet() then
                        case MatchingType of
                            MatchingType::"Description + Amount":
                                begin
                                    TempCommentLine.Reset();
                                    if not TempCommentLine.IsEmpty then begin
                                        BatchApplMatchingRule.SetRange("Use For Cust. Ledger Entries", true);
                                        if BatchApplMatchingRule.FindSet() then
                                            repeat
                                                MatchedText := BatchApplMatchingRule.MatchTextBasedOnPattern(Description);
                                                TempCommentLine.SetRange(Comment, MatchedText);
                                                if not TempCommentLine.IsEmpty then begin
                                                    SetApplID(ApplyToCustLedgEntry);
                                                    ApplyCustLedgEntry("Cust. Ledger Entry");
                                                end;
                                            until BatchApplMatchingRule.Next() = 0
                                    end
                                end;
                            MatchingType::"Amount Only":
                                begin
                                    SetApplID(ApplyToCustLedgEntry);
                                    ApplyCustLedgEntry("Cust. Ledger Entry");
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
                BatchApplMatchingRule.SetRange("Use For Cust. Ledger Entries", true);
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
        BatchApplMatchingRule.SetRange("Use For Cust. Ledger Entries", true);
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

    local procedure ApplyCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters" temporary;
    begin
        SetApplID(CustLedgEntry);
        //CustEntryApplyPostedEntries.SetCalledFromBatchAppl(true);
        CustEntryApplyPostedEntries.Apply(CustLedgEntry, ApplyUnapplyParameters);
    end;

    local procedure SetApplID(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.CalcFields("Remaining Amount");
        CustLedgEntry."Applies-to ID" := CopyStr(UserId(), 1, MaxStrLen(CustLedgEntry."Applies-to ID"));
        CustLedgEntry."Applying Entry" := true;
        CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
        CustLedgEntry.Modify();
    end;
}

