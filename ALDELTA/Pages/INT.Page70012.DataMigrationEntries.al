page 70012 "Data Migration Entries"
{
    // #MyTaxi.W1.CRE.DMIG.001 15/05/2017 CCFR.SDE : MyTaxi - Legacy System Data Migration
    //   Page Creation

    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Data Migration Entries";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SerialNo; Rec.SerialNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SerialNo field.';
                }
                field(EntryType; Rec.EntryType)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the EntryType field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(AccountNo; Rec.AccountNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the AccountNo field.';
                }
                field(EntryNo; Rec.EntryNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(Text; Rec.Text)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Text field.';
                }
                field(AmountEUR; Rec.AmountEUR)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the AmountEUR field.';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(ProjectNo; Rec.ProjectNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ProjectNo field.';
                }
                field(ActivityNo; Rec.ActivityNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ActivityNo field.';
                }
                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CustomerNo field.';
                }
                field(SupplierNo; Rec.SupplierNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SupplierNo field.';
                }
                field(InvoiceNo; Rec.InvoiceNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the InvoiceNo field.';
                }
                field(SupplierInvoiceNo; Rec.SupplierInvoiceNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SupplierInvoiceNo field.';
                }
                field(DueDate; Rec.DueDate)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the DueDate field.';
                }
                field(VATCode; Rec.VATCode)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VATCode field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Unit1No; Rec.Unit1No)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit1No field.';
                }
                field(Unit2No; Rec.Unit2No)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit2No field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Quantity2; Rec.Quantity2)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity2 field.';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field("Processed On"; Rec."Processed On")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Processed On field.';
                }
                field("Processed By"; Rec."Processed By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Processed By field.';
                }
                field("Error Description 1"; Rec."Error Description 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Error Description 1 field.';
                }
                field("Error Description 2"; Rec."Error Description 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Error Description 2 field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("1- Import Data")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the 1- Import Data action.';

                trigger OnAction()
                begin
                    XMLPORT.Run(XMLPORT::"Data Migration Entries");
                    CurrPage.Update();
                end;
            }
            action("2- Process")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Data Migration Process";
                ToolTip = 'Executes the 2- Process action.';
            }
            action("3 - Update Doc Type on Journal")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Data Migration - Update Doc Ty";
                ToolTip = 'Executes the 3 - Update Doc Type on Journal action.';
            }
        }
    }
}

