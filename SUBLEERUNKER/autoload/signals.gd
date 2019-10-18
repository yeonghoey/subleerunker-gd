extends Node


signal domain_changed(name)
signal started()
signal landed(flame)
signal scored(score)
signal hit(player)
signal ended(last_score)
signal top_changed(name, score)

signal steamagent_highscores_request(domain)
signal steamagent_highscores_response(entries)