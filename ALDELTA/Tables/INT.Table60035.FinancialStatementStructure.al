table 60035 "Financial Statement Structure"
{
    // MP 03-12-13
    // Added field "Rounding Factor" (CR 31 - Case 14130)
    // 
    // MP 17-10-16
    // Fixed issue with lines not being deleted

    Caption = 'Financial Statement Structure';
    DataCaptionFields = "Code", Description;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "Description (English)"; Text[50])
        {
            Caption = 'Description (English)';
        }
        field(30; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(40; "Rounding Factor"; Option)
        {
            Caption = 'Rounding Factor';
            Description = 'MP 03-12-13';
            OptionCaption = 'None,1,1000,1000000';
            OptionMembers = "None","1","1000","1000000";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrecFinancialStatementLine: Record "Financial Statement Line";
    begin
        // MP 17-10-16 >>
        lrecFinancialStatementLine.SetRange("Financial Stat. Structure Code", Code);
        lrecFinancialStatementLine.DeleteAll(true);
        // MP 17-10-16 <<
    end;

    trigger OnInsert()
    begin
        lfcnUpdateDefault();
    end;

    trigger OnModify()
    begin
        lfcnUpdateDefault();
    end;

    //[Scope('Internal')]
    procedure lfcnUpdateDefault()
    var
        lreFinancialStatementStructure: Record "Financial Statement Structure";
    begin
        if (Default <> xRec.Default) and Default then begin
            lreFinancialStatementStructure.SetRange(Default, true);
            lreFinancialStatementStructure.SetFilter(Code, '<> %1', Code);
            if lreFinancialStatementStructure.FindFirst() then begin
                lreFinancialStatementStructure.Default := false;
                lreFinancialStatementStructure.Modify();
            end;
        end;
    end;
}

