namespace CentralFeature;

page 91101 BusinessArea
{
    ApplicationArea = All;
    Caption = 'BusinessArea';
    PageType = ListPart;
    SourceTable = "Business Area";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Feature Count"; Rec.FeatureCount)
                {
                    ToolTip = 'Specifies the value of the Feature Count field.', Comment = '%';
                }
            }
        }
    }
}
