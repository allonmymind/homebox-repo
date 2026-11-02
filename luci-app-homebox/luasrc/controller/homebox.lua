module("luci.controller.homebox", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/homebox") then
		return
	end

	entry({"admin", "services", "homebox"}, cbi("homebox"), _("Homebox"), 20).dependent = true

	entry({"admin", "services", "homebox_status"}, call("homebox_status"))
end

function homebox_status()
	local sys = require "luci.sys"
	local uci = require "luci.model.uci".cursor()

	-- pidof 是进程是否真实存在的权威判断
	local running = (sys.call("pidof homebox >/dev/null") == 0)

	local port = uci:get("homebox", "@homebox[0]", "port") or "3300"

	luci.http.prepare_content("application/json")
	luci.http.write_json({ running = running, port = tonumber(port) or 3300 })
end
