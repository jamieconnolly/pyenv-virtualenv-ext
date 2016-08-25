test:
	@bats $${CI:+--tap} test

.PHONY: test
