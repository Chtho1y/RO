return function()
	local SkillLvCfg = {}
	for i = 1, 38 do
		local cfg = InternalRequire('SkillLvCfg'..i, true)
		for k, v in pairs(cfg) do
			SkillLvCfg[k] = v
		end
	end
	package.loaded['SkillLvCfg1'] = nil
	package.loaded['SkillLvCfg2'] = nil
	package.loaded['SkillLvCfg3'] = nil
	package.loaded['SkillLvCfg4'] = nil
	package.loaded['SkillLvCfg5'] = nil
	package.loaded['SkillLvCfg6'] = nil
	package.loaded['SkillLvCfg7'] = nil
	package.loaded['SkillLvCfg8'] = nil
	package.loaded['SkillLvCfg9'] = nil
	package.loaded['SkillLvCfg10'] = nil
	package.loaded['SkillLvCfg11'] = nil
	package.loaded['SkillLvCfg12'] = nil
	package.loaded['SkillLvCfg13'] = nil
	package.loaded['SkillLvCfg14'] = nil
	package.loaded['SkillLvCfg15'] = nil
	package.loaded['SkillLvCfg16'] = nil
	package.loaded['SkillLvCfg17'] = nil
	package.loaded['SkillLvCfg18'] = nil
	package.loaded['SkillLvCfg19'] = nil
	package.loaded['SkillLvCfg20'] = nil
	package.loaded['SkillLvCfg21'] = nil
	package.loaded['SkillLvCfg22'] = nil
	package.loaded['SkillLvCfg23'] = nil
	package.loaded['SkillLvCfg24'] = nil
	package.loaded['SkillLvCfg25'] = nil
	package.loaded['SkillLvCfg26'] = nil
	package.loaded['SkillLvCfg27'] = nil
	package.loaded['SkillLvCfg28'] = nil
	package.loaded['SkillLvCfg29'] = nil
	package.loaded['SkillLvCfg30'] = nil
	package.loaded['SkillLvCfg31'] = nil
	package.loaded['SkillLvCfg32'] = nil
	package.loaded['SkillLvCfg33'] = nil
	package.loaded['SkillLvCfg34'] = nil
	package.loaded['SkillLvCfg35'] = nil
	package.loaded['SkillLvCfg36'] = nil
	package.loaded['SkillLvCfg37'] = nil
	package.loaded['SkillLvCfg38'] = nil
	return SkillLvCfg
end