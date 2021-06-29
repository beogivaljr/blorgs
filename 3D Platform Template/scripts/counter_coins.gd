extends Label

var coin_count = 0


func _ready():
	text=String(coin_count)
	

func _on_Coin_cn_collected():
	coin_count=coin_count+1
	_ready()
