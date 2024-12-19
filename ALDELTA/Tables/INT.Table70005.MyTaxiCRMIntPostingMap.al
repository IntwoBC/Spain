table 70005 "MyTaxi CRM Int. Posting Map."
{
    Caption = 'MyTaxi CRM Int. Posting Mapping';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Invoice Type"; Code[20])
        {
        }
        field(2; Account; Code[20])
        {
            Caption = 'Account';
        }
        field(3; "GL Account"; Code[20])
        {
            Caption = 'GL Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("GL Account");
            end;
        }
        field(4; "VAT Product Posting Group"; Code[10])
        {
            Caption = 'VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(5; "Type Of Additional Note"; Text[30])
        {
            Caption = 'Type Of Additional Note';
        }
        field(6; "Document Type"; Option)
        {
            OptionCaption = 'Credit Memo,Invoice';
            OptionMembers = "Credit Memo",Invoice;
        }
    }

    keys
    {
        key(Key1; "Invoice Type", Account)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc();
            GLAcc.TestField("Account Type", GLAcc."Account Type"::Posting);
            GLAcc.TestField(Blocked, false);
            GLAcc.TestField("Direct Posting");
        end;
    end;
}

