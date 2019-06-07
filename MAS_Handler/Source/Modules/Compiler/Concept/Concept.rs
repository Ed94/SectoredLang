
//Concept Compiler Module

//Using

use std::
{
    io::stdin,

    string::
    {
        String,
    }
};

pub struct Lexer
{

}

pub struct TokenRegistry
{

}

pub trait KeyRegistry
{
    const Key_Auto       : &'static str;
    const Key_Concept    : &'static str;
    const Key_Declare    : &'static str;
    const Key_Dynamic    : &'static str;
    const Key_EntryPoint : &'static str;
    const Key_Immutable  : &'static str;
    const Key_Function   : &'static str;
    const Key_Return     : &'static str;
    const Key_Static     : &'static str;
    const Key_Type       : &'static str;
    const Key_Void       : &'static str;
}

//This is bad cause it produces a non-recoverable allocation in the application...
impl KeyRegistry for Lexer
{
    const Key_Auto       : &'static str = "auto"      ;
    const Key_Concept    : &'static str = "concept"   ;
    const Key_Declare    : &'static str = "declare"   ;
    const Key_Dynamic    : &'static str = "dynamic"   ;
    const Key_EntryPoint : &'static str = "entrypoint";
    const Key_Immutable  : &'static str = "immutable" ;
    const Key_Function   : &'static str = "function"  ;
    const Key_Return     : &'static str = "return"    ;
    const Key_Static     : &'static str = "static"    ;
    const Key_Type       : &'static str = "type"      ;
    const Key_Void       : &'static str = "void"      ;
}