query 50003 "Budget Query"
{

    elements
    {
        dataitem(G_L_Budget_Entry; "G/L Budget Entry")
        {
            column(Budget_Month; Date)
            {
                Method = Month;
            }
            column(Budget_Year; Date)
            {
                Method = Year;
            }
            column(Budget_Local_GL_Account; "G/L Account No.")
            {
            }
            column(Budget_Amount; Amount)
            {
            }
            column(Budget_Cost_Center; "Global Dimension 2 Code")
            {
            }
            dataitem(Corporate_G_L_Account; "Corporate G/L Account")
            {
                DataItemLink = "Local G/L Account No." = G_L_Budget_Entry."G/L Account No.";
                column(Budget_Corporate_GL_Account; "No.")
                {
                }
                column(Budget_Local_GL_Account_Check; "Local G/L Account No.")
                {
                }
            }
        }
    }
}

