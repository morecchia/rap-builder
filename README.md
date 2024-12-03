# RelativityRAPBuilder
A command-line utility that generates a Relativity RAP file from application source code based on a configuration.

## Dependencies
1. Visual Studio 2019 (or above)
2. Powershell
   
## Usage
1. Clone this repo and place the files in a subfolder next to your source repo (ex. 'Project Root\Build' and 'Project Root\Source')
2. Export your application's XML schema file from the Relativity front-end and place it in the project root
3. Update the Build.XML file to match your application schema requirements (see comments in file)
4. If you haven't already, update all of your Visual Studio solution's projects to use a shared assembly

    - create a folder called 'version' in the root of your solution
    - create a 'SharedAssembly.cs' that looks like this:

      ```
      using System.Reflection;
      using System.Runtime.InteropServices;

      [assembly: AssemblyCompany("Company Name")]
      [assembly: AssemblyCopyright("Copyright © 2023, Company Name")]
      [assembly: AssemblyTrademark("")]
      [assembly: AssemblyCulture("")]
      [assembly: ComVisible(false)]
      [assembly: AssemblyVersion("1.0.0.0")]
      [assembly: AssemblyFileVersion("1.0.0.0")]
  
    - Remove the AssemblyCompany, AssemblyCopyright, AssemblyTrademark, AssemblyCulture, AssemblyVersion, AssemblyFileVersion, and ComVisible attributes from the 'AssemblyInfo.cs' files in each of the solution's projects
    - From the Solution Explorer in Visual Studio, right click on the 'Properties' folder in each project and select 'Add -> Existing Item'
    - Find the 'SharedAssembly.cs' file and add it as a link (hint: use the down-arrow button next to the 'Add' button)

5. Build the solution with 'Release' configuration
6. cd into the 'Build' folder (or whatever folder you put the RAPBuilder files in)
7. Run the following command in a Powershell terminal
   `..\Build\Build.bat [Path to your project root]\Source [Path to your project root]\Build Build.xml [Application version]`
8. The final output should look similar to this:
   ```
   [RAPBuilder]: Source directory is [Your build path]
   [RAPBuilder]: Input file path is [Your build path]\Build.xml
   [RAPBuilder]: Version is 0.2.1.2
   [RAPBuilder]: Reading input file...
   [RAPBuilder]: Validating RAPs...
   [RAPBuilder]: building application '[Application name]'...
   [RAPBuilder]: loading application schema...
   [RAPBuilder]: Updating application version to [Application version] ...
   [RAPBuilder]: hashing assemblies...
   [RAPBuilder]: hashing custom pages...
   [RAPBuilder]: creating RAP...
   [RAPBuilder]: complete!

## Note
The batch file, `Build.bat`, contains the path to the MSBuild executable on your local machine.  Depending on your version of Visual Studio and processor architecture, you may need to update this path.
