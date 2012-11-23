module: nanomsg
synopsis: 
author: 
copyright: 

define function main (name :: <string>, arguments :: <vector>)

  sp-init();

  let (major, minor, patch) = sp-version();
  format-out("Using nanomsg %d.%d.%d.\n", major, minor, patch);

  let a = sp-socket($AF-SP, $SP-PAIR);
  sp-bind(a, "inproc://a");

  let b = sp-socket($AF-SP, $SP-PAIR);
  sp-connect(b, "inproc://a");

  let data = make(<buffer>, size: 3);

  sp-send(b, as(<buffer>, "ABC"), 0);
  sp-recv(a, data, 0);

  format-out("Received: %=\n", as(<byte-string>, data));

  sp-close(a);
  sp-close(b);

  sp-term();

  exit-application(0);
end function main;

main(application-name(), application-arguments());
