MELANGE=melange 

all: build

.PHONY: build test

nanomsg.dylan: nanomsg.intr
	$(MELANGE) -Tc-ffi -Iext/nanomsg/include nanomsg.intr nanomsg.dylan

#ext/nanomsg/libnanomsg.a:
#	$(MAKE) -C ext/nanomsg

build: nanomsg.dylan # ext/nanomsg/libnanomsg.a
	dylan-compiler -build nanomsg

test: nanomsg.dylan # ext/nanomsg/libnanomsg.a
	dylan-compiler -build nanomsg-test-suite-app
	_build/bin/nanomsg-test-suite-app

