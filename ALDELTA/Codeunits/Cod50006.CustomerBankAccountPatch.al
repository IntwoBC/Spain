codeunit 50006 "Customer Bank Account Patch"
{
    Permissions = tabledata Customer = RIMD, tabledata "Cust. Ledger Entry" = RIMD,
                  tabledata "Customer Bank Account" = RIMD,
                  tabledata "MyTaxi CRM Interface Records" = RIMD;
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        case Rec."Parameter String" of
            'EXECUTE PATCH':
                begin
                    ExecutePatch('', '');
                    Commit();
                end;
            'DELETE':
                begin
                    DeleteCustomerBankAccounts();
                    Commit();
                end;
        end;
    end;

    procedure ExecutePatch(CustomerNo: Code[20]; BankAccountCode: Code[20])
    begin
        if (CustomerNo <> '') xor (BankAccountCode <> '') then
            Error('Both Customer No. and Bank Account Code must be provided together.');

        if (CustomerNo <> '') and (BankAccountCode <> '') then begin
            EnsureCustomerBankAccountExists(CustomerNo, BankAccountCode);
            FindAndUpdate(CustomerNo, BankAccountCode);
            DeleteRemainingBankAccounts(CustomerNo, BankAccountCode);
            exit;
        end;

        ProcessCustomer();
    end;

    procedure ProcessCustomer()
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then
            repeat
                if Customer."Preferred Bank Account Code" = '' then begin
                    UpdateCustomerPreferredBankAccount(Customer."No.");
                    Customer.Get(Customer."No.");
                end;

                if Customer."Preferred Bank Account Code" <> '' then begin
                    if HasCustomerBankAccount(Customer."No.", Customer."Preferred Bank Account Code") then
                        FindAndUpdate(Customer."No.", Customer."Preferred Bank Account Code");
                end;
                Commit();
            until Customer.Next() = 0;
    end;

    procedure DeleteCustomerBankAccounts()
    var
        Customer: Record Customer;
    begin
        //Customer.SetRange("No.", '100011', '100253');
        Customer.SetFilter("Preferred Bank Account Code", '<>%1', '');
        if Customer.FindSet() then
            repeat
                if HasCustomerBankAccount(Customer."No.", Customer."Preferred Bank Account Code") then
                    DeleteRemainingBankAccounts(Customer."No.", Customer."Preferred Bank Account Code");
                Commit();
            until Customer.Next() = 0;
    end;

    local procedure FindAndUpdate(CustomerNo: Code[20]; BankAccountCode: Code[20])
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustomerLedgerEntry.SetFilter("Recipient Bank Account", '<>%1&<>%2', BankAccountCode, '');
        if CustomerLedgerEntry.FindSet() then begin
            repeat
                CustomerLedgerEntry."Recipient Bank Account" := BankAccountCode;
                CustomerLedgerEntry.Modify();
            until CustomerLedgerEntry.Next() = 0;
        end;
    end;

    local procedure EnsureCustomerBankAccountExists(CustomerNo: Code[20]; BankAccountCode: Code[20])
    begin
        if not HasCustomerBankAccount(CustomerNo, BankAccountCode) then
            Error('Bank account %1 does not exist for customer %2.', BankAccountCode, CustomerNo);
    end;

    local procedure HasCustomerBankAccount(CustomerNo: Code[20]; BankAccountCode: Code[20]): Boolean
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        exit(CustomerBankAccount.Get(CustomerNo, BankAccountCode));
    end;

    local procedure DeleteRemainingBankAccounts(CustomerNo: Code[20]; BankAccountCode: Code[20])
    var
        pCustomerBankAccountL: Record "Customer Bank Account";
    begin
        pCustomerBankAccountL.SetRange("Customer No.", CustomerNo);
        pCustomerBankAccountL.SetFilter(Code, '<>%1', BankAccountCode);
        pCustomerBankAccountL.DeleteAll();
    end;

    procedure CustomerUpdateAction(CustomerNo: Code[20]; BankAccount: Code[20])
    begin
        EnsureCustomerBankAccountExists(CustomerNo, BankAccount);
        FindAndUpdate(CustomerNo, BankAccount);
        DeleteRemainingBankAccounts(CustomerNo, BankAccount);
    end;

    procedure UpdateCustomerPreferredBankAccount(CustomerNo: Code[20])
    var
        CustomerL: Record Customer;
        CustRecords: Record "MyTaxi CRM Interface Records";
        CustomerNoL: Integer;
        BankAccountCode: Code[20];
    begin
        if not Evaluate(CustomerNoL, CustomerNo) then
            exit;

        CustRecords.SetRange(number, CustomerNoL);
        CustRecords.SetFilter("Transfer Date", '<>%1', 0D);
        CustRecords.SetFilter("NAV Bank Account Code", '<>%1', '');
        CustRecords.SetCurrentKey("Transfer Date");
        CustRecords.Ascending(false);

        if CustRecords.FindFirst() then begin
            BankAccountCode := CustRecords."NAV Bank Account Code";

            if not HasCustomerBankAccount(CustomerNo, BankAccountCode) then
                exit;

            if CustomerL.Get(CustomerNo) then begin
                if CustomerL."Preferred Bank Account Code" = BankAccountCode then
                    exit;

                CustomerL.Validate("Preferred Bank Account Code", BankAccountCode);
                CustomerL.Modify();
            end;
        end;
    end;
}
