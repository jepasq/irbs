LNS=ln -sf
BIN=/usr/local/bin
PWD=`pwd`

check:
	rspec tests/*

install:
	mkdir -p $(BIN)
	$(LNS) $(PWD)/src/irbs $(BIN)
