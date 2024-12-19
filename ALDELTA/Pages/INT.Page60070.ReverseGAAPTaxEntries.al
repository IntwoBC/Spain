page 60070 "Reverse GAAP/Tax Entries"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SaveValues = true;
    SourceTable = "Accounting Period";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(gdatStartDate; gdatStartDate)
                {
                    Caption = 'Start Date';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Start Date field.';

                }
                field(gdatEndDate; gdatEndDate)
                {
                    Caption = 'End Date';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Date field.';

                }
                field(gdatPostDate; gdatPostDate)
                {
                    Caption = 'Posting Date';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';

                }
                field("gcodGenJnlBatchName[1]"; gcodGenJnlBatchName[1])
                {
                    Caption = 'GAAP-to-GAAP Journal Batch Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GAAP-to-GAAP Journal Batch Name field.';


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(lfcnLookupBatchName(1, Text));
                    end;
                }
                field("gcodGenJnlBatchName[2]"; gcodGenJnlBatchName[2])
                {
                    Caption = 'GAAP-to-TAX Journal Batch Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the GAAP-to-TAX Journal Batch Name field.';


                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(lfcnLookupBatchName(2, Text));
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        lrecAccPeriod: Record "Accounting Period";
    begin
        lrecAccPeriod.SetRange("Starting Date", 0D, Rec."Starting Date");
        lrecAccPeriod.SetRange("New Fiscal Year", true);
        lrecAccPeriod.FindLast();
        gdatStartDate := lrecAccPeriod."Starting Date";

        lrecAccPeriod.SetRange("Starting Date");
        lrecAccPeriod.Next();
        gdatEndDate := lrecAccPeriod."Starting Date" - 1;

        gdatPostDate := lrecAccPeriod."Starting Date";

        grecGenJnlTemplate[1].SetRange(Type, grecGenJnlTemplate[1].Type::"Tax Adjustments");
        grecGenJnlTemplate[1].FindFirst();

        grecGenJnlTemplate[2].SetRange(Type, grecGenJnlTemplate[2].Type::"Group Adjustments");
        grecGenJnlTemplate[2].FindFirst();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        lmdlReverseGLEntries: Codeunit "Reverse G/L Entries";
    begin
        if CloseAction = ACTION::OK then begin
            if (gcodGenJnlBatchName[1] = '') and (gcodGenJnlBatchName[2] = '') then begin
                Message(txtBatchNameMandatory);
                exit(false);
            end;

            lmdlReverseGLEntries.gfncReverseAdjustments(gdatStartDate, gdatEndDate, gdatPostDate, true, grecGenJnlTemplate, gcodGenJnlBatchName);
        end;

        exit(true);
    end;

    var
        grecGenJnlTemplate: array[2] of Record "Gen. Journal Template";
        gcodGenJnlBatchName: array[2] of Code[10];
        gdatStartDate: Date;
        gdatEndDate: Date;
        gdatPostDate: Date;
        txtBatchNameMandatory: Label 'You must specify at least one journal batch name';


    procedure lfcnLookupBatchName(pintJnlNo: Integer; var ptxtText: Text[1024]): Boolean
    var
        lrecGenJnlBatch: Record "Gen. Journal Batch";
    begin
        lrecGenJnlBatch.SetRange("Journal Template Name", grecGenJnlTemplate[pintJnlNo].Name);
        if PAGE.RunModal(0, lrecGenJnlBatch) = ACTION::LookupOK then begin
            ptxtText := lrecGenJnlBatch.Name;
            exit(true);
        end else
            exit(false);
    end;
}

