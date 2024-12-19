page 60035 "WS Corporate GL Account Stg"
{
    // TEC 12-04-13 -mdan-
    //   New fields
    //     Tax Return Code
    //     Tax Return Description
    //     Tax Return Desc. (English)
    // 
    // MP 30-04-14
    // Development taken from Core II. Substituted CIT Core II fields for variables (in order to use exact same Core II WS dll)

    Caption = 'WS Corporate GL Account Stg';
    PageType = List;
    SourceTable = "Corporate G/L Acc (Staging)";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Income/Balance"; Rec."Income/Balance")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income/Balance field.';

                }
                field("Gen. Bus. Posting Type"; Rec."Gen. Bus. Posting Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Posting Type field.';

                }
                field("Accounting Class"; Rec."Accounting Class")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accounting Class field.';

                }
                field("Name - ENU"; Rec."Name - ENU")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Name - ENU field.';

                }
                field("Financial Statement Code"; Rec."Financial Statement Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Financial Statement Code field.';

                }
                field("Local Chart Of Acc (Mapped)"; Rec."Local Chart Of Acc (Mapped)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Local Chart Of Acc (Mapped) field.';

                }
                field("Company No."; Rec."Company No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company No. field.';

                }
                field("Client No."; Rec."Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Client No. field.';

                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Import Log Entry No."; Rec."Import Log Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Log Entry No. field.';

                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';

                }
                field("FS Name"; Rec."FS Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FS Name field.';

                }
                field("FS Name (English)"; Rec."FS Name (English)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the FS Name (English) field.';

                }
                field("CIT Class Code"; gcodCITClassCode)
                {
                    Caption = 'CIT Class Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CIT Class Code field.';

                }
                field("CIT Name"; gtxtCITName)
                {
                    Caption = 'CIT Name';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CIT Name field.';

                }
                field("CIT Name (English)"; gtxtCITNameEnglish)
                {
                    Caption = 'CIT Name (English)';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CIT Name (English) field.';

                }
                field("Tax Return Code"; gocdTaxReturnCode)
                {
                    Caption = 'Tax Return Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Return Code field.';

                }
                field("Tax Return Description"; gtxtTaxReturnDescription)
                {
                    Caption = 'Tax Return Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Return Description field.';

                }
                field("Tax Return Desc. (English)"; gtxtTaxReturnDescEnglish)
                {
                    Caption = 'Tax Return Desc. (English)';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tax Return Desc. (English) field.';

                }
            }
        }
    }

    actions
    {
    }

    var
        gcodCITClassCode: Code[10];
        gtxtCITName: Text[50];
        gtxtCITNameEnglish: Text[50];
        gocdTaxReturnCode: Code[10];
        gtxtTaxReturnDescription: Text[50];
        gtxtTaxReturnDescEnglish: Text[50];
}

