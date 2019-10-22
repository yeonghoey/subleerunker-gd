extends Node


signal domain_changed(name)
signal started(best_score)
signal landed(flame)
signal scored(score)
signal hit(player)
signal ended(result)
signal top_changed(name, score)

signal retry_score_upload_succeeded(result)