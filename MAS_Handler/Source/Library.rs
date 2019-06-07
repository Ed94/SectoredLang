#![allow(non_snake_case        )]   //Not my style. I'll be providing documentation on my conventions later as I learn the language.
#![allow(non_upper_case_globals)]

//Rusts module system needs work... I guess I'll just go along with it.

//Module TOC

#[path = "Core/Core.rs"           ] pub mod Core    ;   //Core modules.
#[path = "Command_Line/CmdLine.rs"] pub mod CmdLine ;   //Command line related modules.
#[path = "Modules/Module.rs"      ] pub mod Module  ;   //"Modules" related modules. lol.
#[path = "Packager/Packager.rs"   ] pub mod Packager;   //Packager related modules.

//Trial By Fire - Rust Assist Library

#[path = "Utilities/TBF_RustAssist.rs"] pub mod TBF_RustAssist; 