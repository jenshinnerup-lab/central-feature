codeunit 91102 DataManagement
{
    // Initialiser standarddata ved installation
    procedure InitializeDefaultData()
    // Eksempel: Opret standardposter i en tabel
    var
        BusinessCentralVersion: Record "Business Central Version";
        BusinessArea: Record "Business Area";
        FeatureEntry: Record "Feature Entry";
    begin
        // Slet eksisterende data - kun hvis du vil starte forfra 
        BusinessCentralVersion.DeleteAll(true);
        BusinessArea.DeleteAll(true);
        FeatureEntry.DeleteAll(true);

        // Indsæt standard Business Central versioner
        ImportFeatureData();

    end;

    procedure ImportFeatureData()
    var
        Resource: Text;
        InStream: InStream;
        Readdata: Text;
    begin
        foreach Resource in NavApp.ListResources() do begin
            NavApp.GetResource(Resource, InStream, TextEncoding::UTF8);
            InStream.Read(ReadData);
            //Message('Reading JSON data from resource: %1', Resource);
            //Message('JSON Data: %1', ReadData);
            ReadJSON(ReadData);
        end;
    end;

    local procedure ReadJSON(JsonObjectText: Text)
    var

        FeatureEntry: Record "Feature Entry";
        BusinessArea: Record "Business Area";
        BusinessCentralVersion: Record "Business Central Version";

        ArrayJSONManagement: Codeunit "JSON Management";
        JSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";

        i: Integer;
        CodeText: Text;
        VersionJsonObject: Text;
        AreaJsonObject: Text;
        FeatureJsonObject: Text;
        JsonArrayText: Text;


    begin
        JSONManagement.InitializeObject(JsonObjectText);
        if JSONManagement.GetArrayPropertyValueAsStringByName('BusinessCentralVersion', VersionJsonObject) then begin
            ObjectJSONManagement.InitializeObject(VersionJsonObject);

            BusinessCentralVersion.Init();
            ObjectJSONManagement.GetStringPropertyValueByName('Version', CodeText);
            BusinessCentralVersion.Validate(Code, CopyStr(CodeText.ToUpper(), 1, MaxStrLen(BusinessCentralVersion.Code)));
            ObjectJSONManagement.GetStringPropertyValueByName('VersionII', CodeText);
            BusinessCentralVersion.Validate(BusinessCentralVersion.Description, CopyStr(CodeText, 1, MaxStrLen(BusinessCentralVersion.Description)));
            BusinessCentralVersion.Insert();

            JSONManagement.InitializeObject(VersionJsonObject);
            if JSONManagement.GetArrayPropertyValueAsStringByName('Feature', JsonArrayText) then begin
                ArrayJSONManagement.InitializeCollection(JsonArrayText);
                for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                    ArrayJSONManagement.GetObjectFromCollectionByIndex(FeatureJsonObject, i);
                    ObjectJSONManagement.InitializeObject(FeatureJsonObject);


                    //Handle Area Entry
                    BusinessArea.Init();
                    ObjectJSONManagement.GetStringPropertyValueByName('Area', CodeText);
                    if not BusinessArea.Get(CodeText, BusinessCentralVersion.Code) then begin
                        BusinessArea.Validate(Description, CopyStr(CodeText, 1, MaxStrLen(BusinessArea.Description)));
                        BusinessArea.Validate("Business Central Version", BusinessCentralVersion.Code);
                        BusinessArea.Insert();
                    end else begin
                        BusinessArea.Validate(Description, CopyStr(CodeText, 1, MaxStrLen(BusinessArea.Description)));
                        BusinessArea.Validate("Business Central Version", BusinessCentralVersion.Code);
                        BusinessArea.Modify();
                    end;
                    //Handle Feature Entry
                    FeatureEntry.Init();
                    FeatureEntry.Validate("Area", BusinessArea.Description);
                    FeatureEntry.Validate("Business Central Version", BusinessCentralVersion.Code);
                    ObjectJSONManagement.GetStringPropertyValueByName('Title', CodeText);
                    FeatureEntry.Validate(Title, CopyStr(CodeText.ToUpper(), 1, MaxStrLen(FeatureEntry.Title)));
                    ObjectJSONManagement.GetStringPropertyValueByName('description', CodeText);
                    FeatureEntry.Insert(true);
                    FeatureEntry.SetDescription(CodeText);
                    FeatureEntry.Modify();

                end;
            end;
        end;
    end;

}
