extends Control

var musicBusIndex = AudioServer.get_bus_index("Music")
var musicMuted = false

# when node is ready, func is executed
# this ensures everything is hidden to start
func _ready():
	$menuContainer.visible = false
	$optionsContainer.visible = false
	$ColorRect.visible = true
	$AnimationPlayer.play("RESET")

# when buttons are pressed
func _on_play_pressed() -> void:
	play()

func _on_options_pressed() -> void:
	options()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	$AnimationPlayer.play_backwards("options")
	$optionsContainer.visible = false
	$AnimationPlayer.play("menu")
	$menuContainer.visible = true
	
func _on_toggle_music_pressed() -> void:
	musicMuted = !musicMuted
	AudioServer.set_bus_mute(musicBusIndex, musicMuted)

# Functions called by button presses
func options():
	$menuContainer.visible = false
	$optionsContainer.visible = true
	$AnimationPlayer.play("options")

func play():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("menu")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("colorRect")
	$menuContainer.visible = false
	$optionsContainer.visible = false

func pause():
	$AnimationPlayer.play("RESET")
	get_tree().paused = true
	$menuContainer.visible = true
	$AnimationPlayer.play("colorRect")
	$AnimationPlayer.queue("menu")
	

func testPause():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		play()

func _process(_delta: float) -> void:
	testPause()
