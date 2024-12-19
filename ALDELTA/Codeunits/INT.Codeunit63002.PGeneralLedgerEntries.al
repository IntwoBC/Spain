codeunit 63002 "P:General Ledger Entries"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Page, 20, 'OnOpenPageEvent', '', false, false)]
    local procedure levtOnOpenPage(var Rec: Record "G/L Entry")
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
        ltxtFilter: Text[1024];
    begin
        Rec.FilterGroup(3);
        ltxtFilter := Rec.GetFilter("Global Dimension 1 Code");

        if StrPos(ltxtFilter, '{GAAP-') > 0 then begin
            if ltxtFilter = '{GAAP-STATUTORY}' then
                lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Tax Adjustments")
            else
                if ltxtFilter = '{GAAP-TAX}' then
                    lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments")
                else // '{GAAP-GROUP}'
                    lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"19");

            if lrecGenJnlTemplate.FindFirst() then
                Rec.SetRange("Global Dimension 1 Code", lrecGenJnlTemplate."Shortcut Dimension 1 Code");
        end;

        Rec.FilterGroup(0);
    end;

    // [EventSubscriber(ObjectType::Page, 20, 'OnAfterActionEvent', 'ToggleMarkforGAAPTaxReversal', false, false)]
    // local procedure levtOnAfterActionToggleMarkforGAAPTaxReversal(var Rec: Record "G/L Entry")
    // begin
    //     CODEUNIT.Run(CODEUNIT::"Toggle Mark GAAP/Tax Reversal", Rec);
    // end;

    // [EventSubscriber(ObjectType::Page, 20, 'OnAfterActionEvent', 'DocumentLinks', false, false)]
    // local procedure levtOnAfterActionDocumentLinks(var Rec: Record "G/L Entry")
    // var
    //     lrecGLEntryRecLink: Record "G/L Entry Document Link";
    // begin
    //     if lrecGLEntryRecLink.Get(Rec."Transaction No.", Rec."Document No.") then;
    //     lrecGLEntryRecLink.SetRecFilter;
    //     PAGE.Run(PAGE::"G/L Entry Document Links", lrecGLEntryRecLink);
    // end;
}

