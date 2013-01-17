module: nanomsg-test-suite
synopsis: Test suite for the nanomsg library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite nanomsg-test-suite ()
  test init-nanomsg-test;
  test open-close-socket-nanomsg-test;
  test bind-close-socket-nanomsg-test;
  test send-receive-nanomsg-test;
  test req-rep-nanomsg-test;
  test fan-in-nanomsg-test;
  test fan-out-nanomsg-test;
  test pubsub-nanomsg-test;
end suite;

define test init-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);
  check-equal("sp-term succeeds",
              sp-term(), 0);
end test init-nanomsg-test;

define test open-close-socket-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  check-equal("sp-socket succeeds",
              sp-errno(), 0);
  check-equal("sp-close(a) succeeds",
              sp-close(a), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test open-close-socket-nanomsg-test;

define test bind-close-socket-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  check-equal("sp-socket succeeds",
              sp-errno(), 0);

  check-no-condition("sp-bind succeeds",
                     sp-bind(a, "inproc://a"));

  check-equal("sp-close(a) succeeds",
              sp-close(a), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test bind-close-socket-nanomsg-test;

define test send-receive-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  // Setup
  let a = sp-socket($AF-SP, $SP-PAIR);
  let b = sp-socket($AF-SP, $SP-PAIR);

  check-no-condition("sp-bind succeeds",
                     sp-bind(a, "inproc://a"));
  check-no-condition("sp-connect succeeds",
                     sp-connect(b, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Send / receive some data.
  check-equal("sp-send returns 3",
              sp-send(b, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-recv returns 3",
              sp-recv(a, data, 0), 3);

  check-equal("Received data was correct.",
              as(<byte-string>, data), "ABC");

  // Tear down
  check-equal("sp-close(a) succeeds",
              sp-close(a), 0);
  check-equal("sp-close(b) succeeds",
              sp-close(b), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test send-receive-nanomsg-test;

define test req-rep-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let rep = sp-socket($AF-SP, $SP-REP);
  let req1 = sp-socket($AF-SP, $SP-REQ);
  let req2 = sp-socket($AF-SP, $SP-REQ);

  // Setup
  check-no-condition("sp-bind(rep) succeeds",
                     sp-bind(rep, "inproc://a"));
  check-no-condition("sp-connect(req1) succeeds",
                     sp-connect(req1, "inproc://a"));
  check-no-condition("sp-connect(req2) succeeds",
                     sp-connect(req2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Check sending to the wrong things at the wrong time.
  check-condition("sending to a reply socket without a request fails",
                  <sp-error>, sp-send(rep, as(<buffer>, "ABC"), 0));
  check-equal("sending to a reply socket without a request sets EFSM",
              sp-errno(), $EFSM);
  check-condition("recv on a req socket without a reply fails",
                  <sp-error>, sp-recv(req1, data, 0));
  check-equal("recv on a req socket without a reply sets EFSM",
              sp-errno(), $EFSM);

  // Test req+rep cycle
  check-equal("sp-send(req2) is 3",
              sp-send(req2, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-recv(rep) is 3",
              sp-recv(rep, data, 0), 3);
  check-equal("sp-send(rep) is 3",
              sp-send(rep, data, 0), 3);
  check-equal("sp-recv(req2) is 3",
              sp-recv(req2, data, 0), 3);

  // Tear down
  check-equal("sp-close(rep) succeeds",
              sp-close(rep), 0);
  check-equal("sp-close(req1) succeeds",
              sp-close(req1), 0);
  check-equal("sp-close(req2) succeeds",
              sp-close(req2), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test req-rep-nanomsg-test;

define test fan-in-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let sink = sp-socket($AF-SP, $SP-SINK);
  let source1 = sp-socket($AF-SP, $SP-SOURCE);
  let source2 = sp-socket($AF-SP, $SP-SOURCE);

  // Setup
  check-no-condition("sp-bind(sink) succeeds",
                     sp-bind(sink, "inproc://a"));
  check-no-condition("sp-connect(source1) succeeds",
                     sp-connect(source1, "inproc://a"));
  check-no-condition("sp-connect(source2) succeeds",
                     sp-connect(source2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-in
  check-equal("sp-send(source1) is 3",
              sp-send(source1, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-send(source2) is 3",
              sp-send(source2, as(<buffer>, "DEF"), 0), 3);
  check-equal("sp-recv(sink) is 3",
              sp-recv(sink, data, 0), 3);
  check-equal("sp-recv(sink) is 3",
              sp-recv(sink, data, 0), 3);

  // Tear down
  check-equal("sp-close(sink) succeeds",
              sp-close(sink), 0);
  check-equal("sp-close(source1) succeeds",
              sp-close(source1), 0);
  check-equal("sp-close(source2) succeeds",
              sp-close(source2), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test fan-in-nanomsg-test;

define test fan-out-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let push = sp-socket($AF-SP, $SP-PUSH);
  let pull1 = sp-socket($AF-SP, $SP-PULL);
  let pull2 = sp-socket($AF-SP, $SP-PULL);

  // Setup
  check-no-condition("sp-bind(push) succeeds",
                     sp-bind(push, "inproc://a"));
  check-no-condition("sp-connect(pull1) succeeds",
                     sp-connect(pull1, "inproc://a"));
  check-no-condition("sp-connect(pull2) succeeds",
                     sp-connect(pull2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-out
  check-equal("sp-send(push) is 3",
              sp-send(push, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-send(push) is 3",
              sp-send(push, as(<buffer>, "DEF"), 0), 3);
  check-equal("sp-recv(pull1) is 3",
              sp-recv(pull1, data, 0), 3);
  check-equal("sp-recv(pull2) is 3",
              sp-recv(pull2, data, 0), 3);

  // Tear down
  check-equal("sp-close(push) succeeds",
              sp-close(push), 0);
  check-equal("sp-close(pull1) succeeds",
              sp-close(pull1), 0);
  check-equal("sp-close(pull2) succeeds",
              sp-close(pull2), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test fan-out-nanomsg-test;

define test pubsub-nanomsg-test ()
  check-equal("sp-init succeeds",
              sp-init(), 0);

  let pub = sp-socket($AF-SP, $SP-PUB);
  let sub1 = sp-socket($AF-SP, $SP-SUB);
  check-equal("sub1 subscribes",
              sp-setsockopt(sub1, $SP-SUB, $SP-SUBSCRIBE, ""), 0);
  let sub2 = sp-socket($AF-SP, $SP-SUB);
  check-equal("sub2 subscribes",
              sp-setsockopt(sub2, $SP-SUB, $SP-SUBSCRIBE, ""), 0);

  // Setup
  check-no-condition("sp-bind(pub) succeeds",
                     sp-bind(pub, "inproc://a"));
  check-no-condition("sp-connect(sub1) succeeds",
                     sp-connect(sub1, "inproc://a"));
  check-no-condition("sp-connect(sub2) succeeds",
                     sp-connect(sub2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-out
  check-equal("sp-send(pub) is 3",
              sp-send(pub, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-send(pub) is 3",
              sp-send(pub, as(<buffer>, "DEF"), 0), 3);
  check-equal("sp-recv(sub1) is 3",
              sp-recv(sub1, data, 0), 3);
  check-equal("sp-recv(sub2) is 3",
              sp-recv(sub2, data, 0), 3);

  // Tear down
  check-equal("sp-close(pub) succeeds",
              sp-close(pub), 0);
  check-equal("sp-close(sub1) succeeds",
              sp-close(sub1), 0);
  check-equal("sp-close(sub2) succeeds",
              sp-close(sub2), 0);

  check-equal("sp-term succeeds",
              sp-term(), 0);
end test pubsub-nanomsg-test;
