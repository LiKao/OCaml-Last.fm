(** OCaml API to the Last.fm functions*)

(** {1 global functions}*)
(*******************************************************************)
(** Type to identify connections to the Lastfm service *)
type 'a t 
val init : string -> string -> string -> [`Unauthorized] t
val authorize : 'a t -> string -> [`Authorized] t

module Artist : sig
	(** {1 Access to the Last.fm artist.* functions}*)

	(*******************************************************************)
	(** {2 XML Functions}*)
	(** Functions to access unparsed XML data from the Last.fm service *)
	(*******************************************************************)

	(** Get event Data for an artist *)
	val getEvents_xml : string -> 'a t -> string
	val getImages_xml : string -> 'a t -> string
	val getInfo_xml : string -> 'a t -> string
	val getPastEvents_xml : string -> 'a t -> string
	val getPodcast_xml : string -> 'a t -> string
	val getShouts_xml : string -> 'a t -> string
	val getSimilar_xml : string -> 'a t -> string
	val getTags_xml : string -> [`Authorized] t -> string
	val getTopAlbums_xml : string -> 'a t -> string
	val getTopFans_xml : string -> 'a t -> string
	val getTopTags_xml : string -> 'a t -> string
	val getTopTracks_xml : string -> 'a t -> string	
end