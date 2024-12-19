report 60014 "Import/Export Fin. Stat. Struc"
{
    Caption = 'Import/Export Financial Statement Structure';
    ProcessingOnly = true;
    ApplicationArea = All;
 UsageCategory=ReportsAndAnalysis;
    dataset
    {
        dataitem("Financial Statement Structure"; "Financial Statement Structure")
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
            // ltxtFileName := lmdlFileMgt.ServerTempFileName('xml');

            //  lfilServerFile.Create(ltxtFileName);
            //   lfilServerFile.CreateOutStream(lostFileOutStream);
            XMLPORT.Export(XMLPORT::"Financial Statement Structure", lostFileOutStream, "Financial Statement Structure");
            // lfilServerFile.Close;

            ltxtToFile := txt60004;
            //  Download(ltxtFileName, txt60003, '', txt60002, ltxtToFile);
        end else begin
            // lfilTempFile.CreateTempFile;
            // ltxtFileName := lfilTempFile.Name + '.xml';
            // lfilTempFile.Close;
            // Upload(txt60001, '', txt60002, '', ltxtFileName);

            //  lfilServerFile.Open(ltxtFileName);
            // lfilServerFile.CreateInStream(listFileInStream);

            XMLPORT.Import(XMLPORT::"Financial Statement Structure", listFileInStream);
            // lfilServerFile.Close;
        end;

        CurrReport.Break();
    end;

    var
        txt60001: Label 'Import from XML File';
        txt60002: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
        goptDirection: Option Import,Export;
        txt60003: Label 'Export to XML File';
        txt60004: Label 'Default.xml';
}

