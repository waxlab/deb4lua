local psh = function(cmd) return assert(os.execute(cmd)) end
local rsh = function(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local c = f:read()
  f:close()
  return c
end

local version do
  local dt = os.date('*t')
  version = ('%d%02d%02dgit'):format(dt.year, dt.month, dt.day)
end

local dstdir = rsh('realpath ./luakit'..'_'..version)

print('DSTDIR',dstdir)
local srcdir = 'luakit-src'


psh 'git clone https://github.com/luakit/luakit.git luakit-src'
psh ('mkdir -p '..dstdir..'/DEBIAN')
psh ('cd '..srcdir..' ; DESTDIR="'..dstdir..'" make')
psh ('cd '..srcdir..' ; DESTDIR="'..dstdir..'" make install')


local debcontrol = io.open(dstdir..'/DEBIAN/control','w')
debcontrol:write(table.concat({
  'Package: luakit',
  'Version: '..version,
  'Section: web',
  'Priority: optional',
  'Architecture: amd64',
  'Essential: no',
  'Installed-Size: 1024',
  'Maintainer: arkt8',
  'Description: Fast, small, webkit based browser framework extensible by Lua.',
  ''
},'\n'))
debcontrol:close()
psh ( 'dpkg-deb --build '..dstdir)
psh ( 'rm -rf '..dstdir )
psh ( 'rm -rf '..srcdir )


