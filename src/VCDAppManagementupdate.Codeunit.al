codeunit 91101 "App Management update"
{
    Subtype = Upgrade;

    // Kør logik ved opdatering
    trigger OnUpgradePerCompany()
    var
        DataManagement: Codeunit "DataManagement";
    begin
        DataManagement.InitializeDefaultData();
    end;

}