return function()
	local SkillUpEffectCfg = {}
	for i = 1, 2 do
		local cfg = InternalRequire('SkillUpEffectCfg'..i, true)
		for k, v in pairs(cfg) do
			SkillUpEffectCfg[k] = v
		end
	end
	package.loaded['SkillUpEffectCfg1'] = nil
	package.loaded['SkillUpEffectCfg2'] = nil
	return SkillUpEffectCfg
end