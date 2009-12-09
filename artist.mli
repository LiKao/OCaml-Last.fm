type artist_id = string

val getEvents_xml : artist_id -> 'a Base.t -> string
val getImages_xml : artist_id -> 'a Base.t -> string
val getInfo_xml : artist_id -> 'a Base.t -> string
val getPastEvents_xml : artist_id -> 'a Base.t -> string
val getPodcast_xml : artist_id -> 'a Base.t -> string
val getShouts_xml : artist_id -> 'a Base.t -> string
val getSimilar_xml : artist_id -> 'a Base.t -> string
val getTags_xml : artist_id -> [`Authorized] Base.t -> string
val getTopAlbums_xml : artist_id -> 'a Base.t -> string
val getTopFans_xml : artist_id -> 'a Base.t -> string
val getTopTags_xml : artist_id -> 'a Base.t -> string
val getTopTracks_xml : artist_id -> 'a Base.t -> string
val search : string -> ?limit:int -> ?page:int -> 'a Base.t -> string
