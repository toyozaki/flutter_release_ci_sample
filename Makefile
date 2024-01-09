VERSION := $(shell date +%y.%m).$(shell echo "10 * ( $(shell grep "\#\# \[$(shell date +%y.%m)" CHANGELOG.md | wc -l) + 1)" | bc)

.PHONY: release
release:
	git flow init -d -f
	git flow release start $(VERSION)
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sed -i '' -e "s/version: .*/version: $(VERSION)/g" pubspec.yaml 
	else
		sed -i -e "s/version: .*/version: $(VERSION)/g" pubspec.yaml 
	fi
	cider release
	git add .
	git commit -m 'Bump version to $(VERSION)'
	GIT_MERGE_AUTOEDIT=no git flow release finish -m "$(VERSION)" $(VERSION)
