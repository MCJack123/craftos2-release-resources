local version, mainsum, imgsum = ...
local out = assert(io.open("PKGBUILD.new", "w"))
for line in io.lines("PKGBUILD", "*L") do
    if line:match "^%s*pkgver%s*=" then out:write("pkgver=" .. version .. "\n")
    elseif line:match "^%s*pkgrel%s*=" then out:write("pkgrel=1\n")
    elseif line:match "^%s*sha256sums%s*=" then out:write("sha256sums=('" .. mainsum .. "' '" .. imgsum .. "')\n")
    else out:write(line) end
end
out:close()
out = assert(io.open(".SRCINFO.new", "w"))
local sum, source = false, false
for line in io.lines(".SRCINFO", "*L") do
    if line:match "^%s*pkgver%s*=" then out:write("\tpkgver = " .. version .. "\n")
    elseif line:match "^%s*pkgrel%s*=" then out:write("\tpkgrel = 1\n")
    elseif line:match "^%s*sha256sums%s*=" then out:write("\tsha256sums = " .. (sum and imgsum or mainsum) .. "\n") sum = true
    elseif line:match "^%s*source%s*=" then
        local v = version .. (line:match "%-luajit" or "")
        if source then out:write(("\tsource = CraftOS-PC_%s.AppImage::https://github.com/MCJack123/craftos2/releases/download/v%s/CraftOS-PC.x86_64.AppImage\n"):format(v, v))
        else out:write(("\tsource = craftos2-%s.tar.gz::https://github.com/MCJack123/craftos2/archive/v%s.tar.gz\n"):format(v, v)) end
        source = true
    else out:write(line) end
end
out:close()
os.remove("PKGBUILD")
os.remove(".SRCINFO")
os.rename("PKGBUILD.new", "PKGBUILD")
os.rename(".SRCINFO.new", ".SRCINFO")
