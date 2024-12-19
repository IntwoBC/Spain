report 60006 "Copy Financial Statmt Struct."
{
    Caption = 'Copy Financial Statement Structure';
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Financial Statement Line"; "Financial Statement Line")
        {
            DataItemTableView = SORTING("Financial Stat. Structure Code", "Line No.");

            trigger OnAfterGetRecord()
            begin
                grecCopyToFinStatmtLine := "Financial Statement Line";
                grecCopyToFinStatmtLine."Financial Stat. Structure Code" := gcodCopyToFinStatmtStructCode;
                grecCopyToFinStatmtLine.Insert();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Financial Stat. Structure Code", grecCopyFromFinStatmtStructure.Code);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Financials Statement Structure")
                {
                    Caption = 'Financials Statement Structure';
                    field(gcodCopyToFinStatmtStructCode; gcodCopyToFinStatmtStructCode)
                    {
                        Caption = 'Copy To';
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Copy To field.';
                    }
                    field("grecCopyFromFinStatmtStructure.Code"; grecCopyFromFinStatmtStructure.Code)
                    {
                        Caption = 'Copy From';
                        TableRelation = "Financial Statement Structure";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Copy From field.';
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

    trigger OnPreReport()
    begin
        if grecCopyFromFinStatmtStructure.Code = '' then
            Error(txt60000, grecCopyFromFinStatmtStructure.TableCaption);

        grecCopyToFinStatmtLine.SetRange("Financial Stat. Structure Code", gcodCopyToFinStatmtStructCode);
        if not grecCopyToFinStatmtLine.IsEmpty then begin
            if not Confirm(
              StrSubstNo(txt60001, grecCopyFromFinStatmtStructure.TableCaption, gcodCopyToFinStatmtStructCode))
            then
                CurrReport.Quit();

            grecCopyToFinStatmtLine.DeleteAll();
        end;
    end;

    var
        grecCopyFromFinStatmtStructure: Record "Financial Statement Structure";
        grecCopyToFinStatmtLine: Record "Financial Statement Line";
        gcodCopyToFinStatmtStructCode: Code[20];
        txt60000: Label 'You must select the %1 to copy from';
        txt60001: Label 'Any existing lines in the %1 %2 will be deleted.\\Are you sure you want to continue?';


    procedure gfcnSetFinStatmtStructCode(pcodCopyToFinStatmtStructCode: Code[20])
    begin
        gcodCopyToFinStatmtStructCode := pcodCopyToFinStatmtStructCode;
    end;
}

