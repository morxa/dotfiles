DESTDIR=$(HOME)
install: $(addprefix $(DESTDIR)/.,$(filter-out Makefile (wildcard README*),$(wildcard *)))

$(DESTDIR)/.%: %
	mkdir -p "$(dir $@)"
	ln -T -s $(abspath $<) $@

$(DESTDIR)/.config:
	mkdir -p $@
