page 60008 "Parent Client Card"
{
    // MP 02-05-14
    // Development taken from Core II
    // Fields "A/R Trans Posting Scenario" and "A/P Trans Posting Scenario" removed, functionality not implemented

    Caption = 'Parent Client Card';
    PageType = Card;
    SourceTable = "Parent Client";
    ApplicationArea = All;
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("G/L Detail Level"; Rec."G/L Detail Level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Detail Level field.';
                }
                field("G/L Account Template Code"; Rec."G/L Account Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Local COA Template Code field.';
                }
                field("Corporate GL Acc. Templ. Code"; Rec."Corporate GL Acc. Templ. Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corporate COA Template Code field.';
                }
                field("Trial Balance Template Code"; Rec."Trial Balance Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Trial Balance Template Code field.';
                }
                field("G/L Entry Template Code"; Rec."G/L Entry Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Entry Template Code field.';
                }
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer Template Code field.';
                }
                field("Vendor Template Code"; Rec."Vendor Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Template Code field.';
                }
                field("AR Template Code"; Rec."AR Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the AR Template Code field.';
                }
                field("AP Template Code"; Rec."AP Template Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the AP Template Code field.';
                }
                field("Import Logs"; Rec."Import Logs")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Logs field.';
                }
                field("Posting Method"; Rec."Posting Method")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Method field.';
                }
            }
            part("Subsidiary Clients"; "Parent Client Subform")
            {
                SubPageLink = "Parent Client No." = FIELD("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            separator(Action1000000025)
            {
            }
            action("Import Status")
            {
                Caption = 'Import Status';
                ApplicationArea = all;
                ToolTip = 'Executes the Import Status action.';

                trigger OnAction()
                var
                    lpagImportMonitoringMatrix: Page "Import Monitoring Matrix";
                begin
                    lpagImportMonitoringMatrix.gfncSetParentClientFilter(Rec."No.");
                    lpagImportMonitoringMatrix.RunModal();
                end;
            }
            group(Import)
            {
                Caption = 'Import';

                group("Single Files")
                {
                    Caption = 'Single Files';
                    action("G/L Accounts")
                    {
                        Caption = 'G/L Accounts';
                        ApplicationArea = all;
                        ToolTip = 'Executes the G/L Accounts action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 1, true, '');
                        end;
                    }
                    action("Corporate COA")
                    {
                        Caption = 'Corporate COA';
                        ApplicationArea = all;
                        ToolTip = 'Executes the Corporate COA action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 2, true, '');
                        end;
                    }
                    action("G/L Transactions")
                    {
                        Caption = 'G/L Transactions';
                        ApplicationArea = all;
                        ToolTip = 'Executes the G/L Transactions action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 4, true, '');
                        end;
                    }
                    action("G/L Trial Balance")
                    {
                        Caption = 'G/L Trial Balance';
                        ApplicationArea = all;
                        ToolTip = 'Executes the G/L Trial Balance action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 3, true, '');
                        end;
                    }
                    action(Vendors)
                    {
                        Caption = 'Vendors';
                        ApplicationArea = all;
                        ToolTip = 'Executes the Vendors action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 6, true, '');
                        end;
                    }
                    action("AP Transactions")
                    {
                        Caption = 'AP Transactions';
                        ApplicationArea = all;
                        ToolTip = 'Executes the AP Transactions action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 8, true, '');
                        end;
                    }
                    action(Customers)
                    {
                        Caption = 'Customers';
                        ApplicationArea = all;
                        ToolTip = 'Executes the Customers action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 5, true, '');
                        end;
                    }
                    action("AR Transactions")
                    {
                        Caption = 'AR Transactions';
                        ApplicationArea = all;
                        ToolTip = 'Executes the AR Transactions action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncEndToEndProcess(Rec, 7, true, '');
                        end;
                    }
                }
                group("Combined File")
                {
                    Caption = 'Combined File';
                    action("Statutory Standardization Upload Model (SSUM)")
                    {
                        Caption = 'Statutory Standardization Upload Model (SSUM)';
                        ApplicationArea = all;
                        ToolTip = 'Executes the Statutory Standardization Upload Model (SSUM) action.';

                        trigger OnAction()
                        begin
                            gmodDataImportManagementGlobal.gfncSSBImports(Rec, true, '', false);
                        end;
                    }
                }
            }
        }
    }

    var
        gmodDataImportManagementGlobal: Codeunit "Data Import Management Global";
}

