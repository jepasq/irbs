LNS=ln -sf
BIN=/usr/local/bin
PWD=`pwd`

run:
	bundle exec src/irbs $(ARGS)

check:
	bundle exec rspec -I src/ tests/*.rspec tests/examples/*.rspec

install:
	mkdir -p $(BIN)
	$(LNS) $(PWD)/src/irbs $(BIN)
