codeunit 60050 "Run Adjustments View"
{

    trigger OnRun()
    begin
        PAGE.RunModal(PAGE::"Adjustments View");
    end;
}

