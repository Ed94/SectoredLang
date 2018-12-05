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
        Input::Input,
        Registry::ID,
    }
};


//Runtime

fn main()
{
    let mut CycleInst: Cycler = Cycler::Create();

    let mut InputInst: Input = Input::Create();
    
    println!("");
    
    println!("MAS Handler");

    while CycleInst.exist == true
    {
        println!("Cycle.");

        InputInst.GetUserInput();

        InputInst.Parse();
        
        if InputInst.Check(ID::Quit)
        {
            CycleInst.exist = false;
        }

        InputInst.ClearBank();
    }

    println!("");

    println!("MAS Exiting");

    //stdout().flush().unwrap();

    println!("Press any key to continue");

    stdin().read(&mut [0]).unwrap();
}
