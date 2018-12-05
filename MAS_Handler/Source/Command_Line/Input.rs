//Command Line

//Using

use std::
{
    io::stdin,

    string::
    {
        String,
    }
};

use super::
{
    Consts,

    Flags::Flags,

    Registry::
    {
        ID   ,
        Binds,
    }
};


//Input Definition:

//Structure
pub struct Input
{
    cmdBank: Flags,

    userInput: String,
}

//Implementation
impl Input
{
    pub fn Create() -> Input
    {
        Input
        {
            cmdBank: Flags::Create(),

            userInput: String::new(),
        }
    }

    pub fn Check(&mut self, _idToCheck: ID) -> bool
    {
        match _idToCheck
        {
            ID::Quit =>
            {
                if self.cmdBank.Quit == Input::FoundCmd
                {
                    return true;
                }
                else 
                {
                    return false;
                }
            },

            //_ => println!("Failed to find match for ID given to Input::Check."),
        }

        //return false;
    }

    pub fn ClearBank(&mut self)
    {
        self.cmdBank.Clear();
    }

    pub fn GetUserInput(&mut self)
    {
        stdin().read_line(&mut self.userInput).expect("Failed to read line for user input.");
    }

    pub fn Parse(&mut self)
    {
                                         //This right here with input doesn't feel right...
        self.cmdBank.Quit = self.userInput.contains(&Input::Quit.to_string());
    }
}