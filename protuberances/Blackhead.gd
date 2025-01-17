class_name Blackhead extends Area2D


signal protuberance_cleaned

enum State {
	CLOSED,
	OPEN,
	REMOVED,
	CLEAN,
}

onready var _hint = $circle_hint
onready var _sprites = $sprites

export(float) var vapor_tolerance_time: float = 5.0

var _time: float = 0.0
var _state = State.CLOSED
var _fs: int


func _ready():
	_hint.set_color(_hint.white)
	_fs = _sprites.frames.get_frame_count("default")

func apply_vapor() -> bool:
	if _state == State.CLOSED:
		_time += get_process_delta_time()
		if _time >= vapor_tolerance_time:
			_sprites.frame = 1
			_state = State.OPEN
			_hint.set_color(_hint.blue)
			return true
	return false

func remove(delta: float) -> void:
	if _state == State.OPEN:
		var f: int = int(clamp(delta * _fs, 1, _fs - 1))
		_sprites.frame = f
		if _state == State.OPEN and f == _fs - 1:
			print ("Ready to clean")
			_hint.set_color(_hint.red)
			_state = State.REMOVED

func is_open() -> bool:
	return _state == State.OPEN

func clean() -> void:
	if _state == State.REMOVED:
		_sprites.visible = false
		emit_signal("protuberance_cleaned")
		_hint.set_color(_hint.green)
		_state = State.CLEAN
