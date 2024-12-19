query 50005 "Cost Center Query"
{

    elements
    {
        dataitem(Dimension_Value; "Dimension Value")
        {
            filter(Dimension_Code; "Dimension Code")
            {
                ColumnFilter = Dimension_Code = CONST('COST CENTER');
            }
            filter(Dimension_Value_Type; "Dimension Value Type")
            {
                ColumnFilter = Dimension_Value_Type = CONST(Standard);
            }
            column(CC_Code; "Code")
            {
            }
        }
    }
}

