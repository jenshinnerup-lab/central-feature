codeunit 91100 "App Management install"
//Resouces - Used
//https://www.dvlprlife.com/2022/12/dynamics-365-business-central-read-a-json-file-with-al/

{
    Subtype = Install;
    // Kør logik ved første installation
    trigger OnInstallAppPerCompany()
    var
        DataManagement: Codeunit "DataManagement";
    begin
        DataManagement.InitializeDefaultData();
    end;

}