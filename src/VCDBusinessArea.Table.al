table 91101 "Business Area"
{
    Caption = 'Business Area';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(2; FeatureCount; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Feature Entry" where("Area" = field(Description), "Business Central Version" = field("Business Central Version")));
            Caption = 'Feature Count';
            ToolTip = 'Specifies the number of features in this business area for the specified Business Central version.';

        }
        field(3; "Business Central Version"; Code[20])
        {
            Caption = 'Business Central Version';
            TableRelation = "Business Central Version";
        }
        
    }
    keys
    {
        key(PK; "Description", "Business Central Version")
        {
            Clustered = true;
        }
    }
}
