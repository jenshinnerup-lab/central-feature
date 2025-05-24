table 91103 JsonBuffer
{
    Caption = 'JsonBuffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Import; Code[20])
        {
            Caption = 'Import';
        }
        field(2; BusinessCentralVersion; Code[20])
        {
            Caption = 'BusinessCentralVersion';
        }
        field(4; "Area"; Code[20])
        {
            Caption = 'Area';
        }
        field(5; AreaDescription; Text[100])
        {
            Caption = 'AreaDescription';
        }
        field(3; BusinessCentralVersionDesp; Text[100])
        {
            Caption = 'BusinessCentralVersionDesp';
        }
        field(6; Title; Text[250])
        {
            Caption = 'Title';
        }
        field(7; Decription; Blob)
        {
            Caption = 'Decription';
        }
    }
    keys
    {
        key(PK; Import, BusinessCentralVersion, "Area")
        {
            Clustered = true;
        }
    }
}
