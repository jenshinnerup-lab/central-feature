namespace VCD_featuresinfeature.VCD_featuresinfeature;

page 91102 BusinessFeature
{
    ApplicationArea = All;
    Caption = 'BusinessFeature';
    PageType = ListPart;
    SourceTable = "Feature Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Business Central Version"; Rec."Business Central Version")
                {
                    ToolTip = 'Specifies the value of the Business Central Version field.', Comment = '%';
                }
                field("Area"; Rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
