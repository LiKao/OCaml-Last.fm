include Lastfm_base

module Artist = struct 
	include Artist
end

module Album = struct
	include Album
end

module Event = struct
	include Event
end

module Geo = struct
	include Geo
end

module Tag = struct
	include Tag
end

module Types = struct
	type artist = Artist.artist = {
		artist_name   : string;
		artist_mbid   : Lastfm_base.mbid option;
		artist_url    : string;
		artist_images : Lastfm_base.image list;
		artist_streamable : bool}
	type tag = Tag.tag = {tag_name : string; tag_url : string}
end
