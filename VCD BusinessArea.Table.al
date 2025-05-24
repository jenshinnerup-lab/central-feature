table 91101 "Business Area"
{
    Caption = 'Business Area';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Area"; Code[20])
        {
            Caption = 'Area';
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(3; "Feature Count"; Integer)
        {
            Caption = 'Feature Count';
            //todo: Add logic to calculate the number of features associated with this business area

        }
    }
    keys
    {
        key(PK; "Area")
        {
            Clustered = true;
        }
    }
}
