//Using

use std::io::
{
    Read,
    stdin,
    stdout,
    Write
};


//Cycle

struct Core
{
    Exist: bool,   //Used by the core cycle to determine if cycle should iterate
}

impl Core
{
    pub fn Create() -> Core
    {
        Core
        {
            Exist: true,
        }
    }
}


//Command Line

trait CmdConsts
{
    const FoundCmd: bool;
}

struct CmdLineInput
{
    //FoundCmd: bool,

    CmdBank: CmdFlags,

    //PossibleCmds: InputCmds,
    
    UserInput: String,
}

impl CmdLineInput
{
    pub fn Create() -> CmdLineInput
    {
        CmdLineInput
        {
            CmdBank: CmdFlags::Create(),
            
            UserInput: String::new(),
        }
    }

    pub fn Parse(&mut self)
    {
        self.CmdBank.Quit = self.UserInput.contains(&CmdLineInput::Quit.to_string());
    }
}

impl CmdConsts for CmdLineInput
{
    const FoundCmd: bool = true;
}

trait InputCmds
{
    const Quit: &'static str;
}

impl InputCmds for CmdLineInput
{
    const Quit: &'static str = "quit";
}

struct CmdFlags
{
    Quit: bool,
}

impl CmdFlags
{
    pub fn Create() -> CmdFlags
    {
        CmdFlags
        {
            Quit: false,
        }
    }

    pub fn Clear(&mut self)
    {
        self.Quit = false;
    }
}


//Runtime

fn main()
{
    let mut CoreInst: Core = Core::Create();

    let mut CmdL_InputInst: CmdLineInput = CmdLineInput::Create();
    
    println!("");
    
    println!("Launching MAS Handler");

    while CoreInst.Exist == true
    {
        println!("Cycle.");

        stdin().read_line(&mut CmdL_InputInst.UserInput);

        CmdL_InputInst.Parse();
        
        if CmdL_InputInst.CmdBank.Quit == CmdLineInput::FoundCmd
        {
            CoreInst.Exist = false;
        }

        CmdL_InputInst.CmdBank.Clear();
    }

    println!("");

    println!("MAS Exiting");

    //stdout().flush().unwrap();

    println!("Press any key to continue");

    stdin().read(&mut [0]).unwrap();
}
