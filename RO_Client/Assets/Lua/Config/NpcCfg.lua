return function()
	local NpcCfg = {}
	for i = 1, 3 do
		local cfg = InternalRequire('NpcCfg'..i, true)
		for k, v in pairs(cfg) do
			NpcCfg[k] = v
		end
	end
	package.loaded['NpcCfg1'] = nil
	package.loaded['NpcCfg2'] = nil
	package.loaded['NpcCfg3'] = nil
	return NpcCfg
end