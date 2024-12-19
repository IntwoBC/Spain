codeunit 61000 "T:Currency"
{
    // #EYCOS.W1.ISS.GL01.001 16/05/2018 CCFR.SDE : E&Y CORE Bug fixing - Field "Invoice Currency Code" in table "Job Planning Line" & Table "BizTalk Partner Currency Map"
    // do not exist since NAV 2013
    //   Modified function : lfncIsUsed
    // #EYCOS.W1.ISS.GL01.002 24/07/2019 CCFR.SDE : E&Y CORE Bug fixing - Skip the existance check in case of temporary record
    //   Modified function : levtOnBeforeDelete


    trigger OnRun()
    begin
    end;

    var
        ERROR001: Label 'Currency cannot be deleted, because it is is used in table "%1"';

    [EventSubscriber(ObjectType::Table, 4, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure levtOnBeforeDelete(var Rec: Record Currency; RunTrigger: Boolean)
    var
        lintInteger: Integer;
        lrrRecRef: RecordRef;
    begin
        // EYCOS.W1.ISS.GL01.002 <<
        if Rec.IsTemporary then
            exit;
        // EYCOS.W1.ISS.GL01.002 >>
        lintInteger := lfncIsUsed(Rec.Code);
        if lintInteger <> 0 then begin
            lrrRecRef.Open(lintInteger);
            Error(ERROR001, lrrRecRef.Name);
        end;
    end;

    local procedure lfncIsUsed(p_codValue: Code[10]): Integer
    begin
        // Checks if the currency is used in any related field of any other table
        if lfncCheckTable(18, 22, p_codValue) then exit(18);
        if lfncCheckTable(18, 111, p_codValue) then exit(18);
        if lfncCheckTable(19, 5, p_codValue) then exit(19);
        if lfncCheckTable(21, 11, p_codValue) then exit(21);
        if lfncCheckTable(21, 67, p_codValue) then exit(21);
        if lfncCheckTable(23, 22, p_codValue) then exit(23);
        if lfncCheckTable(23, 111, p_codValue) then exit(23);
        if lfncCheckTable(24, 5, p_codValue) then exit(24);
        if lfncCheckTable(25, 11, p_codValue) then exit(25);
        if lfncCheckTable(25, 65, p_codValue) then exit(25);
        if lfncCheckTable(36, 32, p_codValue) then exit(36);
        if lfncCheckTable(37, 91, p_codValue) then exit(37);
        if lfncCheckTable(38, 32, p_codValue) then exit(38);
        if lfncCheckTable(39, 91, p_codValue) then exit(39);
        if lfncCheckTable(81, 12, p_codValue) then exit(81);
        if lfncCheckTable(81, 99, p_codValue) then exit(81);
        if lfncCheckTable(83, 73, p_codValue) then exit(83);
        if lfncCheckTable(86, 5, p_codValue) then exit(86);
        if lfncCheckTable(98, 68, p_codValue) then exit(98);
        if lfncCheckTable(110, 32, p_codValue) then exit(110);
        if lfncCheckTable(112, 32, p_codValue) then exit(112);
        if lfncCheckTable(114, 32, p_codValue) then exit(114);
        if lfncCheckTable(120, 32, p_codValue) then exit(120);
        if lfncCheckTable(122, 32, p_codValue) then exit(122);
        if lfncCheckTable(124, 32, p_codValue) then exit(124);
        if lfncCheckTable(167, 1001, p_codValue) then exit(167);
        if lfncCheckTable(167, 1011, p_codValue) then exit(167);
        if lfncCheckTable(169, 1009, p_codValue) then exit(169);
        if lfncCheckTable(170, 3, p_codValue) then exit(170);
        if lfncCheckTable(173, 3, p_codValue) then exit(173);
        if lfncCheckTable(179, 10, p_codValue) then exit(179);
        if lfncCheckTable(201, 6, p_codValue) then exit(201);
        if lfncCheckTable(210, 93, p_codValue) then exit(210);
        if lfncCheckTable(210, 1008, p_codValue) then exit(210);
        if lfncCheckTable(220, 14, p_codValue) then exit(220);
        if lfncCheckTable(246, 29, p_codValue) then exit(246);
        if lfncCheckTable(264, 1, p_codValue) then exit(264);
        if lfncCheckTable(270, 22, p_codValue) then exit(270);
        if lfncCheckTable(271, 11, p_codValue) then exit(271);
        if lfncCheckTable(287, 16, p_codValue) then exit(287);
        if lfncCheckTable(288, 16, p_codValue) then exit(288);
        if lfncCheckTable(295, 12, p_codValue) then exit(295);
        if lfncCheckTable(297, 12, p_codValue) then exit(297);
        if lfncCheckTable(302, 12, p_codValue) then exit(302);
        if lfncCheckTable(304, 12, p_codValue) then exit(304);
        if lfncCheckTable(317, 7, p_codValue) then exit(317);
        if lfncCheckTable(328, 2, p_codValue) then exit(328);
        if lfncCheckTable(329, 3, p_codValue) then exit(329);
        if lfncCheckTable(330, 1, p_codValue) then exit(330);
        if lfncCheckTable(330, 5, p_codValue) then exit(330);
        if lfncCheckTable(331, 1, p_codValue) then exit(331);
        if lfncCheckTable(332, 1, p_codValue) then exit(332);
        if lfncCheckTable(335, 5, p_codValue) then exit(335);
        if lfncCheckTable(372, 2, p_codValue) then exit(372);
        if lfncCheckTable(379, 10, p_codValue) then exit(379);
        if lfncCheckTable(380, 10, p_codValue) then exit(380);
        if lfncCheckTable(382, 11, p_codValue) then exit(382);
        if lfncCheckTable(382, 67, p_codValue) then exit(382);
        if lfncCheckTable(383, 10, p_codValue) then exit(383);
        if lfncCheckTable(384, 2, p_codValue) then exit(384);
        if lfncCheckTable(413, 3, p_codValue) then exit(413);
        if lfncCheckTable(426, 32, p_codValue) then exit(426);
        if lfncCheckTable(427, 91, p_codValue) then exit(427);
        if lfncCheckTable(428, 32, p_codValue) then exit(428);
        if lfncCheckTable(429, 91, p_codValue) then exit(429);
        if lfncCheckTable(430, 32, p_codValue) then exit(430);
        if lfncCheckTable(431, 91, p_codValue) then exit(431);
        if lfncCheckTable(432, 32, p_codValue) then exit(432);
        if lfncCheckTable(433, 91, p_codValue) then exit(433);
        if lfncCheckTable(434, 32, p_codValue) then exit(434);
        if lfncCheckTable(435, 91, p_codValue) then exit(435);
        if lfncCheckTable(436, 32, p_codValue) then exit(436);
        if lfncCheckTable(437, 91, p_codValue) then exit(437);
        if lfncCheckTable(438, 32, p_codValue) then exit(438);
        if lfncCheckTable(439, 91, p_codValue) then exit(439);
        if lfncCheckTable(440, 32, p_codValue) then exit(440);
        if lfncCheckTable(441, 91, p_codValue) then exit(441);
        if lfncCheckTable(454, 17, p_codValue) then exit(454);
        if lfncCheckTable(456, 17, p_codValue) then exit(456);
        if lfncCheckTable(751, 12, p_codValue) then exit(751);
        if lfncCheckTable(829, 13, p_codValue) then exit(829);
        if lfncCheckTable(1003, 1023, p_codValue) then exit(1003);
        // EYCOS.W1.ISS.GL01.001 <<
        //IF lfncCheckTable(1003, 1047, p_codValue) THEN EXIT(1003);
        // EYCOS.W1.ISS.GL01.001 >>
        if lfncCheckTable(1012, 7, p_codValue) then exit(1012);
        if lfncCheckTable(1013, 6, p_codValue) then exit(1013);
        if lfncCheckTable(1014, 6, p_codValue) then exit(1014);
        if lfncCheckTable(5050, 22, p_codValue) then exit(5050);
        if lfncCheckTable(5105, 22, p_codValue) then exit(5105);
        if lfncCheckTable(5107, 32, p_codValue) then exit(5107);
        if lfncCheckTable(5108, 91, p_codValue) then exit(5108);
        if lfncCheckTable(5109, 32, p_codValue) then exit(5109);
        if lfncCheckTable(5110, 91, p_codValue) then exit(5110);
        if lfncCheckTable(5822, 14, p_codValue) then exit(5822);
        if lfncCheckTable(5900, 32, p_codValue) then exit(5900);
        if lfncCheckTable(5902, 91, p_codValue) then exit(5902);
        if lfncCheckTable(5965, 81, p_codValue) then exit(5965);
        if lfncCheckTable(5970, 81, p_codValue) then exit(5970);
        if lfncCheckTable(5990, 32, p_codValue) then exit(5990);
        if lfncCheckTable(5991, 91, p_codValue) then exit(5991);
        if lfncCheckTable(5992, 32, p_codValue) then exit(5992);
        if lfncCheckTable(5994, 32, p_codValue) then exit(5994);
        if lfncCheckTable(5996, 3, p_codValue) then exit(5996);
        if lfncCheckTable(6081, 4, p_codValue) then exit(6081);
        if lfncCheckTable(6650, 32, p_codValue) then exit(6650);
        if lfncCheckTable(6660, 32, p_codValue) then exit(6660);
        if lfncCheckTable(7002, 3, p_codValue) then exit(7002);
        if lfncCheckTable(7004, 3, p_codValue) then exit(7004);
        if lfncCheckTable(7012, 3, p_codValue) then exit(7012);
        if lfncCheckTable(7014, 3, p_codValue) then exit(7014);
        if lfncCheckTable(7023, 3, p_codValue) then exit(7023);
        if lfncCheckTable(60019, 22, p_codValue) then exit(60019);
        if lfncCheckTable(60020, 22, p_codValue) then exit(60020);
        if lfncCheckTable(60022, 22, p_codValue) then exit(60022);
        if lfncCheckTable(60023, 22, p_codValue) then exit(60023);
        // EYCOS.W1.ISS.GL01.001 <<
        //IF lfncCheckTable(99008532, 4, p_codValue) THEN EXIT(99008532);
        // EYCOS.W1.ISS.GL01.001 >>

        exit(0);
    end;

    local procedure lfncCheckTable(p_intTableID: Integer; p_intFieldID: Integer; p_codValue: Code[10]) r_blnUsed: Boolean
    var
        lrrRecRef: RecordRef;
        lfrFieldRef: FieldRef;
        loptFieldClass: Option Normal,FlowField,FlowFilter;
    begin
        r_blnUsed := false;
        lrrRecRef.Open(p_intTableID);
        lfrFieldRef := lrrRecRef.Field(p_intFieldID);
        Evaluate(loptFieldClass, Format(lfrFieldRef.Class));
        if loptFieldClass = loptFieldClass::Normal then begin
            lfrFieldRef.SetFilter(p_codValue);
            r_blnUsed := lrrRecRef.FindFirst();
        end;
    end;
}

