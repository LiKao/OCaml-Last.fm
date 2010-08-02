type album_id = {album_artist: string; album_name: string}

val getInfo_xml : album_id -> 'a Lastfm_base.t -> string
val getTags_xml : album_id -> [`Authorized] Lastfm_base.t -> string
val search : string -> ?limit:int -> ?page:int -> 'a Lastfm_base.t -> string
