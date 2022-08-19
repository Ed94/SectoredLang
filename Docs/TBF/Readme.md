This is a direct translation of:  
https://github.com/Trial-By-Fire/TBF-C_ConsoleEngine

I used the C version to keep the langauge feature use minimal since I don't want to consider advanced features of the possible upper layers yet.

I plan to port it to a gdscript translatable version where cells are converted to some sort of block grid I'm going to make in godot.
The Platform.uf will thus be changed along with the renderer's functionality to accomodate using a godot viewport sim of a console instead
of a windows console.

Goal with this version is to get it to at least parse completely and have the files not dependent on console intepreted and model populated runtime enviornment.  
