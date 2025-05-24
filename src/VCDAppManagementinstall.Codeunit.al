codeunit 91100 "App Management install"
//Resouces - Used
//https://www.dvlprlife.com/2022/12/dynamics-365-business-central-read-a-json-file-with-al/

{
    Subtype = Install;

    // Kør logik ved første installation
    trigger OnInstallAppPerCompany()
    begin
        InitializeDefaultData();
    end;


    // Initialiser standarddata ved installation
    procedure InitializeDefaultData()
    // Eksempel: Opret standardposter i en tabel
    var
        BusinessCentralVersion: Record "Business Central Version";
    begin
        if not BusinessCentralVersion.Get() then begin
            // InsertBusinessCentralVersion('BC20', 'Business Central 20');
            // InsertBusinessArea('FIN', 'Finance');
            // insertFeatureData('FIN-001');
        end;
    end;

    procedure InsertBusinessCentralVersion(VersionCode: Code[20]; VersionDescription: Text[100])
    var
        BusinessCentralVersion: Record "Business Central Version";
    begin
        BusinessCentralVersion.Init();
        BusinessCentralVersion.Code := VersionCode;
        BusinessCentralVersion.Description := VersionDescription;
        BusinessCentralVersion.Insert();
    end;

    procedure insertBusinessArea(AreaCode: Code[20]; AreaDescription: Text[100])
    var
        BusinessArea: Record "Business Area";
    begin
        BusinessArea.Init();
        BusinessArea.Description := AreaDescription;
        BusinessArea.Insert();
    end;

    procedure insertFeatureData(FeatureCode: Code[20])
    var
        FeatureEntry: Record "Feature Entry";
        JsonBuffer: Record "JsonBuffer";
    begin
        FeatureEntry.Init();
        FeatureEntry.Title := JsonBuffer.Title;
        FeatureEntry.Description := JsonBuffer.Decription;
        FeatureEntry.Insert();
    end;


    procedure ImportFeatureData()
    var
        Resource: Text;
        InStream: InStream;
        Readdata: Text;
    begin
        foreach Resource in NavApp.ListResources() do
            NavApp.GetResource(Resource, InStream);
        InStream.Read(ReadData);
        message(ReadData);
        //ReadJSON(ReadData);
    end;

    local procedure ReadJSON(JsonObjectText: Text)
    var

        FeatureEntry: Record "Feature Entry";
        BusinessArea: Record "Business Area";
        BusinessCentralVersion: Record "Business Central Version";

        // Customer: Record Customer;
        // FeatureEntry: Record "Ship-to Address";

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
            ObjectJSONManagement.InitializeObject(AreaJsonObject);

            BusinessCentralVersion.Init();
            ObjectJSONManagement.GetStringPropertyValueByName('Version', CodeText);
            BusinessCentralVersion.Validate(Code, CopyStr(CodeText.ToUpper(), 1, MaxStrLen(BusinessCentralVersion.Code)));

            ObjectJSONManagement.GetStringPropertyValueByName('VersionII', CodeText);
            BusinessCentralVersion.Validate(BusinessCentralVersion.Description, CopyStr(CodeText, 1, MaxStrLen(BusinessCentralVersion.Description)));



            JSONManagement.InitializeObject(VersionJsonObject);
            if JSONManagement.GetArrayPropertyValueAsStringByName('Feature', JsonArrayText) then begin
                ArrayJSONManagement.InitializeCollection(JsonArrayText);
                for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                    ArrayJSONManagement.GetObjectFromCollectionByIndex(FeatureJsonObject, i);
                    ObjectJSONManagement.InitializeObject(FeatureJsonObject);


                    //Handle Area Entry
                    BusinessArea.Init();
                    ObjectJSONManagement.GetStringPropertyValueByName('Area', CodeText);
                    if not BusinessArea.Get(CodeText) then begin
                        BusinessArea.Validate(Description, CopyStr(CodeText, 1, MaxStrLen(BusinessArea.Description)));
                        BusinessArea.Insert();
                    end else begin
                        BusinessArea.Validate(Description, CopyStr(CodeText, 1, MaxStrLen(BusinessArea.Description)));
                        BusinessArea.Modify();
                    end;

                    //Handle Feature Entry
                    FeatureEntry.Init();
                    FeatureEntry.Validate("Area", BusinessArea.Description);
                    FeatureEntry.Validate("Business Central Version", BusinessCentralVersion.Code);
                    ObjectJSONManagement.GetStringPropertyValueByName('Title', CodeText);
                    FeatureEntry.Validate(Title, CopyStr(CodeText.ToUpper(), 1, MaxStrLen(FeatureEntry.Title)));
                    ObjectJSONManagement.GetStringPropertyValueByName('description', CodeText);
                    FeatureEntry.SetDescription(CodeText);
                    FeatureEntry.Insert();

                end;
            end;
        end;
    end;


}