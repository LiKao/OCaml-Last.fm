type debug_lvl = Error | Message | Warning | Notice | Signature | Url
val debug_lvl : debug_lvl list ref
val printf_debug : debug_lvl -> ('a, out_channel, unit) format -> 'a

type 'a connection 

val init : string -> string -> string -> [`Unauthorized] connection

val authorize : 'a connection -> string -> [`Authorized] connection

val call_method : string -> (string * string) list -> 'a connection -> string
