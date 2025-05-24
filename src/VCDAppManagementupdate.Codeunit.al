codeunit 91101 "App Management update"
{
    Subtype = Upgrade;

    // Kør logik ved opdatering
    trigger OnUpgradePerCompany()
    var

    begin
        MigrateData();
    end;

    // Migrer data ved opdatering
    procedure MigrateData()
    begin
        // Eksempel: Tilføj ny logik baseret på versionsændringer
        //


    end;
}