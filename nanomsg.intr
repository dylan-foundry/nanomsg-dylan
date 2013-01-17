module: nanomsg
synopsis: generated bindings for the nanomsg library
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define simple-C-mapped-subtype <C-buffer-offset> (<C-char*>)
  export-map <machine-word>, export-function: identity;
end;

define class <sp-error> (<error>)
  constant slot sp-error-status :: <integer>, required-init-keyword: status:;
  constant slot sp-error-message :: <string>, init-keyword: message:, init-value: "Unknown error";
end;

define C-mapped-subtype <sp-status> (<C-int>)
  import-map <integer>,
    import-function:
      method (result :: <integer>) => (checked :: <integer>)
        if ((result < 0) & (result ~= $EAGAIN))
          let errno = sp-errno();
          error(make(<sp-error>, status: errno, message: sp-strerror(errno)));
        else
          result;
        end;
      end;
end;

define interface
  #include {
      "sp/sp.h",
      "sp/fanin.h",
      "sp/inproc.h",
      "sp/pair.h",
      "sp/reqrep.h",
      "sp/survey.h",
      "sp/fanout.h",
      "sp/ipc.h",
      "sp/pubsub.h",
      "sp/tcp.h"
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
      "SP_HAUSNUMERO",
      "SP_PAIR_ID",
      "SP_PUBSUB_ID",
      "SP_REQREP_ID",
      "SP_FANIN_ID",
      "SP_FANOUT_ID",
      "SP_SURVEY_ID"
    },

    equate: {"char *" => <c-string>},

    rename: {
      "sp_recv" => %sp-recv,
      "sp_send" => %sp-send,
      "sp_setsockopt" => %sp-setsockopt
    };

    function "sp_version",
      output-argument: 1,
      output-argument: 2,
      output-argument: 3;

    function "sp_bind",
      map-result: <sp-status>;

    function "sp_close",
      map-result: <sp-status>;

    function "sp_connect",
      map-result: <sp-status>;

    function "sp_freemsg",
      map-result: <sp-status>;

    function "sp_getsockopt",
      map-result: <sp-status>;

    function "sp_init",
      map-result: <sp-status>;

    function "sp_recv",
      map-argument: { 2 => <C-buffer-offset> },
      map-result: <sp-status>;

    function "sp_recvmsg",
      map-result: <sp-status>;

    function "sp_send",
      map-argument: { 2 => <C-buffer-offset> },
      map-result: <sp-status>;

    function "sp_sendmsg",
      map-result: <sp-status>;

    function "sp_setsockopt",
      map-result: <sp-status>;

    function "sp_shutdown",
      map-result: <sp-status>;

    function "sp_socket",
      map-result: <sp-status>;

    function "sp_term",
      map-result: <sp-status>;

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

define inline function sp-send (socket :: <integer>, data :: <buffer>, flags :: <integer>) => (res :: <integer>)
  %sp-send(socket, buffer-offset(data, 0), data.size, flags)
end;

define inline function sp-recv (socket :: <integer>, data :: <buffer>, flags :: <integer>) => (res :: <integer>)
  %sp-recv(socket, buffer-offset(data, 0), data.size, flags);
end;

define inline method sp-setsockopt (socket :: <integer>, level :: <integer>, option :: <integer>, value :: <integer>)
  with-stack-structure (int :: <C-int*>)
    pointer-value(int) := value;
    %sp-setsockopt(socket, level, option, int, size-of(<C-int*>));
  end;
end;

define inline method sp-setsockopt (socket :: <integer>, level :: <integer>, option :: <integer>, data :: <byte-string>)
  %sp-setsockopt(socket, level, option, as(<c-string>, data), data.size);
end;
