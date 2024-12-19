page 60048 "My Client Subform"
{
    Caption = 'My Client Subform';
    PageType = ListPart;
    SourceTable = "Subsidiary Client";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';

                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company Name field.';

                }
                field("Chart of Acc. Import Date"; Rec."Chart of Acc. Import Date")
                {
                    Style = StandardAccent;
                    ApplicationArea = all;

                    StyleExpr = gblnErrorGLAcc;
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
    }

    trigger OnAfterGetRecord()
    begin
        grecImportLogSubsClient.SetCurrentKey("Parent Client No.");
        grecImportLogSubsClient.SetRange("Parent Client No.", Rec."Parent Client No.");
        grecImportLogSubsClient.SetRange("Company No.", Rec."Company No.");

        gblnErrorGLAcc := lfcnCheckError(grecImportLogSubsClient."Interface Type"::"Chart Of Accounts");
        gblnErrorCorpGLAcc := lfcnCheckError(grecImportLogSubsClient."Interface Type"::"Corporate Chart Of Accounts");
        gblnErrorTB := lfcnCheckError(grecImportLogSubsClient."Interface Type"::"Trial Balance");
        gblnErrorGLEntries := lfcnCheckError(grecImportLogSubsClient."Interface Type"::"GL Transactions");
        gblnErrorCustomer := lfcnCheckError(grecImportLogSubsClient."Interface Type"::Customer);
        gblnErrorAR := lfcnCheckError(grecImportLogSubsClient."Interface Type"::"AR Transactions");
        gblnErrorVendor := lfcnCheckError(grecImportLogSubsClient."Interface Type"::Vendor);
        gblnErrorAP := lfcnCheckError(grecImportLogSubsClient."Interface Type"::APTransactions);
    end;

    var
        grecImportLogSubsClient: Record "Import Log - Subsidiary Client";

        gblnErrorGLAcc: Boolean;

        gblnErrorCorpGLAcc: Boolean;

        gblnErrorTB: Boolean;

        gblnErrorGLEntries: Boolean;

        gblnErrorCustomer: Boolean;

        gblnErrorAR: Boolean;

        gblnErrorVendor: Boolean;

        gblnErrorAP: Boolean;

    local procedure lfcnCheckError(pintInterfaceType: Integer): Boolean
    begin
        grecImportLogSubsClient.SetRange("Interface Type", pintInterfaceType);
        if grecImportLogSubsClient.FindLast() then
            exit(grecImportLogSubsClient.Status = grecImportLogSubsClient.Status::Error);

        exit(false);
    end;
}

