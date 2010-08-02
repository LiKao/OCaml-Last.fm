(** OCaml API to the Last.fm functions*)

(** {1 global functions}*)
(*******************************************************************)

exception Lastfm_error of (int * string) 

(** Type to identify connections to the Lastfm service *)
type 'a t 
val init : string -> string -> string -> [`Unauthorized] t
val authorize : 'a t -> string -> [`Authorized] t

module Types : sig
	type artist = {
			artist_name   : string;
			artist_mbid   : Lastfm_base.mbid option;
			artist_url    : string;
			artist_images : Lastfm_base.image list;
			artist_streamable : bool}
			
	type tag = {tag_name : string; tag_url : string}
end

module Album : sig
		
	(** {1 Access to the Last.fm album.* functions}*)

	type album_id = {album_artist: string; album_name: string}
	(** type of album Identifiers *)

	(*******************************************************************)
	(** {2 direct access}*)
	(** Functions to access unparsed XML data from the Last.fm service *)
	(*******************************************************************)

	val getInfo_xml : album_id -> 'a t -> string
	(** Get all information about an album.

	Information includes name of album and artist, number of listeners,
	tags and images.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<album>
		  <name>Believe</name>
		  <artist>Cher</artist>
		  <id>2026126</id>
		  <mbid>61bf0388-b8a9-48f4-81d1-7eb02706dfb0</mbid>
		  <url>http://www.last.fm/music/Cher/Believe</url>
		  <releasedate>    6 Apr 1999, 00:00</releasedate>
		  <image size="small">...</image>
		  <image size="medium">...</image>
		  <image size="large">...</image>
		  <listeners>47602</listeners>
		  <playcount>212991</playcount>
		  <toptags>
		    <tag>
		      <name>pop</name>
		      <url>http://www.last.fm/tag/pop</url>
		    </tag>
		    ...
		  </toptags>
		</album>]}*)
	
	val getTags_xml : album_id -> [`Authorized] t -> string
	(** Get all user tags for an album.

	Information includes name of album and artist, number of listeners,
	tags and images.

	{b Authentication required.}
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<tags artist="Sally Shapiro" album="Disco Romance">
		  <tag>
		    <name>swedish</name>
		    <url>http://www.last.fm/tag/swedish</url>
		  </tag>
		  ...
		</tags>]}*)
	
	val search : string -> ?limit:int -> ?page:int -> 'a t -> string
	(** Search for an album.

	Authentication {b not} required. 
	@param limit the number of results per page (maximum 20)
	@param page number of the page that is returned
	
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<results for="cher" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
		  <opensearch:Query role="request" searchTerms="cher" startPage="1"/>
		  <opensearch:totalResults>386</opensearch:totalResults>
		  <opensearch:startIndex>0</opensearch:startIndex>
		  <opensearch:itemsPerPage>20</opensearch:itemsPerPage>
		  <artistmatches>
		    <artist>
		      <name>Cher</name>
		      <mbid>bfcc6d75-a6a5-4bc6-8282-47aec8531818</mbid>
		      <url>www.last.fm/music/Cher</url>
		      <image_small>http://userserve-ak.last.fm/serve/50/342437.jpg</image_small>
		      <image>http://userserve-ak.last.fm/serve/160/342437.jpg</image>
		      <streamable>1</streamable>
		    </artist>
			...
		  </artistmatches>
		</results>]}*)
		
end

module Artist : sig
	(** {1 Access to the Last.fm artist.* functions}*)

	type artist_id = string
	(** Type of artist identifiers *)

	type artist = Types.artist

	val getSimilar : string -> 'a t -> (Types.artist * float) list
	val getTopTags : string -> 'a t -> (Types.tag * int) list

	(*******************************************************************)
	(** {2 direct access}*)
	(** Functions to access unparsed XML data from the Last.fm service *)
	(*******************************************************************)

	val getEvents_xml : artist_id -> 'a t -> string
	(** Get information about upcomming events for an artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<events artist="Cher" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" total="4">
		<event>
		    <id>599858</id>
		  <title>Cher</title>
		  <artists>
		    <artist>Cher</artist>
		    <headliner>Cher</headliner>
		  </artists>
		  <venue>
		    <name>The Colosseum at Caesars Palace</name>
		    <location>
		      <city>Las Vegas</city>
		      <country>United States</country>
		      <street></street>
		      <postalcode></postalcode>
		      <geo:point>
		         <geo:lat>36.2265501474709</geo:lat>
		         <geo:long>-115.0048828125</geo:long>
		      </geo:point>
		      <timezone>PST</timezone>
		     </location>
		    <url>http://www.last.fm/venue/8841108</url>
		  </venue>
		  <startDate>Sat, 16 Aug 2008</startDate>
		  <startTime>19:30</startTime>
		  <description></description>
		  <image size="small">...</image>
		  <image size="medium">...</image>
		  <image size="large">...</image>
		  <attendance>42</attendance>
		  <reviews>0</reviews>
		  <tag>lastfm:event=669027</tag>
		  <url>http://www.last.fm/event/599858</url>
		  <website>http://...</website>
		  <tickets>
		    <ticket supplier="...">http://...</ticket>
		    ...
		  </tickets>
		</event>
		...
		</events>]}*)
	
	val getImages_xml : artist_id -> 'a t -> string
	(** Get images for a given Artist.

	Returns adresses available Images in various sizes.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<images artist="Cher" page="1" totalpages="4" total="174">
		  <image>
		    <title/>
		    <url>http://www.last.fm/music/Cher/+images/340992</url>
		    <dateadded>Sun, 27 May 2007 20:21:51</dateadded>
		    <format>jpg</format>
		    <owner type="user">
		      <name>Fluchi</name>
		      <url>http://www.last.fm/user/Fluchi</url>
		    </owner>
		    <sizes>
		      <size name="original" width="900" height="1553">
		        http://userserve-ak.last.fm/serve/_/340992/Cher.jpg
		      </size>
		      <size name="large" width="126" height="217">http://....jpg</size>
		      <size name="largesquare" width="126" height="126">http://....jpg</size>
		      <size name="medium" width="64" height="110">http://....jpg</size>
		      <size name="small" width="34" height="59">http://....jpg</size>
		    </sizes>
		    <votes>
		      <thumbsup>67</thumbsup>
		      <thumbsdown>31</thumbsdown>
		    </votes>
		  </image>
		  <image>
		  ..
		</images>]}*)
		
	val getInfo_xml : artist_id -> 'a t -> string
	(** Get complete information for an artist.

	Information includes biography, images, similar artists, tags and statistics.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<artist>
		  <name>Cher</name>
		  <mbid>bfcc6d75-a6a5-4bc6-8282-47aec8531818</mbid>
		  <url>http://www.last.fm/music/Cher</url>
		  <image size="small">http://userserve-ak.last.fm/serve/50/285717.jpg</image>
		  <image size="medium">http://userserve-ak.last.fm/serve/85/285717.jpg</image>
		  <image size="large">http://userserve-ak.last.fm/serve/160/285717.jpg</image>
		  <streamable>1</streamable>
		  <stats>
		    <listeners>196440</listeners>
		    <plays>1599101</plays>
		  </stats>
		  <similar>
		    <artist>
		      <name>Madonna</name>
		      <url>http://www.last.fm/music/Madonna</url>
		      <image size="small">http://userserve-ak.last.fm/serve/50/5112299.jpg</image>
		      <image size="medium">http://userserve-ak.last.fm/serve/85/5112299.jpg></image>
		      <image size="large">http://userserve-ak.last.fm/serve/160/5112299.jpg</image>
		    </artist>
		    ...
		  </similar>
		  <tags>
		    <tag>
		      <name>pop</name>
		      <url>http://www.last.fm/tag/pop</url>
		    </tag>
		    ...
		  </tags>
		  <bio>
		    <published>Thu, 13 Mar 2008 03:59:18 +0000</published>
		    <summary>...</summary>
		    <content>...</content>
		  </bio>
		</artist>]}*)
	
	val getPastEvents_xml : artist_id -> 'a t -> string
	(** Get past events an artist has done.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<events artist="Cher" url="http://www.last.fm/music/Cher/+events" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" page="1" perPage="50" total="41" totalPages="1">
		    <event xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
		        <id>1196301</id>
		        <title>pRIvate</title>
		        <artists>
		            <artist>CSS</artist>
		            <artist>Madonna</artist>
		            <artist>Britney Spears</artist>
		            <artist>Lady GaGa</artist>
		            <artist>Cher</artist>
		            <artist>RuPaul</artist>
		            <headliner>CSS</headliner>
		        </artists>
		        <venue>
		            <id>9064369</id>
		            <name>Berlusconni´s</name>
		            <location>
		                <city>São Paulo</city>
		                <country>Brazil</country>
		                <street></street>
		                <postalcode></postalcode>
		                <geo:point>
		                    <geo:lat>-23.5576930875657</geo:lat>
		                    <geo:long>-46.669921875</geo:long>
		                </geo:point>
		            </location>
		            <url>http://www.last.fm/venue/9064369+Berlusconni%C2%B4s</url>
		            <website></website>
		            <phonenumber></phonenumber>
		            <image size="small"></image>
		            <image size="medium"></image>
		            <image size="large"></image>
		            <image size="extralarge"></image>
		            <image size="mega"></image>
		        </venue>
		        <startDate>Fri, 28 Aug 2009 04:42:01</startDate>
		        <description><![CDATA[<div class="bbcode">Rua Nestor Pestana, 189</div>]]></description>
		        <image size="small">http://userserve-ak.last.fm/serve/34/8834875.jpg</image>
		        <image size="medium">http://userserve-ak.last.fm/serve/64/8834875.jpg</image>
		        <image size="large">http://userserve-ak.last.fm/serve/126/8834875.jpg</image>
		        <image size="extralarge">http://userserve-ak.last.fm/serve/252/8834875.jpg</image>
		        <attendance>1</attendance>
		        <reviews>0</reviews>
		        <tag>lastfm:event=1196301</tag>    
		        <url>http://www.last.fm/event/1196301+pRIvate</url>
		        <website></website>
		        <tickets></tickets>
		        <cancelled>0</cancelled>
		  </event>
		</events>]}*)
		
	val getPodcast_xml : artist_id -> 'a t -> string
	(** Get information about free podcasts and mp3s from an artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
		<channel>
		  <title>Free pornophonique MP3s</title>
		  <link>http://www.last.fm/music/pornophonique</link>
		  <description>Free pornophonique MP3s from Last.fm</description>
		  <item>
		    <title>pornophonique - Rock'n'roll Hall Of Fame</title>
		    <guid isPermaLink="false">http://www.last.fm/music/pornophonique/_/Rock%27n%27roll+Hall+Of+Fame</guid>
		    <itunes:author>pornophonique</itunes:author>
		    <enclosure url="http://freedownloads.last.fm/download/120677617/Rock%2527n%2527roll%2BHall%2BOf%2BFame.mp3" length="3872000" type="audio/mpeg" />
		    <description>pornophonique - Rock'n'roll Hall Of Fame (4:02) 3.7 MB</description>
		    <link>http://www.last.fm/music/pornophonique/_/Rock%27n%27roll+Hall+Of+Fame</link>
		  </item>
		  <item>
		    <title>pornophonique - 1/2 player game</title>
		    <guid isPermaLink="false">http://www.last.fm/music/pornophonique/_/1%252F2%2Bplayer%2Bgame</guid>
		    <itunes:author>pornophonique</itunes:author>
		    <enclosure url="http://freedownloads.last.fm/download/113567641/1%252F2%2Bplayer%2Bgame.mp3" length="3664000" type="audio/mpeg" />
		    <description>pornophonique - 1/2 player game (3:49) 3.5 MB</description>
		    <link>http://www.last.fm/music/pornophonique/_/1%252F2%2Bplayer%2Bgame</link>
		  </item>
		</channel>]}*)
	
	val getShouts_xml : artist_id -> 'a t -> string
	(** Get shouts for an artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<shouts artist="Cher" total="495">
		  <shout>
		    <body>Blah</body>
		    <author>joanofarctan</author>
		    <date>Fri, 12 Dec 2008 13:20:41</date>
		  </shout>
		  ...
		</shouts>]}*)
	
	val getSimilar_xml : artist_id -> 'a t -> string
	(** Get a list of artists similar to a given artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<similarartists artist="kid606" streamable="1">
			<artist>
				<name>Venetian Snares</name>
				<mbid>56abaa47-0101-463b-b37e-e961136fec39</mbid>
				<match>100</match>
				<url>/music/Venetian+Snares</url>
				<image>http://userserve-ak.last.fm/serve/160/211799.jpg</image>
			</artist>
		        <artist>
		...]}*)
	
	val getTags_xml : artist_id -> [`Authorized] t -> string
	(** Get tags assigned to an artist by the current user.

	{b Authentication required.}
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<tags artist="Sally Shapiro">
		  <tag>
		    <name>italo</name>
		    <url>http://www.last.fm/tag/italo</url>
		  </tag>
		  ...
		</tags>]}*)
	
	val getTopAlbums_xml : artist_id -> 'a t -> string
	(** Get the top albums of an artist. Sorted by popularity.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<topalbums artist="Cher">
		  <album rank="1">
		    <name>Believe</name>
		    <mbid>61bf0388-b8a9-48f4-81d1-7eb02706dfb0</mbid>
		    <listeners>24486</listeners>
		    <url>http://www.last.fm/music/Cher/Believe</url>
		    <image size="small">...</image>
		    <image size=" medium">...</image>
		    <image size="large">...</image>
		  </album>
		  ...
		</topalbums>]}*)
	
	val getTopFans_xml : artist_id -> 'a t -> string
	(** Get the top fans, based on listening behaviour.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<topfans artist="Cher">
		  <user>
		    <name>Haldeth</name>
		    <url>http://www.last.fm/user/Haldeth/</url>
		    <image size="small">http://userserve-ak.last.fm/serve/50/2032958.gif</image>
		    <image size="medium">http://userserve-ak.last.fm/serve/85/2032958.gif</image>
		    <image size="large">http://userserve-ak.last.fm/serve/160/2032958.gif</image>
		    <weight>114242000</weight>
		  </user>
		  ...
		</topfans>]}*)
	
	val getTopTags_xml : artist_id -> 'a t -> string
	(** Get the top Tags for an artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<toptags artist="Cher">
		  <tag>
		    <name>pop</name>
		    <url>http://www.last.fm/tag/pop</url>
		  </tag>
		  ...
		</toptags>]}*)
	
	val getTopTracks_xml : artist_id -> 'a t -> string
	(** Get the most popular tracks of an artist.

	Authentication {b not} required.
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<toptracks artist="Cher">
		  <track rank="1">
		    <name>Believe</name>
		    <mbid/>
		    <playcount>56325</playcount>
		    <listeners>23217</listeners>
		    <url>http://www.last.fm/music/Cher/_/Believe</url>
		    <image size="small">...</image>
		    <image size=" medium">...</image>
		    <image size="large">...</image>
		  </track>
		  ...
		</toptracks>]}*)	
		
	val search : string -> ?limit:int -> ?page:int -> 'a t -> string
	(** Search for an artist.

	Authentication {b not} required. 
	@param limit the number of results per page (maximum 20)
	@param page number of the page that is returned
	
	@return A string with the last.fm xml-data
	
	Sample respone:
	{[
		<results for="cher" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
		  <opensearch:Query role="request" searchTerms="cher" startPage="1"/>
		  <opensearch:totalResults>386</opensearch:totalResults>
		  <opensearch:startIndex>0</opensearch:startIndex>
		  <opensearch:itemsPerPage>20</opensearch:itemsPerPage>
		  <artistmatches>
		    <artist>
		      <name>Cher</name>
		      <mbid>bfcc6d75-a6a5-4bc6-8282-47aec8531818</mbid>
		      <url>www.last.fm/music/Cher</url>
		      <image_small>http://userserve-ak.last.fm/serve/50/342437.jpg</image_small>
		      <image>http://userserve-ak.last.fm/serve/160/342437.jpg</image>
		      <streamable>1</streamable>
		    </artist>
			...
		  </artistmatches>
		</results>]}*)
		
		val parseSimilar : string -> (Types.artist * float) list
		val parseTopTags : string -> (Types.tag * int) list
		
		val getName : artist -> string	
		val getUrl : artist -> string
		val isStreamable : artist -> bool
end

module Event : sig
	type event_id = int

	val getAttendees_xml : int -> 'a t -> string
	val getInfo : int -> 'a t -> string
	val getShouts : int -> 'a t -> string
end

module Geo : sig
	type geoPos = { latitude : float; longitude : float; }
	type geo_id = Name of string | Pos of geoPos
	
	type metro_id = { metro_country : string; metro : string; }
	
	type time_range = { start_time : float; end_time : float; }
	
	val getEvents_xml :
	  geo_id -> ?page:int -> ?distance:float -> 'a t -> string
	
	val getMetroArtistChart_xml :
	  metro_id -> ?range:time_range -> 'a t -> string
	val getMetroTrackChart_xml :
	  metro_id -> ?range:time_range -> 'a t -> string
	val getMetroUniqueArtistChart_xml :
	  metro_id -> ?range:time_range -> 'a t -> string
	val getMetroUniqueTrackChart_xml :
	  metro_id -> ?range:time_range -> 'a t -> string
	val getMetroWeeklyChartlist_xml : 'a t -> string
end

module Tag : sig
	type tag = Types.tag
	val getName : tag -> string
	val getUrl : tag -> string
end
