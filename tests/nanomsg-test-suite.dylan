module: nanomsg-test-suite
synopsis: Test suite for the nanomsg library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite nanomsg-test-suite ()
  test open-close-socket-nanomsg-test;
  test bind-close-socket-nanomsg-test;
  test send-receive-nanomsg-test;
  test req-rep-nanomsg-test;
  test fan-in-nanomsg-test;
  test fan-out-nanomsg-test;
  test pubsub-nanomsg-test;
end suite;

define test open-close-socket-nanomsg-test ()
  let a = nn-socket($AF-SP, $NN-PAIR);
  check-equal("nn-socket succeeds",
              nn-errno(), 0);
  check-equal("nn-close(a) succeeds",
              nn-close(a), 0);
end test open-close-socket-nanomsg-test;

define test bind-close-socket-nanomsg-test ()
  let a = nn-socket($AF-SP, $NN-PAIR);
  check-equal("nn-socket succeeds",
              nn-errno(), 0);

  check-no-condition("nn-bind succeeds",
                     nn-bind(a, "inproc://a"));

  check-equal("nn-close(a) succeeds",
              nn-close(a), 0);
end test bind-close-socket-nanomsg-test;

define test send-receive-nanomsg-test ()
  // Setup
  let a = nn-socket($AF-SP, $NN-PAIR);
  let b = nn-socket($AF-SP, $NN-PAIR);

  check-no-condition("nn-bind succeeds",
                     nn-bind(a, "inproc://a"));
  check-no-condition("nn-connect succeeds",
                     nn-connect(b, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Send / receive some data.
  check-equal("nn-send returns 3",
              nn-send(b, as(<buffer>, "ABC"), 0), 3);
  check-equal("nn-recv returns 3",
              nn-recv(a, data, 0), 3);

  check-equal("Received data was correct.",
              as(<byte-string>, data), "ABC");

  // Tear down
  check-equal("nn-close(a) succeeds",
              nn-close(a), 0);
  check-equal("nn-close(b) succeeds",
              nn-close(b), 0);
end test send-receive-nanomsg-test;

define test req-rep-nanomsg-test ()
  let rep = nn-socket($AF-SP, $NN-REP);
  let req1 = nn-socket($AF-SP, $NN-REQ);
  let req2 = nn-socket($AF-SP, $NN-REQ);

  // Setup
  check-no-condition("nn-bind(rep) succeeds",
                     nn-bind(rep, "inproc://a"));
  check-no-condition("nn-connect(req1) succeeds",
                     nn-connect(req1, "inproc://a"));
  check-no-condition("nn-connect(req2) succeeds",
                     nn-connect(req2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Check sending to the wrong things at the wrong time.
  check-condition("sending to a reply socket without a request fails",
                  <nn-error>, nn-send(rep, as(<buffer>, "ABC"), 0));
  check-equal("sending to a reply socket without a request sets EFSM",
              nn-errno(), $EFSM);
  check-condition("recv on a req socket without a reply fails",
                  <nn-error>, nn-recv(req1, data, 0));
  check-equal("recv on a req socket without a reply sets EFSM",
              nn-errno(), $EFSM);

  // Test req+rep cycle
  check-equal("nn-send(req2) is 3",
              nn-send(req2, as(<buffer>, "ABC"), 0), 3);
  check-equal("nn-recv(rep) is 3",
              nn-recv(rep, data, 0), 3);
  check-equal("nn-send(rep) is 3",
              nn-send(rep, data, 0), 3);
  check-equal("nn-recv(req2) is 3",
              nn-recv(req2, data, 0), 3);

  // Tear down
  check-equal("nn-close(rep) succeeds",
              nn-close(rep), 0);
  check-equal("nn-close(req1) succeeds",
              nn-close(req1), 0);
  check-equal("nn-close(req2) succeeds",
              nn-close(req2), 0);
end test req-rep-nanomsg-test;

define test fan-in-nanomsg-test ()
  let sink = nn-socket($AF-SP, $NN-SINK);
  let source1 = nn-socket($AF-SP, $NN-SOURCE);
  let source2 = nn-socket($AF-SP, $NN-SOURCE);

  // Setup
  check-no-condition("nn-bind(sink) succeeds",
                     nn-bind(sink, "inproc://a"));
  check-no-condition("nn-connect(source1) succeeds",
                     nn-connect(source1, "inproc://a"));
  check-no-condition("nn-connect(source2) succeeds",
                     nn-connect(source2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-in
  check-equal("nn-send(source1) is 3",
              nn-send(source1, as(<buffer>, "ABC"), 0), 3);
  check-equal("nn-send(source2) is 3",
              nn-send(source2, as(<buffer>, "DEF"), 0), 3);
  check-equal("nn-recv(sink) is 3",
              nn-recv(sink, data, 0), 3);
  check-equal("nn-recv(sink) is 3",
              nn-recv(sink, data, 0), 3);

  // Tear down
  check-equal("nn-close(sink) succeeds",
              nn-close(sink), 0);
  check-equal("nn-close(source1) succeeds",
              nn-close(source1), 0);
  check-equal("nn-close(source2) succeeds",
              nn-close(source2), 0);
end test fan-in-nanomsg-test;

define test fan-out-nanomsg-test ()
  let push = nn-socket($AF-SP, $NN-PUSH);
  let pull1 = nn-socket($AF-SP, $NN-PULL);
  let pull2 = nn-socket($AF-SP, $NN-PULL);

  // Setup
  check-no-condition("nn-bind(push) succeeds",
                     nn-bind(push, "inproc://a"));
  check-no-condition("nn-connect(pull1) succeeds",
                     nn-connect(pull1, "inproc://a"));
  check-no-condition("nn-connect(pull2) succeeds",
                     nn-connect(pull2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-out
  check-equal("nn-send(push) is 3",
              nn-send(push, as(<buffer>, "ABC"), 0), 3);
  check-equal("nn-send(push) is 3",
              nn-send(push, as(<buffer>, "DEF"), 0), 3);
  check-equal("nn-recv(pull1) is 3",
              nn-recv(pull1, data, 0), 3);
  check-equal("nn-recv(pull2) is 3",
              nn-recv(pull2, data, 0), 3);

  // Tear down
  check-equal("nn-close(push) succeeds",
              nn-close(push), 0);
  check-equal("nn-close(pull1) succeeds",
              nn-close(pull1), 0);
  check-equal("nn-close(pull2) succeeds",
              nn-close(pull2), 0);
end test fan-out-nanomsg-test;

define test pubsub-nanomsg-test ()
  let pub = nn-socket($AF-SP, $NN-PUB);
  let sub1 = nn-socket($AF-SP, $NN-SUB);
  check-equal("sub1 subscribes",
              nn-setsockopt(sub1, $NN-SUB, $NN-SUB-SUBSCRIBE, ""), 0);
  let sub2 = nn-socket($AF-SP, $NN-SUB);
  check-equal("sub2 subscribes",
              nn-setsockopt(sub2, $NN-SUB, $NN-SUB-SUBSCRIBE, ""), 0);

  // Setup
  check-no-condition("nn-bind(pub) succeeds",
                     nn-bind(pub, "inproc://a"));
  check-no-condition("nn-connect(sub1) succeeds",
                     nn-connect(sub1, "inproc://a"));
  check-no-condition("nn-connect(sub2) succeeds",
                     nn-connect(sub2, "inproc://a"));

  let data = make(<buffer>, size: 3);

  // Test fan-out
  check-equal("nn-send(pub) is 3",
              nn-send(pub, as(<buffer>, "ABC"), 0), 3);
  check-equal("nn-send(pub) is 3",
              nn-send(pub, as(<buffer>, "DEF"), 0), 3);
  check-equal("nn-recv(sub1) is 3",
              nn-recv(sub1, data, 0), 3);
  check-equal("nn-recv(sub2) is 3",
              nn-recv(sub2, data, 0), 3);

  // Tear down
  check-equal("nn-close(pub) succeeds",
              nn-close(pub), 0);
  check-equal("nn-close(sub1) succeeds",
              nn-close(sub1), 0);
  check-equal("nn-close(sub2) succeeds",
              nn-close(sub2), 0);
end test pubsub-nanomsg-test;
