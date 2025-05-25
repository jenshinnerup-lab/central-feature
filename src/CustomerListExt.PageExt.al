// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.ResourcesInApp;

using Microsoft.Sales.Customer;
using System.Utilities;

pageextension 91100 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    var
        Datamanagement: Codeunit "DataManagement";
        Resource: Text;
        InS: InStream;
        data: Text;
        
    begin
        foreach Resource in NavApp.ListResources() do begin
            //Message('%1', NavApp.GetResourceAsText(Resource));
            NavApp.GetResource(Resource, InS);
            InS.Read(data);
            message(data);
        end;
        Datamanagement.InitializeDefaultData();
    end;
}