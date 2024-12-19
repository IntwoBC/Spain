table 80100 "Batch Appl. Matching Rule"
{
    DataClassification = CustomerContent;
    // PK 30-08-24 EY-MYES0004 Feature 6050340: Job for settlement of open Transactions
    // Object created


    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; "Use For Cust. Ledger Entries"; Boolean)
        {
            Caption = 'Use For Cust. Ledger Entries';
        }
        field(11; "Use For Vend. Ledger Entries"; Boolean)
        {
            Caption = 'Use For Vend. Ledger Entries';
        }
        field(12; "Regular Expr. Matching Pattern"; Text[250])
        {
            Caption = 'Regular Expr. Matching Pattern';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure RegularExpressionMatch(StringToMatch: Text; Pattern: Text): Text
    var
        // Regex: DotNet Regex;
        // RegexOptions: DotNet RegexOptions;
        // MatchCollection: DotNet MatchCollection;
        // Match: DotNet Match;
        // Group: DotNet Group;
        // Capture: DotNet Capture;
        NewString: Text;
        WholeExpressionGroup: Boolean;
    begin
        NewString := '';

        // Regex := Regex.Regex(Pattern, RegexOptions.IgnoreCase);
        // MatchCollection := Regex.Matches(StringToMatch);
        // if IsNull(MatchCollection) then
        //     exit(NewString);

        // if MatchCollection.Count = 0 then
        //     exit(NewString);

        // WholeExpressionGroup := true;
        // foreach Match in MatchCollection do
        //     foreach Group in Match.Groups do begin
        //         if WholeExpressionGroup then
        //             WholeExpressionGroup := false
        //         else
        //             foreach Capture in Group.Captures do
        //                 NewString += Capture.Value;
        //     end;

        exit(NewString);
    end;


    procedure MatchTextBasedOnPattern(StringToMatch: Text): Text
    begin
        exit(RegularExpressionMatch(StringToMatch, "Regular Expr. Matching Pattern"));
    end;
}

