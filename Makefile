.PHONY: doc

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

# Individual checks
check-group:
	bundle exec rspec -I src/ tests/group.rspec

check-arg:
	bundle exec rspec -I src/ tests/argument.rspec

check-parser:
	bundle exec rspec -I src/ tests/parser.rspec

doc:
	@yard
	@echo "Done. Now, open doc/index.html"

undoc:
	@yard stats --list-undoc
	@echo "Done. Now, open doc/index.html"
