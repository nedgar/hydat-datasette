Hydat.sqlite3.zip:
	wget -O $@ "$HYDAT_ZIP_URL"
	
Hydat.zip: Hydat.sqlite3.zip
	unzip $<
