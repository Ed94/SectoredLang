class_name MasEnv extends RefCounted

const NType = SyntaxParser.NType

var Parent : MasEnv
var Records : Dictionary

# TODO: Adapt this to accomadate for use as an identifier env as well.


func assign_Type(symbol : String, value):
	G.check(Records.has(symbol), String("Symbol not found in environment records"))
#	G.check( Records[symbol].has(NType.sec_Type), String("type symbol not found in symbol: " + symbol) )
	
	Records[symbol][NType.sec_Type] = value
	
	return Records[symbol][NType.sec_Type]
	
func assign_Type_static(symbol : String, varSymbol, value):
	G.check(Records.has(symbol), String("Symbol not found in environment records"))
	
	var record = Records[symbol]
	
	if !record.has(NType.sec_Static):
		record[NType.sec_Static] = {}
	
	record[NType.sec_Static][varSymbol] = value
	
	return record[NType.sec_Static][varSymbol]

func define(symbol : String):
	Records[symbol] = {}
	
#func define_type(symbol : String, )

func has(symbol : String):
	return Records.has(symbol)
	
func lookup(symbol : String):
	G.check(Records.has(symbol), String("Symbol not found in environment records"))

	return Records[symbol]

func setup_Globals():
	Records["null"]  = null
	Records["true"]  = true
	Records["false"] = false


#region Object
func _init(parent : MasEnv) -> void:
	Parent = parent
	
	return
#endregion Object


#region Serialization
var SEva

func array_Serialize(array) :
	var result = []

	for entry in array :
		if typeof(entry) == TYPE_ARRAY :
			result.append( array_Serialize( entry))

		elif typeof(entry) == TYPE_OBJECT :
			if entry.get_class() ==  "Eva":
				result.append(entry)
			else:
				result.append( entry.to_SExpression() )
		else :
			result.append( entry )
			
	return result

func to_SExpression():
	var expression = []
	
	for key in Records.keys() :
		var entry = [key]
		var Value = Records[key]
		
		if typeof( Value ) == TYPE_ARRAY :
			var array = array_Serialize( Value )
			
			entry.append(array)
			
		elif typeof( Value ) == TYPE_OBJECT :
			entry.append( Value.to_SExpression() )
			
		else :
			entry.append(Value)
			
		expression.append(entry)
		
	return expression
#endregion Serialization
