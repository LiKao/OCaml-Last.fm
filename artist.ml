(* implemented methods:
Artist.getEvents
Artist.getImages
Artist.getInfo
Artist.getPastEvents
Artist.getPodcast
Artist.getShouts
Artist.getSimilar
Artist.getTags
Artist.getTopAlbums
Artist.getTopFans
Artist.getTopTags
Artist.getTopTracks
Artist.search*)

(* not implemented write methods:
Artist.addTags
Artist.removeTag
Artist.share
Artist.shout*)

open Lastfm_base

type artist_id = string

type artist = {
	artist_name   : string;
	artist_mbid   : mbid option;
	artist_url    : string;
	artist_images : image list;
	artist_streamable : bool} 

let artist_id_to_param artist_id = [("artist",artist_id)] 

let getXXX_xml yyy artist_id connection =
	xxxgetyyy_xml "artist" yyy artist_id artist_id_to_param connection
   

let getEvents_xml name connection =
	getXXX_xml "Events" name connection
	
let getImages_xml name connection =
	getXXX_xml "Images" name connection

let getInfo_xml name connection =
   getXXX_xml "Info" name connection
	
let getPastEvents_xml name connection =
	getXXX_xml "PastEvents" name connection
	
let getPodcast_xml name connection =
	getXXX_xml "Podcast" name connection
	
let getShouts_xml name connection =
	getXXX_xml "Shouts" name connection

let getSimilar_xml name connection =
	getXXX_xml "Similar" name connection
 
let getTags_xml name connection =
	getXXX_xml "Tags" name connection
	
let getTopAlbums_xml name connection =
	getXXX_xml "TopAlbums" name connection

let getTopFans_xml name connection =
	getXXX_xml "TopFans" name connection
	
let getTopTags_xml name connection =
	getXXX_xml "TopTags" name connection

let getTopTracks_xml name connection =
	getXXX_xml "TopTracks" name connection
	
let search name ?limit ?page connection =
	searchXXX "artist" name ?limit ?page connection
	

let (>>=) = Parse_xml.(>>=) 	

let parse_tag =
	(Parse_xml.extract "name"  >>= fun name  -> 
	 Parse_xml.extract "url"   >>= fun url   ->
	 Parse_xml.return {Tag.tag_name = name;Tag.tag_url = url})

let parse_tag_count =
	(parse_tag >>= fun tag ->
	 Parse_xml.extract "count" >>= fun count ->
	 Parse_xml.return (tag,int_of_string count))

let parseTopTags xml = 
	let parser data =
		let toptags_node = Parse_xml.find_first_node data "toptags" in
		Parse_xml.map_selective "tag" parse_tag_count toptags_node 
	in  
	Parse_xml.parse_response xml parser 

let getTopTags name connection =
	let xml = getTopTags_xml name connection in
	parseTopTags xml
	
let parse_images xml =
	let parse_image imagenode =
		let size = Xml.attrib imagenode "size" in
		try 
			let url = Parse_xml.extract_pcdata imagenode in
			Some {Lastfm_base.image_url = url;
		 	      Lastfm_base.image_size = size}
		with Failure _ ->
			None
	in
	let imageoptions = Parse_xml.map_selective "image" parse_image xml in
	List.fold_right (
		function
			Some image -> (fun images -> image::images)
		| None -> (fun images -> images))
		imageoptions []
		
let parse_artist =
	(Parse_xml.extract "name" >>= fun name ->
	 Parse_xml.extract_maybe "mbid" >>= fun mbid ->
	 Parse_xml.extract "url"  >>= fun url  ->
	 Parse_xml.extract "streamable" >>= fun streamable ->
	 parse_images >>= fun images ->
	 Parse_xml.return {artist_name   = name;
		       artist_mbid   = mbid;
			     artist_url    = url;
			     artist_images = images;
			     artist_streamable = (streamable = "1")})

let parse_artist_match =
	(parse_artist >>= fun artist ->
	 Parse_xml.extract "match" >>= fun mtch ->
	 Parse_xml.return (artist,float_of_string mtch))

let parseSimilar xml =
	let parser data = 
		let similarartists_node = Parse_xml.find_first_node data "similarartists" in
		Parse_xml.map_selective "artist" parse_artist_match similarartists_node
	in
	Parse_xml.parse_response xml parser 
	
	
let getSimilar name connection =
	let xml = getSimilar_xml name connection in
	parseSimilar xml


let getName artist =
	artist.artist_name
	
let getUrl artist =
	artist.artist_url
	
let isStreamable artist =
	artist.artist_streamable