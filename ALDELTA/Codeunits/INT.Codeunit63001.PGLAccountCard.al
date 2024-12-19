codeunit 63001 "P:G/L Account Card"
{

    trigger OnRun()
    begin
    end;

    var
        txt60000: Label 'You must specify %1 in %2 %3=%4.';

    [EventSubscriber(ObjectType::Page, 17, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure levtOnAfterValidateNo(var Rec: Record "G/L Account"; var xRec: Record "G/L Account")
    begin
        if xRec."No." = '' then // New recording being inserted
            Rec.CalcFields(BottomUp);
    end;

    [EventSubscriber(ObjectType::Page, 17, 'OnModifyRecordEvent', '', false, false)]
    local procedure levtOnOnModifyRecord(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; var AllowModify: Boolean)
    begin
        if (Rec."Financial Statement Code" = '') and (Rec."No." <> '') then
            Error(txt60000, Rec.FieldCaption("Financial Statement Code"), Rec.TableCaption, Rec.FieldCaption("No."), Rec."No.")
        else begin
            Rec.CalcFields(BottomUp, CorpAccInUse);
            if Rec.BottomUp and Rec.CorpAccInUse and (Rec."Corporate G/L Account No." = '') and (Rec."No." <> '') then
                Error(txt60000, Rec.FieldCaption("Corporate G/L Account No."), Rec.TableCaption, Rec.FieldCaption("No."), Rec."No.")
            else
                AllowModify := true;
        end;
    end;

    // [EventSubscriber(ObjectType::Page, 17, 'OnAfterValidateEvent', 'Corporate G/L Account No.', false, false)]
    // local procedure levtOnAfterValidateCorpGLAccNo(var Rec: Record "G/L Account"; var xRec: Record "G/L Account")
    // begin
    //     Rec.CalcFields("Corporate G/L Account Name");
    // end;

    // [EventSubscriber(ObjectType::Page, 17, 'OnAfterActionEvent', 'FSCodeHistory', false, false)]
    // local procedure levtOnAfterActionFSCodeHistory(var Rec: Record "G/L Account")
    // var
    //     lrecHistAccFinStatmtCode: Record "Hist. Acc. Fin. Statmt. Code";
    // begin
    //     lrecHistAccFinStatmtCode.SetRange("G/L Account Type", lrecHistAccFinStatmtCode."G/L Account Type"::"G/L Account");
    //     lrecHistAccFinStatmtCode.SetRange("G/L Account No.", Rec."No.");
    //     PAGE.RunModal(0, lrecHistAccFinStatmtCode);
    // end;
}

