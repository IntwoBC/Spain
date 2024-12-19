codeunit 60017 "Data Import Safe Process"
{
    // Codeunit can be used for processes where we do not want encounter VALIDATE or similar error


    trigger OnRun()
    var
//lmodDataImportMgt_60012: Codeunit "Data Import Mgt 60012";
    begin
        //case gintAction of
        //1:
        //gblnResult := lmodDataImportMgt_60012.gfncCreateJournalLine(grecGenJournalLine, grecGenJournalLineStaging);
        //else
        // Error(ERR_001);
        // end;
    end;

    var
        gintAction: Integer;
        gblnResult: Boolean;
        ERR_001: Label 'Uknown Action in CU60017';
        grecGenJournalLine: Record "Gen. Journal Line";
        grecGenJournalLineStaging: Record "Gen. Journal Line (Staging)";


    procedure gfncSetAction(p_intAction: Integer)
    begin
        // Generic
        gintAction := p_intAction;
    end;


    procedure gfncGetLastResult(): Boolean
    begin
        // generic
        exit(gblnResult);
    end;


    procedure gfncSetGenJnlLine(p_recGenJournalLine: Record "Gen. Journal Line")
    begin
        // Action 1 specific
        grecGenJournalLine := p_recGenJournalLine;
    end;


    procedure gfncGetGenJnlLine(var p_recGenJournalLine: Record "Gen. Journal Line")
    begin
        // Action 1 specific
        p_recGenJournalLine := grecGenJournalLine;
    end;


    procedure gfncSetGenJnlLineStaging(p_recGenJournalLineStaging: Record "Gen. Journal Line (Staging)")
    begin
        // Action 1 specific
        grecGenJournalLineStaging := p_recGenJournalLineStaging;
    end;
}

