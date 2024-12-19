codeunit 70004 "Read Data Exch. from File MY"
{
    // #MyTaxi.W1.EDD.AR01.001 19/12/2016 CCFR.SDE : Import MT940 Bank Statement Format (*.sta)
    //   Codeunit Creation

    TableNo = "Data Exch.";

    trigger OnRun()
    var
        //TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
    begin
        Rec.Init();
        // Rec."File Name" := CopyStr(FileMgt.BLOBImportWithFilter(TempBlob, ImportBankStmtTxt, '', FileFilterTxt, FileFilterExtensionTxt), 1, 250);
        // if Rec."File Name" <> '' then
        // Rec."File Content" := TempBlob.Blob;
    end;

    var
        ImportBankStmtTxt: Label 'Select a file to import';
        FileFilterTxt: Label 'All Files(*.*)|*.*|XML Files(*.xml)|*.xml|Text Files(*.txt;*.csv;*.asc;*.sta)|*.txt;*.csv;*.asc,*.nda,*.sta';
        FileFilterExtensionTxt: Label 'txt,csv,asc,xml,nda,*.asc,*.sta', Locked = true;
}

