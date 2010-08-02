let parser = XmlParser.make ()

exception Lastfm_error of (int * string) 

let make_tree str=
	let xml = XmlParser.SString str in
	XmlParser.parse parser xml
	
let find_nodes children name =
	let predicate node =
		try 
			Xml.tag node = name
		with Xml.Not_element _ ->
			false
	in
	List.filter predicate children
	
let find_first_node children name =
	List.hd (find_nodes children name)
	
let extract_pcdata node =
	Xml.pcdata (List.hd (Xml.children node))
	
let map_selective name f tree =
	let nodes = find_nodes (Xml.children tree) name in
	List.map f nodes
	
let extract name tree = 
	let nodedata = Xml.children tree in
	extract_pcdata (find_first_node nodedata name)
	
let extract_maybe name tree =
	try 
		let v = extract name tree in
		Some v
	with Failure _ ->
		None 
	
let (>>=) (m : Xml.xml -> 'a) f =
	fun xml -> f (m xml) xml
	
let return res =
	fun xml -> res
		
let rec parse_error error = 
	assert ((Xml.tag error) = "error");
	let code = int_of_string (Xml.attrib error "code") in
	let message = Xml.pcdata (List.hd (Xml.children error)) in  
  (code,message)
	
let parse_response str f =
	let tree = make_tree str in
	assert ((Xml.tag tree) = "lfm");
	if not ((Xml.attrib tree "status") = "ok") then
		let error = find_first_node (Xml.children tree) "error" in
		raise (Lastfm_error (parse_error error))
	else
	f (Xml.children tree)
	
	