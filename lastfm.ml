type debug_lvl =
   Error
|  Message
|  Warning
|  Notice
|  Signature
|  Url;;
let debug_lvl = ref[
   Error;
   Message;
   Warning;
   Notice;
   Signature;
   Url
   ];;
let printf_debug level a =
   if  List.mem level !debug_lvl  then
      Printf.printf a
   else
      Printf.ifprintf stdout a
   ;;

type connection = {key : string; 
				 secret : string;
			         session_key : string; 
				 conn : Curl.t};;
type call = string * string list;;

let basename = "http://ws.audioscrobbler.com/2.0/";;

let call_url connection url =
   let res = Buffer.create 64 in
   let wfun str = Buffer.add_string res str in
   Curl.set_url connection url;
   Curl.set_writefunction connection wfun;
   Curl.perform connection;
   Buffer.contents res;;

let get_sig call secret=
   let sorted_call = List.sort (fun (a,_) (b,_) -> compare a b) call in
   let callsign = List.fold_left (fun str (op,param) -> str ^ op ^ param) "" sorted_call in
   let fullsign = callsign ^secret in
   printf_debug Signature "The full signature is: %s\n" fullsign;
   Digest.to_hex (Digest.string fullsign);;

let make_call connection call secret = 
   printf_debug Notice "Making a call to the Lastfm service\n";
   let url = Printf.sprintf "%s?%sapi_sig=%s" basename   
      (List.fold_left (fun str (op,param) -> Printf.sprintf "%s%s=%s&" str op (Curl.escape param)) "" call)
      (get_sig call secret) 
   in
   printf_debug Url "The URL for this call is: %s\n" url;
   call_url connection url;;
	

let get_session_key conn key secret =
   printf_debug Message "Aquiring Lastfm-Token\n";
   let call = 
       [("method","auth.getToken");
	 ("api_key",key)]
   in
   let res_xml = make_call conn call secret in
   let res = Parse_xml.make_tree res_xml in
   let tokenval = Parse_xml.find_all [Parse_xml.Name "root"; 
                                                        Parse_xml.Name "lfm"; 
						        Parse_xml.Name "token";
                                       		        Parse_xml.Anyval] res 
   in
   let token = Parse_xml.get_value (List.hd tokenval) in
   printf_debug Message "Token aquired.\n The token is %s\n" token;
   Printf.printf "Please go to http://www.last.fm/api/auth/?api_key=%s&token=%s to authorize this application\n" key token;
   let _ = read_line () in
   let call = [("method","auth.getSession");
                    ("token",token);
		    ("api_key",key)]
   in
   let res_xml =make_call conn call secret in
   Printf.printf "%s" res_xml;
   let res = Parse_xml.make_tree res_xml in
   let session_key = Parse_xml.find_all [Parse_xml.Name "root"; 
                                                              Parse_xml.Name "lfm"; 
						              Parse_xml.Name "session";
							      Parse_xml.Name "key";
                                       		              Parse_xml.Anyval] res 
   in
   Parse_xml.get_value (List.hd session_key)
   
let init agent key secret ?session_key () =
   printf_debug Message "Initializing Lastfm service\n";
   printf_debug Message "Initializing Curl connection and setting user agent\n";
   let conn = Curl.init() in
   Curl.set_useragent conn agent;
   let session_key = 
      match session_key with 
         None -> get_session_key conn key secret
      |  Some key -> key
   in
   {key = key;
      secret = secret;
      session_key = session_key;
      conn = conn}


let call_method method_name params connection =
   let call = [("method",method_name)] @
                   params @
		   [("api_key",connection.key);
		    ("sk",connection.session_key)]
   in
   make_call connection.conn call connection.secret


let artist_getXXX_xml xxx artist_name connection =
   let params = [("artist",artist_name)] in
   call_method ("artist.get" ^ xxx) params connection

let artist_getTags_xml =
   artist_getXXX_xml "Tags"
   
let artist_getInfo_xml =
   artist_getXXX_xml "Info"
   
let artist_getTopTags_xml =
   artist_getXXX_xml "TopTags"

let artist_getSimilar_xml =
   artist_getXXX_xml "Similar" 