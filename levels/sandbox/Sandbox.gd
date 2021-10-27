extends BaseLevel

## Script inherited from Base Level because it will contain some common 
## behaviour, like the signal "on_level_finished" for instance.
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.

## Example use of "on_level_finished" signal
func _ready() -> void:
	
	## Wait for 3 seconds to continue with the function.
	yield(get_tree().create_timer(3.0), "timeout")
	
	## Just an example of how to call level finish for the Level Manager to
	## take care of it.
	emit_signal("on_level_finished")
