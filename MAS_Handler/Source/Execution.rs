#![allow(non_snake_case        )]   //Not my style. I'll be providing documentation on my conventions later as I learn the language.
#![allow(non_upper_case_globals)]

//Crates
extern crate MAS_Library;

//Using

use std::io::
{
    Read ,
    stdin,
};

//This formating for use is sick...

use MAS_Library::
{
    Core::
    {
        Cycler::Cycler,   //Use Cycle without needing self naming module.
    },

    CmdLine::
    {
        Input::
        {
            InputOption,
            PollOption ,
            Input      ,
        },

        Registry::ID
    }
};


//Runtime

fn main()
{
    let mut CycleInst: Cycler = Cycler::Create();
    let mut InputInst: Input = Input  ::Create();
    
    println!("");
    
    println!("MAS Handler");

    println!("");

    println!("Please select a interfacing option. (Console, IPC, Web Framework");

    InputInst.Refresh(InputOption::Stdin, PollOption::Line);

    if InputInst.Check(ID::Console)
    {
        CycleInst.RunCycle(&mut InputInst);
    }

    println!("");

    println!("MAS Exiting");

    //stdout().flush().unwrap();

    println!("Press any key to continue");

    stdin().read(&mut [0]).unwrap();
}
