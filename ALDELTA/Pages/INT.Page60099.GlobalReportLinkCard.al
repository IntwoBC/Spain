page 60099 "Global Report Link Card"
{
    Caption = 'Global Report Link Card';
    PageType = Card;
    SourceTable = "Line Number Buffer";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("grecRecordLink.Description"; grecRecordLink.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(gtxtURL; gtxtURL)
                {
                    Caption = 'Link Address';
                    ApplicationArea = all;
                    ExtendedDatatype = URL;
                    ToolTip = 'Specifies the value of the Link Address field.';


                    trigger OnValidate()
                    begin
                        grecRecordLink.URL1 := CopyStr(gtxtURL, 1, 250);
                        // grecRecordLink.URL2 := CopyStr(gtxtURL, 251, 500);
                        //grecRecordLink.URL3 := CopyStr(gtxtURL, 501, 750);
                        //grecRecordLink.URL4 := CopyStr(gtxtURL, 751, 1000);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        grecRecordLink.Get(Rec."Old Line Number");
        //  gtxtURL := grecRecordLink.URL1 + grecRecordLink.URL2 + grecRecordLink.URL3 + grecRecordLink.URL4;
    end;

    trigger OnClosePage()
    begin
        grrfRecord.Close();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        exit(grecRecordLink.Delete(true));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Clear(grecRecordLink."Link ID");
        grecRecordLink."Record ID" := grrfRecord.RecordId;
        grecRecordLink.Insert(true);
        Rec."Old Line Number" := grecRecordLink."Link ID";
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        exit(grecRecordLink.Modify(true));
    end;

    trigger OnOpenPage()
    begin
        grrfRecord.Open(DATABASE::"EY Core Setup");
        grrfRecord.FindFirst();
    end;

    var
        grecRecordLink: Record "Record Link";
        grrfRecord: RecordRef;
        gtxtURL: Text[1024];
}

