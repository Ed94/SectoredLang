cd Engine\gd\

scons -j%NUMBER_OF_PROCESSORS% platform=windows tools=yes target=release_debug bits=64

exit