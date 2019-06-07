//Core

//Using

use super::super::CmdLine::
{
    Input::
    {
        PollOption,
        Input
    },
    
    Registry::ID
};

//Cycler Definition:

//Cycler Structure    
pub struct Cycler
{
    pub exist: bool,   //Used by cycle to determine if cycle should iterate.
}

//Cycler Implmentation
impl Cycler
{
    pub fn Create() -> Cycler   //Default constructor.
    {
        Cycler
        {
            exist: true,
        }
    }

    pub fn RunCycle(&mut self, _inputInst: &mut Input)
    {
        while self.exist == true
        {
            println!("Cycle.");

            _inputInst.PollStdin(PollOption::Line);

            _inputInst.Parse();

            if _inputInst.Check(ID::Quit)
            {
                self.exist = false;
            }
            
            _inputInst.ClearBank();
        }
    }
}