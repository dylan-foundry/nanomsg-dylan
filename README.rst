nanomsg-dylan
=============

These are Dylan bindings for the nanomsg library: https://github.com/250bpm/nanomsg

To build them, you will need to build and install the nanomsg library first. You will
also need OpenDylan 2012.1 or later.

TODO
----

* Move buffer-offset into ``io`` and get rid of the 2 copies in ``network`` as well.
* Error handling for ``nn-allocmsg``.
* Documentation.
* Do better with ``nn-getsockopt``
* Test out support for the surveyor pattern.
* Do better with the zero-copy routines.
