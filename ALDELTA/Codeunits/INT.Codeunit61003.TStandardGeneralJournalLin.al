codeunit 61003 "T:Standard General Journal Lin"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 751, 'OnBeforeValidateEvent', 'Corporate G/L Account No.', false, false)]
    local procedure levtOnBeforeValidateCorporateGLAccountNo(var Rec: Record "Standard General Journal Line"; var xRec: Record "Standard General Journal Line"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
    begin
        if not lfcnIsBottomUp() then begin
            if Rec."Corporate G/L Account No." <> '' then begin
                lrecCorpGLAcc.Get(Rec."Corporate G/L Account No.");
                lrecCorpGLAcc.TestField("Local G/L Account No.");

                Rec.Validate("Account Type", Rec."Account Type"::"G/L Account");
                Rec.Validate("Account No.", lrecCorpGLAcc."Local G/L Account No.");
            end
        end else
            if Rec."Corporate G/L Account No." <> '' then begin
                Rec.Validate("Account Type", Rec."Account Type"::"G/L Account");

                lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
                lrecGLAcc.SetRange("Corporate G/L Account No.", Rec."Corporate G/L Account No.");
                if lrecGLAcc.Count = 1 then begin
                    lrecGLAcc.FindFirst();
                    Rec.Validate("Account No.", lrecGLAcc."No.");
                end else
                    Rec.Validate("Account No.", '');
            end;
    end;

    [EventSubscriber(ObjectType::Table, 751, 'OnBeforeValidateEvent', 'Bal. Corporate G/L Account No.', false, false)]
    local procedure levtOnBeforeValidateBalCorporateGLAccountNo(var Rec: Record "Standard General Journal Line"; var xRec: Record "Standard General Journal Line"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
        lrecGLAcc: Record "G/L Account";
    begin
        if not lfcnIsBottomUp() then begin
            if Rec."Bal. Corporate G/L Account No." <> '' then begin
                lrecCorpGLAcc.Get(Rec."Bal. Corporate G/L Account No.");
                lrecCorpGLAcc.TestField("Local G/L Account No.");

                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");
                Rec.Validate("Bal. Account No.", lrecCorpGLAcc."Local G/L Account No.");
            end
        end else
            if Rec."Bal. Corporate G/L Account No." <> '' then begin
                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");

                lrecGLAcc.SetCurrentKey("Corporate G/L Account No.");
                lrecGLAcc.SetRange("Corporate G/L Account No.", Rec."Bal. Corporate G/L Account No.");
                if lrecGLAcc.Count = 1 then begin
                    lrecGLAcc.FindFirst();
                    Rec.Validate("Bal. Account No.", lrecGLAcc."No.");
                end else
                    Rec.Validate("Bal. Account No.", '');
            end;
    end;

    local procedure lfcnIsBottomUp(): Boolean
    var
        lrecEYCoreSetup: Record "EY Core Setup";
    begin
        lrecEYCoreSetup.Get();
        exit(lrecEYCoreSetup."Company Type" = lrecEYCoreSetup."Company Type"::"Bottom-up");
    end;
}

