BIKESHED = @$(shell \
		   if type bikeshed >/dev/null 2>&1;then \
				echo 'bikeshed';\
			elif type docker >/dev/null 2>&1;then \
				echo 'docker run --rm -it -v $(PWD):/data kbai/bikeshed'; \
			else \
				echo 'echo "bikeshed and docker not installed";exit 1;';\
			fi)
VERSION = 1.2

$(VERSION)/index.html: $(VERSION)/index.bs
	$(BIKESHED) -f spec "$<"

$(VERSION)/index.bs: $(VERSION)/metadata biblio.json $(VERSION)/spec.md
	echo '<pre class="metadata">' >  $@
	cat  $(VERSION)/metadata      >> $@
	echo '</pre>'                 >> $@
	echo '<pre class="biblio">'   >> $@
	cat  biblio.json              >> $@
	echo '</pre>'                 >> $@
	cat  $(VERSION)/spec.md       >> $@
