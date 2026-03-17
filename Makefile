PNPM   ?= pnpm
OUT     = dist/Vencord.user.js
PROFILES = $(wildcard $(HOME)/.runtime/qutebrowser-*/config/greasemonkey)

.PHONY: all install clean

all: $(OUT)

$(OUT): $(shell find src -type f) package.json pnpm-lock.yaml
	$(PNPM) buildWeb

install: $(OUT)
	@if [ -z "$(PROFILES)" ]; then \
		echo "error: no qutebrowser profiles found in ~/.runtime/" >&2; \
		exit 1; \
	fi
	@for dir in $(PROFILES); do \
		sed '/^\/\/ @run-at /a // @qute-no-proxy' $(OUT) > "$$dir/Vencord.user.js"; \
		echo "installed → $$dir/Vencord.user.js"; \
	done

clean:
	rm -rf dist
