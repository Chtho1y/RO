return function()
	local ItemCfg = {}
	for i = 1, 2 do
		local cfg = InternalRequire('ItemCfg'..i, true)
		for k, v in pairs(cfg) do
			ItemCfg[k] = v
		end
	end
	package.loaded['ItemCfg1'] = nil
	package.loaded['ItemCfg2'] = nil
	return ItemCfg
end