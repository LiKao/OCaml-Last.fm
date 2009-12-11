type debug_lvl = Error | Message | Warning | Notice | Signature | Url
val debug_lvl : debug_lvl list ref
val printf_debug : debug_lvl -> ('a, out_channel, unit) format -> 'a

type 'a t
type mbid = string;;
type param = (string * string) list

val init : string -> string -> string -> [`Unauthorized] t
val authorize : 'a t -> string -> [`Authorized] t

(* Internal methods to factor out common code *)
val call_method : string -> (string * string) list -> 'a t -> string
val xxxgetyyy_xml : string -> string -> 'b -> ('b -> param) -> ?extra:param -> 'a t -> string
val searchXXX : string -> string -> ?limit:int -> ?page:int -> 'a t -> string