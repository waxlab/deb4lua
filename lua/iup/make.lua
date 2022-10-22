#!/usr/bin/lua
local sh = os.execute
local psh = function(p) assert(sh(p)) end


local iup = {
  package  = 'libiup',
  arch     = 'amd64',
  version  = '3.30',
  download = 'https://sourceforge.net/projects/iup/files/3.30/Linux%20Libraries/iup-3.30_Linux54_64_lib.tar.gz/download',
  prepare  = function(srcdir, dstdir)
    local inc = dstdir..'/usr/local/include'
    local lib = dstdir..'/usr/local/lib'
    --local lib = dstdir..'/usr/lib/x86_64-linux-gnu'
    psh( 'mkdir -p '..inc )
    psh( 'mkdir -p '..lib )
    psh( 'cp -rf '..srcdir..'/*.so '..srcdir..'/*.a'..' '..lib )
    psh( 'cp -rf '..srcdir..'/include/* '..inc )
  end
}


local luaiup54 = {
  package  = 'liblua54-iup',
  arch     = 'amd64',
  version  = '3.30',
  download = 'https://sourceforge.net/projects/iup/files/3.30/Linux%20Libraries/Lua54/iup-3.30-Lua54_Linux54_64_lib.tar.gz/download',
  prepare  = function(srcdir, dstdir)
    local lib = dstdir..'/usr/local/lib/lua/5.4'
    --local lib = dstdir..'/usr/lib/x86_64-linux-gnu'
    psh( 'mkdir -p '..lib )
    local p = assert(io.popen('find '..srcdir..' -name "*.so" -o -name "*.a"', 'r'))
    local f = true
    while f do
      f = p:read()
      if f then
        psh( 'cp -rf '..f..' '..lib..'/'..(f:gsub('^.*/',''):gsub('^lib',''):gsub('54%.','.')) )
      end
    end
  end
}


function tpl(str, data, default)
  if type(str) == 'table' then str = table.concat(str,"\n") end
  return str:gsub('@@(%w+)@@', function(n)
    return data[n] or default or ''
  end)
end


function fileexists(filename)
  local f = io.open(filename, 'r')
  if not f then return false end
  f:close()
  return true
end


function make(pkg)
  local srcdir = 'src/'..pkg.package..'-'..pkg.version
  local dstdir = 'dst/'..pkg.package..'-'..pkg.version
  local pkgdir = dstdir..'/DEBIAN'
  local srcfile = 'src/'..pkg.download:gsub('^.*/([^/]+)/[^/]+$','%1')

  psh( 'mkdir -p "'..srcdir..'"' )
  psh( 'mkdir -p "'..dstdir..'"' )
  psh( 'mkdir -p "'..pkgdir..'"' )

  if not fileexists(srcfile) then
    psh( 'wget -c '..pkg.download..' -O '..srcfile )
  end

  psh( 'tar -C '..srcdir..' -zxvf '..srcfile )


  local control = io.open( pkgdir..'/control', 'w' )
  control:write(tpl({
    'Package: @@package@@',
    'Version: @@version@@',
    'Section: custom',
    'Priority: optional',
    'Architecture: @@arch@@',
    'Essential: no',
    'Installed-Size: 1024',
    'Maintainer: arkt8',
    'Description: Lua C modules for IUP - Portable User Interface',
    ''
  },pkg))
  control:close()
  pkg.prepare(srcdir, dstdir)
  psh( 'dpkg-deb --build '..dstdir)
  psh 'mv ./dst/*.deb ./'
  psh 'rm -rf ./src/ ./dst/'
end


make(iup)
make(luaiup54)
