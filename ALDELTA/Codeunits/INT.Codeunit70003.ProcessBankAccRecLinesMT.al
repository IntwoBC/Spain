codeunit 70003 "Process Bank Acc. Rec Lines MT"
{
    // #MyTaxi.W1.EDD.AR01.001 19/12/2016 CCFR.SDE : Import MT940 Bank Statement Format (*.sta)
    //   Codeunit Creation

    Permissions = TableData "Data Exch." = rimd;
    TableNo = "Bank Acc. Reconciliation Line";

    trigger OnRun()
    var
        DataExch: Record "Data Exch.";
        ProcessDataExch: Codeunit "Process Data Exch.";
        RecRef: RecordRef;
    begin
        BankAccReconciliationLine := Rec;
        DataExch.Get(Rec."Data Exch. Entry No.");
        RecRef.GetTable(Rec);
        ProcessAllLinesColumnMapping(DataExch, RecRef, Rec);
    end;

    var
        ProgressWindowMsg: Label 'Please wait while the operation is being completed.';
        MissingValueErr: Label 'The file that you are trying to import, %1, is different from the specified %2, %3.\\The value in line %4, column %5 is missing.', Comment = '%1=File Name;%2=Data Exch.Def Type;%3=Data Exch. Def Code;%4=Line No;%5=Column No';
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccount: Record "Bank Account";
        SystemVariableFunctions: Codeunit "Type Helper";
        DateParseErr: Label 'Could not read a date from text ''%1'' using format %2.', Comment = '%1=a string representing a date like 081001,%2=a string representing a format like yyMMdd';
        TransformedValue: Text;
        Tag: Code[10];
        SubTag: Code[10];
        Shift: Integer;
        ImpOpeningAccountNo: Text[35];
        ImpLineDescription: Text[100];
        ImpOpeningDebCred: Code[1];
        ImpLineDebCred: Code[1];
        ImpClosingDebCred: Code[1];
        ImpOpeningCurrencyCode: Code[10];
        ImpClosingCurrencyCode: Code[10];
        FirstDocNo: Code[20];
        LastDocNo: Code[20];
        ImpOpeningPrevDate: Date;
        ImpLineCurrencyDate: Date;
        ImpClosingLastDate: Date;
        ImpOpeningBalance: Decimal;
        ImpLineAmount: Decimal;
        ImpClosingBalance: Decimal;
        ImpLineDescriptionCount: Integer;
        LineNo: Integer;
        DescriptionBelongsToLine: Boolean;
        AutoReconciliation: Boolean;
        Text1000021: Label 'Invalid character %1 on import line. D(ebit) or C(redit) was expected.';


    procedure ProcessColumnMapping(DataExch: Record "Data Exch."; DataExchLineDef: Record "Data Exch. Line Def"; RecRefTemplate: RecordRef; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        DataExchField: Record "Data Exch. Field";
        DataExchFieldGroupByLineNo: Record "Data Exch. Field";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        TempFieldIdsToNegate: Record "Integer" temporary;
        RecRef: RecordRef;
        LastKeyFieldId: Integer;
        LineNoOffset: Integer;
        CurrLineNo: Integer;
    begin
        LastKeyFieldId := GetLastIntegerKeyField(RecRefTemplate);
        LineNoOffset := GetLastKeyValueInRange(RecRefTemplate, LastKeyFieldId);

        DataExchMapping.Get(DataExch."Data Exch. Def Code", DataExchLineDef.Code, RecRefTemplate.Number);

        DataExchFieldMapping.SetRange("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        DataExchFieldMapping.SetRange("Data Exch. Line Def Code", DataExchLineDef.Code);
        DataExchFieldMapping.SetRange("Table ID", RecRefTemplate.Number);

        DataExchField.SetRange("Data Exch. No.", DataExch."Entry No.");
        DataExchField.SetRange("Data Exch. Line Def Code", DataExchLineDef.Code);

        DataExchFieldGroupByLineNo.SetRange("Data Exch. No.", DataExch."Entry No.");
        DataExchFieldGroupByLineNo.SetRange("Data Exch. Line Def Code", DataExchLineDef.Code);
        DataExchFieldGroupByLineNo.Ascending(true);
        if not DataExchFieldGroupByLineNo.FindSet() then
            exit;

        repeat
            if DataExchFieldGroupByLineNo."Line No." <> CurrLineNo then begin
                CurrLineNo := DataExchFieldGroupByLineNo."Line No.";

                RecRef := RecRefTemplate.Duplicate();
                if (DataExchMapping."Data Exch. No. Field ID" <> 0) and (DataExchMapping."Data Exch. Line Field ID" <> 0) then begin
                    SetFieldValue(RecRef, DataExchMapping."Data Exch. No. Field ID", DataExch."Entry No.");
                    SetFieldValue(RecRef, DataExchMapping."Data Exch. Line Field ID", CurrLineNo);
                end;
                SetFieldValue(RecRef, LastKeyFieldId, CurrLineNo * 10000 + LineNoOffset);
                DataExchFieldMapping.FindSet();
                repeat
                    DataExchField.SetRange("Line No.", CurrLineNo);
                    DataExchField.SetRange("Column No.", DataExchFieldMapping."Column No.");
                    if DataExchField.FindSet() then
                        repeat
                            SetField(RecRef, DataExchFieldMapping, DataExchField, TempFieldIdsToNegate)
                        until DataExchField.Next() = 0;
                /*ELSE
                  IF NOT DataExchFieldMapping.Optional THEN
                    ERROR(
                      MissingValueErr,DataExch."File Name",GetType(DataExch."Data Exch. Def Code"),
                      DataExch."Data Exch. Def Code",CurrDataExchField.ValueNo,DataExchFieldMapping."Column No.");*/
                until DataExchFieldMapping.Next() = 0;

                //NegateAmounts(RecRef,TempFieldIdsToNegate);

                //RecRef.INSERT;
            end;
        until DataExchFieldGroupByLineNo.Next() = 0;

    end;


    procedure ProcessAllLinesColumnMapping(DataExch: Record "Data Exch."; RecRef: RecordRef; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        DataExchLineDef: Record "Data Exch. Line Def";
    begin
        DataExchLineDef.SetRange("Data Exch. Def Code", DataExch."Data Exch. Def Code");
        if DataExchLineDef.FindSet() then
            repeat
                ProcessColumnMapping(DataExch, DataExchLineDef, RecRef, BankAccReconciliationLine);
            until DataExchLineDef.Next() = 0;
    end;

    local procedure ProcessLine()
    begin
        //BankAccReconciliationLine.SETRANGE("Statement Type",BankAccReconciliationLine."Statement Type");
        //BankAccReconciliationLine.SETRANGE("Bank Account No.",BankAccReconciliationLine."Bank Account No.");
        //BankAccReconciliationLine.SETRANGE("Statement No.",BankAccReconciliationLine."Statement No.");
        //MESSAGE(FORMAT(BankAccReconciliationLine.COUNT));
        //BankAccReconciliationLine.FINDLAST;
        BankAccReconciliationLine."Statement Type" := BankAccReconciliationLine."Statement Type";
        BankAccReconciliationLine."Bank Account No." := BankAccReconciliationLine."Bank Account No.";
        BankAccReconciliationLine."Statement No." := BankAccReconciliationLine."Statement No.";
        BankAccReconciliationLine."Statement Line No." := BankAccReconciliationLine."Statement Line No." + 10000;
        BankAccount.Get(BankAccReconciliationLine."Bank Account No.");
        if ImpOpeningAccountNo <> BankAccount."Bank Account No." then
            exit;

        BankAccReconciliationLine.Init();

        BankAccReconciliationLine.Validate("Transaction Date", ImpLineCurrencyDate);
        case ImpLineDebCred of
            'D':
                BankAccReconciliationLine.Validate("Statement Amount", -ImpLineAmount);
            'C':
                BankAccReconciliationLine.Validate("Statement Amount", ImpLineAmount);
            else
                Error(Text1000021, ImpLineDebCred);
        end;

        BankAccReconciliationLine.Insert(true);
    end;


    procedure SetField(RecRef: RecordRef; DataExchFieldMapping: Record "Data Exch. Field Mapping"; var DataExchField: Record "Data Exch. Field"; var TempFieldIdsToNegate: Record "Integer" temporary)
    var
        DataExchColumnDef: Record "Data Exch. Column Def";
        TransformationRule: Record "Transformation Rule";
        FieldRef: FieldRef;
        Position: Integer;
        SubFieldText: Text;
    begin
        DataExchColumnDef.Get(
          DataExchFieldMapping."Data Exch. Def Code",
          DataExchFieldMapping."Data Exch. Line Def Code",
          DataExchField."Column No.");

        FieldRef := RecRef.Field(DataExchFieldMapping."Field ID");

        TransformedValue := DelChr(DataExchField.Value, '>'); // We shoud use the trim transformation rule instead of this
        if TransformationRule.Get(DataExchFieldMapping."Transformation Rule") then
            TransformedValue := TransformationRule.TransformText(DataExchField.Value);

        Tag := FindTag(DataExchField.Value);

        case Tag of
            '25': // Account identification
                begin
                    //ImpOpeningAccountNo := DELCHR(GetText(DataExchField.Value,5,35),'<','0');
                    ImpOpeningAccountNo := CopyStr(DataExchField.Value, StrPos(DataExchField.Value, '/') + 1, MaxStrLen(ImpOpeningAccountNo));
                    ImpOpeningAccountNo := CopyStr(ImpOpeningAccountNo, 1, StrLen(ImpOpeningAccountNo) - 3);
                    ImpOpeningDebCred := '';
                    ImpOpeningPrevDate := 0D;
                    ImpOpeningCurrencyCode := '';
                    ImpOpeningBalance := 0;
                    ImpClosingDebCred := '';
                    ImpClosingLastDate := 0D;
                    ImpClosingCurrencyCode := '';
                    ImpClosingBalance := 0;

                    //CLEAR(CBGStatement);
                    //CLEAR(CBGStatementDataExchField.Value);
                end;
            '60F', '60M': // Last delivery; message continued
                begin
                    ImpOpeningDebCred := GetText(DataExchField.Value, 6, 1);
                    ImpOpeningPrevDate := GetDate(DataExchField.Value, 7, 6, 'yyMMdd');
                    ImpOpeningCurrencyCode := GetText(DataExchField.Value, 13, 3);
                    ImpOpeningBalance := GetDecimal(DataExchField.Value, 16, 16, ',');
                    //ProcessHeader;
                end;
            '61': // Statement DataExchField.Value
                begin
                    Shift := 0;
                    ImpLineCurrencyDate := GetDate(DataExchField.Value, 5, 6, 'yyMMdd');
                    ImpLineDebCred := GetText(DataExchField.Value, 11, 1);
                    if not (ImpLineDebCred in ['D', 'C']) then begin
                        Shift := 4;
                        ImpLineDebCred := GetText(DataExchField.Value, 11 + Shift, 1);
                    end;
                    if UpperCase(GetText(DataExchField.Value, 12 + Shift, 1)) in ['A' .. 'Z'] then
                        Shift := Shift + 1;
                    ImpLineAmount := GetDecimal(DataExchField.Value, 12 + Shift, 16, ',');
                    ImpLineDescription := '';
                    ImpLineDescriptionCount := 0;
                    ProcessLine();
                    DescriptionBelongsToLine := true;
                end;
            '86', 'REM': // Description
                begin
                    ImpLineDescriptionCount := ImpLineDescriptionCount + 1;
                    case Tag = 'REM' of
                        true:
                            ImpLineDescription := GetText(DataExchField.Value, 1, 65);
                        false:
                            ImpLineDescription := GetText(DataExchField.Value, 5, 65);
                    end;
                    Position := StrPos(ImpLineDescription, '?');
                    while Position <> 0 do begin
                        ImpLineDescription := DelStr(ImpLineDescription, 1, Position);
                        SubTag := GetText(ImpLineDescription, 1, 2);
                        Position := StrPos(ImpLineDescription, '?');
                        if Position > 3 then
                            SubFieldText := GetText(ImpLineDescription, 3, Position - 3)
                        else
                            SubFieldText := GetText(ImpLineDescription, 3, MaxStrLen(ImpLineDescription));
                        case SubTag of
                            '20':
                                begin
                                    BankAccReconciliationLine.Validate(Description, SubFieldText);
                                    BankAccReconciliationLine.Validate("Document No.", CopyStr(SubFieldText, StrPos(SubFieldText, '+') + 1, MaxStrLen(BankAccReconciliationLine."Document No.")));
                                    BankAccReconciliationLine.Validate("Transaction Text", DelStr(SubFieldText, 1, StrPos(SubFieldText, '+') + 1));
                                end;
                            '23':
                                begin
                                    BankAccReconciliationLine."Transaction Text" := SubFieldText;
                                end;
                            '32':
                                BankAccReconciliationLine.Validate("Related-Party Name", SubFieldText);
                        end;
                        if ImpOpeningAccountNo = BankAccount."Bank Account No." then
                            BankAccReconciliationLine.Modify(true);
                    end;
                    //ProcessComment;
                end;
            '62F', '62M': // Closing balance
                begin
                    ImpClosingDebCred := GetText(DataExchField.Value, 6, 1);
                    ImpClosingLastDate := GetDate(DataExchField.Value, 7, 6, 'yyMMdd');
                    ImpClosingCurrencyCode := GetText(DataExchField.Value, 13, 3);
                    ImpClosingBalance := GetDecimal(DataExchField.Value, 16, 16, ',');
                    //ProcessClosingBalance;
                    DescriptionBelongsToLine := false;
                end;
        end;

        /*CASE FORMAT(FieldRef.TYPE) OF
          'Text',
          'Code':
            SetAndMergeTextCodeField(TransformedValue,FieldRef);
          'Date':
            SetDateDecimalField(TransformedValue,DataExchField,FieldRef,DataExchColumnDef);
          'Decimal':
            IF DataExchColumnDef."Negative-Sign Identifier" = '' THEN BEGIN
              SetDateDecimalField(TransformedValue,DataExchField,FieldRef,DataExchColumnDef);
              AdjustDecimalWithMultiplier(FieldRef,DataExchFieldMapping.Multiplier,FieldRef.VALUE);
            END ELSE
              IF DataExchColumnDef."Negative-Sign Identifier" = DataExchField.Value THEN
                SaveNegativeSignForField(DataExchFieldMapping."Field ID",TempFieldIdsToNegate);
          ELSE
            ERROR(DataTypeNotSupportedErr,DataExchColumnDef.Description,DataExchFieldMapping."Data Exch. Def Code",FieldRef.TYPE);
        END;
        FieldRef.VALIDATE;
        */

    end;

    local procedure SetFieldValue(RecRef: RecordRef; FieldID: Integer; Value: Variant)
    var
        FieldRef: FieldRef;
    begin
        if FieldID = 0 then
            exit;
        FieldRef := RecRef.Field(FieldID);
        FieldRef.Validate(Value);
    end;

    local procedure GetLastIntegerKeyField(RecRef: RecordRef): Integer
    var
        KeyRef: KeyRef;
        FieldRef: FieldRef;
    begin
        KeyRef := RecRef.KeyIndex(1);
        FieldRef := KeyRef.FieldIndex(KeyRef.FieldCount);
        if Format(FieldRef.Type) <> 'Integer' then
            exit(0);

        exit(FieldRef.Number);
    end;

    local procedure GetLastKeyValueInRange(RecRefTemplate: RecordRef; FieldId: Integer): Integer
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef := RecRefTemplate.Duplicate();
        SetKeyAsFilter(RecRef);
        FieldRef := RecRef.Field(FieldId);
        FieldRef.SetRange();
        if RecRef.FindLast() then
            exit(RecRef.Field(FieldId).Value);
        exit(0);
    end;

    local procedure SetKeyAsFilter(var RecRef: RecordRef)
    var
        KeyRef: KeyRef;
        FieldRef: FieldRef;
        i: Integer;
    begin
        KeyRef := RecRef.KeyIndex(1);
        for i := 1 to KeyRef.FieldCount do begin
            FieldRef := RecRef.Field(KeyRef.FieldIndex(i).Number);
            FieldRef.SetRange(FieldRef.Value);
        end
    end;

    local procedure FindTag(Line: Text[1024]) Tag: Code[10]
    var
        Position: Integer;
    begin
        Tag := GetText(Line, 1, MaxStrLen(Tag));
        LineNo := LineNo + 1;

        if LineNo <= 3 then
            if DelChr(CopyStr(Tag, 1, 4), '=') in ['0000', '940'] then
                exit('START');

        case Tag[1] of
            '{':
                exit('START');
            '-':
                exit('STOP');
            ':':
                begin
                    Tag := DelStr(Tag, 1, 1);
                    Position := StrPos(Tag, ':');
                    if Position > 0 then
                        Tag := DelStr(Tag, Position)
                    else
                        exit('REM');
                    if StrLen(Tag) > 3 then
                        exit('REM');
                end;
            else
                exit('REM');
        end;
    end;


    procedure GetDate(String: Text; Position: Integer; Length: Integer; ExpectedFormat: Text) Result: Date
    var
        DateString: Text;
        DateVar: Variant;
    begin
        DateVar := 0D;
        DateString := GetText(String, Position, Length);
        if not SystemVariableFunctions.Evaluate(DateVar, DateString, ExpectedFormat, '') then
            Error(DateParseErr, DateString, ExpectedFormat);
        Result := DateVar;
    end;


    procedure GetText(String: Text[1024]; Position: Integer; Length: Integer): Text[1024]
    begin
        exit(DelChr(CopyStr(String, Position, Length), '<>'));
    end;


    procedure GetDecimal(String: Text[1024]; Position: Integer; Length: Integer; DecimalSeparator: Code[1]) Result: Decimal
    var
        DecimalText: Text[30];
        DecimalTextBeforeComma: Text[30];
        DecimalTextAfterComma: Text[30];
        DecimalBeforeComma: Decimal;
        DecimalAfterComma: Decimal;
        CommaPosition: Integer;
        DecimalVar: Variant;
    begin
        DecimalText := GetText(String, Position, Length);

        Position := 1;
        while DecimalText[Position] in ['0' .. '9', DecimalSeparator[1]] do
            Position := Position + 1;

        DecimalText := CopyStr(DecimalText, 1, Position - 1);
        CommaPosition := StrPos(DecimalText, DecimalSeparator);

        if CommaPosition > 0 then begin
            DecimalTextBeforeComma := CopyStr(DecimalText, 1, CommaPosition - 1);
            DecimalTextAfterComma := DelStr(DecimalText, 1, CommaPosition);
        end else begin
            DecimalTextBeforeComma := DecimalText;
            DecimalTextAfterComma := '0';
        end;

        if DecimalTextAfterComma = '' then
            DecimalTextAfterComma := '0';
        if DecimalTextBeforeComma = '' then
            DecimalTextBeforeComma := '0';

        Evaluate(DecimalBeforeComma, DecimalTextBeforeComma);
        Evaluate(DecimalAfterComma, DecimalTextAfterComma);

        exit(DecimalBeforeComma + Power(0.1, StrLen(DecimalTextAfterComma)) * DecimalAfterComma);
    end;
}

