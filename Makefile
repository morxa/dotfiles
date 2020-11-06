DESTDIR=$(HOME)
install: $(addprefix $(DESTDIR)/.,$(filter-out Makefile (wildcard README*),$(wildcard *)))

$(DESTDIR)/.%: %
	ln -s $(abspath $<) $@
