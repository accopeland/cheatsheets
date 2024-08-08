# brew install lua@5.3
 lua@5.3 is keg-only, which means it was not symlinked into /global/u1/c/copeland/.linuxbrew,because this is an alternate version of another formula.
  If you need to have lua@5.3 first in your PATH, run:
  echo 'export PATH="/global/u1/c/copeland/.linuxbrew/opt/lua@5.3/bin:$PATH"' >> /global/homes/c/copeland/.bash_profile
	##
  For compilers to find lua@5.3 you may need to set:
  export LDFLAGS="-L/global/u1/c/copeland/.linuxbrew/opt/lua@5.3/lib"
  export CPPFLAGS="-I/global/u1/c/copeland/.linuxbrew/opt/lua@5.3/include"
	##
	For pkg-config to find lua@5.3 you may need to set:
  export PKG_CONFIG_PATH="/global/u1/c/copeland/.linuxbrew/opt/lua@5.3/lib/pkgconfig"

# luarocks
LuaRocks supports multiple versions of Lua. By default it is configured
to use Lua5.4, but you can require it to use another version at runtime
with the `--lua-dir` flag, like this:
  luarocks --lua-dir=/global/u1/c/copeland/.linuxbrew/opt/lua@5.1 install say
