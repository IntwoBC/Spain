query 50001 "Default Dimension Query"
{

    elements
    {
        dataitem(Corporate_G_L_Account; "Corporate G/L Account")
        {
            column(Corporate_GL_Account; "No.")
            {
            }
            dataitem(Default_Dimension; "Default Dimension")
            {
                DataItemLink = "No." = Corporate_G_L_Account."No.";
                filter(Table_ID; "Table ID")
                {
                    ColumnFilter = Table_ID = CONST(15);
                }
                filter(Dimension_Code; "Dimension Code")
                {
                    ColumnFilter = Dimension_Code = CONST('MMR ACCOUNT');
                }
                column(MMR_Account_Code; "Dimension Value Code")
                {
                }
            }
        }
    }
}

