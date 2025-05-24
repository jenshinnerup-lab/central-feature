page 91100 "Business Central Version"
{
    ApplicationArea = All;
    Caption = 'Business Central Version';
    PageType = List;
    SourceTable = "Business Central Version";
    UsageCategory = History;

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
            }
        }
    }
}
