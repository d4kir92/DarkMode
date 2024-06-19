local _, _ = ...
D4 = D4 or {}
function D4:MClamp(val, vmin, vmax)
    if val < vmin then
        return vmin
    elseif val > vmax then
        return vmax
    end

    return val
end
