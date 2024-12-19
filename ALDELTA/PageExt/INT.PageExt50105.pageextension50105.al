pageextension 50105 pageextension50105 extends "G/L Account Card"
{
    layout
    {
         modify("Direct Posting")
        {
            Editable = false;
        }
         
        addlast(Reporting)
        {
                field("Financial Statement Code";Rec."Financial Statement Code")
                {
                    Caption='Financial Statement Code';
                    ApplicationArea = All;
                }
            }
        }
    }
       
        

