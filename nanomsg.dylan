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

define constant $EINTR = 4;

define constant $EMFILE = 24;

define constant $EAGAIN = 35;

define constant $EINVAL = 22;

define constant $EAFNOSUPPORT = 47;

define constant $EBADF = 9;

define constant $ETIMEDOUT = 60;

define constant $EADDRNOTAVAIL = 49;

define constant $EPROTONOSUPPORT = 43;

define constant $EFAULT = 14;

define constant $ENOMEM = 12;

define constant $EADDRINUSE = 48;

define constant $ENOPROTOOPT = 42;

define constant $ENOTSUP = 45;

define constant $ENODEV = 19;

define constant $ENAMETOOLONG = 63;

define C-function nn-errno
  result res :: <C-signed-int>;
  c-name: "nn_errno";
end;

define C-pointer-type <c-string> => <C-signed-char>;
define C-function nn-strerror
  input parameter errnum_ :: <C-signed-int>;
  result res :: <c-string>;
  c-name: "nn_strerror";
end;

define C-pointer-type <int*> => <C-signed-int>;
define C-function nn-symbol
  input parameter i_ :: <C-signed-int>;
  input parameter value_ :: <int*>;
  result res :: <c-string>;
  c-name: "nn_symbol";
end;

define C-function nn-term
  c-name: "nn_term";
end;

define constant <__darwin-size-t> = <C-unsigned-long>;

define constant <size-t> = <__darwin-size-t>;

define C-function nn-allocmsg
  input parameter size_ :: <size-t>;
  input parameter type_ :: <C-signed-int>;
  result res :: <C-void*>;
  c-name: "nn_allocmsg";
end;

define C-function nn-freemsg
  input parameter msg_ :: <C-void*>;
  result res :: <nn-status>;
  c-name: "nn_freemsg";
end;

define C-function nn-socket
  input parameter domain_ :: <C-signed-int>;
  input parameter protocol_ :: <C-signed-int>;
  result res :: <nn-status>;
  c-name: "nn_socket";
end;

define C-function nn-close
  input parameter s_ :: <C-signed-int>;
  result res :: <nn-status>;
  c-name: "nn_close";
end;

define C-function %nn-setsockopt
  input parameter s_ :: <C-signed-int>;
  input parameter level_ :: <C-signed-int>;
  input parameter option_ :: <C-signed-int>;
  input parameter optval_ :: <C-void*>;
  input parameter optvallen_ :: <size-t>;
  result res :: <nn-status>;
  c-name: "nn_setsockopt";
end;

define C-pointer-type <size-t*> => <size-t>;
define C-function nn-getsockopt
  input parameter s_ :: <C-signed-int>;
  input parameter level_ :: <C-signed-int>;
  input parameter option_ :: <C-signed-int>;
  input parameter optval_ :: <C-void*>;
  input parameter optvallen_ :: <size-t*>;
  result res :: <nn-status>;
  c-name: "nn_getsockopt";
end;

define C-function nn-bind
  input parameter s_ :: <C-signed-int>;
  input parameter addr_ :: <c-string>;
  result res :: <nn-status>;
  c-name: "nn_bind";
end;

define C-function nn-connect
  input parameter s_ :: <C-signed-int>;
  input parameter addr_ :: <c-string>;
  result res :: <nn-status>;
  c-name: "nn_connect";
end;

define C-function nn-shutdown
  input parameter s_ :: <C-signed-int>;
  input parameter how_ :: <C-signed-int>;
  result res :: <nn-status>;
  c-name: "nn_shutdown";
end;

define C-function %nn-send
  input parameter s_ :: <C-signed-int>;
  input parameter buf_ :: <C-buffer-offset>;
  input parameter len_ :: <size-t>;
  input parameter flags_ :: <C-signed-int>;
  result res :: <nn-status>;
  c-name: "nn_send";
end;

define C-function %nn-recv
  input parameter s_ :: <C-signed-int>;
  input parameter buf_ :: <C-buffer-offset>;
  input parameter len_ :: <size-t>;
  input parameter flags_ :: <C-signed-int>;
  result res :: <nn-status>;
  c-name: "nn_recv";
end;

define C-function nn-device
  input parameter s1_ :: <C-signed-int>;
  input parameter s2_ :: <C-signed-int>;
  result res :: <C-signed-int>;
  c-name: "nn_device";
end;

define constant $NN-VERSION-CURRENT = 0;

define constant $NN-VERSION-REVISION = 1;

define constant $NN-VERSION-AGE = 0;

define constant $EACCESS = 156384729;

define constant $ETERM = 156384765;

define constant $EFSM = 156384766;

define constant $NN-MSG = -1;

define constant $AF-SP = 1;

define constant $AF-SP-RAW = 2;

define constant $NN-SOCKADDR-MAX = 128;

define constant $NN-SOL-SOCKET = 0;

define constant $NN-LINGER = 1;

define constant $NN-SNDBUF = 2;

define constant $NN-RCVBUF = 3;

define constant $NN-SNDTIMEO = 4;

define constant $NN-RCVTIMEO = 5;

define constant $NN-RECONNECT-IVL = 6;

define constant $NN-RECONNECT-IVL-MAX = 7;

define constant $NN-SNDPRIO = 8;

define constant $NN-SNDFD = 10;

define constant $NN-RCVFD = 11;

define constant $NN-DOMAIN = 12;

define constant $NN-PROTOCOL = 13;

define constant $NN-IPV4ONLY = 14;

define constant $NN-SOCKET-NAME = 15;

define constant $NN-DONTWAIT = 1;

define constant $NN-INPROC = -1;

define constant $NN-PAIR = 16;

define constant $NN-PUSH = 80;

define constant $NN-PULL = 81;

define constant $NN-REQ = 48;

define constant $NN-REP = 49;

define constant $NN-REQ-RESEND-IVL = 1;

define constant $NN-SURVEYOR = 96;

define constant $NN-RESPONDENT = 97;

define constant $NN-SURVEYOR-DEADLINE = 1;

define constant $NN-IPC = -2;

define constant $NN-PUB = 32;

define constant $NN-SUB = 33;

define constant $NN-SUB-SUBSCRIBE = 1;

define constant $NN-SUB-UNSUBSCRIBE = 2;

define constant $NN-BUS = 112;

define constant $NN-TCP = -3;

define constant $NN-TCP-NODELAY = 1;

define constant <byte-vector-like> = type-union(<buffer>, type-union(<byte-vector>, <byte-string>));

define inline function nn-send (socket :: <integer>, data :: <byte-vector-like>, flags :: <integer>) => (res :: <integer>)
  %nn-send(socket, byte-storage-address(data), data.size, flags)
end;

define inline function nn-recv (socket :: <integer>, data :: <byte-vector-like>, flags :: <integer>) => (res :: <integer>)
  %nn-recv(socket, byte-storage-address(data), data.size, flags);
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
