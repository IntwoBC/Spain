page 60072 "Corp. G/L Acc./FS Code Matrix"
{
    Caption = 'Corp. G/L Account/FS Code by Accounting Period';
    CardPageID = "Corporate G/L Account Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Corporate G/L Account";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Name (English)";
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Name (English)"; Rec."Name (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name (English) field.';

                }
                field("gcodMatrixData[1]"; gcodMatrixData[1])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[1];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField1Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[1] field.';

                }
                field("gcodMatrixData[2]"; gcodMatrixData[2])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[2];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField2Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[2] field.';

                }
                field("gcodMatrixData[3]"; gcodMatrixData[3])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[3];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField3Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[3] field.';

                }
                field("gcodMatrixData[4]"; gcodMatrixData[4])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[4];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField4Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[4] field.';

                }
                field("gcodMatrixData[5]"; gcodMatrixData[5])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[5];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField5Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[5] field.';

                }
                field("gcodMatrixData[6]"; gcodMatrixData[6])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[6];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField6Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[6] field.';

                }
                field("gcodMatrixData[7]"; gcodMatrixData[7])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[7];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField7Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[7] field.';

                }
                field("gcodMatrixData[8]"; gcodMatrixData[8])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[8];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField8Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[8] field.';

                }
                field("gcodMatrixData[9]"; gcodMatrixData[9])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[9];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField9Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[9] field.';

                }
                field("gcodMatrixData[10]"; gcodMatrixData[10])
                {
                    CaptionClass = '3,' + gtxtMatrixColumnCaptions[10];
                    TableRelation = "Financial Statement Code";
                    Visible = gblnField10Visible;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the gcodMatrixData[10] field.';

                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        lintI: Integer;
    begin
        //for lintI := 1 to gintNoOfColumns do
        // gcodMatrixData[lintI] := gfcnGetFinancialStatementCode(gdatMatrixStartDate[lintI]);
    end;

    trigger OnOpenPage()
    var
        lrecCorpAccPeriod: Record "Corporate Accounting Period";
    begin
        lrecCorpAccPeriod.SetRange("New Fiscal Year", true);
        if lrecCorpAccPeriod.Count > 10 then begin
            lrecCorpAccPeriod.FindLast();
            lrecCorpAccPeriod.Next(-9);
            lrecCorpAccPeriod.SetFilter("Starting Date", '%1..', lrecCorpAccPeriod."Starting Date");
        end;

        if lrecCorpAccPeriod.FindSet() then
            repeat
                gintNoOfColumns += 1;
                gtxtMatrixColumnCaptions[gintNoOfColumns] := Format(lrecCorpAccPeriod."Starting Date");
                gdatMatrixStartDate[gintNoOfColumns] := lrecCorpAccPeriod."Starting Date";
            until lrecCorpAccPeriod.Next() = 0;

        lfcnSetVisible();

        grecHistAccFinStatmtCode.SetRange("G/L Account Type", grecHistAccFinStatmtCode."G/L Account Type"::"Corporate G/L Account");
    end;

    var
        grecHistAccFinStatmtCode: Record "Hist. Acc. Fin. Statmt. Code";
        gtxtMatrixColumnCaptions: array[10] of Text[1024];
        gdatMatrixStartDate: array[10] of Date;
        gcodMatrixData: array[10] of Code[10];
        gintNoOfColumns: Integer;

        gblnField1Visible: Boolean;

        gblnField2Visible: Boolean;

        gblnField3Visible: Boolean;

        gblnField4Visible: Boolean;

        gblnField5Visible: Boolean;

        gblnField6Visible: Boolean;

        gblnField7Visible: Boolean;

        gblnField8Visible: Boolean;

        gblnField9Visible: Boolean;

        gblnField10Visible: Boolean;

    local procedure lfcnSetVisible()
    begin
        gblnField1Visible := gtxtMatrixColumnCaptions[1] <> '';
        gblnField2Visible := gtxtMatrixColumnCaptions[2] <> '';
        gblnField3Visible := gtxtMatrixColumnCaptions[3] <> '';
        gblnField4Visible := gtxtMatrixColumnCaptions[4] <> '';
        gblnField5Visible := gtxtMatrixColumnCaptions[5] <> '';
        gblnField6Visible := gtxtMatrixColumnCaptions[6] <> '';
        gblnField7Visible := gtxtMatrixColumnCaptions[7] <> '';
        gblnField8Visible := gtxtMatrixColumnCaptions[8] <> '';
        gblnField9Visible := gtxtMatrixColumnCaptions[9] <> '';
        gblnField10Visible := gtxtMatrixColumnCaptions[10] <> '';
    end;
}

