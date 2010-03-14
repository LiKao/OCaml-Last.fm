(*implemented methods:
Tag.getSimilar
Tag.getTopAlbums
Tag.getTopArtists
Tag.getTopTags
Tag.getTopTracks
Tag.getWeeklyArtistChart
Tag.getWeeklyChartList
Tag.search*)

type tag_id = string

type tag = {tag_name : string; tag_url : string}

let getName tag =
	tag.tag_name
	
let getUrl tag =
	tag.tag_url