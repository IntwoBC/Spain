codeunit 61001 "T:G/L Account"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnAfterModifyEvent', '', false, false)]
    local procedure levtOnAfterModify(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; RunTrigger: Boolean)
    var
//lmdlFSCodeMgt: Codeunit "Fin. Stmt. Code Management";
    begin
        //lmdlFSCodeMgt.gfcnUpdateGLAccFSCodeAndHistory(Rec, xRec."Financial Statement Code");
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeValidateEvent', 'Account Class', false, false)]
    local procedure levtOnBeforeValidateAccountClass(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        if Rec."Account Class" <> Rec."Account Class"::" " then
            if Rec."Account Class" = Rec."Account Class"::"P&L" then
                Rec.Validate("Income/Balance", Rec."Income/Balance"::"Income Statement")
            else
                Rec.Validate("Income/Balance", Rec."Income/Balance"::"Balance Sheet");
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnBeforeValidateEvent', 'Corporate G/L Account No.', false, false)]
    local procedure levtOnBeforeValidateCorporateGLAccountNo(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; CurrFieldNo: Integer)
    var
        lrecCorpGLAcc: Record "Corporate G/L Account";
    begin
        if Rec."Corporate G/L Account No." <> '' then begin
            lrecCorpGLAcc.Get(Rec."Corporate G/L Account No.");
            lrecCorpGLAcc.TestField("Account Class", Rec."Account Class");
            lrecCorpGLAcc.TestField("Financial Statement Code", Rec."Financial Statement Code");
        end;
    end;


    procedure gfcnGetFinancialStatementCode(var precRec: Record "G/L Account"; pdateDate: Date): Code[10]
    var
        lrecHistAccFinStatmtCode: Record "Hist. Acc. Fin. Statmt. Code";
    begin
        lrecHistAccFinStatmtCode.SetRange("G/L Account Type", lrecHistAccFinStatmtCode."G/L Account Type"::"G/L Account");
        lrecHistAccFinStatmtCode.SetRange("G/L Account No.", precRec."No.");
        lrecHistAccFinStatmtCode.SetFilter("Starting Date", '..%1', pdateDate);
        lrecHistAccFinStatmtCode.SetFilter("Ending Date", '%1..', pdateDate);
        if lrecHistAccFinStatmtCode.FindLast() then
            exit(lrecHistAccFinStatmtCode."Financial Statement Code");

        exit(precRec."Financial Statement Code");
    end;
}

