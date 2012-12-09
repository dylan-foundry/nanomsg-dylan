module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library nanomsg-test-suite
  use common-dylan;
  use io;
  use nanomsg;
  use testworks;

  export nanomsg-test-suite;
end library;

define module nanomsg-test-suite
  use common-dylan, exclude: { format-to-string };
  use format;
  use nanomsg;
  use streams, import { <buffer> };
  use testworks;

  export nanomsg-test-suite;
end module;
