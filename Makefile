default: build

Hydat.sqlite3.zip:
	wget -O $@ --progress=dot:mega "$(HYDAT_ZIP_URL)"

Hydat.sqlite3: Hydat.sqlite3.zip
	unzip $<
	rm -f $<

build: Hydat.sqlite3.zip

deploy:
	cf push "$(CF_APP)"

run-server: Hydat.sqlite3
	ls -al
	exec datasette serve -h $(VCAP_APP_HOST) -p $(VCAP_APP_PORT) --cors -m metadata.json $<
