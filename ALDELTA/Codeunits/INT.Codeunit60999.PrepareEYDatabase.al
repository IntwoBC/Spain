codeunit 60999 "Prepare EY Database"
{

    trigger OnRun()
    begin
    end;

    var
        txtConfirm: Label 'Are you sure you want to initialise the database?';
        txtBlue: Label 'Blue.bmp';
        txtYellow: Label 'Yellow.bmp';
        txtRed: Label 'Red.bmp';
        txtGreen: Label 'Green.bmp';
        txtCountryRapidstart: Label 'PackageEY-COUNTRY-SERVICES-NAV2016.rapidstart';
        txtGlobalRapidstart: Label 'PackageEY-GLOBAL-SERVICES-NAV2016.rapidstart';
        txtMAINProfileID: Label 'EY-COE-MAIN';
        txtMAINProfileDesc: Label 'EY Center of Excellence Main';
        txtCountryProfileID: Label 'EY-COUNTRY-MAIN';
        txtCountryProfileDesc: Label 'EY Country Services';
        txtEYCorePermSetFile: Label 'EYCorePermissionSets.txt';
        txtEYCorePermFile: Label 'EYCorePermissions.txt';


    // procedure gfcnInitDB(ptxtWorkFolder: Text)
    // var
    //     lrecStatusColor: Record "Status Color";
    //     lrecGlobalFileStorage: Record "Global File Storage";
    //     ltmpTempBlob: Record TempBlob temporary;
    //     lrecEYCoreSetup: Record "EY Core Setup";
    //     lrecProfile: Record "Profile";
    //     lmdlFileMgt: Codeunit "File Management";
    //     lfilFile: File;
    //     listFile: InStream;
    // begin
    //     if GuiAllowed then
    //         if not Confirm(txtConfirm) then
    //             exit;

    //     lrecEYCoreSetup.Insert;

    //     lrecStatusColor.Status := lrecStatusColor.Status::Imported;
    //     lrecStatusColor.Picture.Import(ptxtWorkFolder + txtBlue);
    //     lrecStatusColor.Insert;

    //     lrecStatusColor.Status := lrecStatusColor.Status::"In Progress";
    //     lrecStatusColor.Picture.Import(ptxtWorkFolder + txtYellow);
    //     lrecStatusColor.Insert;

    //     lrecStatusColor.Status := lrecStatusColor.Status::Error;
    //     lrecStatusColor.Picture.Import(ptxtWorkFolder + txtRed);
    //     lrecStatusColor.Insert;

    //     lrecStatusColor.Status := lrecStatusColor.Status::Processed;
    //     lrecStatusColor.Picture.Import(ptxtWorkFolder + txtGreen);
    //     lrecStatusColor.Insert;

    //     lrecGlobalFileStorage.Type := lrecGlobalFileStorage.Type::"RapidStart-CountryServices";
    //     lrecGlobalFileStorage."File Name" := txtCountryRapidstart;
    //     lmdlFileMgt.BLOBImportFromServerFile(ltmpTempBlob, ptxtWorkFolder + lrecGlobalFileStorage."File Name");
    //     lrecGlobalFileStorage.Blob := ltmpTempBlob.Blob;
    //     lrecGlobalFileStorage.Insert(true);

    //     lrecGlobalFileStorage.Type := lrecGlobalFileStorage.Type::"RapidStart-GlobalServices";
    //     lrecGlobalFileStorage."File Name" := txtGlobalRapidstart;
    //     ltmpTempBlob.Init;
    //     lmdlFileMgt.BLOBImportFromServerFile(ltmpTempBlob, ptxtWorkFolder + lrecGlobalFileStorage."File Name");
    //     lrecGlobalFileStorage.Blob := ltmpTempBlob.Blob;
    //     lrecGlobalFileStorage.Insert(true);

    //     lrecProfile."Profile ID" := txtMAINProfileID;
    //     lrecProfile.Description := txtMAINProfileDesc;
    //     lrecProfile."Role Center ID" := 60000;
    //     lrecProfile.Insert(true);

    //     lrecProfile.Init;
    //     lrecProfile."Profile ID" := txtCountryProfileID;
    //     lrecProfile.Description := txtCountryProfileDesc;
    //     lrecProfile."Role Center ID" := 60091;
    //     lrecProfile.Insert(true);

    //     lrecProfile.SetRange("Default Role Center", true);
    //     if lrecProfile.FindFirst then begin
    //         lrecProfile."Default Role Center" := false;
    //         lrecProfile.Modify;
    //     end;

    //     // Import Permission Sets
    //     lfilFile.Open(ptxtWorkFolder + txtEYCorePermSetFile);
    //     lfilFile.CreateInStream(listFile);
    //     XMLPORT.Import(XMLPORT::"Import/Export Permission Sets", listFile);
    //     lfilFile.Close;

    //     lfilFile.Open(ptxtWorkFolder + txtEYCorePermFile);
    //     lfilFile.CreateInStream(listFile);
    //     XMLPORT.Import(XMLPORT::"Import/Export Permissions", listFile);
    //     lfilFile.Close;
    // end;
}

