# NOTE: This needs to be redone, making the RD parser naturally had me go through this with a comb...


# UNIVERSAL PATTERNS: 

## SECTOR DECLARATION
***Note: All sectors begin and end with a symbol for starting and ending its scope***  
```
	: def_Start SECTOR_BODY def_End
	;
```

## SECTOR ENTRIES
***Note: All options a sector may have can be repeatedly have a new entry in the body unless otherwise specified***  
```
	: VALID ENTRY ...  
	;
```

## LP SECTOR
```
	: LP_SECTOR_SYMBOL SECTOR
	;
```

## SECTOR STACKING
***Note: Linear order of stacking must respect the following Sector's scope constraints.***
```
	: SECTOR_SYMBOL ... SECTOR_SYMBOL SECTOR
	;
```

## Ignored 
***Note: LP development enviornment may collect comments for program database metadata***
```
	: Formatting
	| Comments
	;
```

# Universal Sector (The Unit or 'unconstrained' identifier body)
```
	: Comments  
	| Capture  
	| LP Sectors  
	| Identifier Symbol  
	;
```

# Capture
***Note: Capture the context of the content specified in the parameter expression***  
```
	: ( 'Parameter Expression' ) 
	| ( 'Parameter Expression' ) Symbol
	| ( 'Parameter Expression' ) Sector
	| ( 'Parameter Expression' ) Symbol Sector
	;
```

## Parameter Expression
```
	: 'Parameter Entry', ...
	;
```

## Parameter Entry
```
	: Symbol 
	| Symbol : TYPE 
	| Symbol : TYPE = Expression
	;
```

# LP Sector
***Note: Symbols provided by the langauge platform, their definitions are implemented by said platform***  
***All of these symbols are considered SECTORS***
```
	: alias  
	| conditional  
	| depend  
	| expose  
	| layer  
	| meta  
	| tt

Layer 0 ------------------
	| proc  
	| exe  
	| interrupt
	| static  

Layer 2 ------------------
	| interface

Layer 4 ------------------
	| fn
	;
```

# Identifier Symbol
***Note: Symbols provided by the program model***
```
	: Identifier  Member Resolution '.'  
	| Identifier 'Identifier Sector'
	;
```

## Member Resolution '.'
```
Layer 0 -------------------- 

	: alignof   
	| offsetof  
	| posof		
	| sizeof  
	| ptr  
	| val

Layer 1---------------------
	| typeof
	;
```

# Identifier Sector 
***Note: Definitions provided by the program model***
```
	(Universal Sector)  
	: enum  

Layer 0 -------------------  
	| binary  
	| ternary  
	| octal  
	| hex  
	| struct  
	| static    
	| union   
	| type  
	| op  

Lyaer 1 --------------------

Layer 2 --------------------
	| trait
	| virtual
	; 
``` 

## enum
```
	: Symbol 
	| Symbol = literal_Number : type depend(unsigned)
	;
```

## binary
```
	: BINARY_BLOCK
	;
```

## ternary
```
	: TERNARY_BLOCK
	;
```

## octal
```
	: OCTAL_BLOCK
	;
```

## hex
```
	: HEX_BLOCK
	;
```

## struct
```
	: 'struct Sector'
	| align(literal_Number depend(unsigned)) 'struct Sector'

Layer 1 ------------------
	: soa 'struct Sector'
	| soa align(literal_Number depend(unsigned)) 'struct Sector'
	;
```

## struct Sector
```
	: Symbol : type 
	| Symbol : type = Expression
	;
```

## union
```
	: Symbol : type 
	| Symbol : type = Expression (NOTE: ONLY ONE OF THEM MAY HAVE THIS)
	;
```

# type
*Identifier:*
```
	: type 
	: type          ref
	| type ro       ref (Layers 0 - 1 ONLY)
	| type mut      ref (Layers > 1 ONLY)
	| type mut      ref (Layers > 1 ONLY)
	| type volatile ref
	| type volatile ref
	;
```
*Stack Sector:*
```
	| type register
	;
```

# op
```
	: Operator_Symbol Capture
	: Operator_Symbol Capture               exe
	| Operator_Symbol         -> Expression
	| Operator_Symbol Capture -> Expression
	| Operator_Symbol Capture -> Symbol     exe
	;
```

# alias
```
	: UNDEFINED  
	;
```

# conditional
*Not Runtime Model:*
```
	: if Expression 'Universal Sector'   
	| if Expression 'Universal Sector' else  'Universal Sector' 
	;
```
*Runtime Model:*
```
	: if Expression 'Stack Sector'  
	| if Expression 'Stack Sector' else 'StackSector'  
	;
```

# depend
```
	: Capture  
	;
```

# expose
```
	: Universal Sector  
	;
```

# layer
```
	: Universal Sector  
	;
```

# meta
```
	: Universal Sector
	;
```

# proc
```
	: capture  
	| -> Identifier(Symbol)  

Layer 0 -------------------  
	| exe  
	| inline  
	;
```

# exe
***Note: One exe scope CAN HAVE more than one STACK SECTOR LINEARLY (They are fused in the runtime model stage)***
```
	: Stack Sector  
	;
```

***Stages:***
* Generative Model: Can be used to generate aspects of the interface model or the runtime model.
* Interface Model: Can arbitrarily execute before runtime model is constructed, to manipualate the interface used by the runtime.
* Runtime Model: Used to describe runtime execution.

## Stack Sector
***NOTE: Just nested scope that pushes the stack, transparent capture of exe scope***
```
	: conditional  
	| in  
	| Expression Assignment  

Layer 0--------------------  

	| break           def_SEnd  
	| goto label      def_SEnd  
	| pop  Symbol     def_SEnd  
	| push Symbol     def_SEnd  
	| ret  Identifier def_SEnd  

	| label   'label Sector'  
	| loop    'loop Sector'
	| switch  'switch Sector'

	| mpage    Symbol def_SEnd
	| register Symbol def_SEnd

	| Stack Sector	

Layer 0.OS-----------------
	| heap
	;

Layer 2--------------------
	| gc
	;
```

### label Sector
```
	(Stack Sector)
	;
```

### loop Sector
```
Layer 0--------------------  

	(Stack Sector)  
	| continue     def_SEnd   
	;
```

### switch Sector
```
	: `Expression` `Stack Sector` | fall ...  
	;
```

# static
***Note: The symbol to identify a static variable is optional if declared within an Identifier Sector***
```
	: Symbol : type  
	| Symbol : type  = Expression 
	| type
	| type = Expression
	;
```

# interface
***Note: The symbol to identify an interface is optional if declared within an Identifier Sector***
```
	: 'Interface Sector'
	| Symbol 'Interface Sector'
	;
```

# interface Sector
```
	: 'interface Specifier Sector'
	;
```

# interface Specifier Sector
*Declaration*
```
	: trait   Symbol ...
	| virtual Symbol ...
	;
```
*Implementation*
```
	: trait   proc Symbol...
	| trait   fn   Symbol...
	| virtual proc Symbol...
	| virtual fn   Symbol...
	;
```

# fn 
***Note: The capture is optional as it may be defined before the function sector***
```
	: -> Expression
	| Capture -> Expression
	;
```

# Expression
```
	: Assignment
	;
```

## Assignment
```
	: ResolvedSymbol Op_Assignment UnaryExpression  
	;
```

### Op_Assignment
```
	: =
	| &=
	| |=
	| ^=
	| ~=
	| <<=
	| >>=
	| +=
	| -=
	| *=
	| /=
	| %=
	;
```

## Unary Expression
```
	: Op_Unary Op_Expression
	| Op_Expression
	;
```

### Op_Unary
```
	: !
	| ~
	;
```

## Op_Expression
***NOTE: Depends on LP's operator format***
```
	: ResolvedSymbol Operator ResolvedSymbol   
	| Operator ResolvedSymbol ResolvedSymbol 
	;
```

### Operator
```
	: Op_Logical
	| Op_Arithemtic
	;
```

### Op_Logical
```
	: &&
	| ||
	| &
	| |
	| ^
	| <<
	| >>
	;
```

### Op_Arithmetic
```
	: +
	| -
	| *
	| /
	| %
	| ++
	| --
	| ==
	| !=
	| >=
	| <=
	; 
```
