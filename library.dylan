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
    nn-version,
    nn-errno,
    nn-strerror,
    nn-term,
    nn-socket,
    nn-close,
    nn-setsockopt,
    nn-getsockopt,
    nn-bind,
    nn-connect,
    nn-shutdown,
    nn-allocmsg,
    nn-freemsg,
    nn-send,
    nn-sendmsg,
    nn-recv,
    nn-recvmsg;

  export
    <nn-error>,
    nn-error-status,
    nn-error-message;

  export
    $NN-VERSION-MAJOR,
    $NN-VERSION-MINOR,
    $NN-VERSION-PATCH,
    $NN-VERSION,
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
    $NN-SOCKADDR-MAX,
    $NN-PAIR,
    $NN-INPROC,
    $NN-IPC,
    $NN-TCP,
    $NN-PUB,
    $NN-SUB,
    $NN-REP,
    $NN-REQ,
    $NN-SINK,
    $NN-SOURCE,
    $NN-PUSH,
    $NN-PULL,
    $NN-SURVEYOR,
    $NN-RESPONDENT,
    $NN-SOL-SOCKET,
    $NN-LINGER,
    $NN-SNDBUF,
    $NN-RCVBUF,
    $NN-SNDTIMEO,
    $NN-RCVTIMEO,
    $NN-RECONNECT-IVL,
    $NN-RECONNECT-IVL-MAX,
    $NN-SNDPRIO,
    $NN-SNDFD,
    $NN-RCVFD,
    $NN-SUBSCRIBE,
    $NN-UNSUBSCRIBE,
    $NN-RESEND-IVL,
    $NN-DEADLINE,
    $NN-DONTWAIT;
end module;
