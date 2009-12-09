val getEvents_xml : string -> 'a Base.t -> string
val getImages_xml : string -> 'a Base.t -> string
val getInfo_xml : string -> 'a Base.t -> string
val getPastEvents_xml : string -> 'a Base.t -> string
val getPodcast_xml : string -> 'a Base.t -> string
val getShouts_xml : string -> 'a Base.t -> string
val getSimilar_xml : string -> 'a Base.t -> string
val getTags_xml : string -> [`Authorized] Base.t -> string
val getTopAlbums_xml : string -> 'a Base.t -> string
val getTopFans_xml : string -> 'a Base.t -> string
val getTopTags_xml : string -> 'a Base.t -> string
val getTopTracks_xml : string -> 'a Base.t -> string
val search : string -> ?limit:int -> ?page:int -> 'a Base.t -> string
