report 60002 "Equity Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EquityReconciliation.rdlc';
    Caption = 'Equity Reconciliation';
    ApplicationArea = All;
    UsageCategory=ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            RequestFilterHeading = 'Equity Reconciliation';
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo())
            {
            }
            column(USERID; UserId)
            {
            }
            column(Equity_Reconciliation_Line__Start_Balance_Caption; gtxtStartBalanceCaption)
            {
            }
            column(Equity_Reconciliation_Line__Net_Change_Caption; gtxtNetChangePLCaption)
            {
            }
            column(Equity_Reconciliation_Line__End_Balance_Caption; gtxtEndBalanceCaption)
            {
            }
            column(Equity_Reconciliation_Line__Net_Change_Equity_Caption; gtxtNetChangeEquityCaption)
            {
            }
            column(Equity_Reconciliation_Line_Code; gtmpEquityReconLine.Code)
            {
            }
            column(Equity_Reconciliation_Line_Description; gtmpEquityReconLine.Description)
            {
            }
            column(Equity_Reconciliation_Line_Year; gtmpEquityReconLine.Year)
            {
            }
            column(Equity_Reconciliation_Line__Start_Balance_; gtmpEquityReconLine."Start Balance")
            {
            }
            column(Equity_Reconciliation_Line__Document_No___Start_Balance__; gtmpEquityReconLine."Document No. (Start Balance)")
            {
            }
            column(Equity_Reconciliation_Line__Net_Change_; gtmpEquityReconLine."Net Change (P&L)")
            {
            }
            column(Equity_Reconciliation_Line__Document_No___Net_Change__; gtmpEquityReconLine."Document No. (Net Change)")
            {
            }
            column(Equity_Reconciliation_Line__End_Balance_; gtmpEquityReconLine."End Balance")
            {
            }
            column(Equity_Reconciliation_Line_Type; gtmpEquityReconLine.Type)
            {
            }
            column(Equity_Reconciliation_Line_Subtotal; gtmpEquityReconLine.Subtotal)
            {
            }
            column(Equity_Reconciliation_Line__Net_Change_Equity; gtmpEquityReconLine."Net Change (Equity)")
            {
            }
            column(Equity_Reconciliation_Line_EntryDescription; gtmpEquityReconLine."Entry Description")
            {
            }
            column(Equity_Reconciliation_LineCaption; Equity_Reconciliation_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_CodeCaption; Equity_Reconciliation_Line_CodeCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_DescriptionCaption; Equity_Reconciliation_Line_DescriptionCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_YearCaption; Equity_Reconciliation_Line_YearCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line__Document_No___Start_Balance__Caption; Equity_Reconciliation_Line__Document_No___Start_Balance__CaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line__Document_No___Net_Change__Caption; Equity_Reconciliation_Line__Document_No___Net_Change__CaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_TypeCaption; Equity_Reconciliation_Line_TypeCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_SubtotalCaption; Equity_Reconciliation_Line_SubtotalCaptionLbl)
            {
            }
            column(Equity_Reconciliation_Line_EntryDescriptionCaption; Equity_Reconciliation_Line_EntryDescriptionCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    gtmpEquityReconLine.FindSet()
                else
                    gtmpEquityReconLine.Next();
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, gtmpEquityReconLine.Count);
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
        gtmpEquityReconLine: Record "Equity Reconciliation Line" temporary;

        gtxtStartBalanceCaption: Text[30];

        gtxtNetChangePLCaption: Text[30];

        gtxtNetChangeEquityCaption: Text[30];

        gtxtEndBalanceCaption: Text[30];
        Equity_Reconciliation_LineCaptionLbl: Label 'Equity Reconciliation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Equity_Reconciliation_Line_CodeCaptionLbl: Label 'Label1000000009';
        Equity_Reconciliation_Line_DescriptionCaptionLbl: Label 'Label1000000012';
        Equity_Reconciliation_Line_YearCaptionLbl: Label 'Label1000000015';
        Equity_Reconciliation_Line__Document_No___Start_Balance__CaptionLbl: Label 'Label1000000021';
        Equity_Reconciliation_Line__Document_No___Net_Change__CaptionLbl: Label 'Label1000000027';
        Equity_Reconciliation_Line_TypeCaptionLbl: Label 'Label1000000033';
        Equity_Reconciliation_Line_SubtotalCaptionLbl: Label 'Label1000000036';
        Equity_Reconciliation_Line_EntryDescriptionCaptionLbl: Label 'Label1000000019';


    procedure gfcnSetSource(var ptmpEquityReconLine: Record "Equity Reconciliation Line" temporary)
    begin
        if ptmpEquityReconLine.FindSet() then
            repeat
                gtmpEquityReconLine := ptmpEquityReconLine;
                gtmpEquityReconLine.Insert();
            until ptmpEquityReconLine.Next() = 0;
    end;


    procedure gfcnSetCaptions(var ptxtStartBalanceCaption: Text[30]; var ptxtNetChangePLCaption: Text[30]; var ptxtNetChangeEquityCaption: Text[30]; var ptxtEndBalanceCaption: Text[30])
    begin
        gtxtStartBalanceCaption := ptxtStartBalanceCaption;
        gtxtNetChangePLCaption := ptxtNetChangePLCaption;
        gtxtNetChangeEquityCaption := ptxtNetChangeEquityCaption;
        gtxtEndBalanceCaption := ptxtEndBalanceCaption;
    end;
}

