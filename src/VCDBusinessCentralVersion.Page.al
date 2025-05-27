page 91100 "Business Central Version"
{
    ApplicationArea = All;
    Caption = 'Business Central Version';
    PageType = List;
    SourceTable = "Business Central Version";
    UsageCategory = History;
    DataCaptionFields = "Code", "Description";

    layout
    {
        area(Content)
        {

            repeater(General)
            {

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Description"; Rec."Description")
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Feature Count"; Rec.FeatureCount)
                {
                    ToolTip = 'Specifies the value of the Feature Count field.', Comment = '%';
                }
            }

            part(buisinessarea; BusinessArea)
            {
                ApplicationArea = All;
                Caption = 'Business Areas';
                SubPageLink = "Business Central Version" = field("Code");
                UpdatePropagation = Both;

            }
            part(Features; BusinessFeature)
            {
                ApplicationArea = All;
                Caption = 'Features';
                Provider = buisinessarea;
                SubPageLink = "Business Central Version" = field("Business Central Version"), "Area" = field(Description);
                UpdatePropagation = Both;
            }

        }

    }

}
