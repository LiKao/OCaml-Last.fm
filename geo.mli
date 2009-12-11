type geoPos = { latitude : float; longitude : float; }
type geo_id = Name of string | Pos of geoPos

type metro_id = { metro_country : string; metro : string; }

type time_range = { start_time : float; end_time : float; }

val getEvents_xml :
  geo_id -> ?page:int -> ?distance:float -> 'a Base.t -> string

val getMetroArtistChart_xml :
  metro_id -> ?range:time_range -> 'a Base.t -> string
val getMetroTrackChart_xml :
  metro_id -> ?range:time_range -> 'a Base.t -> string
val getMetroUniqueArtistChart_xml :
  metro_id -> ?range:time_range -> 'a Base.t -> string
val getMetroUniqueTrackChart_xml :
  metro_id -> ?range:time_range -> 'a Base.t -> string
val getMetroWeeklyChartlist_xml : 'a Base.t -> string
