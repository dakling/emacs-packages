using System; 
using System.Collections.Generic; 
using System.Linq; 
using ilPSP; 
using ilPSP.Utils; 
using BoSSS.Platform; 
using BoSSS.Foundation; 
using BoSSS.Foundation.Grid; 
using BoSSS.Foundation.Grid.Classic; 
using BoSSS.Foundation.IO; 
using BoSSS.Solution; 
using BoSSS.Solution.Control;  
using BoSSS.Solution.GridImport; 
using BoSSS.Solution.Statistic; 
using BoSSS.Solution.Utils; 
using BoSSS.Solution.Gnuplot; 
using BoSSS.Application.BoSSSpad; 
using Renci.SshNet; 
using Mono.CSharp;

namespace BoSSS.Application.BoSSSpad {
    Console.WriteLine("");
    Console.WriteLine("  BoSSSpad C# interpreter");
    Console.WriteLine("  _______________________\n");

    try {
	var databases = DatabaseController.LoadDatabaseInfosFromXML();
		    
	string summary = databases.Summary();
	Console.WriteLine("Databases loaded:");
	Console.WriteLine(summary);
    } catch (Exception e) {
	Console.WriteLine();
	Console.WriteLine(
			  "{0} occurred with message '{1}' while loading the databases. Type 'LastError' for details.",
			  e.GetType(),
			  e.Message);
	InteractiveShell.LastError = e;
    }

}
