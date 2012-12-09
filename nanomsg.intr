module: nanomsg
synopsis: generated bindings for the nanomsg library
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define simple-C-mapped-subtype <C-buffer-offset> (<C-char*>)
  export-map <machine-word>, export-function: identity;
end;

define interface
  #include "sp/sp.h",
    equate: {"char *" => <c-string>},
    rename: {
      "sp_recv" => %sp-recv,
      "sp_send" => %sp-send
    };

    function "sp_version",
      output-argument: 1,
      output-argument: 2,
      output-argument: 3;

    function "sp_send",
      map-argument: { 2 => <C-buffer-offset> };

    function "sp_recv",
      map-argument: { 2 => <C-buffer-offset> };

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
