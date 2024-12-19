codeunit 80100 "EYMY Progress Bar"
{
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Object created


    trigger OnRun()
    begin
    end;

    var
        ProgressBarMaxValue: Integer;
        ProgressBarCurrValue: Integer;
        ProgressBar: Dialog;
        ProgressBarLastUpdate: DateTime;
        Text001: Label 'Counter #1##########\ Total #2##########\Progress @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        ProgresBarOpened: Boolean;


    procedure Open(MaxValue: Integer; Title: Text[1024])
    begin
        ProgressBarMaxValue := MaxValue;
        ProgressBarCurrValue := 0;
        ProgressBarLastUpdate := 0DT;
        if GuiAllowed then begin
            ProgressBar.Open(Title + '\' + Text001);
            ProgressBar.Update(1, '0');
            ProgressBar.Update(2, Format(MaxValue));
            ProgresBarOpened := true;
            ProgressBarLastUpdate := CurrentDateTime;
        end;
    end;


    procedure Update()
    var
        CurrDT: DateTime;
    begin
        ProgressBarCurrValue += 1;
        CurrDT := CurrentDateTime;
        if ProgresBarOpened then
            if CurrDT - ProgressBarLastUpdate > 500 then begin
                ProgressBar.Update(1, ProgressBarCurrValue);
                ProgressBar.Update(3, Round(ProgressBarCurrValue / ProgressBarMaxValue * 10000, 1));
                ProgressBarLastUpdate := CurrentDateTime;
            end;
    end;


    procedure Close()
    begin
        if ProgresBarOpened then
            ProgressBar.Close();
    end;
}

