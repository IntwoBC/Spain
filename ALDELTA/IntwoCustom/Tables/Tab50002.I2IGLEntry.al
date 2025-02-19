table 50002 "I2I G/L Entry"
{
    Caption = 'G/L Entry';
    DrillDownPageID = "General Ledger Entries";
    LookupPageID = "General Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                UpdateAccountID();
            end;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date");
            end;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const(Customer)) Customer
            else
            if ("Bal. Account Type" = const(Vendor)) Vendor
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Bal. Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Bal. Account Type" = const(Employee)) Employee;
        }
        field(17; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(18; "Source Currency Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Source Currency Code";
            AutoFormatType = 1;
            Caption = 'Source Currency Amount';
            DataClassification = CustomerContent;
        }
        field(19; "Source Currency VAT Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Source Currency Code";
            AutoFormatType = 1;
            Caption = 'Source VAT Currency Amount';
            DataClassification = CustomerContent;
        }
        field(20; "Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
            TableRelation = Currency;
            DataClassification = SystemMetadata;
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(29; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(30; "Prior-Year Entry"; Boolean)
        {
            Caption = 'Prior-Year Entry';
        }
        field(41; "Job No."; Code[20])
        {
            Caption = 'Project No.';
            TableRelation = Job;
        }
        field(42; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(43; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(45; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(46; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(47; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(48; "Gen. Posting Type"; Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
        }
        field(49; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(51; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(52; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(53; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
        }
        field(54; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
        }
        field(55; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(56; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(57; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer
            else
            if ("Source Type" = const(Vendor)) Vendor
            else
            if ("Source Type" = const("Bank Account")) "Bank Account"
            else
            if ("Source Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Source Type" = const(Employee)) Employee;
        }
        field(59; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(60; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(61; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(62; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(63; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(64; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(68; "Additional-Currency Amount"; Decimal)
        {
            AccessByPermission = TableData Currency = R;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
        }
        field(69; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Debit Amount';
        }
        field(70; "Add.-Currency Credit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Credit Amount';
        }
        field(71; "Close Income Statement Dim. ID"; Integer)
        {
            Caption = 'Close Income Statement Dim. ID';
        }
        field(72; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(73; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(74; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "G/L Entry";
        }
        field(75; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "G/L Entry";
        }
        field(76; "G/L Account Name"; Text[100])
        {
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Journal Templ. Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions();
            end;
        }
        field(79; "VAT Reporting Date"; Date)
        {
            Caption = 'VAT Date';
            Editable = false;
        }
        field(481; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(3)));
        }
        field(482; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(4)));
        }
        field(483; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(5)));
        }
        field(484; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(6)));
        }
        field(485; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(7)));
        }
        field(486; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(8)));
        }

        field(495; "Last Dim. Correction Entry No."; Integer)
        {
            Caption = 'Last Dim. Correction Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(496; "Last Dim. Correction Node"; Integer)
        {
            Caption = 'Last Dim. Correction Node';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(497; "Dimension Changes Count"; Integer)
        {
            Caption = 'Count of Dimension Changes';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2678; "Allocation Account No."; Code[20])
        {
            Caption = 'Allocation Account No.';
            DataClassification = CustomerContent;
        }
        field(5400; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(5600; "FA Entry Type"; Option)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Entry Type';
            OptionCaption = ' ,Fixed Asset,Maintenance';
            OptionMembers = " ","Fixed Asset",Maintenance;
        }
        field(5601; "FA Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Entry No.';
            TableRelation = if ("FA Entry Type" = const("Fixed Asset")) "FA Ledger Entry"
            else
            if ("FA Entry Type" = const(Maintenance)) "Maintenance Ledger Entry";
        }
        field(5618; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(6200; "Non-Deductible VAT Amount"; Decimal)
        {
            Caption = 'Non-Deductible VAT Amount';
            AutoFormatType = 1;
        }
        field(6201; "Non-Deductible VAT Amount ACY"; Decimal)
        {
            Caption = 'Non-Deductible VAT Amount ACY';
            AutoFormatType = 1;
        }
        field(8001; "Account Id"; Guid)
        {
            CalcFormula = lookup("G/L Account".SystemId where("No." = field("G/L Account No.")));
            Caption = 'Account Id';
            FieldClass = FlowField;
            TableRelation = "G/L Account".SystemId;

            trigger OnValidate()
            begin
                UpdateAccountNo();
            end;
        }
        field(8005; "Last Modified DateTime"; DateTime)
        {
            Caption = 'Last Modified DateTime';
            Editable = false;
        }
        field(12100; "Official Date"; Date)
        {
            Caption = 'Official Date';
        }
        field(12101; Positive; Boolean)
        {
            Caption = 'Positive';
            Editable = false;
        }
        field(50003; "Purchase Order No."; Code[50])
        {
            Caption = 'Purchase Order No.';
            Description = 'SUP:ISSUE:#117922';
            Editable = false;
        }
        field(60000; "Corporate G/L Account No."; Code[20])
        {
            Caption = 'Corporate G/L Account No.';
            Description = 'MP 18-01-12';
            TableRelation = "Corporate G/L Account";
        }
        field(60010; "Bal. Corporate G/L Account No."; Code[20])
        {
            Caption = 'Bal. Corporate G/L Account No.';
            Description = 'MP 18-01-12';
            TableRelation = "Corporate G/L Account";
        }
        field(60020; "GAAP Adjustment Reason"; Option)
        {
            Caption = 'GAAP Adjustment Reason';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,Timing,GAAP,Reclassification,Tax';
            OptionMembers = " ",Timing,GAAP,Reclassification,Tax;
        }
        field(60030; "Adjustment Role"; Option)
        {
            Caption = 'Adjustment Role';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,EY,Client,Auditor';
            OptionMembers = " ",EY,Client,Auditor;
        }
        field(60040; "Tax Adjustment Reason"; Option)
        {
            Caption = 'Tax Adjustment Reason';
            Description = 'MP 18-01-12';
            OptionCaption = ' ,P&L,Equity,,Non Temporary,Other P&L,Other Equity,Other Non Temporary';
            OptionMembers = " ","P&L",Equity,"<Obsolete>","Non Temporary","Other P&L","Other Equity","Other Non Temporary";
        }
        field(60060; "Equity Correction Code"; Code[10])
        {
            Caption = 'Equity Correction Code';
            Description = 'MP 18-01-12';
            TableRelation = "Equity Correction Code";
        }
        field(60070; "Record Links"; Boolean)
        {
            CalcFormula = Exist("G/L Entry Document Link" WHERE("Transaction No." = FIELD("Transaction No."),
                                                                 "Document No." = FIELD("Document No.")));
            Caption = 'Links';
            Description = 'MP 18-01-12';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60080; "Description (English)"; Text[50])
        {
            Caption = 'Description (English)';
            Description = 'MP 18-01-12';
        }
        field(60090; "Corporate G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup("Corporate G/L Account".Name WHERE("No." = FIELD("Corporate G/L Account No.")));
            Caption = 'Corporate G/L Account Name';
            Description = 'MP 27-11-15';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60110; Reversible; Boolean)
        {
            Caption = 'Reversible';
            Description = 'MD 25-09-12';
        }
        field(60111; "Reversed at"; Date)
        {
            Caption = 'Reversed at';
            Description = 'MD 25-09-12';
        }
        field(60112; "Reversal Entry No."; Integer)
        {
            Caption = 'Reversal Entry No.';
            Description = 'MD 09-10-12';
            TableRelation = "G/L Entry";
        }
        field(99090; "Client Entry No."; BigInteger)
        {
            Caption = 'Client Entry No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount", Quantity, "Source Currency Amount";
            IncludedFields = Amount, "Additional-Currency Amount";
        }
        key(Key3; "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "VAT Reporting Date", "Source Currency Code")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount", "Source Currency Amount";
        }
        key(Key4; "G/L Account No.", "Business Unit Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key5; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key6; "Document No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount";
        }
        key(Key7; "Transaction No.")
        {
        }
        key(Key8; "IC Partner Code")
        {
        }
        key(Key9; "G/L Account No.", "Job No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key10; "Posting Date", "G/L Account No.", "Dimension Set ID")
        {
            SumIndexFields = Amount;
        }
        key(Key11; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        {
        }
        key(Key12; "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        {
        }
        key(Key13; "Official Date")
        {
            SumIndexFields = "Debit Amount", "Credit Amount";
        }
        key(Key14; "G/L Account No.", "Posting Date", "Bal. Account No.", "Transaction No.")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key15; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Close Income Statement Dim. ID", "Posting Date", "Bal. Account No.", "Transaction No.")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key16; "Transaction No.", "G/L Account No.", "Document No.", Positive, "Source Type", "Source No.")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount";
        }
        key(Key17; "Close Income Statement Dim. ID")
        {
        }
        key(Key18; "Dimension Set ID")
        {
        }
        key(Key19; "Corporate G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key20; "Corporate G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role", "GAAP Adjustment Reason", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key21; "Corporate G/L Account No.", "Business Unit Code", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key22; "Corporate G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Adjustment Role", "GAAP Adjustment Reason", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key23; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "GAAP Adjustment Reason", "Posting Date")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "G/L Account No.", "Posting Date", "Document Type", "Document No.")
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure GetLastEntry(var LastEntryNo: Integer; var LastTransactionNo: Integer)
    var
        FindRecordManagement: Codeunit "Find Record Management";
        FieldNoValues: List of [Integer];
    begin
        FieldNoValues.Add(FieldNo("Entry No."));
        FieldNoValues.Add(FieldNo("Transaction No."));
        FindRecordManagement.GetLastEntryIntFieldValues(Rec, FieldNoValues);
        LastEntryNo := FieldNoValues.Get(1);
        LastTransactionNo := FieldNoValues.Get(2);
    end;

    procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;

    procedure ShowValueEntries()
    var
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        ValueEntry: Record "Value Entry";
        TempValueEntry: Record "Value Entry" temporary;
    begin
        //OnBeforeShowValueEntries(ValueEntry, GLItemLedgRelation);

        GLItemLedgRelation.SetRange("G/L Entry No.", "Entry No.");
        if GLItemLedgRelation.FindSet() then
            repeat
                ValueEntry.Get(GLItemLedgRelation."Value Entry No.");
                TempValueEntry.Init();
                TempValueEntry := ValueEntry;
                TempValueEntry.Insert();
            until GLItemLedgRelation.Next() = 0;

        PAGE.RunModal(0, TempValueEntry);
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Entry No."));
    end;

    procedure UpdateDebitCredit(Correction: Boolean)
    begin
        if ((Amount > 0) and (not Correction)) or
           ((Amount < 0) and Correction)
        then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
        end;

        if (("Additional-Currency Amount" > 0) and (not Correction)) or
           (("Additional-Currency Amount" < 0) and Correction)
        then begin
            "Add.-Currency Debit Amount" := "Additional-Currency Amount";
            "Add.-Currency Credit Amount" := 0
        end else begin
            "Add.-Currency Debit Amount" := 0;
            "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
        end;

        //OnAfterUpdateDebitCredit(Rec, Correction);
    end;

    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        SetVATDate(GenJnlLine);
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        Comment := GenJnlLine.Comment;
        "Business Unit Code" := GenJnlLine."Business Unit Code";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Source Code" := GenJnlLine."Source Code";
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" then begin
            if GenJnlLine."Source Type" = GenJnlLine."Source Type"::Employee then
                "Source Type" := "Source Type"::Employee
            else
                "Source Type" := GenJnlLine."Source Type";
            "Source No." := GenJnlLine."Source No.";
        end else begin
            if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee then
                "Source Type" := "Source Type"::Employee
            else
                "Source Type" := GenJnlLine."Account Type";
            "Source No." := GenJnlLine."Account No.";
        end;
        if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") or
           (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
        then
            "Source Type" := "Source Type"::" ";
        "Job No." := GenJnlLine."Job No.";
        Quantity := GenJnlLine.Quantity;
        "Journal Templ. Name" := GenJnlLine."Journal Template Name";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := CopyStr(UserId(), 1, MaxStrLen("User ID"));
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        "Prod. Order No." := GenJnlLine."Prod. Order No.";

        //OnAfterCopyGLEntryFromGenJnlLine(Rec, GenJnlLine);
    end;

    procedure CopyPostingGroupsFromGLEntry(GLEntry: Record "G/L Entry")
    begin
        "Gen. Posting Type" := GLEntry."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
        "Tax Area Code" := GLEntry."Tax Area Code";
        "Tax Liable" := GLEntry."Tax Liable";
        "Tax Group Code" := GLEntry."Tax Group Code";
        "Use Tax" := GLEntry."Use Tax";

        //OnAfterCopyPostingGroupsFromGLEntry(rec, GLEntry);
    end;

    procedure CopyPostingGroupsFromVATEntry(VATEntry: Record "VAT Entry")
    begin
        "Gen. Posting Type" := VATEntry.Type;
        "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
        "Tax Area Code" := VATEntry."Tax Area Code";
        "Tax Liable" := VATEntry."Tax Liable";
        "Tax Group Code" := VATEntry."Tax Group Code";
        "Use Tax" := VATEntry."Use Tax";

        //OnAfterCopyPostingGroupsFromVATEntry(Rec, VATEntry);
    end;

    procedure CopyPostingGroupsFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
        "Tax Area Code" := GenJnlLine."Tax Area Code";
        "Tax Liable" := GenJnlLine."Tax Liable";
        "Tax Group Code" := GenJnlLine."Tax Group Code";
        "Use Tax" := GenJnlLine."Use Tax";

        //OnAfterCopyPostingGroupsFromGenJnlLine(Rec, GenJnlLine);
    end;

    procedure CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; GenPostingType: Option " ",Purchase,Sale,Settlement)
    begin
        "Gen. Posting Type" := "General Posting Type".FromInteger(GenPostingType);
        "Gen. Bus. Posting Group" := DtldCVLedgEntryBuf."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := DtldCVLedgEntryBuf."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := DtldCVLedgEntryBuf."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := DtldCVLedgEntryBuf."VAT Prod. Posting Group";
        "Tax Area Code" := DtldCVLedgEntryBuf."Tax Area Code";
        "Tax Liable" := DtldCVLedgEntryBuf."Tax Liable";
        "Tax Group Code" := DtldCVLedgEntryBuf."Tax Group Code";
        "Use Tax" := DtldCVLedgEntryBuf."Use Tax";

        //OnAfterCopyPostingGroupsFromDtldCVBuf(Rec, DtldCVLedgEntryBuf);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromDeferralPostBuffer(DeferralPostBuffer: Record "Deferral Posting Buffer")
    begin
        "System-Created Entry" := DeferralPostBuffer."System-Created Entry";
        "Gen. Posting Type" := DeferralPostBuffer."Gen. Posting Type";
        "Gen. Bus. Posting Group" := DeferralPostBuffer."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := DeferralPostBuffer."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := DeferralPostBuffer."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := DeferralPostBuffer."VAT Prod. Posting Group";
        "Tax Area Code" := DeferralPostBuffer."Tax Area Code";
        "Tax Liable" := DeferralPostBuffer."Tax Liable";
        "Tax Group Code" := DeferralPostBuffer."Tax Group Code";
        "Use Tax" := DeferralPostBuffer."Use Tax";

        //OnAfterCopyFromDeferralPostBuffer(Rec, DeferralPostBuffer);
    end;

    procedure UpdateAccountID()
    var
        GLAccount: Record "G/L Account";
    begin
        if "G/L Account No." = '' then begin
            Clear("Account Id");
            exit;
        end;

        if not GLAccount.Get("G/L Account No.") then
            exit;

        "Account Id" := GLAccount.SystemId;
    end;

    local procedure UpdateAccountNo()
    var
        GLAccount: Record "G/L Account";
    begin
        if IsNullGuid("Account Id") then
            exit;

        if not GLAccount.GetBySystemId("Account Id") then
            exit;

        "G/L Account No." := GLAccount."No.";
    end;

    local procedure SetVATDate(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine."VAT Reporting Date" = 0D then
            "VAT Reporting Date" := GLSetup.GetVATDate(GenJnlLine."Posting Date", GenJnlLine."Document Date")
        else
            "VAT Reporting Date" := GenJnlLine."VAT Reporting Date";
    end;
}