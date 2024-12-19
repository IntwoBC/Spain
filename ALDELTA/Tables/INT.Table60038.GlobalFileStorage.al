table 60038 "Global File Storage"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = ' ,RapidStart-CountryServices,RapidStart-GlobalServices';
            OptionMembers = " ","RapidStart-CountryServices","RapidStart-GlobalServices";
        }
        field(10; Blob; BLOB)
        {
        }
        field(20; "File Name"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField(Type);
    end;

    var
    //grecTempBlob: Record TempBlob;
    // gmdlFileMgt: Codeunit "File Management";


    procedure gfcnImport()
    begin
        // grecTempBlob.Init;
        // "File Name" := gmdlFileMgt.GetFileName(gmdlFileMgt.BLOBImport(grecTempBlob, ''));
        if "File Name" <> '' then begin
            // Blob := grecTempBlob.Blob;
            Modify();
        end;
    end;


    procedure gfcnExport()
    begin
        CalcFields(Blob);
        //grecTempBlob.Init;
        //grecTempBlob.Blob := Blob;
        //gmdlFileMgt.BLOBExport(grecTempBlob, "File Name", true);
    end;

    //[Scope('Internal')]
    procedure gfcnRemove()
    begin
        Clear(Blob);
        Clear("File Name");
        Modify();
    end;

    //[Scope('Internal')]
    procedure gfcnExportToTempServerFile(): Text
    var
        ltxtServerFileName: Text;
    begin
        CalcFields(Blob);
        // grecTempBlob.Init;
        //grecTempBlob.Blob := Blob;
        // ltxtServerFileName := gmdlFileMgt.ServerTempFileName(gmdlFileMgt.GetExtension("File Name"));
        // gmdlFileMgt.BLOBExportToServerFile(grecTempBlob, ltxtServerFileName);
        exit(ltxtServerFileName);
    end;
}

