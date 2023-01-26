local version, mainsum, luasum = ...
local out = assert(io.open("PKGBUILD.new", "w"))
for line in io.lines("PKGBUILD", "*L") do
    if line:match "^%s*pkgver%s*=" then out:write("pkgver=" .. version .. "\n")
    elseif line:match "^%s*pkgrel%s*=" then out:write("pkgrel=1\n")
    elseif line:match "^%s*sha256sums%s*=" then out:write("sha256sums=('" .. mainsum .. "' '" .. luasum .. "')\n")
    else out:write(line) end
end
out:close()
out = assert(io.open(".SRCINFO.new", "w"))
local sum, source = false, false
for line in io.lines(".SRCINFO", "*L") do
    if line:match "^%s*pkgver%s*=" then out:write("\tpkgver = " .. version .. "\n")
    elseif line:match "^%s*pkgrel%s*=" then out:write("\tpkgrel = 1\n")
    elseif line:match "^%s*sha256sums%s*=" then out:write("\tsha256sums = " .. (sum and luasum or mainsum) .. "\n") sum = true
    elseif line:match "^%s*source%s*=" and not line:match "craftos2%-luajit" then
        local t = source and "-lua" or ""
        out:write(("\tsource = craftos2%s-%s.tar.gz::https://github.com/MCJack123/craftos2%s/archive/v%s.tar.gz\n"):format(t, version, t, version .. (line:match "%-luajit" or "")))
        source = true
    else out:write(line) end
end
out:close()
os.remove("PKGBUILD")
os.remove(".SRCINFO")
os.rename("PKGBUILD.new", "PKGBUILD")
os.rename(".SRCINFO.new", ".SRCINFO")
