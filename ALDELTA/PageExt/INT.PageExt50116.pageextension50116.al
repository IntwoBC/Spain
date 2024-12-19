pageextension 50116 pageextension50116 extends "G/L Balance by Dimension"
{
    // MP 25-11-13
    // Added filtering depending on Company Type (CR 30) - NAV 2016 upgrade note - cannot be implemented as events/extensions

    var
        lmdlCompanyTypeMgt: Codeunit "Company Type Management";


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: lmdlCompanyTypeMgt)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnBeforeGLAccFilter(GLAcc,GLAccFilter,LineDimOption,ColumnDimOption);
    GlobalDim1Filter := GLAcc.GetFilter("Global Dimension 1 Filter");
    GlobalDim2Filter := GLAcc.GetFilter("Global Dimension 2 Filter");

    #5..23

    MATRIX_NoOfColumns := 32;
    MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // {>>>>>>>} ORIGINAL
    //{=======} MODIFIED
    // lmdlCompanyTypeMgt.gfcnApplyFilterGLAcc(GLAcc,0); // MP 25-11-13
    // {=======} TARGET
    OnBeforeGLAccFilter(GLAcc,GLAccFilter,LineDimOption,ColumnDimOption);
    // {<<<<<<<}
    #2..26
    */
    //end;
}

