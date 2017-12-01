default: build

build: Hydat.sqlite3.zip

deploy: Hydat.sqlite3
	cf push

Hydat.sqlite3.zip:
	wget -O $@ "$(HYDAT_ZIP_URL)"

Hydat.sqlite3: Hydat.sqlite3.zip
	unzip $<
