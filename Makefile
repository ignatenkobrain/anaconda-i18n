BRANCH=master

updates-img:
	-@rm -rf trans
	-@mkdir -p trans/.tx/
	@cd trans; \
	 curl https://git.fedorahosted.org/cgit/anaconda.git/plain/.tx/config?h=${BRANCH} -o .tx/config; \
	 tx pull -a --disable-overwrite \
	 cd ..
	-@rm -rf updates
	-@mkdir -p updates/usr/share/locale/
	@for lang in trans/po/*; do \
	   name=$$(basename "$$lang"); \
	   name=$${name%%.po}; \
	   msgdir="updates/usr/share/locale/$$name/LC_MESSAGES"; \
	   mkdir -p "$$msgdir"; \
	   msgfmt "$$lang" -o "$$msgdir/$$name.mo"; \
	 done
	@cd updates; find . | cpio -c -o | gzip -9 > ../updates.img; cd ..
	-@rm -rf updates
	-@rm -rf trans
