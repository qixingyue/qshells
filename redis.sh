#before you install redis , edit the src/Makefile change prefix to your prefer which is the place where redis binary locate.

make

cd utils
./install_server.sh


shutdown

redis-cli shutdown
