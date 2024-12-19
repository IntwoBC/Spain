xmlport 60009 Security
{
    // MP 21-11-14
    // Upgraded to NAV 2013 R2
    // 
    // MP 11-06-15
    // Added line of code to OnBeforeInsertRecord for WindowsLogin to populate "User Name"

    DefaultFieldsValidation = false;
    Direction = Import;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Users)
        {
            tableelement(User; User)
            {
                XmlName = 'WindowsLogin';
                UseTemporary = true;
                textattribute(actionwl)
                {
                    XmlName = 'Action';
                }
                fieldelement(SID; User."Windows Security ID")
                {
                }
                tableelement("Access Control"; "Access Control")
                {
                    LinkFields = "User Security ID" = FIELD("User Security ID");
                    LinkTable = User;
                    MinOccurs = Zero;
                    XmlName = 'Role';
                    UseTemporary = true;
                    textattribute(actionr)
                    {
                        Occurrence = Optional;
                        XmlName = 'Action';
                    }
                    fieldelement(RoleID; "Access Control"."Role ID")
                    {
                    }
                    fieldelement(CompanyName; "Access Control"."Company Name")
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        if goptActionWL = goptActionWL::Update then begin
                            if ActionR = '' then
                                Error(txtActionNotSpecifiedR, "Access Control"."Role ID", "Access Control"."User Security ID");

                            Evaluate(goptActionR, ActionR);
                        end else begin
                            if goptActionWL = goptActionWL::Delete then
                                Error(txtRolesActionDelete);

                            // Windows Login Action either Insert or Replace
                            goptActionR := goptActionR::Add;
                        end;

                        case goptActionR of
                            goptActionR::Add:
                                begin
                                    Clear(grecWindowsAccessControl);
                                    //grecWindowsAccessControl.VALIDATE("User Security ID",grecWindowsLogin.SID);
                                    grecWindowsAccessControl.Validate("User Security ID", grecUser."User Security ID"); // MP 21-11-14 Replaces above
                                    grecWindowsAccessControl.Validate("Role ID", "Access Control"."Role ID");
                                    grecWindowsAccessControl.Validate("Company Name", "Access Control"."Company Name");
                                    grecWindowsAccessControl.Insert(true);
                                end;
                            goptActionR::Remove:
                                begin
                                    //grecWindowsAccessControl."User Security ID" := grecWindowsLogin.SID;
                                    grecWindowsAccessControl."User Security ID" := grecUser."User Security ID"; // MP 21-11-14 Replaces above
                                    grecWindowsAccessControl."Role ID" := "Access Control"."Role ID";
                                    grecWindowsAccessControl."Company Name" := "Access Control"."Company Name";
                                    grecWindowsAccessControl.Delete(true);
                                end;
                        end;
                    end;
                }

                trigger OnBeforeInsertRecord()
                begin
                    if ActionWL = '' then
                        //ERROR(txtActionNotSpecifiedWL,Table2000000054.SID);
                        Error(txtActionNotSpecifiedWL, User."Windows Security ID"); // MP 21-11-14 Replaces above

                    Evaluate(goptActionWL, ActionWL);

                    //CLEAR(grecWindowsLogin);
                    Clear(grecUser); // MP 21-11-14 Replaces above
                    Clear(grecWindowsAccessControl);

                    case goptActionWL of
                        goptActionWL::Insert:
                            begin
                                // MP 21-11-14 >>
                                //grecWindowsLogin.VALIDATE(SID,Table2000000054.SID);
                                //grecWindowsLogin.INSERT(TRUE);
                                grecUser."User Security ID" := CreateGuid();
                                grecUser.Validate("Windows Security ID", User."Windows Security ID");
                                //grecUser."User Name" := gmdlIdentityMgt.UserName(User."Windows Security ID"); // MP 11-06-15
                                grecUser.Insert(true);
                                // MP 21-11-14 <<
                            end;

                        goptActionWL::Update:
                            begin
                                // MP 21-11-14 >>
                                //Table2000000054.TESTFIELD(SID);
                                //grecWindowsLogin.GET(Table2000000054.SID);
                                User.TestField("Windows Security ID");
                                grecUser.SetRange("Windows Security ID", User."Windows Security ID");
                                grecUser.FindFirst();
                                // MP 21-11-14 <<
                            end;

                        goptActionWL::Delete:
                            begin
                                // MP 21-11-14 >>
                                //Table2000000054.TESTFIELD(SID);
                                //grecWindowsLogin.SID := Table2000000054.SID;
                                //grecWindowsLogin.DELETE(TRUE);
                                User.TestField("Windows Security ID");
                                grecUser.SetRange("Windows Security ID", User."Windows Security ID");
                                grecUser.FindFirst();
                                grecUser.Delete(true);
                                // MP 21-11-14 <<
                            end;

                        goptActionWL::Replace:
                            begin
                                // MP 21-11-14 >>
                                //Table2000000054.TESTFIELD(SID);
                                //grecWindowsLogin.GET(Table2000000054.SID);

                                //grecWindowsAccessControl.SETRANGE("User Security ID",grecWindowsLogin.SID);

                                User.TestField("Windows Security ID");
                                grecUser.SetRange("Windows Security ID", User."Windows Security ID");
                                grecUser.FindFirst();

                                grecWindowsAccessControl.SetRange("User Security ID", grecUser."User Security ID");
                                // MP 21-11-14 <<
                                grecWindowsAccessControl.DeleteAll(true);
                            end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        grecUser: Record User;
        grecWindowsAccessControl: Record "Access Control";
        gmdlIdentityMgt: Codeunit "Identity Management";
        goptActionWL: Option Insert,Update,Delete,Replace;
        goptActionR: Option ,Add,Remove;
        txtActionNotSpecifiedWL: Label 'Action must be specified against WindowsLogin SID %1';
        txtActionNotSpecifiedR: Label 'Action must be specified against RoleID %1 (WindowsLogin SID %2)';
        txtRolesActionDelete: Label 'You cannot specify Roles when Action is Delete';
}

