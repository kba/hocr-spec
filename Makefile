VERSION := 1.2

SPEC_BIBLIO = biblio.json
SPEC_METADATA = $(VERSION)/metadata
SPEC_MD = $(VERSION)/spec.md
SPEC_BS = $(VERSION)/index.bs
SPEC_HTML = $(VERSION)/index.html

BIKESHED = $(shell for cmd in bikeshed docker curl;do type >/dev/null 2>&1 $$cmd && echo $$cmd && break;done)

$(SPEC_HTML): $(SPEC_METADATA) biblio.json $(SPEC_MD)
	echo '<pre class="metadata">' >  $(SPEC_BS)
	cat  $(SPEC_METADATA)         >> $(SPEC_BS)
	echo '</pre>'                 >> $(SPEC_BS)
	echo '<pre class="biblio">'   >> $(SPEC_BS)
	cat  $(SPEC_BIBLIO)           >> $(SPEC_BS)
	echo '</pre>'                 >> $(SPEC_BS)
	cat  $(SPEC_MD)               >> $(SPEC_BS)
	case "$(BIKESHED)" in \
		bikeshed) bikeshed -f spec $(SPEC_BS) ;; \
		docker) docker run --rm -it -v $(PWD):/data kbai/bikeshed -f spec $(SPEC_BS) ;; \
		curl) curl "https://api.csswg.org/bikeshed/" -o $(SPEC_HTML) -F force=true -F file=@$(SPEC_BS) ;; \
		*) echo 'Unsupported bikeshed backend "$(BIKESHED)"'; exit 1 ;;\
	esac
	rm -f $(SPEC_BS)

clean:
	$(RM) $(SPEC_HTML) $(SPEC_BS)
