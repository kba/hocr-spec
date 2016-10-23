VERSION := 1.2

SPEC_BIBLIO = biblio.json
SPEC_BEFORE = $(VERSION)/spec.before.html
SPEC_AFTER = $(VERSION)/spec.after.html
SPEC_MD = $(VERSION)/spec.md
SPEC_BS = $(VERSION)/index.bs
SPEC_HTML = $(VERSION)/index.html

BIKESHED = $(shell for cmd in bikeshed docker curl;do type >/dev/null 2>&1 $$cmd && echo $$cmd && break;done)
BIKESHED_ARGS = -f

$(SPEC_HTML): $(SPEC_METADATA) biblio.json $(SPEC_MD)
	@echo 'Rebuilding spec...'
	@cat  $(SPEC_BEFORE) > $(SPEC_BS)
	@echo '<pre class="biblio">'   >> $(SPEC_BS)
	@cat  $(SPEC_BIBLIO)           >> $(SPEC_BS)
	@echo '</pre>'                 >> $(SPEC_BS)
	@cat  $(SPEC_MD) $(SPEC_AFTER) >> $(SPEC_BS)
	@case "$(BIKESHED)" in \
		bikeshed) bikeshed $(BIKESHED_ARGS) spec $(SPEC_BS) ;; \
		docker)   docker run --rm -it -v $(PWD):/data kbai/bikeshed $(BIKESHED_ARGS) spec $(SPEC_BS) ;; \
		curl)     curl "https://api.csswg.org/bikeshed/" -o $(SPEC_HTML) -Fforce=true -Ffile=@$(SPEC_BS) ;; \
		*)        echo 'Unsupported bikeshed backend "$(BIKESHED)"'; exit 1 ;; esac
	@rm -f $(SPEC_BS)

clean:
	$(RM) $(SPEC_HTML) $(SPEC_BS)
