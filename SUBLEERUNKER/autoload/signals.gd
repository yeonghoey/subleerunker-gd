extends Node

# Scene transition signals
signal scene_intro_ended()
signal scene_play_selected()
signal scene_vs_selected()
signal scene_achievements_selected()
signal scene_options_selected()
signal scene_play_closed()
signal scene_vs_closed()
signal scene_achievements_closed()
signal scene_options_closed()

# Options
signal option_get_requested(key)
signal option_set_requested(key, value)
signal option_fullscreen_updated(value)
signal option_hidecursor_updated(value)
signal option_music_updated(value)
signal option_sound_updated(value)

signal domain_changed(name)
signal started(best_score)
signal landed(flame)
signal scored(score)
signal hit(player)
signal ended(result)
signal top_changed(name, score)

signal retry_score_upload_succeeded(result)