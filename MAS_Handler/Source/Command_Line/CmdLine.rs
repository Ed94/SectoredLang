//Command Line Module

//Module TOC

pub mod Input   ;
pub mod Registry;

mod Flags;


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