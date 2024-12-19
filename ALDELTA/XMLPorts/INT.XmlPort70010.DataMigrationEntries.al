xmlport 70010 "Data Migration Entries"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   XMLport Creation
    // #MyTaxi.W1.CRE.DMIG.002 12/06/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   New format for date and decimal separator

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ',';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Data Migration Entries"; "Data Migration Entries")
            {
                XmlName = 'RevisionEntries';
                fieldelement(SerialNo; "Data Migration Entries".SerialNo)
                {
                }
                fieldelement(EntryType; "Data Migration Entries".EntryType)
                {
                }
                textelement(Date)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        Evaluate(Day, CopyStr(Date, 1, 2));
                        Evaluate(Month, CopyStr(Date, 4, 2));
                        Evaluate(Year, CopyStr(Date, 7, 4));
                        "Data Migration Entries".Date := DMY2Date(Day, Month, Year);
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
                fieldelement(AccountNo; "Data Migration Entries".AccountNo)
                {
                }
                fieldelement(EntryNo; "Data Migration Entries".EntryNo)
                {
                }
                fieldelement(Text; "Data Migration Entries".Text)
                {
                }
                textelement(AmountEUR)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        if AmountEUR <> '' then
                            Evaluate("Data Migration Entries".AmountEUR, ConvertStr(Format(AmountEUR), '.', tDecimal));
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
                fieldelement(Currency; "Data Migration Entries".Currency)
                {
                }
                textelement(Amount)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        if Amount <> '' then
                            Evaluate("Data Migration Entries".Amount, ConvertStr(Format(Amount), '.', tDecimal));
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
                fieldelement(ProjectNo; "Data Migration Entries".ProjectNo)
                {
                }
                fieldelement(ActivityNo; "Data Migration Entries".ActivityNo)
                {
                }
                fieldelement(CustomerNo; "Data Migration Entries".CustomerNo)
                {
                }
                fieldelement(SupplierNo; "Data Migration Entries".SupplierNo)
                {
                }
                fieldelement(InvoiceNo; "Data Migration Entries".InvoiceNo)
                {
                }
                fieldelement(SupplierInvoiceNo; "Data Migration Entries".SupplierInvoiceNo)
                {
                }
                textelement(DueDate)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        Evaluate(Day, CopyStr(Date, 1, 2));
                        Evaluate(Month, CopyStr(Date, 4, 2));
                        Evaluate(Year, CopyStr(Date, 7, 4));
                        "Data Migration Entries".DueDate := DMY2Date(Day, Month, Year);
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
                fieldelement(VATCode; "Data Migration Entries".VATCode)
                {
                }
                fieldelement(Department; "Data Migration Entries".Department)
                {
                }
                fieldelement(Unit1No; "Data Migration Entries".Unit1No)
                {
                }
                fieldelement(Unit2No; "Data Migration Entries".Unit2No)
                {
                }
                textelement(Quantity)
                {

                    trigger OnBeforePassVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        if Quantity <> '' then
                            Evaluate("Data Migration Entries".Quantity, ConvertStr(Format(Quantity), '.', tDecimal));
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
                textelement(Quantity2)
                {

                    trigger OnBeforePassVariable()
                    begin
                        // MyTaxi.W1.CRE.DMIG.002 <<
                        if Quantity2 <> '' then
                            Evaluate("Data Migration Entries".Quantity2, ConvertStr(Format(Quantity2), '.', tDecimal));
                        // MyTaxi.W1.CRE.DMIG.002 >>
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        // MyTaxi.W1.CRE.DMIG.002 <<
        vDecimal := 1 / 2;
        if StrPos(Format(vDecimal), '.') <> 0 then
            tDecimal := '.'
        else
            tDecimal := '.';
        // MyTaxi.W1.CRE.DMIG.002 >>
    end;

    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        vDecimal: Decimal;
        tDecimal: Text;
}

