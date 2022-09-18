
.SUFFIXES: .css .less

all: targets requirements


# Subdirectories

dir := alleged/blog
include $(dir)/Rules.mk

dir := alleged/whyhello/static/style
include $(dir)/Rules.mk

dir := alleged/frontpage/static/style
include $(dir)/Rules.mk


# Defintions of this built at this level


PYTHON=poetry run python
SITE=alleged
PACKAGE=alleged
HOST=$(SITE)@spreadsite.org
VIRTUALENV=$(SITE)
SETTINGS=$(SITE)
SITE_DIR=/home/$(SITE)/Sites/$(PACKAGE)



REALCLEAN := $(REALCLEAN) requirements.txt

requirements.txt: poetry.lock pyproject.toml
	poetry export --format=requirements.txt --output=$@ --without-hashes

tests:
	$(PYTHON) manage.py test --keep --fail


run_home=ssh $(HOST) sh
prefix=. /home/$(SITE)/virtualenvs/$(VIRTUALENV)/bin/activate; cd $(SITE_DIR);
manage=$(prefix) envdir /service/$(SITE)/env ./manage.py

# Push to the shared Git repo and run commands on the remote server to fetch and update.
deploy: tests requirements.txt
	git push
	echo "mkdir -p static caches/django" | $(run_home)
	echo "cd $(SITE_DIR); git pull" | $(run_home)
	scp requirements.txt $(HOST):$(SITE_DIR)
	echo "$(prefix) pip install -r requirements.txt" | $(run_home)
	echo "$(manage) migrate" | $(run_home)
	echo "$(manage) collectstatic --noinput" | $(run_home)
# 	echo "$(prefix) django-admin compilemessages" | $(run_home)
	echo Might need to run sudo pdc@spreadsite.org and then sudo svc -h /service/$(SITE)



# Variables TARGETS, CLEAN, and REALCLEAN may be added to by Rules.mk fragments
# in subdirectories

.PHONY: targets
targets: $(TARGETS)

.PHONEY: requirements
requirements: requirements.txt

.PHONEY: clean
clean:
	rm -f $(CLEAN)

.PHONEY: realclean
realclean: clean
	rm -f $(REALCLEAN)

.PHONEY: depend
depend: $(DEPEND)

-include $(DEPEND)
