codeunit 60026 "Company Type Management"
{
    // MP 25-11-13
    // Object created (CR 30)
    // 
    // MP 07-05-14
    // Changed filter in function gfcnApplyFilterGLAcc
    // 
    // MP 15-06-15
    // Added function LookupUser, Identical copy of function of same name from Codeunit 418 User Management, in order to
    // hide user listing for client access


    trigger OnRun()
    begin
    end;

    var
        grecEYCoreSetup: Record "EY Core Setup";
        gblnEYCoreSetupRead: Boolean;


    procedure gfcnApplyFilterGLAcc(var precGLAcc: Record "G/L Account"; pintFilterGroup: Integer) rblnIsBottomUp: Boolean
    var
        lrecGenJnlTemplate: Record "Gen. Journal Template";
    begin
        // MP 25-11-13

        rblnIsBottomUp := gfcnIsBottomUp();
        if rblnIsBottomUp then begin
            if pintFilterGroup <> 0 then
                precGLAcc.FilterGroup(pintFilterGroup);

            // MP 07-05-14 >>
            //SETRANGE("Global Dimension 1 Filter",'');
            lrecGenJnlTemplate.SetRange(Type, lrecGenJnlTemplate.Type::"Group Adjustments");
            lrecGenJnlTemplate.FindFirst();
            precGLAcc.SetFilter("Global Dimension 1 Filter", '%1|%2', '', lrecGenJnlTemplate."Shortcut Dimension 1 Code");
            // MP 07-05-14 <<

            if pintFilterGroup <> 0 then
                precGLAcc.FilterGroup(0);
        end;
    end;


    procedure gfcnApplyFilterCorpGLAcc(var precCorpGLAcc: Record "Corporate G/L Account"; pintFilterGroup: Integer) rblnIsBottomUp: Boolean
    begin
        // MP 25-11-13

        rblnIsBottomUp := gfcnIsBottomUp();
        if not rblnIsBottomUp then begin
            if pintFilterGroup <> 0 then
                precCorpGLAcc.FilterGroup(pintFilterGroup);

            precCorpGLAcc.SetRange("Global Dimension 1 Filter", '');

            if pintFilterGroup <> 0 then
                precCorpGLAcc.FilterGroup(0);
        end;
    end;

    local procedure lfcnGetEYCoreSetup()
    begin
        // MP 25-11-13

        if not gblnEYCoreSetupRead then begin
            grecEYCoreSetup.Get();
            grecEYCoreSetup.CalcFields("Corp. Accounts In use");
            gblnEYCoreSetupRead := true;
        end;
    end;


    procedure gfcnIsBottomUp() rblnIsBottomUp: Boolean
    begin
        // MP 25-11-13

        lfcnGetEYCoreSetup();
        rblnIsBottomUp := grecEYCoreSetup."Company Type" = grecEYCoreSetup."Company Type"::"Bottom-up";
    end;


    procedure gfcnCorpAccInUse() rblnCorpAccInUse: Boolean
    begin
        // MP 25-11-13

        lfcnGetEYCoreSetup();
        rblnCorpAccInUse := grecEYCoreSetup."Corp. Accounts In use";
    end;


    procedure gfcnGetAccPeriodTableID() rintTableID: Integer
    begin
        // MP 25-11-13

        lfcnGetEYCoreSetup();
        if (grecEYCoreSetup."Company Type" = grecEYCoreSetup."Company Type"::"Bottom-up") and
          (not grecEYCoreSetup."Corp. Accounts In use")
        then
            exit(DATABASE::"Accounting Period");

        exit(DATABASE::"Corporate Accounting Period");
    end;
}

