codeunit 70010 "Data Migration Process"
{
    Permissions = TableData "Cust. Ledger Entry" = rm;
    TableNo = "Data Migration Entries";

    trigger OnRun()
    var
        Text001: Label 'Gen. Journal Template name is blank.';
        Text002: Label 'Gen. Journal Batch name is blank.';
    begin
        GenJnlLine.Init();

        GenJnlLine.Validate("Journal Template Name", JournalTemplate);
        GenJnlLine.Validate("Journal Batch Name", BatchName);
        GenJnlLine."Line No." := LineNo;
        LineNo := LineNo + 10000;
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        DataMigrationGLAccountMap.Get(Rec.AccountNo);
        GLAccount.Get(DataMigrationGLAccountMap."Local Account");
        GenJnlLine.Validate("Account No.", DataMigrationGLAccountMap."Local Account");
        GenJnlLine.Validate("Posting Date", Rec.Date);
        // MyTaxi.W1.CRE.DMIG.003 >>
        GenJnlTemplate.Get(JournalTemplate);
        GenJnlBatch.Get(JournalTemplate, BatchName);
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        // MyTaxi.W1.CRE.DMIG.003 <<
        GenJnlLine."Document No." := Rec.EntryNo;
        // MyTaxi.W1.CRE.DMIG.003 >>
        if UseOldDocumentNo <> '' then
            GenJnlLine."Document No." := UseOldDocumentNo;

        if Balance <> 0 then begin
            if UseOldDocumentNo = '' then
                GenJnlLine."Document No." := OldDocumentNo
        end
        else
            if GenJnlBatch."No. Series" <> '' then begin
                if OldDocumentNo <> '' then begin
                    //ERROR(OldDocumentNo);
                    NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine, GenJnlBatch."No. Series", GenJnlLine."Posting Date");
                    if NoSeriesLine."Increment-by No." > 1 then
                        NoSeriesMgt.IncrementNoText(GenJnlLine."Document No.", NoSeriesLine."Increment-by No.")
                    else
                        GenJnlLine."Document No." := IncStr(OldDocumentNo);
                end
                else begin
                    Clear(NoSeriesMgt);
                    //ERROR(GenJnlBatch."No. Series");
                    GenJnlLine."Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", GenJnlLine."Posting Date");
                end;
            end;
        //ERROR(FORMAT(GenJnlBatch."No. Series") + ' T- '+ OldDocumentNo+' - '+UseOldDocumentNo+' - '+FORMAT(Balance));
        // MyTaxi.W1.CRE.DMIG.003 <<
        // MyTaxi.W1.CRE.DMIG.002 <<
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate("Gen. Bus. Posting Group", '');
        GenJnlLine.Validate("Gen. Prod. Posting Group", '');
        GenJnlLine.Validate("VAT Bus. Posting Group", '');
        GenJnlLine.Validate("VAT Prod. Posting Group", '');
        // MyTaxi.W1.CRE.DMIG.002 >>
        if Rec.VATCode <> '' then
            DataMigrationVATGroupMap.Get(Rec.VATCode)
        else
            DataMigrationVATGroupMap.Init();

        if Rec.CustomerNo <> '' then begin
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.Validate("Account No.", Rec.CustomerNo);
            CustomerPostingGroup.SetRange("Receivables Account", DataMigrationGLAccountMap."Local Account");
            CustomerPostingGroup.FindFirst();
            GenJnlLine.Validate("Posting Group", CustomerPostingGroup.Code);
            GenJnlLine.Validate("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.Validate("Source No.", Rec.CustomerNo);
            Customer.Get(Rec.CustomerNo);
        end
        else
            if Rec.SupplierNo <> '' then begin
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.Validate("Account No.", Rec.SupplierNo);
                VendorPostingGroup.SetRange("Payables Account", DataMigrationGLAccountMap."Local Account");
                VendorPostingGroup.FindFirst();
                GenJnlLine.Validate("Posting Group", VendorPostingGroup.Code);
                GenJnlLine.Validate("Source Type", GenJnlLine."Source Type"::Vendor);
                GenJnlLine.Validate("Source No.", Rec.SupplierNo);
                Vendor.Get(Rec.SupplierNo);
            end;

        case Rec.EntryType of
            'Manual customer invoice':
                begin
                    // MyTaxi.W1.CRE.DMIG.003 <<
                    /*Processed :=TRUE;
                    "Processed On" := CURRENTDATETIME;
                    "Processed By" := USERID;
                    MODIFY;
                    EXIT;
                    GenJnlLine."Document No." := Text;
                    GenJnlLine."External Document No." := EntryNo;*/
                    // MyTaxi.W1.CRE.DMIG.003 >>
                    // MyTaxi.W1.CRE.DMIG.002 <<
                    /*VATPostingSetup.RESET;
                    VATPostingSetup.SETRANGE(VATPostingSetup."Sales VAT Account",DataMigrationGLAccountMap."Local Account");
                    IF (CustomerNo='') AND (GLAccount."Income/Balance"=GLAccount."Income/Balance"::"Balance Sheet")
                        AND (VATCode<>'') AND VATPostingSetup.FINDFIRST
                    THEN BEGIN
                      LastGenJnlLine.VALIDATE(Amount,LastGenJnlLine.Amount+AmountEUR);
                      LastGenJnlLine.MODIFY;
                      IF LastGenJnlLine."VAT Amount"<>AmountEUR THEN BEGIN
                        LastGenJnlLine.VALIDATE("VAT Amount",AmountEUR);
                        LastGenJnlLine.MODIFY;
                      END;
                    END;*/
                    // MyTaxi.W1.CRE.DMIG.002 >>
                    // MyTaxi.W1.CRE.DMIG.003 <<
                    if ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) and (Rec.Amount < 0)) or
                       ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (Rec.Amount > 0)) then
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::"Credit Memo")
                    else
                        // MyTaxi.W1.CRE.DMIG.003 >>
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Invoice);
                    GenJnlLine."External Document No." := Rec.InvoiceNo;
                    // MyTaxi.W1.CRE.DMIG.002 <<
                    /*IF GLAccount."Income/Balance"=GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                      GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
                      GenJnlLine.VALIDATE("VAT Bus. Posting Group",'DOMESTIC');
                      GenJnlLine.VALIDATE("VAT Prod. Posting Group",DataMigrationVATGroupMap."NAV VAT Prod Group");
                    END;*/
                    // MyTaxi.W1.CRE.DMIG.002 >>
                end;
            'Supplier invoice':
                begin
                    if Rec.SupplierInvoiceNo = '' then
                        GenJnlLine."External Document No." := CopyStr(Rec.Text, 1, MaxStrLen(GenJnlLine."External Document No."))
                    else
                        GenJnlLine."External Document No." := Rec.SupplierInvoiceNo;
                    // MyTaxi.W1.CRE.DMIG.002 <<
                    /*VATPostingSetup.RESET;
                    VATPostingSetup.SETRANGE(VATPostingSetup."Purchase VAT Account",DataMigrationGLAccountMap."Local Account");
                    IF (SupplierNo='') AND (GLAccount."Income/Balance"=GLAccount."Income/Balance"::"Balance Sheet")
                        AND (VATCode<>'') AND VATPostingSetup.FINDFIRST
                    THEN BEGIN
                      LastGenJnlLine.VALIDATE(Amount,LastGenJnlLine.Amount+AmountEUR);
                      LastGenJnlLine.MODIFY;
                      IF LastGenJnlLine."VAT Amount"<>AmountEUR THEN BEGIN
                        LastGenJnlLine.VALIDATE("VAT Amount",AmountEUR);
                        LastGenJnlLine.MODIFY;
                      END;
                      Processed :=TRUE;
                      "Processed On" := CURRENTDATETIME;
                      "Processed By" := USERID;
                      MODIFY;
                      CurrReport.SKIP;
                    END;*/
                    // MyTaxi.W1.CRE.DMIG.002 >>
                    // MyTaxi.W1.CRE.DMIG.003 <<
                    if ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and (Rec.Amount > 0)) or
                       ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (Rec.Amount < 0)) then
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::"Credit Memo")
                    else
                        // MyTaxi.W1.CRE.DMIG.003 >>
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Invoice);
                    GenJnlLine."External Document No." := Rec.SupplierInvoiceNo;
                    // MyTaxi.W1.CRE.DMIG.002 <<
                    /*IF GLAccount."Income/Balance"=GLAccount."Income/Balance"::"Income Statement" THEN BEGIN
                      GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                      GenJnlLine.VALIDATE("VAT Bus. Posting Group",Vendor."VAT Bus. Posting Group");
                      GenJnlLine.VALIDATE("VAT Prod. Posting Group",DataMigrationVATGroupMap."NAV VAT Prod Group");
                    END;*/
                    // MyTaxi.W1.CRE.DMIG.002 >>
                end;
            'Customer payment', 'Supplier payment':
                begin
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    // MyTaxi.W1.CRE.DMIG.003 >>
                    if ((Rec.EntryType = 'Customer payment') and (((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) and (Rec.Amount > 0)) or
                       ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (Rec.Amount < 0)))) or
                       ((Rec.EntryType = 'Supplier payment') and (((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and (Rec.Amount < 0)) or
                       ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (Rec.Amount > 0)))) then
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Refund);
                    // MyTaxi.W1.CRE.DMIG.003 <<
                    if (Rec.CustomerNo = '') and (Rec.SupplierNo = '') then begin
                        //BankAccountPostingGroup.SetRange("G/L Bank Account No.", DataMigrationGLAccountMap."Local Account");
                        if BankAccountPostingGroup.FindFirst() then
                            BankAccount.SetRange(BankAccount."Bank Acc. Posting Group", BankAccountPostingGroup.Code);
                        if BankAccount.FindFirst() then begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                            GenJnlLine.Validate("Account No.", BankAccount."No.");
                        end;
                    end
                    else begin
                        // MyTaxi.W1.CRE.DMIG.003 <<
                        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
                            if SalesInvoiceHeader.Get(Rec.InvoiceNo) then begin
                                CustLedgerEntry.Reset();
                                CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Payment);
                                CustLedgerEntry.SetRange("External Document No.", Rec.InvoiceNo);
                                CustLedgerEntry.SetRange(Open, true);
                                if CustLedgerEntry.FindFirst() then begin
                                    GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Payment);
                                    GenJnlLine.Validate("Applies-to Doc. No.", CustLedgerEntry."Document No.");
                                end
                                else begin
                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                                    CustLedgerEntry.SetRange("Document No.", Rec.InvoiceNo);
                                    CustLedgerEntry.SetRange(Open, true);
                                    if CustLedgerEntry.FindFirst() then begin
                                        GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                                        GenJnlLine.Validate("Applies-to Doc. No.", CustLedgerEntry."Document No.");
                                    end;
                                end;
                            end
                            else begin
                                CustLedgerEntry.Reset();
                                CustLedgerEntry.SetFilter("Document Type", '%1|%2|%3', CustLedgerEntry."Document Type"::" ", CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::Payment);
                                CustLedgerEntry.SetRange("External Document No.", Rec.InvoiceNo);
                                CustLedgerEntry.SetRange(Open, true);
                                if Rec.Amount > 0 then
                                    CustLedgerEntry.SetRange(Positive, true)
                                else
                                    CustLedgerEntry.SetRange(Positive, false);
                                if CustLedgerEntry.Count > 1 then
                                    CustLedgerEntry.SetRange("Remaining Amount", Rec.Amount);
                                if CustLedgerEntry.FindFirst() then begin
                                    GenJnlLine.Validate("Applies-to ID", GenJnlLine."Document No.");
                                    CustLedgerEntry.Validate("Applies-to ID", GenJnlLine."Document No.");
                                    CustLedgerEntry.Validate("Amount to Apply", Rec.Amount);
                                    CustLedgerEntry.Modify();
                                end;
                            end;
                            /*IF InvoiceNo<>'' THEN BEGIN
                                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                                GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                            END;*/
                            // MyTaxi.W1.CRE.DMIG.003 >>
                        end;
                    end;
                end;
            else begin
                Customer.Init();
                Vendor.Init();
            end;
        end;

        GenJnlLine.Description := CopyStr(Rec.Text, 1, MaxStrLen(GenJnlLine.Description));
        // MyTaxi.W1.CRE.DMIG.003 >>
        //GenJnlLine.VALIDATE(Amount,AmountEUR);
        GenJnlLine.Validate(Amount, Rec.Amount);
        // MyTaxi.W1.CRE.DMIG.003 <<
        GenJnlLine.Validate("Due Date", Rec.DueDate);
        if Rec.Department <> '' then begin
            DataMigrationCostCenterMap.Get(Rec.Department);
            GenJnlLine.Validate("Shortcut Dimension 2 Code", DataMigrationCostCenterMap."NAV Cost Center");
        end;
        GenJnlLine.Insert(true);
        LastGenJnlLine.Copy(GenJnlLine);
        Rec.Processed := true;
        Rec."Processed On" := CurrentDateTime;
        Rec."Processed By" := UserId;
        Rec."Journal Template Name" := GenJnlLine."Journal Template Name";
        Rec."Line No." := GenJnlLine."Line No.";
        Rec."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        Rec.Modify();
        Commit();

    end;

    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        LastGenJnlLine: Record "Gen. Journal Line";
        DataMigrationGLAccountMap: Record "Data Migration GL Account Map";
        DataMigrationVATGroupMap: Record "Data Migration VAT Group Map";
        DataMigrationCostCenterMap: Record "Data Migration Cost Center Map";
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        VATPostingSetup: Record "VAT Posting Setup";
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        NoSeriesLine: Record "No. Series Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlTemplate: Record "Gen. Journal Template";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BatchName: Code[10];
        TemplateCode: Code[20];
        JournalTemplate: Text[10];
        LineNo: Integer;
        OldDocNo: Code[20];
        OldCustNo: Code[20];
        OldSupNo: Code[20];
        Balance: Decimal;
        OldDocumentNo: Code[20];
        UseOldDocumentNo: Code[20];


    procedure SetParams(pBatchName: Code[10]; pJournalTemplate: Text[10]; pLineNo: Integer; pBalance: Decimal; pOldDocumentNo: Code[20]; pUseOldDocumentNo: Code[20])
    begin
        BatchName := pBatchName;
        JournalTemplate := pJournalTemplate;
        LineNo := pLineNo;
        Balance := pBalance;
        OldDocumentNo := pOldDocumentNo;
        UseOldDocumentNo := pUseOldDocumentNo;
    end;

    local procedure IncrementDocumentNo()
    var
        NoSeriesLine: Record "No. Series Line";
    begin
    end;
}

