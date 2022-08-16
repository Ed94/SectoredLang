class_name MasEnv extends RefCounted

const NType = SyntaxParser.NType

const SecContext = "Sector Context"

var Parent  : MasEnv
var Records : Dictionary
var Interp  : Interpreter

# TODO: Adapt this to accomadate for use as an identifier env as well.

func resolve_Context(symbol):
	var symbolID       = symbol
	var contextRecords = Records
	
	if typeof(symbol) == TYPE_ARRAY:
		symbolID = symbol.back().entry(1)

		var index = 0
		while index < symbol.size() - 1:
			var recordID = symbol[index]
			contextRecords = contextRecords[ recordID ].Records
			index += 1
			
	return [ symbolID, contextRecords ]
	
func assign(symbol, value):
	var context = resolve_Context(symbol)
	
	var symbolID = context[0]
	var records  = context[1]
	
	if records.has(NType.sec_Stack) && records[NType.sec_Stack].has( symbolID ):
		records[NType.sec_Stack][ symbolID ] = value
		
		return records[NType.sec_Stack][ symbolID ]

	if records.has(NType.sec_Static) && records[NType.sec_Static].has( symbolID ):
		records[NType.sec_Static][ symbolID ] = value
		
		return records[NType.sec_Static][ symbolID ] 

	return null

func assign_Type(value):
	Records[NType.sec_Type] = value
	
	return Records[NType.sec_Type]

func assign_Stack(varSymbol, value):
	var record = Records
	
	if ! record.has(NType.sec_Stack):
		record[NType.sec_Stack] = {}
	
	record[NType.sec_Stack][varSymbol] = value
	
	return record[NType.sec_Stack][varSymbol]

func assign_Static(varSymbol, value):
	var record = Records
	
	if ! record.has(NType.sec_Static):
		record[NType.sec_Static] = {}
	
	record[NType.sec_Static][varSymbol] = value
	
	return record[NType.sec_Static][varSymbol]

func define(symbol : String, env : MasEnv):
	Records[symbol] = env
	
func store_SectorContext(symbol, value):
	if ! Records.has(SecContext):
		Records[SecContext] = []
		
	Records[SecContext][symbol] = value
	
#func assign_Unresolved(symbol):
	

func has(symbol : String):
	return Records.has(symbol)
	
func lookup(symbol):
	var context = resolve_Context(symbol)
	
	var symbolID = context[0]
	var records  = context[1]
	
	if records.has(NType.sec_Stack) && records[NType.sec_Stack].has( symbolID ):
		return records[NType.sec_Stack][ symbolID ]
	
	if records.has(NType.sec_Static) && records[NType.sec_Static].has( symbolID ):
		return records[NType.sec_Static][ symbolID ]

	if records.has( symbolID ):
		return records[ symbolID ]

	return Parent.lookup( symbol )

func setup_Globals():
	Records["null"]  = null
	Records["true"]  = true
	Records["false"] = false


#region Object
func _init(parent : MasEnv, interp : Interpreter) -> void:
	Interp = interp
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
