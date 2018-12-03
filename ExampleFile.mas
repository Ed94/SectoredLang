//This is an example of MAS code.

| Compiler - C1 | 

{ C }

[ Math ], [[[ ExampleSource ]]]

struct AStructure
{
    Integer anInteger;
    
    String astring;
}

AStructure aStructOfStructure;

[[[]]]
{}
||


// { } This also means default.
| Compiler - C3 | { C++ } [[ ExampleSource ]]

enum BindID { EInteger, EString };

class Binder
{
    union IntStrUnion
    {
        Integer integer;
        
        String string;
    }
    
public:
    Process()
    {
    	if (bindType == EInteger)
	{
	    | Unissembly - High |{}(aUnionOfIntStr.integer integer)
	         inc integer
		 ret integer
            {}||
	    
	    return aUnionOfIntStr.string;
	}
	else
	{
	    | Unissembly - High |{}(aUnionOfIntStr.string string)
	         ret string
	    {}||
	    
	    return aUnionOfIntStr.string;
	}
    }
private:
    IntStrUnion aUnionOfIntStr;
    
    BindID bindType;
}

int main
{
    Binder aBinder;
    
    aBinder.Process();
    
    aStructOfStructure.anInteger++;
	
    string[] strings;
    
    exit(0);
}

[[[]]]{}|| 
