OSTYPE := $(shell uname -s)
CURRENT_VERSION := $(shell grep "version: " pubspec.yaml | awk '{print $$2}')
NEXT_VERSION := $(shell date +%y.%m).$(shell echo "10 * ( $(shell grep "\#\# \[$(shell date +%y.%m)" CHANGELOG.md | wc -l) + 1)" | bc)


.PHONY: release
release:
	git flow init -d -f
	git flow release start $(NEXT_VERSION)
	@if test $(OSTYPE) = "Darwin" ; then\
		sed -i '' -e "s/version: .*/version: $(NEXT_VERSION)/g" pubspec.yaml;\
	else\
		sed -i -e "s/version: .*/version: $(NEXT_VERSION)/g" pubspec.yaml;\
	fi
	cider release
	git add .
	git commit -m 'Bump version to $(NEXT_VERSION)'
	GIT_MERGE_AUTOEDIT=no git flow release finish -m "$(NEXT_VERSION)" $(NEXT_VERSION)

.PHONY: hotfix-prepare
hotfix-prepare:
	git checkout main
	git pull origin main
	git checkout -b hotfix/$(NEXT_VERSION) 
	@if test $(OSTYPE) = "Darwin" ; then\
		sed -i '' -e "s/version: .*/version: $(NEXT_VERSION)/g" pubspec.yaml;\
	else\
		sed -i -e "s/version: .*/version: $(NEXT_VERSION)/g" pubspec.yaml;\
	fi

.PHONY: hotifx-commit
hotfix-commit:
	cider release
	git add .
	git commit -m 'Bump version to $(CURRENT_VERSION)'

.PHONY: hotfix-release
hotfix-release:
	git tag -a $(CURRENT_VERSION) -m "$(CURRENT_VERSION)"

.PHONY: current-version
current-version:
	@echo $(CURRENT_VERSION)