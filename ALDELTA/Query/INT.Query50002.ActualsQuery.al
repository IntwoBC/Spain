query 50002 "Actuals Query"
{

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(Actuals_Month; "Posting Date")
            {
                Method = Month;
            }
            column(Actuals_Year; "Posting Date")
            {
                Method = Year;
            }
            column(Actuals_Corporate_GL_Account; "Corporate G/L Account No.")
            {
            }
            column(Actuals_Amount; Amount)
            {
                Method = Sum;
                ReverseSign = false;
            }
            dataitem(Corporate_G_L_Account; "Corporate G/L Account")
            {
                DataItemLink = "No." = G_L_Entry."Corporate G/L Account No.";
                filter(Income_Balance; "Income/Balance")
                {
                    ColumnFilter = Income_Balance = CONST("Income Statement");
                }
                column(Actuals_Corporate_GL_Account_N; Name)
                {
                }
                column(Actuals_Local_GL_Account; "Local G/L Account No.")
                {
                }
                dataitem(Dimension_Set_Entry; "Dimension Set Entry")
                {
                    DataItemLink = "Dimension Set ID" = G_L_Entry."Dimension Set ID";
                    filter(Dimension_Code; "Dimension Code")
                    {
                        ColumnFilter = Dimension_Code = CONST('COST CENTER');
                    }
                    column(Actuals_Cost_Center; "Dimension Value Code")
                    {
                    }
                }
            }
        }
    }
}

