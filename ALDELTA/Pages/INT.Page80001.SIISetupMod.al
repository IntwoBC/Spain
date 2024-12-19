page 80001 "SII Setup Mod"
{
    PageType = List;
    SourceTable = "SII Setup";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Primary Key field.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
                // field(Certificate; Rec.Certificate)
                // {ApplicationArea=all;
                // }
                // field(Password; Rec.Password)
                // {ApplicationArea=all;
                // }
                field(InvoicesIssuedEndpointUrl; Rec.InvoicesIssuedEndpointUrl)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the InvoicesIssuedEndpointUrl field.';
                }
                field(InvoicesReceivedEndpointUrl; Rec.InvoicesReceivedEndpointUrl)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the InvoicesReceivedEndpointUrl field.';
                }
                field(PaymentsIssuedEndpointUrl; Rec.PaymentsIssuedEndpointUrl)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PaymentsIssuedEndpointUrl field.';
                }
                field(PaymentsReceivedEndpointUrl; Rec.PaymentsReceivedEndpointUrl)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PaymentsReceivedEndpointUrl field.';
                }
                // field(IntracommunityEndpointUrl; Rec.IntracommunityEndpointUrl)
                // {ApplicationArea=all;
                // }
                field("Enable Batch Submissions"; Rec."Enable Batch Submissions")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Enable Batch Submissions field.';
                }
                field("Job Batch Submission Threshold"; Rec."Job Batch Submission Threshold")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Batch Submission Threshold field.';
                }
                field("Show Advanced Actions"; Rec."Show Advanced Actions")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Show Advanced Actions field.';
                }
                field(CollectionInCashEndpointUrl; Rec.CollectionInCashEndpointUrl)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CollectionInCashEndpointUrl field.';
                }
                field("Invoice Amount Threshold"; Rec."Invoice Amount Threshold")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoice Amount Threshold field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Auto Missing Entries Check"; Rec."Auto Missing Entries Check")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Auto Missing Entries Check field.';
                }
            }
        }
    }

    actions
    {
    }
}

