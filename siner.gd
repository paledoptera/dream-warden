class_name Siner
extends Node

static func get_sine(siner : float, amplitude := 1.0, frequency := 1.0) -> float:
	var sine = sin(siner * frequency) * amplitude
	return sine
