extends AudioStreamPlayer

# Preloadujemy dźwięki bezpośrednio w skrypcie, 
# aby Singleton zawsze miał do nich dostęp.
var sound_x = preload("res://assets/sounds/pop_2.wav")
var sound_o = preload("res://assets/sounds/pop_4.wav")
var sound_start = preload("res://assets/sounds/start.wav")
var sound_win = preload("res://assets/sounds/finish.wav")

var playback: AudioStreamPlaybackPolyphonic

func _ready() -> void:
	if not stream is AudioStreamPolyphonic:
		stream = AudioStreamPolyphonic.new()
	
	# Upewniamy się, że odtwarzacz jest w stanie "playing"
	if not playing:
		play()

func play_x_sound() -> void:
	_play_poly(sound_x)

func play_o_sound() -> void:
	_play_poly(sound_o)

func play_start_sound() -> void:
	_play_poly(sound_start)

func play_win_sound() -> void:
	_play_poly(sound_win)

func _play_poly(audio_stream: AudioStream) -> void:
	if not audio_stream:
		return

	# Kluczowa poprawka: Jeśli odtwarzacz przestał grać (np. po długiej przerwie),
	# musimy go zrestartować, aby polifonia znów działała.
	if not playing:
		play()
	
	# Pobieramy playback dynamicznie za każdym razem.
	# W Godot 4 playback jest dostępny tylko wtedy, gdy player faktycznie "gra".
	playback = get_stream_playback()
	
	if playback:
		playback.play_stream(audio_stream)

func play_ui_click() -> void:
	# Tutaj możesz dodać dźwięk kliknięcia w menu
	pass
