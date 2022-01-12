// Sector Attribution

// Alias - Single : Defintion ;
// A-S:D;
alias Identifier : /- Def -/ ;

// Alias - Multi : Body ;
// A-M:D;
alias : Identifier : /- Body -/ ;

// Identifier - Multi : Alias - Multi : Body ;
// I-M:A-M:
Identifier : alias : /- Body -/ ;

// Identifier - Alias : Body ;
// I-A:B;
Identifier alias : /- Body -/ ; // ?

// Identifier - Alias - Identifier - Single : Definition ;
// I-A-I-S:D;
Identifier alias Identifier2 : /- Def -/ ;

// Single definitions must be scoped with an identifier.


// In Symbol Table (CSV):

// If Alias comes first, the identifier is BOUND to the alias scope.
// A-S 
Identifier, Definition
// A-M
#, Identifier, Definition, ...

// If Identifier comes first, the nested sector is BOUND to that scope
// Sector precedence binds context.


// Defined symbols can be extended anywhere within their unit.

// Ex: Defering attribution
Identifier : /- body -/ ;
// expose attribute added later.
// the symbol table would amend the identifier.
expose Identifer;





// Expose the identifier and all its content for this body.
expose Identifier :
	/- Body -/
;

// Expose the content of this identifier (If the identifier is exposed)
Identifier :
	expose :
		/- Body -/
	;

	/- Body -/
;

// Above requires at least one place identifier is deemed exposed otherwise,
// subexposed body is revoked :
expose Identifier;

// Procedure definitions

// Signatures (AKA declarations)

Identifier proc;
Identifier proc (...);
Identifier proc -> Type;
Identifier proc (...) -> Type;

// Procedures may have multiple exe bodies, they are combined in the order
// discorved within the body
Identifier proc exe : /- Execution -/;


