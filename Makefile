LNS=ln -sf
BIN=/usr/local/bin
PWD=`pwd`

check:
	rspec -I src/ tests/*.rspec

install:
	mkdir -p $(BIN)
	$(LNS) $(PWD)/src/irbs $(BIN)
