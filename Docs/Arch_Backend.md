# Progam Model Generator

Takes in RSNodes from the frontend and resolves if they considered run-time apporpirate or translation-time.

Any RSNodes considered translation-time related are prepared into translation-time units and sent to the translation-time executer to process.

After the translation-time executer completes its process the progam model is generated using the RSNodes and GNodes.

# Translation-Time Executer

A process that that either generates GNodes to resolve generic symbols dependent on other symbols or to execute translation time exe sectors.

# GNode : Generated Node

Nodes generated during translation time.

These are just RSNodes with additonal attribute of being generated and possibly some other fields that may be useful specific to the backend.

The backend may provide these nodes to the frontend for the generated VSNode viewer after a program model generation attempt.

GNodes that are considered runtime-resolved are provided to the program model generator.

# Program Model

This is a data container that a backend platform such as an interpreter or compiler may produce and exectuable or executable.

The program model will be divided into two sections:

## Program Environment

A static set of all data addressable by the execution graph during runtime.  

For a compiler it will become static data symbols or function symbols.

For an interpreter it will be its initially loaded environment that will be modified as the interprter's execution engine runs the execution graph.

## Execution Graph

Full execution graph of the program. This only contains execution that encapsulated within procedures and the root node is the entrypoint.  

Any execution not encapsulated by an entrypoint is ran by the translation time executer. 
