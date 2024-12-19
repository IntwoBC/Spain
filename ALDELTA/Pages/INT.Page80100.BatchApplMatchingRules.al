page 80100 "Batch Appl. Matching Rules"
{
    PageType = List;
    SourceTable = "Batch Appl. Matching Rule";
    ApplicationArea = All;
UsageCategory=lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Use For Cust. Ledger Entries"; Rec."Use For Cust. Ledger Entries")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Use For Cust. Ledger Entries field.';
                }
                field("Use For Vend. Ledger Entries"; Rec."Use For Vend. Ledger Entries")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Use For Vend. Ledger Entries field.';
                }
                field("Regular Expr. Matching Pattern"; Rec."Regular Expr. Matching Pattern")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Regular Expr. Matching Pattern field.';
                }
            }
            grid("Regular Expression Test")
            {
                Caption = 'Regular Expression Test';
                GridLayout = Columns;

                group(Control80113)
                {
                    ShowCaption = false;
                    field(TestText; TestText)
                    {
                        Caption = 'Test Text';
                        MultiLine = true;
                        ShowCaption = false;
                        Width = 300;
                        ApplicationArea = all;
                    }
                    field(ResultText; ResultText)
                    {
                        Caption = 'Result';
                        Editable = false;
                        ApplicationArea = all;
                        ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                    }
                    field(UpdateResultLbl; UpdateResultLbl)
                    {
                        Editable = false;
                        ShowCaption = false;
                        ApplicationArea = all;

                        trigger OnDrillDown()
                        begin
                            //    ResultText := MatchTextBasedOnPattern(TestText);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Regular Expression")
            {
                Caption = 'Test Regular Expression';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Test Regular Expression action.';

                trigger OnAction()
                begin
                    // Message(MatchTextBasedOnPattern(TestText));
                end;
            }
        }
    }

    var
        TestText: Text;
        ResultText: Text;
        UpdateResultLbl: Label 'Update';
}

