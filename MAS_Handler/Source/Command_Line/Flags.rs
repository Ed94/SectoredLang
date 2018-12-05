//Command Line

//Flags Definition::

pub struct Flags
{
    pub Quit: bool,
}

impl Flags
{
    pub fn Create() -> Flags
    {
        Flags
        {
            Quit: false,
        }
    }

    pub fn Clear(&mut self)
    {
        self.Quit = false;
    }
}