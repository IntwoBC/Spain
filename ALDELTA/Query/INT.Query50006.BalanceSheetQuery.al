query 50006 "Balance Sheet Query"
{

    elements
    {
        dataitem(G_L_Entry; "G/L Entry")
        {
            column(BS_Posting_Date; "Posting Date")
            {
            }
            column(BS_Posting_Month; "Posting Date")
            {
                Method = Month;
            }
            column(BS_Posting_Year; "Posting Date")
            {
                Method = Year;
            }
            column(BS_Corporate_GL_Account; "Corporate G/L Account No.")
            {
            }
            column(BS_Amount; Amount)
            {
                Method = Sum;
            }
            dataitem(Corporate_G_L_Account; "Corporate G/L Account")
            {
                DataItemLink = "No." = G_L_Entry."Corporate G/L Account No.";
                filter(Income_Balance; "Income/Balance")
                {
                    ColumnFilter = Income_Balance = CONST("Balance Sheet");
                }
                column(BS_Corporate_GL_Account_N; Name)
                {
                }
                column(BS_Local_GL_Account; "Local G/L Account No.")
                {
                }
            }
        }
    }
}

