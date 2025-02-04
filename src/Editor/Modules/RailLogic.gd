extends VBoxContainer

var current_rail_logic = null
var current_rail_logic_type = ""
var resource_selector_called = false

func _ready() -> void:
	set_rail_logic(null)


func set_rail_logic(rail_logic):
	visible = rail_logic != null
	current_rail_logic = rail_logic
	current_rail_logic_type = rail_logic.type if rail_logic else ""
	$SignalSettings.visible = current_rail_logic_type == RailLogicTypes.SIGNAL
	$StationSettings.visible = current_rail_logic_type == RailLogicTypes.STATION
	$SpeedLimitSettings.visible = current_rail_logic_type == RailLogicTypes.SPEED_LIMIT
	$WarnSpeedLimitSettings.visible = current_rail_logic_type == RailLogicTypes.SPEED_LIMIT_WARNING
	$GeneralSettings.visible = visible
	if visible:
		update_general_settings_ui()
	match current_rail_logic_type:
		RailLogicTypes.SIGNAL:
			update_signal_settings_ui()
		RailLogicTypes.STATION:
			update_station_settings_ui()
		RailLogicTypes.SPEED_LIMIT:
			update_speed_limit_settings_ui()
		RailLogicTypes.SPEED_LIMIT_WARNING:
			update_warn_speed_limit_settings_ui()




func update_general_settings_ui():
	$GeneralSettings/Distance.value = current_rail_logic.on_rail_position
	$GeneralSettings/Forwad.pressed = current_rail_logic.forward


func _on_Distance_value_changed(value):
	$GeneralSettings/Distance.value = clamp($GeneralSettings/Distance.value, 0, find_parent("Editor").get_rail(current_rail_logic.attached_rail).length)
	current_rail_logic.on_rail_position = $GeneralSettings/Distance.value
	current_rail_logic.set_to_rail()


func _on_Forwad_pressed():
	current_rail_logic.forward = $GeneralSettings/Forwad.pressed
	current_rail_logic.set_to_rail()


func _on_PickVisibleInstance_pressed():
	resource_selector_called = true
	var content_selector = find_parent("Editor").get_node("EditorHUD/Content_Selector")
	content_selector.set_type(content_selector.SIGNAL_TYPES)
	content_selector.show()


func _on_Block_Signal_pressed():
	current_rail_logic.is_block_signal = $SignalSettings/BlockSignal.pressed
	update_signal_settings_ui()


func update_signal_settings_ui():
	$SignalSettings/VisibleInstance/LineEdit.text = current_rail_logic.visual_instance_path


func _on_Content_Selector_resource_selected(complete_path):
	if not resource_selector_called:
		return
	resource_selector_called = false
	if complete_path == "":
		return
	$SignalSettings/VisibleInstance/LineEdit.text = complete_path
	current_rail_logic.visual_instance_path = complete_path
	current_rail_logic.update_visual_instance()







func update_station_settings_ui():
	$StationSettings/Name.text = current_rail_logic.name
	$StationSettings/Length.value = current_rail_logic.length
	$StationSettings/AssignedSignal.text = current_rail_logic.assigned_signal
	$StationSettings/PlatformSide.selected = current_rail_logic.platform_side
	$StationSettings/EnablePersonSystem.pressed = current_rail_logic.personSystem
	$StationSettings/PlatformHeight.visible = current_rail_logic.personSystem
	$StationSettings/Label4.visible = current_rail_logic.personSystem
	$StationSettings/PlatformHeight.value = current_rail_logic.platformHeight
	$StationSettings/Label5.visible = current_rail_logic.personSystem
	$StationSettings/PlatformStart.visible = current_rail_logic.personSystem
	$StationSettings/PlatformStart.value = current_rail_logic.platformStart
	$StationSettings/Label6.visible = current_rail_logic.personSystem
	$StationSettings/PlatformEnd.visible = current_rail_logic.personSystem
	$StationSettings/PlatformEnd.value = current_rail_logic.platformEnd


func _on_StationName_text_entered(new_text):
	Root.name_node_appropriate(current_rail_logic, new_text, current_rail_logic.get_parent())
	$StationSettings/Name.text = current_rail_logic.name


func _on_Length_value_changed(value):
	current_rail_logic.length = $StationSettings/Length.value


func _on_PlatformSide_item_selected(index):
	current_rail_logic.platform_side = index


func _on_EnablePersonSystem_pressed():
	current_rail_logic.personSystem = $StationSettings/EnablePersonSystem.pressed


func _on_PlatformHeight_value_changed(value):
	current_rail_logic.platformHeight = value


func _on_PlatformStart_value_changed(value):
	current_rail_logic.platformStart = value


func _on_PlatformEnd_value_changed(value):
	current_rail_logic.platformEnd = value


func update_speed_limit_settings_ui():
	$SpeedLimitSettings/SpeedLimit.value = current_rail_logic.speed


func _on_SpeedLimit_SpeedLimit_value_changed(value):
	current_rail_logic.speed = $SpeedLimitSettings/SpeedLimit.value
	current_rail_logic.set_to_rail()


func update_warn_speed_limit_settings_ui():
	$WarnSpeedLimitSettings/SpeedLimit.value = current_rail_logic.warn_speed


func _on_WarnSpeedLimit_value_changed(value):
	current_rail_logic.warn_speed = $WarnSpeedLimitSettings/SpeedLimit.value
	current_rail_logic.set_to_rail()


func _on_ConnectedSignal_text_changed(new_text):
	current_rail_logic.assigned_signal = $StationSettings/AssignedSignal.text


func _on_selected_rail_logic_deleted():
	hide()
