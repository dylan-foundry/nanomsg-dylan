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
  check-equal("sp-errno after sp-close(a) is 0",
              if (~sp-close(a)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test open-close-socket-nanomsg-test;

define test bind-close-socket-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let a = sp-socket($AF-SP, $SP-PAIR);
  check-equal("sp-errno after sp-socket is 0",
              sp-errno(), 0);

  check-equal("sp-errno after sp-bind is 0",
              if (~sp-bind(a, "inproc://a")) sp-errno() else 0 end, 0);

  check-equal("sp-errno after sp-close(a) is 0",
              if (~sp-close(a)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test bind-close-socket-nanomsg-test;

define test send-receive-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  // Setup
  let a = sp-socket($AF-SP, $SP-PAIR);
  let b = sp-socket($AF-SP, $SP-PAIR);

  check-equal("sp-errno after sp-bind is 0",
              if (~sp-bind(a, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect is 0",
              if (~sp-connect(b, "inproc://a")) sp-errno() else 0 end, 0);

  let data = make(<buffer>, size: 3);

  // Send / receive some data.
  check-equal("sp-send returns 3",
              sp-send(b, as(<buffer>, "ABC"), 0), 3);
  check-equal("sp-recv returns 3",
              sp-recv(a, data, 0), 3);

  check-equal("Received data was correct.",
              as(<byte-string>, data), "ABC");

  // Tear down
  check-equal("sp-errno after sp-close(a) is 0",
              if (~sp-close(a)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(b) is 0",
              if (~sp-close(b)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test send-receive-nanomsg-test;

define test req-rep-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let rep = sp-socket($AF-SP, $SP-REP);
  let req1 = sp-socket($AF-SP, $SP-REQ);
  let req2 = sp-socket($AF-SP, $SP-REQ);

  // Setup
  check-equal("sp-errno after sp-bind(rep) is 0",
              if (~sp-bind(rep, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(req1) is 0",
              if (~sp-connect(req1, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(req2) is 0",
              if (~sp-connect(req2, "inproc://a")) sp-errno() else 0 end, 0);

  let data = make(<buffer>, size: 3);

  // Check sending to the wrong things at the wrong time.
  check-equal("sending to a reply socket without a request fails",
              sp-send(rep, as(<buffer>, "ABC"), 0), -1);
  check-equal("sending to a reply socket without a request sets EFSM",
              sp-errno(), $EFSM);
  check-equal("recv on a req socket without a reply fails",
              sp-recv(req1, data, 0), -1);
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
  check-equal("sp-errno after sp-close(rep) is 0",
              if (~sp-close(rep)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(req1) is 0",
              if (~sp-close(req1)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(req2) is 0",
              if (~sp-close(req2)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test req-rep-nanomsg-test;

define test fan-in-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let sink = sp-socket($AF-SP, $SP-SINK);
  let source1 = sp-socket($AF-SP, $SP-SOURCE);
  let source2 = sp-socket($AF-SP, $SP-SOURCE);

  // Setup
  check-equal("sp-errno after sp-bind(sink) is 0",
              if (~sp-bind(sink, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(source1) is 0",
              if (~sp-connect(source1, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(source2) is 0",
              if (~sp-connect(source2, "inproc://a")) sp-errno() else 0 end, 0);

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
  check-equal("sp-errno after sp-close(sink) is 0",
              if (~sp-close(sink)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(source1) is 0",
              if (~sp-close(source1)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(source2) is 0",
              if (~sp-close(source2)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test fan-in-nanomsg-test;

define test fan-out-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let push = sp-socket($AF-SP, $SP-PUSH);
  let pull1 = sp-socket($AF-SP, $SP-PULL);
  let pull2 = sp-socket($AF-SP, $SP-PULL);

  // Setup
  check-equal("sp-errno after sp-bind(push) is 0",
              if (~sp-bind(push, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(pull1) is 0",
              if (~sp-connect(pull1, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(pull2) is 0",
              if (~sp-connect(pull2, "inproc://a")) sp-errno() else 0 end, 0);

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
  check-equal("sp-errno after sp-close(push) is 0",
              if (~sp-close(push)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(pull1) is 0",
              if (~sp-close(pull1)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(pull2) is 0",
              if (~sp-close(pull2)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test fan-out-nanomsg-test;

define test pubsub-nanomsg-test ()
  check-equal("sp-init returns 0",
              sp-init(), 0);

  let pub = sp-socket($AF-SP, $SP-PUB);
  let sub1 = sp-socket($AF-SP, $SP-SUB);
  check-equal("sp-errno after sub1 subscribes",
              if (0 > sp-setsockopt(sub1, $SP-SUB, $SP-SUBSCRIBE, "")) sp-errno() else 0 end, 0);
  let sub2 = sp-socket($AF-SP, $SP-SUB);
  check-equal("sp-errno after sub2 subscribes",
              if (~sp-setsockopt(sub2, $SP-SUB, $SP-SUBSCRIBE, "")) sp-errno() else 0 end, 0);

  // Setup
  check-equal("sp-errno after sp-bind(pub) is 0",
              if (~sp-bind(pub, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(sub1) is 0",
              if (~sp-connect(sub1, "inproc://a")) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-connect(sub2) is 0",
              if (~sp-connect(sub2, "inproc://a")) sp-errno() else 0 end, 0);

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
  check-equal("sp-errno after sp-close(pub) is 0",
              if (~sp-close(pub)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(sub1) is 0",
              if (~sp-close(sub1)) sp-errno() else 0 end, 0);
  check-equal("sp-errno after sp-close(sub2) is 0",
              if (~sp-close(sub2)) sp-errno() else 0 end, 0);

  check-equal("sp-term returns 0",
              sp-term(), 0);
end test pubsub-nanomsg-test;
