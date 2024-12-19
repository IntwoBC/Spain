codeunit 60035 Security
{

    trigger OnRun()
    begin
    end;


    procedure Process(Users: XMLport Security)
    begin
        Users.Import();
    end;
}

