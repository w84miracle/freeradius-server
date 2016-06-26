#
#  Unit tests for individual pieces of functionality.
#

#
#  The files are put here in order.  Later tests need
#  functionality from earlier tests.
#
FILES  := rfc.txt errors.txt extended.txt lucent.txt wimax.txt \
	escape.txt condition.txt xlat.txt vendor.txt dhcp.txt \
	tlv.txt tunnel.txt dict.txt

PROTO_DICTS := radius dhcp tacacs

TEST_DIR := $(BUILD_DIR)/tests/unit_test_attribute
DICT_DIR := $(TEST_DIR)/share

PROTO_TEST_DICTS := $(addprefix $(DICT_DIR)/,$(addsuffix /dictionary,$(PROTO_DICTS)))

$(info $(PROTO_TEST_DICTS) aaaa)

define MAKE_DICT_TEST_DIR
$(DICT_DIR)/$(1):
	${Q}mkdir -p $$@

$(DICT_DIR)/$(1)/dictionary: $(top_srcdir)/share/dictionary/$(1)/dictionary $(top_srcdir)/src/tests/unit_test_attribute/dictionary.$(1) | $(DICT_DIR)/$(1)
	${Q}for x in $$^; do \
		echo '$$$$INCLUDE ' "$$$$x" >> $$@; \
	done
endef

#
#  Create the output directory(s)
#
.PHONY: $(TEST_DIR)
$(TEST_DIR):
	${Q}mkdir -p $@

.PHONY: $(DICT_DIR)
$(DICT_DIR):
	${Q}mkdir -p $@

#
#  Link in any protocol dictionaries we need
#
$(foreach x,$(PROTO_DICTS),$(eval $(call MAKE_DICT_TEST_DIR,$x)))

#
#  Files in the output dir depend on the unit tests
#
$(TEST_DIR)/%: $(DIR)/% $(BUILD_DIR)/bin/unit_test_attribute $(TESTBINDIR)/unit_test_attribute $(PROTO_TEST_DICTS) | $(TEST_DIR)
	${Q}echo UNIT-TEST $(notdir $@)
	${Q}if ! $(TESTBIN)/unit_test_attribute -D $(DICT_DIR) $<; then \
		echo "$(TESTBIN)/unit_test_attribute -D $(DICT_DIR) $<"; \
		exit 1; \
	fi
	${Q}touch $@

#
#  Get all of the unit test output files
#
TESTS.UNIT_FILES := $(addprefix $(TEST_DIR)/,$(FILES))

#
#  Depend on the output files, and create the directory first.
#
tests.unit: $(TESTS.UNIT_FILES)
