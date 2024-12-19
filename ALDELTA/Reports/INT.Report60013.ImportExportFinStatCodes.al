report 60013 "Import/Export Fin. Stat. Codes"
{
    Caption = 'Import/Export Financial Statement Codes';
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Financial Statement Code"; "Financial Statement Code")
        {
            RequestFilterFields = "Code";
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(goptDirection; goptDirection)
                {
                    Caption = 'Direction';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Direction field.';
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
        lostFileOutStream: OutStream;
        listFileInStream: InStream;
        ltxtFileName: Text;
        ltxtToFile: Text;
    begin
        if goptDirection = goptDirection::Export then begin
            // ltxtFileName := lmdlFileMgt.ServerTempFileName('txt');

            // lfilServerFile.Create(ltxtFileName);
            //lfilServerFile.CreateOutStream(lostFileOutStream);
            // XMLPORT.Export(XMLPORT::"Financial Statement Code", lostFileOutStream, "Financial Statement Code");
            // lfilServerFile.Close;

            // ltxtToFile := txt60004;
            // Download(ltxtFileName, txt60003, '', txt60002, ltxtToFile);
            //end else begin
            // lfilTempFile.CreateTempFile;
            // ltxtFileName := lfilTempFile.Name + '.txt';
            // lfilTempFile.Close;
            // Upload(txt60001, '', txt60002, '', ltxtFileName);

            // lfilServerFile.Open(ltxtFileName);
            // lfilServerFile.CreateInStream(listFileInStream);

            // XMLPORT.Import(XMLPORT::"Financial Statement Code", listFileInStream);
            // lfilServerFile.Close;
        end;

        CurrReport.Break();
    end;

    var
        txt60001: Label 'Import from Text File';
        txt60002: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        goptDirection: Option Import,Export;
        txt60003: Label 'Export to Text File';
        txt60004: Label 'Default.txt';
}

