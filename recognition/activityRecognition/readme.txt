MATLAB Compiler

1. Prerequisites for Deployment 

. Verify the MATLAB runtime is installed and ensure you    
  have installed version 8.4 (R2014b).   

. If the MATLAB runtime is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MATLAB runtime installer.

  (2) run the MATLAB runtime installer.

Or download the Macintosh version of the MATLAB runtime for R2014b 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
   
For more information about the MATLAB runtime and the MATLAB runtime installer, see 
Distribution to End Users in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.    


NOTE: You will need administrator rights to run MCRInstaller. 


2. Files to Deploy and Package

Files to package for Standalone 
================================
-run_mainActivityRecognition.sh (shell script for temporarily setting environment 
 variables and executing the application)
   -to run the shell script, type
   
       ./run_mainActivityRecognition.sh <mcr_directory> <argument_list>
       
    at Linux or Mac command prompt. <mcr_directory> is the directory 
    where version 8.4 of the MATLAB runtime is installed or the directory where 
    MATLAB is installed on the machine. <argument_list> is all the 
    arguments you want to pass to your application. For example, 

    If you have version 8.4 of the MATLAB runtime installed in 
    /mathworks/home/application/v84, run the shell script as:
    
       ./run_mainActivityRecognition.sh /mathworks/home/application/v84
       
    If you have MATLAB installed in /mathworks/devel/application/matlab, 
    run the shell script as:
    
       ./run_mainActivityRecognition.sh /mathworks/devel/application/matlab
-MCRInstaller.zip 
   -if end users are unable to download the MATLAB runtime using the above  
    link, include it when building your component by clicking 
    the "Runtime downloaded from web" link in the Deployment Tool
-The Macintosh bundle directory structure mainActivityRecognition.app 
   -this can be gathered up using the zip command 
    zip -r mainActivityRecognition.zip mainActivityRecognition.app
    or the tar command 
    tar -cvf mainActivityRecognition.tar mainActivityRecognition.app
-This readme file 

3. Definitions

For information on deployment terminology, go to 
http://www.mathworks.com/help. Select MATLAB Compiler >   
Getting Started > About Application Deployment > 
Application Deployment Terms in the MathWorks Documentation 
Center.


4. Appendix 

A. Mac systems:
   On the target machine, add the MATLAB runtime directory to the environment variable 
   DYLD_LIBRARY_PATH by issuing the following commands:

        NOTE: <mcr_root> is the directory where MATLAB runtime is installed
              on the target machine.         

            setenv DYLD_LIBRARY_PATH
                $DYLD_LIBRARY_PATH:
                <mcr_root>/v84/runtime/maci64:
                <mcr_root>/v84/sys/os/maci64:
                <mcr_root>/v84/bin/maci64


   For more detail information about setting the MATLAB runtime paths, see Distribution 
   to End Users in the MATLAB Compiler documentation in the MathWorks Documentation 
   Center.


     
        NOTE: To make these changes persistent after logout on Linux 
              or Mac machines, modify the .cshrc file to include this  
              setenv command.
        NOTE: The environment variable syntax utilizes forward 
              slashes (/), delimited by colons (:).  
        NOTE: When deploying standalone applications, it is possible 
              to run the shell script file run_mainActivityRecognition.sh 
              instead of setting environment variables. See 
              section 2 "Files to Deploy and Package".    



5. Launching of application using Macintosh finder.

If the application is purely graphical, that is, it doesn't read from standard in or 
write to standard out or standard error, it may be launched in the finder just like any 
other Macintosh application.



