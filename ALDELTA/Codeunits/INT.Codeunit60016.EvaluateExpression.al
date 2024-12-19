codeunit 60016 "Evaluate Expression"
{

    trigger OnRun()
    var
        lvarResult: Variant;
    begin
        //lvarResult := gdotEvaluate.Compute(gtxtExpression, '');

        if lvarResult.IsDecimal then
            gdecResult := lvarResult;
    end;

    var
        //gdotEvaluate: DotNet DataTable;
        gtxtExpression: Text[1024];
        gdecResult: Decimal;


    procedure gfcnInit()
    begin
        // if IsNull(gdotEvaluate) then
        //     gdotEvaluate := gdotEvaluate.DataTable('temp');
    end;


    procedure gfcnSetExpression(ptxtExpression: Text[1024])
    begin
        gtxtExpression := ptxtExpression;
        gdecResult := 0;
    end;


    procedure gfcnGetResult(): Decimal
    begin
        exit(gdecResult);
    end;


    procedure gfcnGetErrorMessage() rtxtErrorMessage: Text[1024]
    var
        ltxtErrorMsgGeneral: Text[1024];
        ltxtErrorMsgDivZero: Text[1024];
    begin
        rtxtErrorMessage := GetLastErrorText;

        ltxtErrorMsgGeneral := 'The call to member Compute failed: ';
        ltxtErrorMsgDivZero := 'Attempted to divide by zero';

        if StrPos(rtxtErrorMessage, ltxtErrorMsgDivZero) > 0 then // Ignore division by zero error
            rtxtErrorMessage := ''
        else
            if StrPos(rtxtErrorMessage, ltxtErrorMsgGeneral) > 0 then
                rtxtErrorMessage := CopyStr(rtxtErrorMessage,
                  StrPos(rtxtErrorMessage, ltxtErrorMsgGeneral) + StrLen(ltxtErrorMsgGeneral))
    end;
}

