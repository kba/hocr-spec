VERSION := 1.2

SPEC_BIBLIO = biblio.json
SPEC_METADATA = $(VERSION)/metadata
SPEC_MD = $(VERSION)/spec.md
SPEC_BS = $(VERSION)/index.bs
SPEC_HTML = $(VERSION)/index.html

BIKESHED = $(shell for cmd in bikeshed docker curl;do type >/dev/null 2>&1 $$cmd && echo $$cmd && return;done)

$(SPEC_HTML): $(SPEC_BS)
	case "$(BIKESHED)" in \
		bikeshed) bikeshed -f spec $(SPEC_BS) ;; \
		docker) docker run --rm -it -v $(PWD):/data kbai/bikeshed -f spec $(SPEC_BS) ;; \
		curl) curl "https://api.csswg.org/bikeshed/" -o $(SPEC_HTML) -F file=@$(SPEC_BS) ;; \
		*) echo 'Unsupported bikeshed backend "$(BIKESHED)"'; exit 1 ;;\
	esac

$(SPEC_BS): $(SPEC_METADATA) biblio.json $(SPEC_MD)
	echo '<pre class="metadata">' >  $@
	cat  $(SPEC_METADATA)         >> $@
	echo '</pre>'                 >> $@
	echo '<pre class="biblio">'   >> $@
	cat  $(SPEC_BIBLIO)           >> $@
	echo '</pre>'                 >> $@
	cat  $(SPEC_MD)               >> $@

clean:
	$(RM) $(SPEC_HTML) $(SPEC_BS)
