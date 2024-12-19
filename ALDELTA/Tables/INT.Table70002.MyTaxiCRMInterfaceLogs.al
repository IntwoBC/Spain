table 70002 "MyTaxi CRM Interface Logs"
{
    // #MyTaxi.W1.EDD.INT01.001 19/12/2016 CCFR.SDE : MyTaxi CRM Interface
    //   Table Creation

    Caption = 'MyTaxi CRM Interface Logs';
    DrillDownPageID = "MyTaxi CRM Int. Posting Setup";
    LookupPageID = "MyTaxi CRM Int. Posting Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Batch No."; Integer)
        {
            Caption = 'Batch No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Error,Warning,Information;
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; Time; Time)
        {
            Caption = 'Time';
        }
        field(6; "Interface Code"; Option)
        {
            Caption = 'Interface Code';
            OptionCaption = ' ,Customer,Invoice,Credit Memo';
            OptionMembers = " ",Customer,Invoice,"Credit Memo";
        }
        field(7; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(9; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(10; "Table Position"; Text[250])
        {
            Caption = 'Table Position';
        }
        field(11; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(13; "File Link"; Text[250])
        {
            Caption = 'File Link';
            Editable = false;

            trigger OnLookup()
            begin
                HyperLink("File Link");
            end;
        }
        field(14; "Flow Type"; Option)
        {
            Caption = 'Flow Type';
            OptionMembers = " ",Process,Import,Export;
        }
        field(15; "Sent by Email"; Boolean)
        {
            Caption = 'Sent by Email';
        }
        field(16; "Email Date"; Date)
        {
            Caption = 'Email Date';
        }
        field(17; "Email Time"; Time)
        {
            Caption = 'Email Time';
        }
        field(18; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            NotBlank = true;
            TableRelation = "Reason Code";
        }
        field(19; "Reason Description"; Text[50])
        {
            CalcFormula = Lookup("Reason Code".Description WHERE(Code = FIELD("Reason Code")));
            Caption = 'Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        NextEntryNo: Integer;


    procedure SetError(TheInterfaceCode: Option " ",Customer,Invoice,"Credit Memo"; TheType: Option Error,Warning,Information; TheTableID: Integer; TheTablePosition: Text[250]; TheError: Text[250]; TheError2: Text[250]; TheBatchNo: Integer; TheFlowType: Option; TheFileLink: Text[250]; TheUserID: Code[50]; TheReasonCode: Code[10]): Integer
    begin
        LockTable();

        if FindLast() then
            NextEntryNo := "Entry No." + 1
        else
            NextEntryNo := 1;

        Init();

        "Interface Code" := TheInterfaceCode;
        Date := Today;
        Time := SYSTEM.Time;
        Type := TheType;
        "Entry No." := NextEntryNo;
        Description := TheError;
        "Description 2" := TheError2;
        "Table ID" := TheTableID;
        "Table Position" := TheTablePosition;
        "Batch No." := TheBatchNo;
        "Flow Type" := TheFlowType;
        "File Link" := TheFileLink;
        "User ID" := TheUserID;
        "Reason Code" := TheReasonCode;
        Insert();
        exit(NextEntryNo);
    end;


    procedure ShowError()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        CompanyInfo: Record "Company Information";
        RecRef: RecordRef;
        SalesHeader: Record "Sales Header";
    begin
        if "Table ID" = 0 then
            exit;

        RecRef.Open("Table ID");
        RecRef.SetPosition("Table Position");

        case "Table ID" of
            DATABASE::"Sales Header":
                begin
                    RecRef.SetTable(SalesHeader);
                    SalesHeader.SetRecFilter();
                    case SalesHeader."Document Type" of
                        SalesHeader."Document Type"::Quote:
                            PAGE.RunModal(PAGE::"Sales Quote", SalesHeader);
                        SalesHeader."Document Type"::Order:
                            PAGE.RunModal(PAGE::"Sales Order", SalesHeader);
                        SalesHeader."Document Type"::Invoice:
                            PAGE.RunModal(PAGE::"Sales Invoice", SalesHeader);
                        SalesHeader."Document Type"::"Credit Memo":
                            PAGE.RunModal(PAGE::"Sales Credit Memo", SalesHeader);
                        SalesHeader."Document Type"::"Blanket Order":
                            PAGE.RunModal(PAGE::"Blanket Sales Order", SalesHeader);
                        SalesHeader."Document Type"::"Return Order":
                            PAGE.RunModal(PAGE::"Sales Return Order", SalesHeader);
                    end;
                end;
        end;
    end;
}

