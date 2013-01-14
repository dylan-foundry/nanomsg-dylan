MELANGE=melange

all: build

.PHONY: build test

nanomsg.dylan: nanomsg.intr
	$(MELANGE) -Tc-ffi -Iext/nanomsg/include nanomsg.intr nanomsg.dylan

build: nanomsg.dylan
	dylan-compiler -build nanomsg

test: nanomsg.dylan
	dylan-compiler -build nanomsg-test-suite-app
	_build/bin/nanomsg-test-suite-app

clean:
	rm nanomsg.dylan
	rm -rf _build/bin/nanomsg*
	rm -rf _build/lib/*nanomsg*
	rm -rf _build/build/nanomsg*
