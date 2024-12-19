// pageextension 50135 pageextension50135 extends "Debugger Code Viewer"
// {

//Unsupported feature: Code Modification on "OnAfterGetRecord".

//trigger OnAfterGetRecord()
//>>>> ORIGINAL CODE:
//begin
/*
NewObjectType := "Object Type";
NewObjectId := "Object ID";
NewCallstackId := ID;
NewLineNo := "Line No.";

if DebuggerManagement.IsBreakAfterCodeTrackingAction then begin
  DebuggerManagement.ResetActionState;
  BreakpointCollection := CurrBreakpointCollection;
end else
  GetBreakpointCollection(NewObjectType,NewObjectId,BreakpointCollection);

IsBreakAfterRunningCodeAction := DebuggerManagement.IsBreakAfterRunningCodeAction;

if (ObjType <> NewObjectType) or
   (ObjectId <> NewObjectId) or (CallstackId <> NewCallstackId) or IsBreakAfterRunningCodeAction
then begin
  CallstackId := NewCallstackId;

  if (ObjType <> NewObjectType) or (ObjectId <> NewObjectId) or IsBreakAfterRunningCodeAction then begin
    ObjType := NewObjectType;
    ObjectId := NewObjectId;

    ObjectMetadata.Init;
    NAVAppObjectMetadata.Init;

    if AllObj.Get(ObjType,ObjectId) and not IsNullGuid(AllObj."App Package ID") then begin
      if NAVAppObjectMetadata.Get(AllObj."App Package ID",ObjType,ObjectId) then
        if NAVApp.Get(AllObj."App Package ID") then
          if NAVApp."Show My Code" then begin
            NAVAppObjectMetadata.CalcFields("User AL Code");
            NAVAppObjectMetadata."User AL Code".CreateInStream(CodeStream,TEXTENCODING::UTF8);
            Code.Read(CodeStream);

            LineNo := NewLineNo;
            CurrBreakpointCollection := BreakpointCollection;
            CurrPage.CodeViewer.LoadCode(Code,NewLineNo,BreakpointCollection,(NewCallstackId = 1));
          end else begin
            NewLineNo := 0;
            LineNo := NewLineNo;
            CurrBreakpointCollection := BreakpointCollection;
            CurrPage.CodeViewer.LoadCode('',NewLineNo,BreakpointCollection,(NewCallstackId = 1));
          end
    end else
      if ObjectMetadata.Get(ObjType,ObjectId) then begin
        ObjectMetadata.CalcFields("User AL Code");
        ObjectMetadata."User AL Code".CreateInStream(CodeStream,TEXTENCODING::UTF8);
        Code.Read(CodeStream);

        LineNo := NewLineNo;
        CurrBreakpointCollection := BreakpointCollection;
        CurrPage.CodeViewer.LoadCode(Code,NewLineNo,BreakpointCollection,(NewCallstackId = 1));
      end;

    if IsBreakAfterRunningCodeAction then
      DebuggerManagement.ResetActionState;

    // Refresh to update data caption on debugger page

    DebuggerManagement.RefreshDebuggerTaskPage;

    exit;
  end;
end;

if NewLineNo <> LineNo then begin
  LineNo := NewLineNo;
  if IsNull(BreakpointCollection) then
    if IsNull(CurrBreakpointCollection) then
      CurrPage.CodeViewer.UpdateLine(NewLineNo,(NewCallstackId = 1))
    else
      CurrPage.CodeViewer.Update(NewLineNo,BreakpointCollection,(NewCallstackId = 1))
  else
    if not BreakpointCollection.Equals(CurrBreakpointCollection) then
      CurrPage.CodeViewer.Update(NewLineNo,BreakpointCollection,(NewCallstackId = 1))
    else
      CurrPage.CodeViewer.UpdateLine(NewLineNo,(NewCallstackId = 1))
end else
  PaintBreakpoints(BreakpointCollection);

CurrBreakpointCollection := BreakpointCollection;
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
//The code has been merged but contained errors that could prevent import
//and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
//NewObjectType := "Object Type";
//NewObjectId := "Object ID";
//NewCallstackId := ID;
//NewLineNo := "Line No.";
//
//IF DebuggerManagement.IsBreakAfterCodeTrackingAction THEN BEGIN
//  DebuggerManagement.ResetActionState;
//  BreakpointCollection := CurrBreakpointCollection;
//END ELSE
//  GetBreakpointCollection(NewObjectType,NewObjectId,BreakpointCollection);
//
//IsBreakAfterRunningCodeAction := DebuggerManagement.IsBreakAfterRunningCodeAction;
//
//IF (ObjType <> NewObjectType) OR
//   (ObjectId <> NewObjectId) OR (CallstackId <> NewCallstackId) OR IsBreakAfterRunningCodeAction
//THEN BEGIN
//  CallstackId := NewCallstackId;
//
//  IF (ObjType <> NewObjectType) OR (ObjectId <> NewObjectId) OR IsBreakAfterRunningCodeAction THEN BEGIN
//    ObjType := NewObjectType;
//    ObjectId := NewObjectId;
//
//    ObjectMetadata.INIT;
//    NAVAppObjectMetadata.INIT;
//
//    IF AllObj.GET(ObjType,ObjectId) AND NOT ISNULLGUID(AllObj."App Package ID") THEN BEGIN
//      IF NAVAppObjectMetadata.GET(AllObj."App Package ID",ObjType,ObjectId) THEN
//        IF NAVApp.GET(AllObj."App Package ID") THEN
//          IF NAVApp."Show My Code" THEN BEGIN
//            NAVAppObjectMetadata.CALCFIELDS("User AL Code");
//            NAVAppObjectMetadata."User AL Code".CREATEINSTREAM(CodeStream,TEXTENCODING::UTF8);
//            Code.READ(CodeStream);
//
//MODIFIED
//        LineNo := NewLineNo;
//        CurrBreakpointCollection := BreakpointCollection;
//       // CurrPage.CodeViewer.LoadCode(Code,NewLineNo,BreakpointCollection,(NewCallstackId = 1));
//      END
//{=======} TARGET
//            LineNo := NewLineNo;
//            CurrBreakpointCollection := BreakpointCollection;
//            CurrPage.CodeViewer.LoadCode(Code,NewLineNo,BreakpointCollection,(NewCallstackId = 1));
//          END ELSE BEGIN
//            NewLineNo := 0;
//            LineNo := NewLineNo;
//            CurrBreakpointCollection := BreakpointCollection;
//            CurrPage.CodeViewer.LoadCode('',NewLineNo,BreakpointCollection,(NewCallstackId = 1));
//          END
//{<<<<<<<}
//    END ELSE
//      IF ObjectMetadata.GET(ObjType,ObjectId) THEN BEGIN
//        ObjectMetadata.CALCFIELDS("User AL Code");
//        ObjectMetadata."User AL Code".CREATEINSTREAM(CodeStream,TEXTENCODING::UTF8);
//        Code.READ(CodeStream);
//
//        LineNo := NewLineNo;
//        CurrBreakpointCollection := BreakpointCollection;
//       // CurrPage.CodeViewer.LoadCode(Code,NewLineNo,BreakpointCollection,(NewCallstackId = 1));
//      END;
//
//    IF IsBreakAfterRunningCodeAction THEN
//      DebuggerManagement.ResetActionState;
//
//    // Refresh to update data caption on debugger page
//
//    DebuggerManagement.RefreshDebuggerTaskPage;
//
//    EXIT;
//  END;
//END;
//
////IF NewLineNo <> LineNo THEN BEGIN
////  LineNo := NewLineNo;
////  IF ISNULL(BreakpointCollection) THEN
////IF ISNULL(CurrBreakpointCollection) THEN
////      CurrPage.CodeViewer.UpdateLine(NewLineNo,(NewCallstackId = 1))
////    ELSE
//     // CurrPage.CodeViewer.Update(NewLineNo,BreakpointCollection,(NewCallstackId = 1))
// // ELSE
////    IF NOT BreakpointCollection.Equals(CurrBreakpointCollection) THEN
////      CurrPage.CodeViewer.Update(NewLineNo,BreakpointCollection,(NewCallstackId = 1))
////    ELSE
//     // CurrPage.CodeViewer.UpdateLine(NewLineNo,(NewCallstackId = 1))
////END ELSE
////  PaintBreakpoints(BreakpointCollection);
//
////CurrBreakpointCollection := BreakpointCollection;
*/
//end;


//Unsupported feature: Code Modification on "OnFindRecord".

//trigger OnFindRecord()
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
if CallStack.IsEmpty then begin
  GetBreakpointCollection(ObjType,ObjectId,BreakpointCollection);
  PaintBreakpoints(BreakpointCollection);
  CurrBreakpointCollection := BreakpointCollection;

  if LineNo <> -1 then begin
    // Set line to -1 to remove the current line marker
    LineNo := -1;
    CurrPage.CodeViewer.UpdateLine(LineNo,true);
  end;
  exit(false);
end;

exit(Find(Which));
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
#1..8
   // CurrPage.CodeViewer.UpdateLine(LineNo,TRUE);
#10..14
*/
//end;


//Unsupported feature: Code Modification on "ToggleBreakpoint(PROCEDURE 2)".

//procedure ToggleBreakpoint();
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
UpdateBreakpoint(CurrPage.CodeViewer.CaretLine);
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
//UpdateBreakpoint(CurrPage.CodeViewer.CaretLine);
*/
//end;


//Unsupported feature: Code Modification on "SetBreakpointCondition(PROCEDURE 4)".

//procedure SetBreakpointCondition();
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
if (ObjType = 0) or (ObjectId = 0) then
  exit;

with DebuggerBreakpoint do begin
  Init;
  "Object Type" := ObjType;
  "Object ID" := ObjectId;
  "Line No." := CurrPage.CodeViewer.CaretLine;

  IsNewRecord := Insert(true);

#12..25
        Delete(true);
  end
end
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
#1..7
  //"Line No." := CurrPage.CodeViewer.CaretLine;
#9..28
*/
//end;


//Unsupported feature: Code Modification on "ShowTooltip(PROCEDURE 16)".

//procedure ShowTooltip();
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
if CallStack.IsEmpty then
  CurrPage.CodeViewer.ShowTooltip('')
else
  if GetVariables(VariableName,LeftContext,Variables) then
    CurrPage.CodeViewer.ShowTooltip(Variables)
  else begin
    TooltipText := StrSubstNo(Text001,VariableName);
    CurrPage.CodeViewer.ShowTooltip(TooltipText);
  end;
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
//IF CallStack.ISEMPTY THEN
//  //CurrPage.CodeViewer.ShowTooltip('')
//ELSE
//  IF GetVariables(VariableName,LeftContext,Variables) THEN
//    CurrPage.CodeViewer.ShowTooltip(Variables)
//  ELSE BEGIN
//    TooltipText := STRSUBSTNO(Text001,VariableName);
//    CurrPage.CodeViewer.ShowTooltip(TooltipText);
//  END;
*/
//end;


//Unsupported feature: Code Modification on "PaintBreakpoints(PROCEDURE 14)".

//procedure PaintBreakpoints();
//Parameters and return type have not been exported.
//>>>> ORIGINAL CODE:
//begin
/*
if IsNull(BreakpointCollection) then begin
  if not IsNull(CurrBreakpointCollection) then
    CurrPage.CodeViewer.UpdateBreakpoints(BreakpointCollection);
end else
  if not BreakpointCollection.Equals(CurrBreakpointCollection) then
    CurrPage.CodeViewer.UpdateBreakpoints(BreakpointCollection);
*/
//end;
//>>>> MODIFIED CODE:
//begin
/*
//IF ISNULL(BreakpointCollection) THEN BEGIN
//  IF NOT ISNULL(CurrBreakpointCollection) THEN
//    CurrPage.CodeViewer.UpdateBreakpoints(BreakpointCollection);
//END ELSE
//  IF NOT BreakpointCollection.Equals(CurrBreakpointCollection) THEN
//    CurrPage.CodeViewer.UpdateBreakpoints(BreakpointCollection);
*/
//end;
//}

