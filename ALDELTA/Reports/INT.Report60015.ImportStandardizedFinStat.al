report 60015 "Import Standardized Fin. Stat."
{
    Caption = 'Import/Export Financial Statement Structure';
    ProcessingOnly = true;
    ApplicationArea = All;
  UsageCategory=ReportsAndAnalysis;
    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("Import from tab-separated file, must be saved as ""Text (MS-DOS)"" in Excel.")
                {
                    Caption = 'Import from tab-separated file, must be saved as "Text (MS-DOS)" in Excel.';
                    group("Columns expected:")
                    {
                        Caption = 'Columns expected:';
                        group("1. Description")
                        {
                            Caption = '1. Description';
                        }
                        group("2. Description (English)")
                        {
                            Caption = '2. Description (English)';
                        }
                        group("3. Financial Statement Code")
                        {
                            Caption = '3. Financial Statement Code';
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        lmdlFileMgt: Codeunit "File Management";
        lxmlImportStdFinStat: XMLport "Import Standardized Fin. Stat.";
        lfilTempFile: File;
        lfilServerFile: File;
        lostFileOutStream: OutStream;
        listFileInStream: InStream;
        ltxtFileName: Text;
        ltxtToFile: Text;
    begin
        //lfilTempFile.CreateTempFile;
        // ltxtFileName := lfilTempFile.Name + '.txt';
        ///  lfilTempFile.Close;
        //  Upload(txt60001, '', txt60002, '', ltxtFileName);

        // lfilServerFile.Open(ltxtFileName);
        // lfilServerFile.CreateInStream(listFileInStream);

        lxmlImportStdFinStat.SetSource(listFileInStream);
        lxmlImportStdFinStat.gfcnSetFinStatStructCode(gcodFinStatStructCode);
        lxmlImportStdFinStat.Import();

        // lfilServerFile.Close;

        CurrReport.Break();
    end;

    var
        txt60001: Label 'Import from Text File';
        txt60002: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        gcodFinStatStructCode: Code[20];


    procedure gfcnSetFinStatStructCode(pcodFinStatStructCode: Code[20])
    begin
        gcodFinStatStructCode := pcodFinStatStructCode;
    end;
}

