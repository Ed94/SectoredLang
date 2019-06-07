//Command Line

//Flags Definition::

pub struct Flags
{
    pub Help        : bool,
    pub Quit        : bool,
    pub Console     : bool,
    pub IPC         : bool,
    pub WebFramework: bool,
}

impl Flags
{
    pub fn Create() -> Flags
    {
        Flags
        {
            Help        : false,
            Quit        : false,
            Console     : false,
            IPC         : false,
            WebFramework: false,
        }
    }

    pub fn Clear(&mut self)
    {
        self.Help         = false;
        self.Quit         = false;
        self.Console      = false;
        self.IPC          = false;
        self.WebFramework = false;
    }
}