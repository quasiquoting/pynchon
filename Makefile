.PHONY: compile test

all: compile

compile: ; @rebar3 compile

test: ; @rebar3 eunit -m pynchon-tests
