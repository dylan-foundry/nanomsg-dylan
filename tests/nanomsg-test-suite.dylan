module: nanomsg-test-suite
synopsis: Test suite for the nanomsg library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite nanomsg-test-suite ()
  test init-nanomsg-test;
  test open-close-socket-nanomsg-test;
  test bind-close-socket-nanomsg-test;
  test send-receive-nanomsg-test;
end suite;

define test init-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);
  check-equal("sp-term returns 0",
              sp-term(), 0);
end test init-nanomsg-test;

define test open-close-socket-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  check-equal("sp-errno after sp-socket is 0",
              sp-errno(), 0);
  sp-close(a);
  check-equal("sp-errno after sp-close is 0",
              sp-errno(), 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test open-close-socket-nanomsg-test;

define test bind-close-socket-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  check-equal("sp-errno after sp-socket is 0",
              sp-errno(), 0);

  sp-bind(a, "inproc://a");
  check-equal("sp-errno after sp-bind is 0",
              sp-errno(), 0);

  sp-close(a);
  check-equal("sp-errno after sp-close is 0",
              sp-errno(), 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test bind-close-socket-nanomsg-test;

define test send-receive-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  sp-bind(a, "inproc://a");
  check-equal("sp-errno after sp-bind is 0",
              sp-errno(), 0);

  let b = sp-socket($AF-SP, $SP-PAIR);
  sp-connect(b, "inproc://a");
  check-equal("sp-errno after sp-connect is 0",
              sp-errno(), 0);

  let data = make(<buffer>, size: 3);

  sp-send(b, as(<buffer>, "ABC"), 0);
  sp-recv(a, data, 0);

  check-equal("Received data was correct.",
              as(<byte-string>, data), "ABC");

  sp-close(a);
  check-equal("sp-errno after sp-close(a) is 0",
              sp-errno(), 0);

  sp-close(b);
  check-equal("sp-errno after sp-close(b) is 0",
              sp-errno(), 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test send-receive-nanomsg-test;
