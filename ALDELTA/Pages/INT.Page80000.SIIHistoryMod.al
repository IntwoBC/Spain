page 80000 "SII History Mod"
{
    PageType = List;
    SourceTable = "SII History";
    ApplicationArea = All;
    UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field("Document State Id"; Rec."Document State Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document State Id field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field("Retries Left"; Rec."Retries Left")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Retries Left field.';
                }
                field("Request XML"; Rec."Request XML")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Request XML field.';
                }
                field("Response XML"; Rec."Response XML")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Response XML field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Error Message field.';
                }
                field("Upload Type"; Rec."Upload Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Upload Type field.';
                }
                field("Is Manual"; Rec."Is Manual")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Manual field.';
                }
                field("Is Accepted With Errors Retry"; Rec."Is Accepted With Errors Retry")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Accepted With Errors Retry field.';
                }
                field("Session Id"; Rec."Session Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Session Id field.';
                }
                field("Retry Accepted"; Rec."Retry Accepted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Retry Accepted field.';
                }
            }
        }
    }

    actions
    {
    }
}

