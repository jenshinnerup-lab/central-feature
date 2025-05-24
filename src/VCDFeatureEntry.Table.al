table 91102 "Feature Entry"
{
    Caption = 'Feature Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Title; Text[250])
        {
            Caption = 'Title';
        }
        field(2; "Area"; Code[100])
        {
            Caption = 'Area';
        }
        field(3; Description; Blob)
        {
            Caption = 'Description';
        }
        field(4; "Business Central Version"; Code[20])
        {
            Caption = 'Business Central Version';
            TableRelation = "Business Central Version";
        }

    }

    keys
    {
        key(PK; "Title", "Area", "Business Central Version")
        {
            Clustered = true;
        }

    }

    procedure SetDescription(NewDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Description);
        Description.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewDescription);
        Modify();
    end;

    procedure GetDescription() FeatureDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Description);
        Description.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Description)));
    end;

}
