extends Node

const LogType := Log.EType


var MAS : Interpreter


@onready var EnvView := get_node("TextPipeline/HBox/EnvView")
@onready var Out := get_node("AuxPanels/OutPanel") as Output

func on_EnvUpdated():
	EnvView.text = JSON.new().stringify(MAS.Env.to_SExpression(), "\t")


func _input(event):
	if event.is_action("MAS_Interpret"):
		var result = MAS.eva(G.AST)
	
		if result != null:
			Out.write( result )
		
		return
		

	
	

func _ready() -> void:
	MAS = Interpreter.new(null)
	
	G.MAS = MAS
	G.MAS_EnvUpdated.connect( on_EnvUpdated )
	G.Log.out(LogType.log, "Initialized Persistent MAS Interpreter.")
	return
