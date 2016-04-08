DIFF:=diff -u
RUNTEMPLATE:=../runtemplate.lua

TESTS:=$(subst .cfg,,$(wildcard test*.cfg))

test01_ARGS:="much more"
test02_ARGS:=hostname=orange
test03_ARGS:=cn=common-name

all: $(TESTS)

$(TESTS):
	$(RUNTEMPLATE) $@.cfg $@.yaml -- $($@_ARGS) | $(DIFF) $@.output - && echo "$@: OK" || echo "$@: FAIL"

.PHONY: all $(TESTS)
