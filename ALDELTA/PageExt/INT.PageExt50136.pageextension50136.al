// pageextension 50136 pageextension50136 extends "Session List"
// {
//     actions
//     {
//         addafter(Subscriptions)
//         {
//             action("Kill Session")
//             {
//                 Caption = 'Kill Session';
//                 Image = Delete;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     //if Confirm('Kill Session?', false) then
//                         //StopSession("Session ID");
//                 end;
//             }
//         }
//     }
// }

