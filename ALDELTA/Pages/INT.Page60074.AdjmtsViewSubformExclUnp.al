page 60074 "Adjmts. View Subform-Excl. Unp"
{
    Caption = 'Posted G/L Entries Only';
    Editable = false;
    PageType = ListPart;
    SourceTable = "G/L Entry";
    SourceTableView = SORTING("Global Dimension 1 Code", "Posting Date")
                      WHERE("Global Dimension 1 Code" = FILTER(<> ''));
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the entry''s posting date.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the entry''s Document No.';

                }
                field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';

                }
                field("Corporate G/L Account Name"; Rec."Corporate G/L Account Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate G/L Account Name field.';

                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the account that the entry has been posted to.';

                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the name of the account that the entry has been posted to.';

                }
                field("GAAP Adjustment Reason"; Rec."GAAP Adjustment Reason")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GAAP Adjustment Reason field.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';

                }
                field("Adjustment Role"; Rec."Adjustment Role")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Adjustment Role field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the entry.';

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Amount of the entry.';

                }
                field("Equity Correction Code"; Rec."Equity Correction Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Equity Correction Code field.';

                }
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';

                }
                field(Reversible; Rec.Reversible)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reversible field.';

                }
                field("Reversed at"; Rec."Reversed at")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reversed at field.';

                }
                field("Reversal Entry No."; Rec."Reversal Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reversal Entry No. field.';

                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Workaroound for MS bug
    end;


    procedure gfcnUpdate(ptxtDateFilter: Text; poptExcludeEntries: Option " ","Reclassification Reversals","Closing Date","Reclassification Reversals and Closing Date")
    var
        lrecCorpAccPeriod: Record "Corporate Accounting Period";
        ltxtEntryNoFilter: Text;
    begin
        Rec.SetFilter("Posting Date", ptxtDateFilter);

        if poptExcludeEntries in [poptExcludeEntries::"Reclassification Reversals", poptExcludeEntries::"Reclassification Reversals and Closing Date"] then begin
            Rec.SetRange("GAAP Adjustment Reason", Rec."GAAP Adjustment Reason"::Reclassification);
            if Rec.FindSet() then begin
                repeat
                    if (Rec."Reversal Entry No." <> 0) or lrecCorpAccPeriod.Get(Rec."Posting Date") then begin
                        if ltxtEntryNoFilter <> '' then
                            ltxtEntryNoFilter += '&';

                        ltxtEntryNoFilter += StrSubstNo('<>%1', Rec."Entry No.");
                    end;
                until Rec.Next() = 0;
            end;
            Rec.SetFilter("Entry No.", ltxtEntryNoFilter);
            Rec.SetRange("GAAP Adjustment Reason");
        end;

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;


    procedure gfcnGetCopy(var precGLEntry: Record "G/L Entry")
    begin
        precGLEntry.Copy(Rec);
    end;
}

