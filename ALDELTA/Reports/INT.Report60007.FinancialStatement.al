report 60007 "Financial Statement"
{
    // MP 04-12-15
    // Minor label and layout adjustments (CB1 Enhancements)
    DefaultLayout = RDLC;
    RDLCLayout = './FinancialStatement.rdlc';

    Caption = 'Financial Statement';
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(gtmpFinStatLine__Start_Balance_Caption; gtxtStartBalanceCaption)
            {
            }
            column(gtmpFinStatLine__End_Balance_Caption; gtxtEndBalanceCaption)
            {
            }
            column(gtmpFinStatLine_Description; gtmpFinStatLine.Description)
            {
            }
            column(gtmpFinStatLine__Description__English__; gtmpFinStatLine."Description (English)")
            {
            }
            column(gtmpFinStatLine__Financial_Statement_Code_; gtmpFinStatLine.Code)
            {
            }
            column(gtmpFinStatLine__Start_Balance_; gtmpFinStatLine."Start Balance")
            {
            }
            column(gtmpFinStatLine__End_Balance_; gtmpFinStatLine."End Balance")
            {
            }
            column(gtmpFinStatLine__Type; Format(gtmpFinStatLine."Line Type", 0, 2))
            {
            }
            column(gtmpFinStatLine__Indentation; gtmpFinStatLine.Indentation)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    gtmpFinStatLine.FindSet()
                else
                    gtmpFinStatLine.Next();
            end;

            trigger OnPreDataItem()
            begin
                if gblnShowSummary then
                    gtmpFinStatLine.SetRange(Indentation, 0);

                SetRange(Number, 1, gtmpFinStatLine.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(gblnShowSummary; gblnShowSummary)
                {
                    Caption = 'Summary';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Summary field.';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Financial_Statement_LineCaptionLbl = 'Financial Statement';
        CurrReport_PAGENOCaptionLbl = 'Page';
        gtmpFinStatLine_DescriptionCaption = 'Description';
        gtmpFinStatLine__Description__English__Caption = 'Description (English)';
        gtmpFinStatLine__Financial_Statement_Code_Caption = 'Financial Statement Code';
    }

    var
        gtmpFinStatLine: Record "Financial Statement Line" temporary;

        gtxtStartBalanceCaption: Text[30];

        gtxtEndBalanceCaption: Text[30];
        gblnShowSummary: Boolean;


    procedure gfcnSetSource(var ptmpFinStatLine: Record "Financial Statement Line" temporary)
    begin
        if ptmpFinStatLine.FindSet() then
            repeat
                gtmpFinStatLine := ptmpFinStatLine;
                gtmpFinStatLine.Insert();
            until ptmpFinStatLine.Next() = 0;
    end;


    procedure gfcnSetCaptions(var ptxtStartBalanceCaption: Text[30]; var ptxtEndBalanceCaption: Text[30])
    begin
        gtxtStartBalanceCaption := ptxtStartBalanceCaption;
        gtxtEndBalanceCaption := ptxtEndBalanceCaption;
    end;
}

