table 91100 "Business Central Version"
{
    Caption = 'Business Central Version';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(3; FeatureCount; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Feature Entry" where("Business Central Version" = field(Code)));
            Caption = 'Feature Count';
            ToolTip = 'Specifies the number of features in this Business Central version.';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
