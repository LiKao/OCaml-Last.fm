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

exception Lastfm_error of (int * string) 

type connection =
	{user_agent : string;
	 pipeline : Http_client.pipeline}

type 'a t = 
	{key : string; 
	 secret : string;
	 session_key : string option; 
	 connection : connection}

type mbid = string;;

type param = (string * string) list

let basename = "http://ws.audioscrobbler.com/2.0/";;

let call_url connection url =
	let call = new Http_client.get url in
	let headers = call#request_header `Base in
	headers#update_field "User-agent" connection.user_agent;
	headers#update_field "Expect" "100-continue";
	connection.pipeline#add call;
	connection.pipeline#run ();
	call#response_body#value

let get_sig call secret=
  let sorted_call = List.sort (fun (a,_) (b,_) -> compare a b) call in
  let callsign = List.fold_left 
										(fun str (op,param) -> Printf.sprintf "%s%s%s" str op param) 
										"" 
										sorted_call 
	in
  let fullsign = callsign ^secret in
  printf_debug Signature "The full signature is: %s\n" fullsign;
  Digest.to_hex (Digest.string fullsign);;

let make_call connection call secret = 
   printf_debug Notice "Making a call to the Lastfm service\n";
	 flush stdout;
   let url = Printf.sprintf "%s?%sapi_sig=%s" basename   
      (List.fold_left (fun str (op,param) -> Printf.sprintf "%s%s=%s&" str op (Netencoding.Url.encode param)) "" call)
      (get_sig call secret) 
   in
   printf_debug Url "The URL for this call is: %s\n" url;
	 flush stdout;
   let res = call_url connection url in
	 printf_debug Notice "Call succeeded\n";
	 flush stdout;
	 res;;
(*
 (* Legacy stuff to be rewritten *)
let get_session_key conn key secret =
	printf_debug Message "Aquiring Lastfm-Token\n";
	let call = 
		[("method","auth.getToken");
	 	 ("api_key",key)]
	in
	let res_xml = make_call conn call secret in
	let res = Parse_xml.make_tree res_xml in
	let tokenval = Parse_xml.find_all [Parse_xml.Name "lfm"; 
						                         Parse_xml.Name "token";
                                     Parse_xml.AnyVal] res 
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
  let session_key = Parse_xml.find_all [Parse_xml.Name "lfm"; 
						              							Parse_xml.Name "session";
							      										Parse_xml.Name "key";
                                       	Parse_xml.AnyVal] res 
	in
  Parse_xml.get_value (List.hd session_key)
*)
 
let init agent key secret =
	printf_debug Message "Initializing Lastfm service\n";
	let connection = {
		user_agent = agent;
		pipeline = new Http_client.pipeline}
	in
  {key = key;
   secret = secret;
   session_key = None;
   connection = connection}

let authorize connection session_key =
	  {connection with session_key = Some session_key}
  	
let call_method method_name params connection =
   let call = [("method",method_name)] @
               params @
		   				[("api_key",connection.key)] @
							match connection.session_key with
								Some sk -> [("sk",sk)]
							| None -> []
   in
   make_call connection.connection call connection.secret
	
let xxxgetyyy_xml xxx yyy id id_to_param ?extra connection =
  let params = id_to_param id in
	let extra_params =
		match extra with
			None -> []
		| Some extra_params -> extra_params
	in
  call_method (xxx ^ ".get" ^ yyy) (params @ extra_params) connection
	
let searchXXX xxx name ?limit ?page connection =
	let limit_param = 
		match limit with 
		None -> []
	| Some limit -> [("limit",Printf.sprintf "%i" limit)]
	in
	let page_param =
		match page with
			None -> []
		| Some page -> [("page",Printf.sprintf "%i" page)]
	in
	let params = [(xxx,name)] @ 
	              limit_param @ 
							  page_param 
	in
	call_method (xxx ^ ".search") params connection
	
type image = {image_url : string; image_size : string} 