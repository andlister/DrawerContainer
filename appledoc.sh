#!/bin/bash

PROJECT_DIR='.'

/usr/local/bin/appledoc \
	--project-name "ALDrawerContainer" \
	--project-company "plasticcube" \
	--company-id "com.plasticcube" \
	--docset-atom-filename "ALDrawerContainer.atom" \
	--docset-feed-url "https://github.com/plasticcube/DrawerContainer/docs/publish/ALDrawerContainer.atom" \
	--docset-package-url "https://github.com/plasticcube/DrawerContainer/docs/publish/com.plasticcube.ALDrawerContainer-1.0.xar" \
	--docset-fallback-url "https://github.com/plasticcube/DrawerContainer/" \
	--output "${PROJECT_DIR}/docs" \
	--publish-docset \
	--logformat xcode \
	--keep-undocumented-objects \
	--keep-undocumented-members \
	--keep-intermediate-files \
	--no-repeat-first-par \
	--no-warn-invalid-crossref \
	--ignore "${PROJECT_DIR}/DrawerMenuDemo" \
	--ignore "${PROJECT_DIR}/docs" \
	--ignore "${PROJECT_DIR}/appledoc.sh" \
	--ignore "*.m" \
	"${PROJECT_DIR}"
