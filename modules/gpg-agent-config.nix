{
  package ? "",
  ...
}:

let
 config = builtins.concatStringsSep "\n" [
    "enable-ssh-support"
    "default-cache-ttl 60480000"
    "max-cache-ttl 60480000"
    "default-cache-ttl-ssh 60480000"
    "max-cache-ttl-ssh 60480000"
    (if package != "" then
      "pinentry-program ${package}"
    else
      ""
    )
  ];
in config
