BINDIR      ?= .bundle/bin
BUNDLE      ?= $(BINDIR)/bundle

all:: jekyll
default: all

.bundle: Gemfile
# ignore WARNING:  You don't have /app/prototype/.bundle/bin in your PATH, gem executables will not run.
	mkdir -p $(BINDIR) && gem install --user-install bundler --bindir=$(BINDIR) --no-wrappers 2>&1 | grep -Ev 'PATH|not run'

	# XXX This can be used to install bundler but doesn't work on Jenkins :(
	# $(BUNDLE) install --path .bundle --binstubs $(BINDIR)
	# Instead we now rely on Bundler being installed globally.
	$(BUNDLE) install --path .bundle --binstubs
	@touch .bundle

jekyll: .bundle
	$(BUNDLE) exec jekyll build --config=_config.yml

serve: .bundle
	$(BUNDLE) exec jekyll serve --config=_config.yml

clean:
	rm -rf .bundle

.PHONY: all jekyll serve clean