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

pub enum InputOption
{
    Stdin,
}

pub enum PollOption
{
    Line,
}

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
            ID::Help =>
            {
                if self.cmdBank.Help == Input::FoundCmd
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
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
            ID::Console =>
            {
                if self.cmdBank.Console == Input::FoundCmd
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            ID::IPC =>
            {
                if self.cmdBank.IPC == Input::FoundCmd
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            ID::WebFramework =>
            {
                if self.cmdBank.WebFramework == Input::FoundCmd
                {
                    return true;
                }
                else 
                {
                    return false;
                }
            }

            //_ => println!("Failed to find match for ID given to Input::Check."),
        }

        //return false;
    }

    pub fn ClearBank(&mut self)
    {
        self.cmdBank.Clear();
    }

    pub fn PollStdin(&mut self, _pollToComplete: PollOption)
    {
        match _pollToComplete
        {
            PollOption::Line =>
            {
                stdin().read_line(&mut self.userInput).expect("Failed to read line for user input.");
            }
        }
    }

    pub fn Parse(&mut self)
    {
        self.cmdBank.Help = self.userInput.contains(&Input::Bind_Help.to_string());
                                         //This right here with input doesn't feel right... (I gave the binds a identifier to thier origin cause you can't figure it out via vs code hover)
        self.cmdBank.Quit = self.userInput.contains(&Input::Bind_Quit.to_string());

        self.cmdBank.Console      = self.userInput.contains(&Input::Bind_Console     .to_string());
        self.cmdBank.IPC          = self.userInput.contains(&Input::Bind_IPC         .to_string());
        self.cmdBank.WebFramework = self.userInput.contains(&Input::Bind_WebFramework.to_string());
    }

    pub fn Refresh(&mut self, _inputOption: InputOption, _pollToComplete: PollOption)
    {
        match _inputOption
        {
            InputOption::Stdin =>
            {
                self.PollStdin(_pollToComplete);

                self.Parse();
            }
        }
    }
}