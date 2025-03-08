local ColorExtension = {}

local normalizedValue = (1 / 255)

local function HexToDecimal(byte)
    if byte == 48 then return 0x0;
    elseif byte == 49 then return 0x1;
    elseif byte == 50 then return 0x2;
    elseif byte == 51 then return 0x3;
    elseif byte == 52 then return 0x4;
    elseif byte == 53 then return 0x5;
    elseif byte == 54 then return 0x6;
    elseif byte == 55 then return 0x7;
    elseif byte == 56 then return 0x8;
    elseif byte == 57 then return 0x9;
    elseif byte == 65 then return 0xA;
    elseif byte == 97 then return 0xA;
    elseif byte == 66 then return 0xB;
    elseif byte == 98 then return 0xB;
    elseif byte == 67 then return 0xC;
    elseif byte == 99 then return 0xC;
    elseif byte == 68 then return 0xD;
    elseif byte == 100 then return 0xD;
    elseif byte == 69 then return 0xE;
    elseif byte == 101 then return 0xE;
    elseif byte == 70 then return 0xF;
    elseif byte == 102 then return 0xF;
    else
        return 0xF;
    end
end

local function ParserColor24(text, offset)
    local r = (HexToDecimal(string.byte(text, offset)) * 16 ) + HexToDecimal(string.byte(text, offset + 1));
    local g = (HexToDecimal(string.byte(text, offset + 2)) * 16 ) + HexToDecimal(string.byte(text, offset + 3));
    local b = (HexToDecimal(string.byte(text, offset + 4)) * 16 ) + HexToDecimal(string.byte(text, offset + 5));
    return r, g, b;
end

local function ParserColor32(text, offset)
    local r = (HexToDecimal(string.byte(text, offset)) * 16 ) + HexToDecimal(string.byte(text, offset + 1));
    local g = (HexToDecimal(string.byte(text, offset + 2)) * 16 ) + HexToDecimal(string.byte(text, offset + 3));
    local b = (HexToDecimal(string.byte(text, offset + 4)) * 16 ) + HexToDecimal(string.byte(text, offset + 5));
    local a = (HexToDecimal(string.byte(text, offset + 6)) * 16 ) + HexToDecimal(string.byte(text, offset + 7));
    return r, g, b, a;
end

local function ParserColor(text, textLen, offset)
    local len = textLen - offset
    if len >= 7 then
        local r, g, b, a = ParserColor32(text, offset)
        return Color.New(r * normalizedValue, g * normalizedValue, b * normalizedValue, a * normalizedValue)
    elseif len >= 5 then
        local r, g, b = ParserColor24(text, offset)
        return Color.New(r * normalizedValue, g * normalizedValue, b * normalizedValue, 1)
    else
        return Color.white
    end
end

function ColorExtension.HexStringToColor(text, offset)
    if text then
        if offset == nil or offset <= 0 then offset = 1 end
        local len = #text
        for i = offset, len do
            if string.byte(text, i) == 35 then
                return ParserColor(text, len, i + 1)
            end
        end
    end
    return Color.white
end

function ColorExtension.TableToColor(table)
    if not table then return Color.white end
    local r = Clamp(table[1] or 255, 0, 255)
    local g = Clamp(table[2] or 255, 0, 255)
    local b = Clamp(table[3] or 255, 0, 255)
    local a = Clamp(table[4] or 255, 0, 255)
    return Color(r * normalizedValue, g * normalizedValue, b * normalizedValue, a * normalizedValue)
end


return ColorExtension