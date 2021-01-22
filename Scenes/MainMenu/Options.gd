extends VBoxContainer


onready var _master_volume_slider : HSlider = $MasterVolumeHSlider
onready var _master_volume_info : Label = $MasterVolumeInfo/MasterVolumeNumberLabel

onready var _music_volume_slider : HSlider = $MusicVolumeHSlider
onready var _music_volume_info : Label = $MusicVolumeInfo/MusicVolumeNumberLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	_master_volume_slider.connect("value_changed", self,"master_volume_changed")
	_music_volume_slider.connect("value_changed", self,"music_volume_changed")
	
	var master_vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	_master_volume_slider.value = master_vol
	
	var music_vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	_music_volume_slider.value = music_vol

func master_volume_changed(value : float):
	_volume_changed(value, "Master", _master_volume_slider, _master_volume_info)

func music_volume_changed(value : float):
	_volume_changed(value, "Music", _music_volume_slider, _music_volume_info)

func _volume_changed(value : float, bus : String, slider : HSlider, info : Label):
	if(value != slider.min_value):
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	var max_diffrance = (slider.max_value - slider.min_value)
	var precent = round(((value - slider.min_value) / max_diffrance) * 100)
	var text = str(precent)
	info.text = text
