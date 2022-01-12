# MAS (Modular Alias Sectored)

An experimental langauge for figuring out stuff I wanted in langauges

I have tried serveral different ways to break down the langauge this is around my third or forth attempt

A project is an encapsulated unit that specifies a program  
A package is an encapsulated unit that may be used by a project  
Projects can be a package for another project.  

The point of MAS was to see if it was possible to make a langauge that achieved the following goals:
1. Model a langauge where program structure modularity was a main priority.
2. Provide a language syntax that is similar and practical to use across different 
	language translation platforms (LTPs)
3. Isolate features into language feature layers (LFLs) to make comprehension and convention
	 explicitly enforced in a flexible manner.
4. Program structure and build specification can be controlled per project via the build and UX toolchain.
5. Setup the infrastructure to support high coherency between the language toolchain and the 
   user expereince for editing and debugging the program's source translation or run-time execution
  
  
My goal is to make a prototype that at least a prototype that covers goals 1, 2, and 3 for layers 0.OS and 1.  
Currently I am boostrapping a basic interpreter to get a layer X variant of the language working parsing wise.
