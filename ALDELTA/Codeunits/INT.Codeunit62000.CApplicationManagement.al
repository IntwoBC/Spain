codeunit 62000 "C:ApplicationManagement"
{

    trigger OnRun()
    begin
    end;

    var
        txt60000: Label 'TBREVERSAL';
        txt60001: Label 'Trial Balance Reversal';
        txt60002: Label 'IMPTOOL';
        txt60003: Label 'Import Tool';
        txt60004: Label 'GTREVERSAL';
        txt60005: Label 'GAAP/Tax Reversal';
        txt60006: Label 'Setting up company...';
        txtInternalOnly: Label 'internal-only';

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterGetDefaultRoleCenter', '', false, false)]
    // local procedure levtOnAfterGetDefaultRoleCenter(var DefaultRoleCenterID: Integer)
    // var
    //     lrecEYCoreSetup: Record "EY Core Setup";
    // beginSetup."Company Type" of
    //         lrecEYCoreSetup."Company Type"::"Top-down":
    //             DefaultRoleCenterID := 60000; // PAGE::"EY Core Main Role Center";
    //         lrecEYCoreSetup."Company Type"::"Bottom-up":
    //             DefaultRoleCenterID := 60091; // PAGE::"EY Core Local Role Center";
    //         lrecEYCoreSetup."Company Type"::"Import Tool":
    //             DefaultRoleCenterID := 60002; // PAGE::"Import Tool Role Center";
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnBeforeCompanyOpen', '', false, false)]
    // local procedure levtOnBeforeCompanyOpen()
    // begin
    //     if (CurrentClientType = CLIENTTYPE::Web) and (TenantId = txtInternalOnly) then
    //         Error('The tenant "%1" is not available for external client access.', txtInternalOnly);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterCompanyOpen', '', false, false)]
    // local procedure levtOnAfterCompanyOpen()
    // var
    //     lrecEYCoreSetup: Record "EY Core Setup";
    //     lrecGLAccount: Record "G/L Account";
    //     lrecSourceCodeSetup: Record "Source Code Setup";
    //     lrecCompany: Record Company;
    //     lrecGlobalFileStorage: Record "Global File Storage";
    //     lrecGLSetup: Record "General Ledger Setup";
    //     ldlgWindow: Dialog;
    //     lmdlConfigPackageImport: Codeunit "Config. Package - Import";
    //     ltxtServerFileName: Text;
    // begin
    //     if (not lrecEYCoreSetup.Get) and lrecGLAccount.IsEmpty then begin

    //         if not (lrecGLSetup.Get) and (not GuiAllowed) then // Called externally, intended for calls immediately after company created
    //             CODEUNIT.Run(CODEUNIT::"Company-Initialize");

    // if lrecEYCoreSetup.Get then;

    // case lrecEYCore
    //         if lrecSourceCodeSetup.Get then begin
    //             lfcnInsertSourceCode(lrecSourceCodeSetup."TB Reversal", txt60000, txt60001);
    //             lfcnInsertSourceCode(lrecSourceCodeSetup."Import Tool", txt60002, txt60003);
    //             lfcnInsertSourceCode(lrecSourceCodeSetup."GAAP/Tax Reversal", txt60004, txt60005);
    //             lrecSourceCodeSetup.Modify(true);
    //         end;

    // lrecCompany.Get(CompanyName);
    //  CASE lrecCompany."Company Type" OF
    //    lrecCompany."Company Type"::"Top-down":
    //      lrecGlobalFileStorage.SETRANGE(Type,lrecGlobalFileStorage.Type::"RapidStart-GlobalServices");
    //
    //    lrecCompany."Company Type"::"Bottom-up":
    //      lrecGlobalFileStorage.SETRANGE(Type,lrecGlobalFileStorage.Type::"RapidStart-CountryServices");
    //  END;

    // lrecGlobalFileStorage.FindFirst;
    //ltxtServerFileName := lrecGlobalFileStorage.gfcnExportToTempServerFile;

    //         if GuiAllowed then
    //             ldlgWindow.Open(txt60006);
    //        // lmdlConfigPackageImport.ImportAndApplyRapidStartPackage(ltxtServerFileName);
    //         if GuiAllowed then
    //             ldlgWindow.Close;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterGetApplicationVersion', '', false, false)]
    // local procedure levtOnAfterGetApplicationVersion(var AppVersion: Text[80])
    // var
    //     lrecObject: Record "Object";
    // begin
    //     lrecObject.Get(lrecObject.Type::Codeunit, '', CODEUNIT::"C:ApplicationManagement");
    //     AppVersion += ' ' + lrecObject."Version List";
    // end;

    local procedure lfcnInsertSourceCode(var pcodSourceCodeDefCode: Code[10]; pcodCode: Code[10]; ptxtDescription: Text[50])
    var
        lrecSourceCode: Record "Source Code";
    begin
        pcodSourceCodeDefCode := pcodCode;
        lrecSourceCode.Init();
        lrecSourceCode.Code := pcodCode;
        lrecSourceCode.Description := ptxtDescription;
        lrecSourceCode.Insert();
    end;
}

