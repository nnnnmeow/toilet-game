extends StaticBody3D

func interact(callback: Callable):
	var res = await callback.call(true)
	if res == 1:
		%FlushSFX.play()
		%AnimationPlayer.play("flush")
	else:
		%MicrowaveDoorOpen.play()
