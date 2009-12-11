(*implemented methods:
Geo.getEvents
Geo.getMetroArtistChart
Geo.getMetroTrackChart
Geo.getMetroUniqueArtistChart
Geo.getMetroUniqueTrackChart
Geo.getMetroWeeklyChartlist
Geo.getTopArtists
Geo.getTopTracks*)

open Base

type geoPos = {latitude: float; longitude: float}

type geo_id =
	Name of string
| Pos of geoPos


let geo_id_to_param geo_id =
	match geo_id with
		Name name -> ["location",name]
	| Pos geoPos -> [("lat", string_of_float geoPos.latitude);
						       ("long", string_of_float geoPos.longitude)]

type metro_id = {metro_country: string; metro: string}

let metro_id_to_param metro_id =
	[("country",metro_id.metro_country);
	 ("metro",metro_id.metro)]
	
type time_range = {start_time: float; end_time: float}

let time_range_to_param time_range =
	[("start", string_of_float time_range.start_time);
	 ("end", string_of_float time_range.end_time)]
	
let getXXX_pos_xml yyy geo_id ?extra connection =
	xxxgetyyy_xml "geo" yyy geo_id geo_id_to_param ?extra connection
	
let getEvents_xml geo_id ?page ?distance connection =
	let extra = 
		begin
			match page with
				None -> []  
			|	Some page -> ["page",string_of_int page]
		end @
		begin
			match distance with
				None -> []  
			|	Some distance -> ["distance",string_of_float distance]
		end
	in
	getXXX_pos_xml "Events" ~extra geo_id connection
	
let getXXX_metro_xml yyy metro_id ?range connection =
	let extra =
		match range with
			None -> []
		| Some range -> time_range_to_param range
	in
	xxxgetyyy_xml "geo" yyy metro_id metro_id_to_param ~extra connection
	
let getMetroArtistChart_xml metro_id ?range connection =
	getXXX_metro_xml "MetroArtistChart" metro_id ?range connection
	
let getMetroTrackChart_xml metro_id ?range connection =
	getXXX_metro_xml "MetroTrackChart" metro_id ?range connection
	
let getMetroUniqueArtistChart_xml metro_id ?range connection =
	getXXX_metro_xml "MetroUniqueArtistChart" metro_id ?range connection
	
let getMetroUniqueTrackChart_xml metro_id ?range connection =
	getXXX_metro_xml "MetroUniqueTrackChart" metro_id ?range connection

let getMetroWeeklyChartlist_xml connection =
	call_method "getMetroWeeklyChartlist" [] connection
	 