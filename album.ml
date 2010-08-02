(* implemented methods:
Album.getInfo
Album.getTags
Album.search*)

(* not implemented write methods:
Album.addTags
Album.addTags
*)

open Lastfm_base

type album_id = {album_artist: string; album_name: string}

let album_id_to_param album_id = [("artist",album_id.album_artist);
                                  ("album",album_id.album_name)]
	

let getXXX_xml yyy album_id connection =
	xxxgetyyy_xml "album" yyy album_id album_id_to_param connection
	
let getInfo_xml name connection =
   getXXX_xml "Info" name connection
	
let getTags_xml name connection =
	getXXX_xml "Tags" name connection
	
let search name ?limit ?page connection =
	searchXXX "album" name ?limit ?page connection