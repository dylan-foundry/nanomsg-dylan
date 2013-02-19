module: nanomsg
synopsis: generated bindings for the nanomsg library
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define simple-C-mapped-subtype <C-buffer-offset> (<C-void*>)
  export-map <machine-word>, export-function: identity;
end;

define class <nn-error> (<error>)
  constant slot nn-error-status :: <integer>, required-init-keyword: status:;
  constant slot nn-error-message :: <string>, init-keyword: message:, init-value: "Unknown error";
end;

define C-mapped-subtype <nn-status> (<C-int>)
  import-map <integer>,
    import-function:
      method (result :: <integer>) => (checked :: <integer>)
        if ((result < 0) & (result ~= $EAGAIN))
          let errno = nn-errno();
          error(make(<nn-error>, status: errno, message: nn-strerror(errno)));
        else
          result;
        end;
      end;
end;

define interface
  #include {
      "nanomsg/nn.h",
      "nanomsg/fanin.h",
      "nanomsg/inproc.h",
      "nanomsg/pair.h",
      "nanomsg/reqrep.h",
      "nanomsg/survey.h",
      "nanomsg/fanout.h",
      "nanomsg/ipc.h",
      "nanomsg/pubsub.h",
      "nanomsg/bus.h",
      "nanomsg/tcp.h"
    },

    import: all,

    // Pick up the definitions that aren't defined by nanomsg itself.
    import: {
      "EADDRINUSE",
      "EADDRNOTAVAIL",
      "EAFNOSUPPORT",
      "EAGAIN",
      "EBADF",
      "EFAULT",
      "EINTR",
      "EINVAL",
      "EMFILE",
      "ENAMETOOLONG",
      "ENODEV",
      "ENOMEM",
      "ENOPROTOOPT",
      "ENOTSUP",
      "EPROTONOSUPPORT",
      "ETIMEDOUT"
    },

    exclude: {
      "NN_HAUSNUMERO",
      "NN_PAIR_ID",
      "NN_PUBSUB_ID",
      "NN_REQREP_ID",
      "NN_FANIN_ID",
      "NN_FANOUT_ID",
      "NN_SURVEY_ID",
      "NN_BUS_ID",
      "struct nn_cmsghdr",
      "nn_cmsg_nexthdr"
    },

    equate: {"char *" => <c-string>},

    rename: {
      "nn_recv" => %nn-recv,
      "nn_send" => %nn-send,
      "nn_setsockopt" => %nn-setsockopt
    };

    function "nn_version",
      output-argument: 1,
      output-argument: 2,
      output-argument: 3;

    function "nn_bind",
      map-result: <nn-status>;

    function "nn_close",
      map-result: <nn-status>;

    function "nn_connect",
      map-result: <nn-status>;

    function "nn_freemsg",
      map-result: <nn-status>;

    function "nn_getsockopt",
      map-result: <nn-status>;

    function "nn_recv",
      map-argument: { 2 => <C-buffer-offset> },
      map-result: <nn-status>;

    function "nn_recvmsg",
      map-result: <nn-status>;

    function "nn_send",
      map-argument: { 2 => <C-buffer-offset> },
      map-result: <nn-status>;

    function "nn_sendmsg",
      map-result: <nn-status>;

    function "nn_setsockopt",
      map-result: <nn-status>;

    function "nn_shutdown",
      map-result: <nn-status>;

    function "nn_socket",
      map-result: <nn-status>;

    function "nn_term",
      map-result: <nn-status>;

end interface;

// Function for adding the base address of the repeated slots of a <buffer>
// to an offset and returning the result as a <machine-word>.  This is
// necessary for passing <buffer> contents across the FFI.

define function buffer-offset
    (the-buffer :: <buffer>, data-offset :: <integer>)
 => (result-offset :: <machine-word>)
  u%+(data-offset,
      primitive-wrap-machine-word
        (primitive-repeated-slot-as-raw
           (the-buffer, primitive-repeated-slot-offset(the-buffer))))
end function;

define inline function nn-send (socket :: <integer>, data :: <buffer>, flags :: <integer>) => (res :: <integer>)
  %nn-send(socket, buffer-offset(data, 0), data.size, flags)
end;

define inline function nn-recv (socket :: <integer>, data :: <buffer>, flags :: <integer>) => (res :: <integer>)
  %nn-recv(socket, buffer-offset(data, 0), data.size, flags);
end;

define inline method nn-setsockopt (socket :: <integer>, level :: <integer>, option :: <integer>, value :: <integer>)
  with-stack-structure (int :: <C-int*>)
    pointer-value(int) := value;
    %nn-setsockopt(socket, level, option, int, size-of(<C-int*>));
  end;
end;

define inline method nn-setsockopt (socket :: <integer>, level :: <integer>, option :: <integer>, data :: <byte-string>)
  %nn-setsockopt(socket, level, option, as(<c-string>, data), data.size);
end;
