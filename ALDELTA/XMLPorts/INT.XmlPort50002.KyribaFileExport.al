xmlport 50002 "Kyriba File - Export"
{
    // SUP:ISSUE:#110847  20/08/2021  COSMO.ABT
    //    # Create the XMLport.

    Caption = 'Kyriba File - Export';
    Direction = Export;
    Format = VariableText;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("Cash Flow Forecast Entry"; "Cash Flow Forecast Entry")
            {
                XmlName = 'CashFlowForcastEntry';
                textelement(ActionCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ActionCode := 'C';
                    end;
                }
                textelement(AccountCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case "Cash Flow Forecast Entry"."Source Type" of
                            "Cash Flow Forecast Entry"."Source Type"::Receivables:
                                begin
                                    AccountCode := CashFlowSetup."AR Bank Account No.";
                                end;
                            "Cash Flow Forecast Entry"."Source Type"::Payables:
                                begin
                                    AccountCode := CashFlowSetup."AP Bank Account No.";
                                end;
                        end;
                    end;
                }
                textelement(CashFlowCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CashFlowCode := '-TRF';
                    end;
                }
                textelement(BudgetCode)
                {
                }
                textelement(FlowStatus)
                {

                    trigger OnBeforePassVariable()
                    begin
                        FlowStatus := 'CF';
                    end;
                }
                textelement(TransactionDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case "Cash Flow Forecast Entry"."Source Type" of
                            "Cash Flow Forecast Entry"."Source Type"::Receivables:
                                begin
                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetCurrentKey("Document No.");
                                    CustLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if CustLedgerEntry.FindFirst() then begin
                                        TransactionDate := Format(CustLedgerEntry."Posting Date");
                                    end;
                                end;
                            "Cash Flow Forecast Entry"."Source Type"::Payables:
                                begin
                                    VendorLedgerEntry.Reset();
                                    VendorLedgerEntry.SetCurrentKey("Document No.");
                                    VendorLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if VendorLedgerEntry.FindFirst() then begin
                                        TransactionDate := Format(VendorLedgerEntry."Posting Date");
                                    end;
                                end;
                        end;
                    end;
                }
                textelement(ValueDate)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case "Cash Flow Forecast Entry"."Source Type" of
                            "Cash Flow Forecast Entry"."Source Type"::Receivables:
                                begin
                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetCurrentKey("Document No.");
                                    CustLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if CustLedgerEntry.FindFirst() then begin
                                        ValueDate := Format(CustLedgerEntry."Due Date");
                                    end;
                                end;
                            "Cash Flow Forecast Entry"."Source Type"::Payables:
                                begin
                                    VendorLedgerEntry.Reset();
                                    VendorLedgerEntry.SetCurrentKey("Document No.");
                                    VendorLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if VendorLedgerEntry.FindFirst() then begin
                                        ValueDate := Format(VendorLedgerEntry."Due Date");
                                    end;
                                end;
                        end;
                    end;
                }
                textelement(Amount)
                {

                    trigger OnBeforePassVariable()
                    begin
                        case "Cash Flow Forecast Entry"."Source Type" of
                            "Cash Flow Forecast Entry"."Source Type"::Receivables:
                                begin
                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetCurrentKey("Document No.");
                                    CustLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if CustLedgerEntry.FindFirst() then begin
                                        CustLedgerEntry.CalcFields(Amount);
                                        Amount := Format(CustLedgerEntry.Amount);
                                    end;
                                end;
                            "Cash Flow Forecast Entry"."Source Type"::Payables:
                                begin
                                    VendorLedgerEntry.Reset();
                                    VendorLedgerEntry.SetCurrentKey("Document No.");
                                    VendorLedgerEntry.SetRange("Document No.", "Cash Flow Forecast Entry"."Document No.");
                                    if VendorLedgerEntry.FindFirst() then begin
                                        VendorLedgerEntry.CalcFields(Amount);
                                        Amount := Format(VendorLedgerEntry.Amount);
                                    end;
                                end;
                        end;
                    end;
                }
                fieldelement(Currency; "Cash Flow Forecast Entry"."Currency Code")
                {
                }
                fieldelement(Description; "Cash Flow Forecast Entry"."Document No.")
                {
                }
                textelement(Reference)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Reference := Format("Cash Flow Forecast Entry"."Source Type") + ' ' + Format("Cash Flow Forecast Entry"."Source No.");
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
        CashFlowSetup.Get();

        currXMLport.Filename := 'Kyriba File - Export.csv';
    end;

    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CashFlowSetup: Record "Cash Flow Setup";
}

