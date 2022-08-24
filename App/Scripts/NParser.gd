# Not sure about this yet...
# Node Parser
# Parses SNodes to resolve more concrete symbols from the program model.
# These are the nodes provided to the backend.

class_name NParser extends Object

var   SNode   = TParser.SNode
const SType  = TParser.SType

const RSType = {
	
}

class NRange : 
	var Start
	var End

class NNode:
	var Type : String
	var Span : NRange
	
	
