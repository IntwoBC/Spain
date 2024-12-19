tableextension 50119 tableextension50119 extends "Dimension Value"
{
    // #MyTaxi.W1.CRE.INT01.011 18/05/2018 CCFR.SDE : Set the cost center 2 dimension on sales header
    //   New added field : 70000 "MyTaxi CRM Interace Code"
    fields
    {
        field(70000; "MyTaxi CRM Interace Code"; Code[20])
        {
            Description = 'MyTaxi.W1.CRE.INT01.011';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Err70000: Label 'Code %1 is already set up for Dimension Value Code %2.';
                DimensionValue: Record "Dimension Value";
            begin
                if "MyTaxi CRM Interace Code" = '' then
                    exit;
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", "Dimension Code");
                DimensionValue.SetFilter(Code, '<>%1', Code);
                DimensionValue.SetRange("MyTaxi CRM Interace Code", "MyTaxi CRM Interace Code");
                if DimensionValue.FindFirst() then
                    Error(Err70000, "MyTaxi CRM Interace Code", DimensionValue.Code);
            end;
        }
    }
}

