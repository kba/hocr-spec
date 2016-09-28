BIKESHED = bikeshed -f
VERSION = 1.2

$(VERSION)/index.html: $(VERSION)/index.bs
	$(BIKESHED) spec "$<"

$(VERSION)/index.bs: $(VERSION)/metadata biblio.json $(VERSION)/spec.md
	echo '<pre class="metadata">' >  $@
	cat  $(VERSION)/metadata      >> $@
	echo '</pre>'                 >> $@
	echo '<pre class="biblio">'   >> $@
	cat  biblio.json              >> $@
	echo '</pre>'                 >> $@
	cat  $(VERSION)/spec.md       >> $@
