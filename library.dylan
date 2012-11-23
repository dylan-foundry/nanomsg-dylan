module: dylan-user

define library nanomsg
  use dylan;
  use common-dylan;
  use io;
  use c-ffi;

  export nanomsg;
end library;

define module nanomsg
  use common-dylan, exclude: { format-to-string };
  use format-out;
  use c-ffi;
  use dylan-direct-c-ffi;
  use streams;

  export
    sp-version,
    sp-errno,
    sp-strerror,
    sp-init,
    sp-term,
    sp-socket,
    sp-close,
    sp-setsockopt,
    sp-getsockopt,
    sp-bind,
    sp-connect,
    sp-shutdown,
    sp-send,
    sp-recv;

  export
    $SP-VERSION-MAJOR,
    $SP-VERSION-MINOR,
    $SP-VERSION-PATCH,
    $SP-VERSION,
    $SP-HAUSNUMERO,
    $ETERM,
    $EFSM,
    $AF-SP,
    $AF-SP-RAW,
    $SP-SOCKADDR-MAX,
    $SP-PAIR,
    $SP-PUB,
    $SP-SUB,
    $SP-REP,
    $SP-REQ,
    $SP-SOL-SOCKET,
    $SP-SUBSCRIBE,
    $SP-UNSUBSCRIBE,
    $SP-RESEND-IVL,
    $SP-DONTWAIT;
end module;