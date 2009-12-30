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

open Base

type artist_id = string

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
	

let getTopTags name connection =
	let xml = getTopTags_xml name connection in
	let tree = Parse_xml.make_tree xml in
	let tag_trees = Parse_xml.find_all [Parse_xml.Name "lfm"; 
			    	                          Parse_xml.Name "toptags";
																			Parse_xml.AnyNode ] tree
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
  		 
	