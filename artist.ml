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

let getEvents_xml =
	getXXX_xml "Events"
	
let getImages_xml =
	getXXX_xml "Images"

let getInfo_xml =
   getXXX_xml "Info"
	
let getPastEvents_xml =
	getXXX_xml "PastEvents"
	
let getPodcast_xml =
	getXXX_xml "Podcast"
	
let getShouts_xml =
	getXXX_xml "Shouts"

let getSimilar_xml =
	getXXX_xml "Similar"
 
let getTags_xml =
	getXXX_xml "Tags"
	
let getTopAlbums_xml =
	getXXX_xml "TopAlbums"

let getTopFans_xml =
	getXXX_xml "TopFans"
	
let getTopTags_xml =
	getXXX_xml "TopTags"

let getTopTracks_xml =
	getXXX_xml "TopTracks"


   

   




