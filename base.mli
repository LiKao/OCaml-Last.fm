type debug_lvl = Error | Message | Warning | Notice | Signature | Url
val debug_lvl : debug_lvl list ref
val printf_debug : debug_lvl -> ('a, out_channel, unit) format -> 'a

type 'a t

val init : string -> string -> string -> [`Unauthorized] t

val authorize : 'a t -> string -> [`Authorized] t

val call_method : string -> (string * string) list -> 'a t -> string