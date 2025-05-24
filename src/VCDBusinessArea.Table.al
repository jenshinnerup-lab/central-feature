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
        field(2; "Feature Count"; Integer)
        {
            Caption = 'Feature Count';
            //todo: Add logic to calculate the number of features associated with this business area

        }
    }
    keys
    {
        key(PK; "Description")
        {
            Clustered = true;
        }
    }
}
