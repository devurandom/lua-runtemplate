DIFF:=diff -u

all: $(subst .cfg,,$(wildcard test-*))

test-01:
	../runtemplate.lua $@.cfg $@.yaml -- "much more" | $(DIFF) $@.output - && echo "$@: OK" || echo "$@: FAIL"

test-02:
	../runtemplate.lua $@.cfg $@.yaml -- orange | $(DIFF) $@.output - && echo "$@: OK" || echo "$@: FAIL"

.PHONY: test-01
