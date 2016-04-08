DIFF:=diff -u
TESTS:=$(subst .cfg,,$(wildcard test*.cfg))

test01_ARGS:="much more"
test02_ARGS:=orange

all: $(TESTS)

$(TESTS):
	../runtemplate.lua $@.cfg $@.yaml -- $($@_ARGS) | $(DIFF) $@.output - && echo "$@: OK" || echo "$@: FAIL"

.PHONY: all $(TESTS)
