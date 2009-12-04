(* implemented methods:
Artist.addTags
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
Artist.removeTag
Artist.search
Artist.share
Artist.shout*)

open Lastfm

let getXXX_xml xxx artist_name connection =
   let params = [("artist",artist_name)] in
   call_method ("artist.get" ^ xxx) params connection

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