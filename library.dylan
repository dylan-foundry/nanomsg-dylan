module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library nanomsg
  use dylan;
  use common-dylan;
  use io;
  use c-ffi;

  export nanomsg;
end library;

define module nanomsg
  use common-dylan, exclude: { format-to-string };
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
    sp-allocmsg,
    sp-freemsg,
    sp-send,
    sp-sendmsg,
    sp-recv,
    sp-recvmsg;

  export
    <sp-error>,
    sp-error-status,
    sp-error-message;

  export
    $SP-VERSION-MAJOR,
    $SP-VERSION-MINOR,
    $SP-VERSION-PATCH,
    $SP-VERSION,
    $EADDRINUSE,
    $EADDRNOTAVAIL,
    $EAFNOSUPPORT,
    $EAGAIN,
    $EBADF,
    $EFAULT,
    $EFSM,
    $EINTR,
    $EINVAL,
    $EMFILE,
    $ENAMETOOLONG,
    $ENODEV,
    $ENOMEM,
    $ENOPROTOOPT,
    $ENOTSUP,
    $EPROTONOSUPPORT,
    $ETERM,
    $ETIMEDOUT,
    $AF-SP,
    $AF-SP-RAW,
    $SP-SOCKADDR-MAX,
    $SP-PAIR,
    $SP-INPROC,
    $SP-IPC,
    $SP-TCP,
    $SP-PUB,
    $SP-SUB,
    $SP-REP,
    $SP-REQ,
    $SP-SINK,
    $SP-SOURCE,
    $SP-PUSH,
    $SP-PULL,
    $SP-SURVEYOR,
    $SP-RESPONDENT,
    $SP-SOL-SOCKET,
    $SP-LINGER,
    $SP-SNDBUF,
    $SP-RCVBUF,
    $SP-SNDTIMEO,
    $SP-RCVTIMEO,
    $SP-RECONNECT-IVL,
    $SP-RECONNECT-IVL-MAX,
    $SP-SUBSCRIBE,
    $SP-UNSUBSCRIBE,
    $SP-RESEND-IVL,
    $SP-DEADLINE,
    $SP-DONTWAIT;
end module;
