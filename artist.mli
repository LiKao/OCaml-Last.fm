type artist_id = string

type artist = {
	artist_name   : string;
	artist_mbid   : Lastfm_base.mbid option;
	artist_url    : string;
	artist_images : Lastfm_base.image list;
	artist_streamable : bool} 

val getEvents_xml : artist_id -> 'a Lastfm_base.t -> string
val getImages_xml : artist_id -> 'a Lastfm_base.t -> string
val getInfo_xml : artist_id -> 'a Lastfm_base.t -> string
val getPastEvents_xml : artist_id -> 'a Lastfm_base.t -> string
val getPodcast_xml : artist_id -> 'a Lastfm_base.t -> string
val getShouts_xml : artist_id -> 'a Lastfm_base.t -> string
val getSimilar_xml : artist_id -> 'a Lastfm_base.t -> string
val getTags_xml : artist_id -> [`Authorized] Lastfm_base.t -> string
val getTopAlbums_xml : artist_id -> 'a Lastfm_base.t -> string
val getTopFans_xml : artist_id -> 'a Lastfm_base.t -> string
val getTopTags_xml : artist_id -> 'a Lastfm_base.t -> string
val getTopTracks_xml : artist_id -> 'a Lastfm_base.t -> string

val search : string -> ?limit:int -> ?page:int -> 'a Lastfm_base.t -> string
val getSimilar : string -> 'a Lastfm_base.t -> (artist * float) list
val getTopTags : string -> 'a Lastfm_base.t -> (Tag.tag * int) list

val parseSimilar : string -> (artist * float) list
val parseTopTags : string -> (Tag.tag * int) list

val getName : artist -> string	
val getUrl : artist -> string
val isStreamable : artist -> bool