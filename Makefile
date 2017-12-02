default: build

Hydat.sqlite3.zip:
	wget -O $@ --progress=dot:mega "$(HYDAT_ZIP_URL)"

Hydat.sqlite3: Hydat.sqlite3.zip
	unzip $<

build: Hydat.sqlite3.zip

deploy: Hydat.sqlite3
	cf push "$(CF_APP)"

run-server: Hydat.sqlite3
	exec datasette serve -h $(VCAP_APP_HOST) -p $(VCAP_APP_PORT) $<
