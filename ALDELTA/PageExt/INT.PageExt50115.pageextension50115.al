pageextension 50115 pageextension50115 extends "General Journal"
{
    // PK 22-12-21 EY-MTES0002 EY Core compatibility modifications
    // "Corporate G/L Account No." removed
    // #1..7
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("Corporate G/L Account No."; Rec."Corporate G/L Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Corporate G/L Account No. field.';
                trigger OnLookup(var Text: Text): Boolean
                var
                    CorporateGLAccount: Record "Corporate G/L Account";
                    CorporateGLaccountPage: page "Corporate G/L Account List";
                begin
                    if not Rec.BottomUp then begin
                        CorporateGLAccount.SetRange("Local G/L Account No.", Rec."Account No.");
                        CorporateGLaccountPage.SetTableView(CorporateGLAccount);
                        CorporateGLaccountPage.LookupMode(true);
                        if CorporateGLaccountPage.RunModal() = Action::LookupOK then begin
                            CorporateGLaccountPage.GetRecord(CorporateGLAccount);
                            Rec."Corporate G/L Account No." := CorporateGLAccount."No.";
                            CurrPage.Update(true);
                        end;
                    end;
                end;
            }
        }
        addafter("Succeeded VAT Registration No.")
        {
            // field("Posting Group"; Rec."Posting Group")
            // {
            //     Editable = true;
            //     ApplicationArea = All;
            // }
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
            }
            field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
            }
        }
    }
}

