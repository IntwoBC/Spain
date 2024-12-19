report 60016 "Imp. G/L Acc. Map. - Bottom-Up"
{
    Caption = 'Import G/L Account Mapping - Country Services';
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
                        group("1. Local G/L Account No.")
                        {
                            Caption = '1. Local G/L Account No.';
                        }
                        group("2. Corporate G/L Account No.")
                        {
                            Caption = '2. Corporate G/L Account No.';
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
        lfilTempFile: File;
        lfilServerFile: File;
        listFileInStream: InStream;
        ltxtFileName: Text;
        ltxtToFile: Text;
    begin
        // lfilTempFile.CreateTempFile;
        //   ltxtFileName := lfilTempFile.Name + '.txt';
        //  lfilTempFile.Close;
        //  Upload(txt60001, '', txt60002, '', ltxtFileName);

        //lfilServerFile.Open(ltxtFileName);
        //  lfilServerFile.CreateInStream(listFileInStream);

        XMLPORT.Import(XMLPORT::"G/L Acc. Mapping - Bottom-Up", listFileInStream);

        //  lfilServerFile.Close;

        CurrReport.Break();
    end;

    var
        txt60001: Label 'Import from Text File';
        txt60002: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
}

