codeunit 63000 "P:Chart of Accounts"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Page, 16, 'OnOpenPageEvent', '', false, false)]
    local procedure levtOnOpenPage(var Rec: Record "G/L Account")
    var
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";
    begin
        lmdlCompanyTypeMgt.gfcnApplyFilterGLAcc(Rec, 2);
    end;
}

