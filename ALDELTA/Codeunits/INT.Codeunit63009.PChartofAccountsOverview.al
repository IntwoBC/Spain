codeunit 63009 "P:Chart of Accounts Overview"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Page, 634, 'OnOpenPageEvent', '', false, false)]
    local procedure levtOnOpenPage(var Rec: Record "G/L Account")
    var
        lmdlCompanyTypeManagement: Codeunit "Company Type Management";
    begin
        lmdlCompanyTypeManagement.gfcnApplyFilterGLAcc(Rec, 0);
    end;
}

