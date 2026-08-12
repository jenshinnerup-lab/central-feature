namespace CentralFeature;

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
                    Visible = false; // Hide this field as it is not needed in the list part
                    ToolTip = 'Specifies the value of the Business Central Version field.', Comment = '%';
                }
                field("Area"; Rec."Area")
                {
                    Visible = false; // Hide this field as it is not needed in the list part
                    ToolTip = 'Specifies the value of the Area field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    MultiLine = true; // Allow multiline for better readability
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
