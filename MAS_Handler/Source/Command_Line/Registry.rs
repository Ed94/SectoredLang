//Command Line

//Using

use super::
{
    Input::Input,
};

//Registry Definition:

pub enum ID
{
    //General
    Help,
    Quit,

    //Input Interface options
    Console     ,
    IPC         ,
    WebFramework 
}

pub trait Binds
{
    //General
    const Bind_Help        : &'static str;
    const Bind_Quit        : &'static str;
    //Input Interface option
    const Bind_Console     : &'static str;
    const Bind_IPC         : &'static str;
    const Bind_WebFramework: &'static str;

}

impl Binds for Input
{
    //General
    const Bind_Help        : &'static str = "help"        ;
    const Bind_Quit        : &'static str = "quit"        ;
    //Input Interface Option
    const Bind_Console     : &'static str = "console"     ;
    const Bind_IPC         : &'static str = "IPC"         ;
    const Bind_WebFramework: &'static str = "web famework";
}