codeunit 60015 "Corporate G/L Account-Indent"
{

    trigger OnRun()
    begin
        if not
           Confirm(
             Text000 +
             Text001 +
             Text002 +
             Text003, true)
        then
            exit;

        Indent();
    end;

    var
        Text000: Label 'This function updates the indentation of all the corporate G/L accounts in the chart of accounts. ';
        Text001: Label 'All accounts between a Begin-Total and the matching End-Total are indented one level. ';
        Text002: Label 'The Totaling for each End-total is also updated.';
        Text003: Label '\\Do you want to indent the chart of accounts?';
        Text004: Label 'Indenting the Corporate Chart of Accounts #1##########';
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        lrecCorpGLAcc: Record "Corporate G/L Account";
        Window: Dialog;
        AccNo: array[10] of Code[20];
        i: Integer;


    procedure Indent()
    begin
        Window.Open(Text004);

        if lrecCorpGLAcc.Find('-') then
            repeat
                Window.Update(1, lrecCorpGLAcc."No.");

                if lrecCorpGLAcc."Account Type" = lrecCorpGLAcc."Account Type"::"End-Total" then begin
                    if i < 1 then
                        Error(
                          Text005,
                          lrecCorpGLAcc."No.");
                    lrecCorpGLAcc.Totaling := AccNo[i] + '..' + lrecCorpGLAcc."No.";
                    i := i - 1;
                end;

                lrecCorpGLAcc.Indentation := i;
                lrecCorpGLAcc.Modify();

                if lrecCorpGLAcc."Account Type" = lrecCorpGLAcc."Account Type"::"Begin-Total" then begin
                    i := i + 1;
                    AccNo[i] := lrecCorpGLAcc."No.";
                end;
            until lrecCorpGLAcc.Next() = 0;

        Window.Close();
    end;
}

