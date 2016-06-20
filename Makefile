.PHONY: test

test:
	@bats $${CI:+--tap} test
