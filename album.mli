type album_id = {album_artist: string; album: string}

val getInfo_xml : album_id -> 'a Base.t -> string
val getTags_xml : album_id -> [`Authorized] Base.t -> string
val search : string -> ?limit:int -> ?page:int -> 'a Base.t -> string
