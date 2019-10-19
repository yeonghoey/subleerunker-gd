extends Node


signal domain_changed(name)
signal started()
signal landed(flame)
signal scored(score)
signal hit(player)
signal ended(last_score)
signal top_changed(name, score)

signal highscores_requested(domain)
signal highscores_responded(entries)
signal score_upload_requested(score)
signal score_upload_responded(result)