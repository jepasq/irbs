# irbs

Inspection/Representation Based web Server.

## Dependencies

You must install rspec before running unit tests :

	sudo pamac install ruby-rspec ruby-yard

Dependencies are listed in a *Gemfile*. To install all at once :

	bundle

If you need to set a local path because of permissions error :

	bundle config set --local path vendor/bundle

## Running

To avoid require issue and run the main script with *bundler* context :

	bundle exec src/irbs

or simply 

	make run

You can pass parameters after make run, for example, to run an example, run
the following command : `make run examples/004_favicon`.

## Installation

A *Makefile* provides a rule to link in-source binary to `/usr/local/bin`. To
use it, try :

	make install

## Unit tests

Unit tests are provided by rspec-based files in `tests/`. You can run them
using the following command :

	make check

You can also running individual test if you correctly include *src/* files
ans call rspec through bundle. For example to run argument unit tests only :

	bundle exec rspec -I src/ tests/argument.rspec

If you want to run a specific test, you can append line number after *rspec*
file name :
	
	bundle exec rspec -I src/ tests/argument.rspec:38 	

## Naming conventions

### Class name

While the parser search for *Camelcase* class names (i.e. `Sidebar`), the
ruby name convention makes this class reside in a file named `sidebar.rb`
(note the down case first char). The parser follow this convention.

## Troubleshooting

If you have **LoadError** failure when running individual unit tests such as

	LoadError:
      cannot load such file -- <A random src/ filename>

you may have forgotten to add `-I src/`. Also make sure to call `rspec`
the `bundle exec` way.

## API documentation

To generate or update *API documentation*, plus run `yard` then open

	doc/index.html 
	
file. A good start point is the Server class.
