
//All the the supported module types.
#[path = "Metal/Metal.rs"            ] pub mod Metal      ;   //Metal       "Module"
#[path = "Assembler/Assembler.rs"    ] pub mod Assembler  ;   //Assembler   "Module"
#[path = "Compiler/Compiler.rs"      ] pub mod Compiler   ;   //Compiler    "Module"
#[path = "Interpreter/Interpreter.rs"] pub mod Interpreter;   //Interpreter "Module"
#[path = "Functional/Functional.rs"  ] pub mod Functional ;   //Functional  "Module"
#[path = "Logical/Logical.rs"        ] pub mod Logical    ;   //Logical     "Module"