query 50004 "Corporate Account Query"
{

    elements
    {
        dataitem(Corporate_G_L_Account; "Corporate G/L Account")
        {
            filter(Income_Balance; "Income/Balance")
            {
                ColumnFilter = Income_Balance = CONST("Income Statement");
            }
            column(Corporate_GL_Account; "No.")
            {
            }
        }
    }
}

