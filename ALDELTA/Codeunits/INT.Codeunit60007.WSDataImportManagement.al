codeunit 60007 "WS Data Import Management"
{

    trigger OnRun()
    begin
    end;

    var
        ERR_001: Label 'Unsupported Table No. %1';


    procedure Test(p_txtText: Text[1024]) r_txtText: Text[1024]
    begin
        //
        //Test function.
        //
        p_txtText := UpperCase(p_txtText);
    end;


    procedure DateRangeValid(p_datStartDate: Date; p_datEndDate: Date): Boolean
    var
        lrecUserSetup: Record "User Setup";
        lrecGeneralLedgerSetup: Record "General Ledger Setup";
       // lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        //
        // Checks if current user can post within date range
        //
        //exit(lmodDataImportManagementCommon.gfncUserPostingRangeValid(p_datStartDate, p_datEndDate, UserId));
    end;


    procedure ValidateData(p_intImportLog: BigInteger; p_intTableNo: Integer) r_blnResult: Boolean
    var
        // lrecImportLog: Record "Import Log";
        // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
        // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
        // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
        // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
        // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
    begin
        //
        // Will initiate Stage 4 validation of local data
        //
//lrecImportLog.Get(p_intImportLog);

        // case p_intTableNo of
        //     60009:
        //         r_blnResult := lmodDataImportMgt_60009.gfncValidateLocalData(lrecImportLog, false);
        //     60012:
        //         r_blnResult := lmodDataImportMgt_60012.gfncValidateLocalData(lrecImportLog, false);
        //     60018:
        //         r_blnResult := lmodDataImportMgt_60018.gfncValidateLocalData(lrecImportLog, false);
        //     60019:
        //         r_blnResult := lmodDataImportMgt_60019.gfncValidateLocalData(lrecImportLog, false);
        //     60020:
        //         r_blnResult := lmodDataImportMgt_60020.gfncValidateLocalData(lrecImportLog, false);
        //     else
        //         Error(ERR_001, p_intTableNo);
        // end;
    end;


    procedure PostTransactions(p_intImportLog: BigInteger; p_intTableNo: Integer) r_blnResult: Boolean
    var
        // lrecImportLog: Record "Import Log";
        // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
        // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
        // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
        // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
        // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
    begin
        //
        // Will initiate Stage 5 posting of transactions
        //
        //lrecImportLog.Get(p_intImportLog);

        // case p_intTableNo of
        //     60009:
        //         r_blnResult := lmodDataImportMgt_60009.gfncPostTransactions(lrecImportLog, false);
        //     60012:
        //         r_blnResult := lmodDataImportMgt_60012.gfncPostTransactions(lrecImportLog, false);
        //     60018:
        //         r_blnResult := lmodDataImportMgt_60018.gfncPostTransactions(lrecImportLog, false);
        //     60019:
        //         r_blnResult := lmodDataImportMgt_60019.gfncPostTransactions(lrecImportLog, false);
        //     60020:
        //         r_blnResult := lmodDataImportMgt_60020.gfncPostTransactions(lrecImportLog, false);
        //     else
        //         Error(ERR_001, p_intTableNo);
        // end;
    end;


    procedure DeleteEntries(p_intImportLog: BigInteger; p_intTableNo: Integer)
    var
//lmodDataImportManagementCommon: Codeunit "Data Import Management Common";
    begin
        //
        // Page does not support delete multiple
        // Therefore specific webcall
        //
        //lmodDataImportManagementCommon.gfncDeleteEntries(p_intImportLog, p_intTableNo, false);
    end;


    procedure Archive(p_intImportLog: BigInteger; p_intTableNo: Integer) r_blnResult: Boolean
    var
        // lrecImportLog: Record "Import Log";
        // lmodDataImportMgt_60009: Codeunit "Data Import Mgt 60009";
        // lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
        // lmodDataImportMgt_60018: Codeunit "Data Import Mgt 60018";
        // lmodDataImportMgt_60019: Codeunit "Data Import Mgt 60019";
        // lmodDataImportMgt_60020: Codeunit "Data Import Mgt60020";
    begin
        //
        // Will archive remote data
        //
//lrecImportLog.Get(p_intImportLog);

        // case p_intTableNo of
        //     60009:
        //         r_blnResult := lmodDataImportMgt_60009.gfncArchive(lrecImportLog, false);
        //     60012:
        //         r_blnResult := lmodDataImportMgt_60012.gfncArchive(lrecImportLog, false);
        //     60018:
        //         r_blnResult := lmodDataImportMgt_60018.gfncArchive(lrecImportLog, false);
        //     60019:
        //         r_blnResult := lmodDataImportMgt_60019.gfncArchive(lrecImportLog, false);
        //     60020:
        //         r_blnResult := lmodDataImportMgt_60020.gfncArchive(lrecImportLog, false);
        //     else
        //         Error(ERR_001, p_intTableNo);
        // end;
    end;
}

