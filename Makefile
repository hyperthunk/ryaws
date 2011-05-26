.PHONY: rel deps

all: deps compile

compile:
	rebar compile

deps:
	rebar get-deps

clean:
	rebar clean

distclean: clean relclean
	rebar delete-deps

test:
	rebar skip_deps=true eunit

rel: deps
	rebar compile generate

relclean:
	rm -rf rel/ryaws

rebuild: relclean all rel

retest: rebuild
	rel/ryaws/bin/ryaws console
