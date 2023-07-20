# irbs

Inspection/Representation Based web Server.

## Dependencies

You must install rspec before running unit tests :

	sudo pamac install ruby-rspec 

Dependencies are listed in a *Gemfile*. To install all at once :

	bundle

If you need to set a local path because of permissions error :

	bundle config set --local path vendor/bundle

## Instalation

A *Makefile* provides a rule to link in-source binary to `/usr/local/bin`. To
use it, try :

	make install

## Unit tests

Unit tests are provided by rspec-based files in `tests/`. You can run them
using the following command :

	make check

