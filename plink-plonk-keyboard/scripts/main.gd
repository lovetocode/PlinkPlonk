extends Control

const KEYBOARD := preload("res://scripts/keyboard.gd")
const TOP_BAR := 70.0

var vbox: VBoxContainer
var drums

const THEMES := [
	{"name": "Classic", "white": Color.WHITE, "black": Color.BLACK, "pressed": Color(0.4, 0.7, 1.0), "border": Color.DIM_GRAY},
	{"name": "Chiptune", "white": Color(0.7, 1.0, 0.7), "black": Color(0.1, 0.25, 0.1), "pressed": Color(1.0, 0.9, 0.2), "border": Color(0.05, 0.15, 0.05)},
	{"name": "Sunset", "white": Color(1.0, 0.9, 0.75), "black": Color(0.35, 0.1, 0.2), "pressed": Color(1.0, 0.5, 0.2), "border": Color(0.3, 0.1, 0.1)},
	{"name": "Night", "white": Color(0.25, 0.28, 0.4), "black": Color(0.05, 0.05, 0.12), "pressed": Color(0.8, 0.4, 1.0), "border": Color.BLACK},
]

var theme_indexes := [0, 1]
var theme_buttons := []
var kbs := []

func _ready() -> void:
	vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.offset_top = TOP_BAR
	vbox.add_theme_constant_override("separation", 6)
	add_child(vbox)
	var sw := Button.new()
	sw.text = "Swap hands"
	sw.position = Vector2(670, 10)
	sw.custom_minimum_size = Vector2(200, 50)
	sw.pressed.connect(swap_hands)
	add_child(sw)

	for n in [72, 48]:
		var kb: Control = KEYBOARD.new()
		kb.start_note = n
		kb.side_on_right = (n == 72)
		kb.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(kb)
		kbs.append(kb)

	for i in kbs.size():
		var b := Button.new()
		b.position = Vector2(10 + i * 330, 10)
		b.custom_minimum_size = Vector2(310, 50)
		b.pressed.connect(next_theme.bind(i))
		add_child(b)
		theme_buttons.append(b)
		apply_theme(i)
		
func swap_hands() -> void:
	vbox.move_child(vbox.get_child(1), 0)

func next_theme(i: int) -> void:
	theme_indexes[i] = (theme_indexes[i] + 1) % THEMES.size()
	apply_theme(i)

func apply_theme(i: int) -> void:
	var t = THEMES[theme_indexes[i]]
	theme_buttons[i].text = ("Right: " if i == 0 else "Left: ") + t.name
	kbs[i].colors = t
	kbs[i].queue_redraw()
