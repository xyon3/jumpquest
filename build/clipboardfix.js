function _godot_js_display_clipboard_get(callback) {
	try {
		var result = prompt("Paste your token:");
		const ptr=GodotRuntime.allocString(result);
		const func=GodotRuntime.get_func(callback);
		func(ptr);
		GodotRuntime.free(ptr);
	} catch (e) { console.log(e) }
}
