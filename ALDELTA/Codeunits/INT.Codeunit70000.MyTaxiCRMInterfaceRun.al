codeunit 70000 "MyTaxi CRM Interface Run"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Codeunit Creation
    // #MyTaxi.W1.CRE.INT01.013 05/12/2018 CCFR.SDE : New update and Deployment

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        case Rec."Parameter String" of
            'GET CUSTOMERS':
                begin
                    ClearLastError();
                    Clear(MyTaxiCRMInterfaceWS);
                    MyTaxiCRMInterfaceSetup.Get();
                    // MyTaxiCRMInterfaceWS.SetParams(InterfaceType::Customers, FlowType::Import, MyTaxiCRMInterfaceRecords);
                    if not MyTaxiCRMInterfaceWS.GetMasterData(MyTaxiCRMInterfaceSetup."Master Data Last Max Date", Today) then begin
                        MyTaxiCRMInterfaceLogs.SetError(MyTaxiCRMInterfaceLogs."Interface Code"::Customer, MyTaxiCRMInterfaceLogs.Type::Error, 0, '',
                                          CopyStr(GetLastErrorText, 1, 250), CopyStr(GetLastErrorText, 251, 250),
                                          CODEUNIT::"MyTaxi CRM Interface WS", MyTaxiCRMInterfaceLogs."Flow Type"::Import, '', UserId, '');
                    end;
                    Commit();
                end;
            'GET INVOICES':
                begin
                    ClearLastError();
                    Clear(MyTaxiCRMInterfaceWS);
                    // MyTaxiCRMInterfaceWS.SetParams(InterfaceType::"Sales Invoice", FlowType::Import, MyTaxiCRMInterfaceRecords);
                    if not MyTaxiCRMInterfaceWS.Run() then begin
                        MyTaxiCRMInterfaceLogs.SetError(MyTaxiCRMInterfaceLogs."Interface Code"::Customer, MyTaxiCRMInterfaceLogs.Type::Error, 0, '',
                                          CopyStr(GetLastErrorText, 1, 250), CopyStr(GetLastErrorText, 251, 250),
                                          CODEUNIT::"MyTaxi CRM Interface WS", MyTaxiCRMInterfaceLogs."Flow Type"::Import, '', UserId, '');
                    end;
                    Commit();
                end;
            'PROCESS CUSTOMERS':
                begin
                    MyTaxiCRMInterfaceRecords.Reset();
                    MyTaxiCRMInterfaceRecords.SetCurrentKey("Transfer Date", "Process Status");
                    MyTaxiCRMInterfaceRecords.SetRange("Transfer Date", 0D);
                    MyTaxiCRMInterfaceRecords.SetRange("Interface Type", MyTaxiCRMInterfaceRecords."Interface Type"::Customer);
                    MyTaxiCRMInterfaceRecords.SetRange("Process Status", MyTaxiCRMInterfaceRecords."Process Status"::Error);
                    MyTaxiCRMInterfaceRecords.SetFilter("Process Status Description", '%1|%2', Error70000, Error70001);
                    if MyTaxiCRMInterfaceRecords.FindSet() then begin
                        repeat
                            MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::" ";
                            MyTaxiCRMInterfaceRecords."Process Status Description" := '';
                            MyTaxiCRMInterfaceRecords.Modify();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                        Commit();
                    end;
                    MyTaxiCRMInterfaceRecords.Reset();
                    MyTaxiCRMInterfaceRecords.SetCurrentKey("Transfer Date", "Process Status");
                    MyTaxiCRMInterfaceRecords.SetRange("Transfer Date", 0D);
                    MyTaxiCRMInterfaceRecords.SetRange("Interface Type", MyTaxiCRMInterfaceRecords."Interface Type"::Customer);
                    MyTaxiCRMInterfaceRecords.SetRange("Process Status", MyTaxiCRMInterfaceRecords."Process Status"::" ");
                    if MyTaxiCRMInterfaceRecords.FindSet() then
                        repeat
                            ClearLastError();
                            Clear(MyTaxiCRMInterfaceProcess);
                            MyTaxiCRMInterfaceProcess.SetParams(InterfaceType::Customers, MyTaxiCRMInterfaceRecords);
                            if not MyTaxiCRMInterfaceProcess.Run() then begin
                                /*RecLogbook.SetError(RecLogbook."Interface Code"::Vendors,RecLogbook.Type::Error,0,'',
                                                 COPYSTR(GETLASTERRORTEXT,1,250),
                                                 CODEUNIT::Codeunit81701,RecLogbook."Flow type"::Import,'');*/
                                MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::Error;
                                MyTaxiCRMInterfaceRecords."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
                                MyTaxiCRMInterfaceRecords.Modify();
                            end;
                            Commit();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                end;
            'PROCESS SALES DOCUMENTS':
                begin
                    MyTaxiCRMInterfaceRecords.Reset();
                    MyTaxiCRMInterfaceRecords.SetCurrentKey("Transfer Date", "Process Status");
                    MyTaxiCRMInterfaceRecords.SetRange("Transfer Date", 0D);
                    MyTaxiCRMInterfaceRecords.SetRange("Interface Type", MyTaxiCRMInterfaceRecords."Interface Type"::Invoice);
                    MyTaxiCRMInterfaceRecords.SetRange("Process Status", MyTaxiCRMInterfaceRecords."Process Status"::Error);
                    MyTaxiCRMInterfaceRecords.SetFilter("Process Status Description", '%1|%2|%3|%4|%5', Error70000, Error70001);//Err81002,Err81003,Err81004);
                    if MyTaxiCRMInterfaceRecords.FindSet() then begin
                        repeat
                            //MyTaxiCRMInterfaceRecords."Transfer Date" := 0D;
                            //MyTaxiCRMInterfaceRecords."Transfer Time" := 0T;
                            MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::" ";
                            MyTaxiCRMInterfaceRecords."Process Status Description" := '';
                            MyTaxiCRMInterfaceRecords.Modify();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                        Commit();
                    end;
                    MyTaxiCRMInterfaceRecords.Reset();
                    //MyTaxiCRMInterfaceRecords.SETCURRENTKEY("Transfer Date","Process Status");
                    MyTaxiCRMInterfaceRecords.SetRange("Transfer Date", 0D);
                    MyTaxiCRMInterfaceRecords.SetRange("Interface Type", MyTaxiCRMInterfaceRecords."Interface Type"::Invoice);
                    MyTaxiCRMInterfaceRecords.SetRange("Process Status", MyTaxiCRMInterfaceRecords."Process Status"::" ");
                    MyTaxiCRMInterfaceRecords.SetRange(statusCode, 'NEW');
                    //ERROR(FORMAT(MyTaxiCRMInterfaceRecords.COUNT));
                    if MyTaxiCRMInterfaceRecords.FindSet() then
                        repeat
                            ClearLastError();
                            Clear(MyTaxiCRMInterfaceProcess);
                            MyTaxiCRMInterfaceProcess.SetParams(InterfaceType::"Sales Invoice", MyTaxiCRMInterfaceRecords);
                            if not MyTaxiCRMInterfaceProcess.Run() then begin
                                /*RecLogbook.SetError(RecLogbook."Interface Code"::Vendors,RecLogbook.Type::Error,0,'',
                                                 COPYSTR(GETLASTERRORTEXT,1,250),
                                                 CODEUNIT::Codeunit81701,RecLogbook."Flow type"::Import,'');*/
                                MyTaxiCRMInterfaceRecords.Get(MyTaxiCRMInterfaceRecords."Entry No.");

                                MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::Error;
                                MyTaxiCRMInterfaceRecords."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
                                MyTaxiCRMInterfaceRecords.statusCode := 'ERROR';
                                MyTaxiCRMInterfaceRecords."Send Update" := true;
                                MyTaxiCRMInterfaceRecords.Modify();
                            end;
                            Commit();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                end;
            'UPDATE INVOICES':
                begin
                    MyTaxiCRMInterfaceRecords.Reset();
                    //MyTaxiCRMInterfaceRecords.SETCURRENTKEY("Transfer Date","Process Status");
                    //MyTaxiCRMInterfaceRecords.SETRANGE("Transfer Date",0D);
                    //MyTaxiCRMInterfaceRecords.SETRANGE("Process Status",MyTaxiCRMInterfaceRecords."Process Status"::" ");
                    MyTaxiCRMInterfaceRecords.SetRange("Send Update", true);
                    if MyTaxiCRMInterfaceRecords.FindSet() then
                        repeat
                            ClearLastError();
                            Clear(MyTaxiCRMInterfaceWS);
                            // MyTaxiCRMInterfaceWS.SetParams(InterfaceType::"Sales Invoice", FlowType::Export, MyTaxiCRMInterfaceRecords);
                            if not MyTaxiCRMInterfaceWS.Run() then begin
                                MyTaxiCRMInterfaceLogs.SetError(MyTaxiCRMInterfaceLogs."Interface Code"::Customer, MyTaxiCRMInterfaceLogs.Type::Error, 0, '',
                                                  CopyStr(GetLastErrorText, 1, 250), CopyStr(GetLastErrorText, 251, 250),
                                                  CODEUNIT::"MyTaxi CRM Interface WS", MyTaxiCRMInterfaceLogs."Flow Type"::Import, '', UserId, '');

                                MyTaxiCRMInterfaceRecords.Get(MyTaxiCRMInterfaceRecords."Entry No.");

                                MyTaxiCRMInterfaceRecords."Process Status" := MyTaxiCRMInterfaceRecords."Process Status"::Error;
                                MyTaxiCRMInterfaceRecords."Process Status Description" := CopyStr(GetLastErrorText, 1, 250);
                                MyTaxiCRMInterfaceRecords.Modify();
                            end;
                            Commit();
                        until MyTaxiCRMInterfaceRecords.Next() = 0;
                end;
        end;

    end;

    var
        MyTaxiCRMInterfaceSetup: Record "MyTaxi CRM Interface Setup";
        MyTaxiCRMInterfaceLogs: Record "MyTaxi CRM Interface Logs";
        MyTaxiCRMInterfaceRecords: Record "MyTaxi CRM Interface Records";
        MyTaxiCRMInterfaceWS: Codeunit "MyTaxi CRM Interface WS";
        MyTaxiCRMInterfaceProcess: Codeunit "MyTaxi CRM Interface Process";
        Error70000: Label '*locked by*';
        Error70001: Label '*activity was deadlocked*';
        InterfaceType: Option " ",Customers,"Sales Invoice";
        FlowType: Option " ",Process,Import,Export;
}

