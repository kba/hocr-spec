VERSION := 1.2

SPEC_BIBLIO = biblio.json
SPEC_METADATA = $(VERSION)/metadata
SPEC_MD = $(VERSION)/spec.md
SPEC_BS = $(VERSION)/index.bs
SPEC_HTML = $(VERSION)/index.html

HAS_COMMAND = type >/dev/null 2>&1
BIKESHED = @$(shell \
	@if $(HAS_COMMAND) bikeshed;then \
		echo 'bikeshed -f spec $(SPEC_BS)';\
	elif $(HAS_COMMAND) docker;then \
		echo 'docker run --rm -it -v $(PWD):/data kbai/bikeshed -f spec $(SPEC_BS)'; \
	elif $(HAS_COMMAND) curl;then \
		echo 'curl "https://api.csswg.org/bikeshed/" -o $(SPEC_HTML) -F file=@$(SPEC_BS)'; \
	else \
		echo 'echo "bikeshed, docker and curl not installed";exit 1;';\
	fi)

$(SPEC_HTML): $(SPEC_BS)
	$(BIKESHED)

$(SPEC_BS): $(SPEC_METADATA) biblio.json $(SPEC_MD)
	echo '<pre class="metadata">' >  $@
	cat  $(SPEC_METADATA)         >> $@
	echo '</pre>'                 >> $@
	echo '<pre class="biblio">'   >> $@
	cat  $(SPEC_BIBLIO)           >> $@
	echo '</pre>'                 >> $@
	cat  $(SPEC_MD)               >> $@
