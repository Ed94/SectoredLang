//Core

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
}