return function()
	local StroyPerformCfg = {}
	for i = 1, 3 do
		local cfg = InternalRequire('StroyPerformCfg'..i, true)
		for k, v in pairs(cfg) do
			StroyPerformCfg[k] = v
		end
	end
	package.loaded['StroyPerformCfg1'] = nil
	package.loaded['StroyPerformCfg2'] = nil
	package.loaded['StroyPerformCfg3'] = nil
	return StroyPerformCfg
end