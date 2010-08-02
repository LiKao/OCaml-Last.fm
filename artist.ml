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
	

let parseTopTags xml = 
	let tree = Parse_xml.make_tree xml in
	let tag_trees = Parse_xml.find_all [Parse_xml.Name "lfm"; 
			    	                          Parse_xml.Name "toptags";
																			Parse_xml.Name "tag" ] tree
	in
	let makeTag tree = 
		let tag_name_value = Parse_xml.find_all [Parse_xml.Name "name";
		                                         Parse_xml.AnyVal] tree in
    let tag_url_value = Parse_xml.find_all [Parse_xml.Name "url";
		                                         Parse_xml.AnyVal] tree in
    let tag_count_value = Parse_xml.find_all [Parse_xml.Name "count";
		                                         Parse_xml.AnyVal] tree in																																												
																						
		({Tag.tag_name = Parse_xml.extract_value tag_name_value;
		 Tag.tag_url = Parse_xml.extract_value tag_url_value},
		 int_of_string (Parse_xml.extract_value tag_count_value))
	in
	List.map makeTag tag_trees

let getTopTags name connection =
	let xml = getTopTags_xml name connection in
	parseTopTags xml
	
let parseSimilar xml =
	let tree = Parse_xml.make_tree xml in
	let artist_trees = Parse_xml.find_all [Parse_xml.Name "lfm";
	                                       Parse_xml.Name "similarartists";
																				 Parse_xml.Name "artist"] tree
  in
	let extract_artist_info artist_xml =
		let artist_name_value = Parse_xml.find_all [Parse_xml.Name "name";
		                                            Parse_xml.AnyVal] artist_xml in
		let artist_mbid_value = Parse_xml.find_all [Parse_xml.Name "mbid";
		                                            Parse_xml.AnyVal] artist_xml in
		let artist_url_value  = Parse_xml.find_all [Parse_xml.Name "url";
		                                            Parse_xml.AnyVal] artist_xml in
		let artist_streamable_value = Parse_xml.find_all [Parse_xml.Name "streamable";
		                                                  Parse_xml.AnyVal] artist_xml in
    let artist_images_values = Parse_xml.find_all [Parse_xml.Name "image"] in
		let artist_match_value = Parse_xml.find_all [Parse_xml.Name "match";
		                                             Parse_xml.AnyVal] artist_xml in
		let artist_mbid = 
			try Some (Parse_xml.extract_value artist_mbid_value)
			with Parse_xml.No_Value -> None
		in
		let artist_is_streamable = 
			(int_of_string (Parse_xml.extract_value artist_streamable_value)) != 0
		in
		({artist_name   = Parse_xml.extract_value artist_name_value;
		  artist_mbid   = artist_mbid;
			artist_url    = Parse_xml.extract_value artist_url_value;
			artist_images = [];
			artist_streamable = artist_is_streamable},
			float_of_string (Parse_xml.extract_value artist_match_value))
		in
		List.map extract_artist_info artist_trees
	
	
let getSimilar name connection =
	let xml = getSimilar_xml name connection in
	parseSimilar xml


let getName artist =
	artist.artist_name
	
let getUrl artist =
	artist.artist_url
	
let isStreamable artist =
	artist.artist_streamable