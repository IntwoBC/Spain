page 60031 "WS Import Log"
{
    Caption = 'WS Import Log';
    CardPageID = "Import Log Card";
    PageType = List;
    SourceTable = "Import Log";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';

                }
                field("Parent Client No."; Rec."Parent Client No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Parent Client No. field.';

                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Type field.';

                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';

                }
                field("Table Caption"; Rec."Table Caption")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table Caption field.';

                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the File Name field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stage field.';

                }
                field(Errors; Rec.Errors)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Errors field.';

                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Table ID field.';

                }
                field("Import Date"; Rec."Import Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Date field.';

                }

                field("Import Time"; Rec."Import Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Import Time field.';

                }
                field("TB to TB client"; Rec."TB to TB client")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TB to TB client field.';

                }
                field("G/L Detail level"; Rec."G/L Detail level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the G/L Detail level field.';

                }
                field("Statutory Reporting"; Rec."Statutory Reporting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Statutory Reporting field.';

                }
                field("Corp. Tax Reporting"; Rec."Corp. Tax Reporting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Corp. Tax Reporting field.';

                }
                field("VAT Reporting level"; Rec."VAT Reporting level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Reporting level field.';

                }
                field("Posting Method"; Rec."Posting Method")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Method field.';

                }
                field(ARTransPost; Rec."A/R Trans Posting Scenario")
                {
                    Caption = 'ARTransPost';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ARTransPost field.';

                }
                field(APTransPost; Rec."A/P Trans Posting Scenario")
                {
                    Caption = 'APTransPost';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the APTransPost field.';

                }
            }
        }
    }

    actions
    {
    }
}

