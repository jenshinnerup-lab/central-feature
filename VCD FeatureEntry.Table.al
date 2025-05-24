table 91102 "Feature Entry"
{
    Caption = 'Feature Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Area"; Code[20])
        {
            Caption = 'Area';
        }
        field(3; Title; Text[250])
        {
            Caption = 'Title';
        }
        field(4; Discription; Blob)
        {
            Caption = 'Discription';
        }
        field(5; "Business Central Version"; Code[20])
        {
            Caption = 'Business Central Version';
            TableRelation = "Business Central Version";
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
