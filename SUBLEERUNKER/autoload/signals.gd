extends Node


signal domain_changed(name)
signal started(best_score)
signal landed(flame)
signal scored(score)
signal hit(player)
signal ended(result)
signal top_changed(name, score)

signal score_upload_requested(domain, score)
signal score_upload_responded(result)