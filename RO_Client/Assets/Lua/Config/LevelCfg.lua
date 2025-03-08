return function()
	local LevelCfg = {}
	for i = 1, 3 do
		local cfg = InternalRequire('LevelCfg'..i, true)
		for k, v in pairs(cfg) do
			LevelCfg[k] = v
		end
	end
	package.loaded['LevelCfg1'] = nil
	package.loaded['LevelCfg2'] = nil
	package.loaded['LevelCfg3'] = nil
	return LevelCfg
end