//Command Line

//Using

use super::
{
    Input::Input,
};

//Registry Definition:

pub enum ID
{
    Quit, 
}

pub trait Binds
{
    const Quit: &'static str;
}

impl Binds for Input
{
    const Quit: &'static str = "quit";
}