//Command Line Module

//Module TOC

pub mod Input;

mod Flags   ;
pub mod Registry;


//Constants

trait Consts
{
    const FoundCmd: bool;
}


//Overload Consts for Input.
impl Consts for self::Input::Input
{
    const FoundCmd: bool = true;
}