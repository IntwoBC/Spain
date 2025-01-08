table 60014 "Corporate G/L Account"
{
    // TEC 13-04-12 -mdan-
    //   Synchronized Captions with field Names (60080, 60090, 60100)
    // 
    // MP 19-02-14
    // Added validation to "Local G/L Account No." (CR 30)
    // 
    // MP 03-11-15
    // Added field "Fin. Statement Description" (CB1 Enhancements)
    // Added key Indentation
    // Added option "Tax" to field "GAAP Adjustment Reason Filter"
    // 
    // MP 22-02-16
    // Added key Search Name,Local G/L Account No. (CB1 Enhancements)
    // 
    // MP 22-03-16
    // Added line of code to OnModify() in order to update FS Code history (CB1 CR002)
    // Added FlowField "Fin. Statement Code (Local)"

    Caption = 'Corporate G/L Account';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Corporate Chart of Accounts";
    LookupPageID = "Corporate G/L Account List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate()
            var
                 GLEntry: Record "I2I G/L Entry";
            begin
                if ("Account Type" <> "Account Type"::Posting) and
                   (xRec."Account Type" = xRec."Account Type"::Posting)
                then begin
                    GLEntry.SetCurrentKey("G/L Account No.");
                    GLEntry.SetRange("G/L Account No.", "No.");
                    if GLEntry.Find('-') then
                        Error(
                          Text000,
                          FieldCaption("Account Type"));
                end;
                Totaling := '';
            end;
        }
        field(9; "Income/Balance"; Option)
        {
            Caption = 'Income/Balance';
            OptionCaption = 'Income Statement,Balance Sheet';
            OptionMembers = "Income Statement","Balance Sheet";
        }
        field(10; "Debit/Credit"; Option)
        {
            Caption = 'Debit/Credit';
            OptionCaption = 'Both,Debit,Credit';
            OptionMembers = Both,Debit,Credit;
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Corporate G/L Account"),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(18; "No. of Blank Lines"; Integer)
        {
            Caption = 'No. of Blank Lines';
            MinValue = 0;
        }
        field(19; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(26; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(28; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(29; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
  CalcFormula = Sum("I2I G/L Entry".Amount WHERE("Corporate G/L Account No." = FIELD("No."),
                                                        "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                        "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                        "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
CalcFormula = Sum("I2I G/L Entry".Amount WHERE("Corporate G/L Account No." = FIELD("No."),
                                                        "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                        "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not ("Account Type" in ["Account Type"::Total, "Account Type"::"End-Total"]) then
                    FieldError("Account Type");
                CalcFields(Balance);
            end;
        }
        field(36; Balance; Decimal)
        {
            AutoFormatType = 1;
  CalcFormula = Sum("I2I G/L Entry".Amount WHERE("Corporate G/L Account No." = FIELD("No."),
                                                        "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                        "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Business Unit Filter"; Code[10])
        {
            Caption = 'Business Unit Filter';
            FieldClass = FlowFilter;
            TableRelation = "Business Unit";
        }
        field(47; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
 CalcFormula = Sum("I2I G/L Entry"."Debit Amount" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                "Posting Date" = FIELD("Date Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
 CalcFormula = Sum("I2I G/L Entry"."Credit Amount" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                 "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                 "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                 "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Additional-Currency Net Change"; Decimal)
        {
 AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("I2I G/L Entry"."Additional-Currency Amount" WHERE("Corporate G/L Account No." = FIELD("No."),

                                                                              "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                              "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                              "Posting Date" = FIELD("Date Filter")));
            Caption = 'Additional-Currency Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Add.-Currency Balance at Date"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
 CalcFormula = Sum("I2I G/L Entry"."Additional-Currency Amount" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                              "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                              "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                              "Posting Date" = FIELD(UPPERLIMIT("Date Filter"))));
            Caption = 'Add.-Currency Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Additional-Currency Balance"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
 CalcFormula = Sum("I2I G/L Entry"."Additional-Currency Amount" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                              "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                              "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter")));
            Caption = 'Additional-Currency Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
 CalcFormula = Sum("I2I G/L Entry"."Add.-Currency Debit Amount" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                              "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                              "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                              "Posting Date" = FIELD("Date Filter")));
            Caption = 'Add.-Currency Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Add.-Currency Credit Amount"; Decimal)
        {
 AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CalcFormula = Sum("I2I G/L Entry"."Add.-Currency Credit Amount" WHERE("Corporate G/L Account No." = FIELD("No."),

                                                                               "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Adjustment Role" = FIELD("Adjustment Role Filter"),
                                                                               "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                               "Posting Date" = FIELD("Date Filter")));
            Caption = 'Add.-Currency Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60000; "Account Class"; Option)
        {
            Caption = 'Account Class';
            OptionCaption = ' ,Balance Sheet,Equity,P&L';
            OptionMembers = " ","Balance Sheet",Equity,"P&L";

            trigger OnValidate()
            begin
                if "Account Class" <> "Account Class"::" " then
                    if "Account Class" = "Account Class"::"P&L" then
                        Validate("Income/Balance", "Income/Balance"::"Income Statement")
                    else
                        Validate("Income/Balance", "Income/Balance"::"Balance Sheet");
            end;
        }
        field(60010; "Financial Statement Code"; Code[10])
        {
            Caption = 'Financial Statement Code';
            TableRelation = "Financial Statement Code";
        }
        field(60020; "Local G/L Account No."; Code[20])
        {
            Caption = 'Local G/L Account No.';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));

            trigger OnValidate()
            var
                lrecGLAcc: Record "G/L Account";
            begin
                // MP 19-02-14 >>
                if "Local G/L Account No." <> '' then begin
                    lrecGLAcc.Get("Local G/L Account No.");
                    lrecGLAcc.TestField("Account Class", "Account Class");
                    lrecGLAcc.TestField("Financial Statement Code", "Financial Statement Code");
                end;
                // MP 19-02-14 <<
            end;
        }
        field(60040; "Name (English)"; Text[50])
        {
            Caption = 'Name (English)';
        }
        field(60050; "Gen. Jnl. Template Name Filter"; Code[10])
        {
            Caption = 'Gen. Jnl. Template Name Filter';
            FieldClass = FlowFilter;
            TableRelation = "Gen. Journal Template";
        }
        field(60060; "Gen. Jnl. Batch Name Filter"; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Name Filter';
            FieldClass = FlowFilter;
        }
        field(60070; "Adjustment Role Filter"; Option)
        {
            Caption = 'Adjustment Role Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,EY,Client,Auditor';
            OptionMembers = " ",EY,Client,Auditor;
        }
        field(60080; "Preposted Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Corporate G/L Account No." = FIELD("No."),
                                                                        "Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                        "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                        "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                        "Journal Template Name" = FIELD("Gen. Jnl. Template Name Filter"),
                                                                        "Journal Batch Name" = FIELD("Gen. Jnl. Batch Name Filter"),
                                                                        "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Preposted Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60090; "Preposted Net Change (Bal.)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Gen. Journal Line"."Amount (LCY)" WHERE("Bal. Corporate G/L Account No." = FIELD("No."),
                                                                         "Bal. Corporate G/L Account No." = FIELD(FILTER(Totaling)),
                                                                         "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                         "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                         "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                         "Journal Template Name" = FIELD("Gen. Jnl. Template Name Filter"),
                                                                         "Journal Batch Name" = FIELD("Gen. Jnl. Batch Name Filter"),
                                                                         "GAAP Adjustment Reason" = FIELD("GAAP Adjustment Reason Filter"),
                                                                         "Posting Date" = FIELD("Date Filter")));
            Caption = 'Preposted Net Change (Bal.)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60100; "Local G/L Acc. Name"; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Local G/L Account No.")));
            Caption = 'Local G/L Acc. Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60110; "Local G/L Acc. Name (English)"; Text[50])
        {
            CalcFormula = Lookup("G/L Account"."Name (English)" WHERE("No." = FIELD("Local G/L Account No.")));
            Caption = 'Local G/L Account Name (English)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60120; "GAAP Adjustment Reason Filter"; Option)
        {
            Caption = 'GAAP Adjustment Reason Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Timing,GAAP,Reclassification,Tax';
            OptionMembers = " ",Timing,GAAP,Reclassification,Tax;
        }
        field(60220; "Fin. Statement Description"; Text[100])
        {
            CalcFormula = Lookup("Financial Statement Code".Description WHERE(Code = FIELD("Financial Statement Code")));
            Caption = 'Financial Statement Description';
            Description = 'MP 03-11-15';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60230; "Fin. Statement Code (Local)"; Code[10])
        {
            CalcFormula = Lookup("G/L Account"."Financial Statement Code" WHERE("No." = FIELD("Local G/L Account No.")));
            Caption = 'Fin. Statement Code (Local)';
            Description = 'MP 31-03-16';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Financial Statement Code";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; "Financial Statement Code")
        {
        }
        key(Key5; "Local G/L Account No.")
        {
        }
        key(Key6; "Account Class")
        {
        }
        key(Key7; "Financial Statement Code", "Local G/L Account No.")
        {
        }
        key(Key8; Indentation)
        {
        }
        key(Key9; "Search Name", "Local G/L Account No.")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Income/Balance")
        {
        }
    }

    trigger OnDelete()
    var
        CommentLine: Record "Comment Line";
        lrecGLEntry: Record "I2I G/L Entry";
    begin
        lrecGLEntry.SetCurrentKey("Corporate G/L Account No.");
        lrecGLEntry.SetRange("Corporate G/L Account No.", "No.");
        if not lrecGLEntry.IsEmpty then
            Error(txt60000, "No.");

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::"G/L Account");
        CommentLine.SetRange("No.", "No.");
       CommentLine.DeleteAll;
    end;

    trigger OnModify()
    var
        lmdlFSCodeMgt: Codeunit "Fin. Stmt.Code Management";
    begin
        "Last Date Modified" := Today;

        lmdlFSCodeMgt.gfcnUpdateCorpGLAccFSCodeAndHistory(Rec, xRec."Financial Statement Code"); // MP 22-03-16
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: Label 'You cannot change %1 because there are one or more ledger entries associated with this account.';
        Text001: Label 'You cannot change %1 because this account is part of one or more budgets.';
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        Text002: Label 'There is another %1: %2; which refers to the same %3, but with a different %4: %5.';
        txt60000: Label 'You cannot delete %1 because there are one or more ledger entries associated with this account.';


    procedure SetupNewGLAcc(OldGLAcc: Record "Corporate G/L Account"; BelowOldGLAcc: Boolean)
    var
        OldGLAcc2: Record "Corporate G/L Account";
    begin
        if not BelowOldGLAcc then begin
            OldGLAcc2 := OldGLAcc;
            OldGLAcc.Copy(Rec);
            OldGLAcc := OldGLAcc2;
            if not OldGLAcc.Find('<') then
                OldGLAcc.Init();
        end;
        "Income/Balance" := OldGLAcc."Income/Balance";
    end;


    procedure CheckGLAcc()
    begin
        TestField("Account Type", "Account Type"::Posting);
    end;


    procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;


    procedure gfcnGetFinancialStatementCode(pdateDate: Date): Code[10]
    var
        lrecHistAccFinStatmtCode: Record "Hist. Acc. Fin. Statmt. Code";
    begin
        // MP 03-11-15

        lrecHistAccFinStatmtCode.SetRange("G/L Account Type", lrecHistAccFinStatmtCode."G/L Account Type"::"Corporate G/L Account");
        lrecHistAccFinStatmtCode.SetRange("G/L Account No.", "No.");
        lrecHistAccFinStatmtCode.SetFilter("Starting Date", '..%1', pdateDate);
        lrecHistAccFinStatmtCode.SetFilter("Ending Date", '%1..', pdateDate);
        if lrecHistAccFinStatmtCode.FindLast() then
            exit(lrecHistAccFinStatmtCode."Financial Statement Code");

        exit("Financial Statement Code");
    end;


}

