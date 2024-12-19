table 60029 "Equity Reconciliation Line"
{
    Caption = 'Equity Reconciliation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Corp. Account Summary,Entries,Total';
            OptionMembers = " ","Corp. Account Summary",Entries,Total;
        }
        field(20; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(32; "Entry Description"; Text[50])
        {
            Caption = 'Entry Description';
        }
        field(40; "Start Balance"; Decimal)
        {
            BlankZero = true;
            Caption = 'Start Balance';
        }
        field(50; "Net Change (P&L)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Net Change (P&L)';
        }
        field(52; "Net Change (Equity)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Net Change (Equity)';
        }
        field(60; "End Balance"; Decimal)
        {
            BlankZero = true;
            Caption = 'End Balance';
        }
        field(70; "Document No. (Start Balance)"; Code[20])
        {
            Caption = 'Document No.';
        }
        field(80; "Document No. (Net Change)"; Code[20])
        {
            Caption = 'Document No.';
        }
        field(90; Year; Integer)
        {
            BlankZero = true;
            Caption = 'Year';
        }
        field(100; Subtotal; Boolean)
        {
            Caption = 'Subtotal';
        }
        field(110; "Year Start Date"; Date)
        {
            Caption = 'Year Start Date';
        }
        field(120; "Year End Date"; Date)
        {
            Caption = 'Year End Date';
        }
        field(130; Statutory; Boolean)
        {
            Caption = 'Statutory';
        }
        field(140; Tax; Boolean)
        {
            Caption = 'Tax';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        lrecEquityReconEntryDesc: Record "Equity Recon. Entry Desc.";
        lcodDocNo: Code[20];
    begin
        if "Entry Description" <> xRec."Entry Description" then begin
            if not Confirm(StrSubstNo(txt60000, FieldCaption("Entry Description"))) then
                Error('');

            if "Document No. (Start Balance)" <> '' then
                lcodDocNo := "Document No. (Start Balance)"
            else
                lcodDocNo := "Document No. (Net Change)";

            if not lrecEquityReconEntryDesc.Get(Code, Year, lcodDocNo) then begin
                lrecEquityReconEntryDesc.Code := Code;
                lrecEquityReconEntryDesc.Year := Year;
                lrecEquityReconEntryDesc."Document No." := lcodDocNo;

                lrecEquityReconEntryDesc.Description := "Entry Description";
                lrecEquityReconEntryDesc.Insert();
            end else begin
                lrecEquityReconEntryDesc.Description := "Entry Description";
                lrecEquityReconEntryDesc.Modify();
            end;
        end;
    end;

    var
        txt60000: Label 'Are you sure you want to overwrite the %1?';
        txt60001: Label 'Cannot be specified here.';
}

