page 60046 "My Clients Import Status"
{
    // MP 19-04-12
    // Changed caption for Page Actions: Local Chart of Accounts and Corporate Chart of Accounts
    // 
    // MP 30-04-14
    // Development taken from Core II
    // 
    // MP 04-12-14
    // NAV 2013 R2 Upgrade

    Caption = 'My Clients - Last Import Dates';
    CardPageID = "Import Monitoring Matrix";
    Editable = false;
    PageType = ListPart;
    SourceTable = "My Client";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';

                }
                field("Parent Client Name"; Rec."Parent Client Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client Name field.';

                }
                field("Chart of Acc. Import Date"; Rec."Chart of Acc. Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorGLAcc;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Chart of Accounts field.';

                }
                field("Corp. Chart of Acc.Import Date"; Rec."Corp. Chart of Acc.Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorCorpGLAcc;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corp. Chart of Accounts field.';

                }
                field("TB Import Date"; Rec."TB Import Date")
                {
                    Style = StandardAccent;
                    ApplicationArea = all;

                    StyleExpr = gblnErrorTB;
                    ToolTip = 'Specifies the value of the TB field.';
                }
                field("G/L Entries Import Date"; Rec."G/L Entries Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorGLEntries;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Entries field.';

                }
                field("Customer Import Date"; Rec."Customer Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorCustomer;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customers field.';

                }
                field("AR Import Date"; Rec."AR Import Date")
                {
                    Style = StandardAccent;
                    ApplicationArea = all;

                    StyleExpr = gblnErrorAR;
                    ToolTip = 'Specifies the value of the AR field.';
                }
                field("Vendor Import Date"; Rec."Vendor Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorVendor;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendors field.';

                }
                field("AP Import Date"; Rec."AP Import Date")
                {
                    Style = StandardAccent;
                    StyleExpr = gblnErrorAP;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the AP field.';

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000021>")
            {
                Caption = 'Import Status';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ApplicationArea = all;
                ToolTip = 'Executes the Import Status action.';


                trigger OnAction()
                var
                    lpagImportMonitoringMatrix: Page "Import Monitoring Matrix";
                begin
                    lpagImportMonitoringMatrix.gfncSetParentClientFilter(Rec."Parent Client No.");
                    lpagImportMonitoringMatrix.RunModal();
                end;
            }
            group("Import Single Files")
            {
                Caption = 'Import Single Files';
                Image = ImportDatabase;
                action("Local Chart of Accounts")
                {
                    Caption = 'Local Chart of Accounts';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Local Chart of Accounts action.';


                    trigger OnAction()
                    begin
                        lfcnImport(1);
                    end;
                }
                action("Corporate Chart of Accounts")
                {
                    Caption = 'Corporate Chart of Accounts';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Corporate Chart of Accounts action.';


                    trigger OnAction()
                    begin
                        lfcnImport(2);
                    end;
                }
                action("G/L Trial Balance")
                {
                    Caption = 'G/L Trial Balance';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Trial Balance action.';


                    trigger OnAction()
                    begin
                        lfcnImport(3);
                    end;
                }
                action("G/L Transactions")
                {
                    Caption = 'G/L Transactions';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the G/L Transactions action.';


                    trigger OnAction()
                    begin
                        lfcnImport(4);
                    end;
                }
                action(Vendors)
                {
                    Caption = 'Vendors';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Vendors action.';


                    trigger OnAction()
                    begin
                        lfcnImport(6);
                    end;
                }
                action("AP Transactions")
                {
                    Caption = 'AP Transactions';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the AP Transactions action.';


                    trigger OnAction()
                    begin
                        lfcnImport(8);
                    end;
                }
                action(Customers)
                {
                    Caption = 'Customers';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Customers action.';


                    trigger OnAction()
                    begin
                        lfcnImport(5);
                    end;
                }
                action("AR Transactions")
                {
                    Caption = 'AR Transactions';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    ToolTip = 'Executes the AR Transactions action.';


                    trigger OnAction()
                    begin
                        lfcnImport(7);
                    end;
                }
            }
            group("Import Combined File")
            {
                Caption = 'Import Combined File';
                Image = ExecuteBatch;
                action("Statutory Standardization Upload Model (SSUM)")
                {
                    Caption = 'Statutory Standardization Upload Model (SSUM)';
                    Image = ImportExcel;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Statutory Standardization Upload Model (SSUM) action.';


                    trigger OnAction()
                    var
                        lrecParentClient: Record "Parent Client";
                        lmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
                    begin
                        lrecParentClient.Get(Rec."Parent Client No.");
                        lmodDataImportManagementGlobal.gfncSSBImports(lrecParentClient, true, '', false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        grecImportLog.SetCurrentKey("Parent Client No.");
        grecImportLog.SetRange("Parent Client No.", Rec."Parent Client No.");

        gblnErrorGLAcc := lfcnCheckError(grecImportLog."Interface Type"::"Chart Of Accounts");
        gblnErrorCorpGLAcc := lfcnCheckError(grecImportLog."Interface Type"::"Corporate Chart Of Accounts");
        gblnErrorTB := lfcnCheckError(grecImportLog."Interface Type"::"Trial Balance");
        gblnErrorGLEntries := lfcnCheckError(grecImportLog."Interface Type"::"GL Transactions");
        gblnErrorCustomer := lfcnCheckError(grecImportLog."Interface Type"::Customer);
        gblnErrorAR := lfcnCheckError(grecImportLog."Interface Type"::"AR Transactions");
        gblnErrorVendor := lfcnCheckError(grecImportLog."Interface Type"::Vendor);
        gblnErrorAP := lfcnCheckError(grecImportLog."Interface Type"::APTransactions);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("User ID", UserId);
    end;

    var
        grecImportLog: Record "Import Log";

        gblnErrorGLAcc: Boolean;

        gblnErrorCorpGLAcc: Boolean;

        gblnErrorTB: Boolean;

        gblnErrorGLEntries: Boolean;

        gblnErrorCustomer: Boolean;

        gblnErrorAR: Boolean;

        gblnErrorVendor: Boolean;

        gblnErrorAP: Boolean;

    local procedure lfcnImport(p_intInfoType: Integer)
    var
        lrecParentClient: Record "Parent Client";
        lmdlDataImportMgtGlobal: Codeunit "Data Import Management Global";
    begin
        lrecParentClient.Get(Rec."Parent Client No.");
        //lmdlDataImportMgtGlobal.gfncRunStage1(lrecParentClient,p_intInfoType,TRUE);
        lmdlDataImportMgtGlobal.gfncEndToEndProcess(lrecParentClient, p_intInfoType, true, '');
    end;

    local procedure lfcnCheckError(pintInterfaceType: Integer): Boolean
    begin
        grecImportLog.SetRange("Interface Type", pintInterfaceType);
        if grecImportLog.FindLast() then
            exit(grecImportLog.Status = grecImportLog.Status::Error);

        exit(false);
    end;
}

