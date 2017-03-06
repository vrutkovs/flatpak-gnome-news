all: install-deps build prune install-repo
	flatpak update --user org.gnome.News

install-deps:
	flatpak --user remote-add --if-not-exists --from gnome-nightly https://sdk.gnome.org/gnome.flatpakrepo
	flatpak --user install gnome-nightly org.gnome.Platform/x86_64/master org.gnome.Sdk/x86_64/master || true

build:
	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
		--subject="Nightly build of GNOME News, `date`" \
		${EXPORT_ARGS} app org.gnome.News.json

prune:
	flatpak build-update-repo --prune --prune-depth=20 repo

install-repo:
	flatpak --user remote-add --if-not-exists --no-gpg-verify nightly-news ./repo
	flatpak --user -v install nightly-news org.gnome.News || true
