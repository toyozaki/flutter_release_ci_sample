VERSION := $(shell date +%y.%m).$(shell bc -e "10 * ( $(shell grep "$(shell date +%y.%m)" CHANGELOG.md | wc -l) + 1)")

.PHONY: release
bump:
	git flow init -d -f
	git flow release start $(VERSION)
	sed -i '' -e "s/version: .*/version: $(VERSION)/g" pubspec.yaml 
	cider release
	git add .
	git commit -m 'Bump version to $(VERSION)'
	GIT_MERGE_AUTOEDIT=no git flow release finish -m "$(VERSION)" $(VERSION)
