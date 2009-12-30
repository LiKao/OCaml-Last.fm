type xml_tree = 
   Value of string
|  Node of string * (string * string) list * xml_tree list

type specifier = 
   Name of string
|  AnyNode
|  AnyVal

let make_tree xml =
   (* we walk the xml tree and construct all nodes we encounter.
       Once a node is finished it is incorparated into the parent node *)
   let branches = ref [Node ("root",[],[])] in
   let start_element_handler name values = 
      (*creates a new node branche and adds it to the stack*)
      let branch = Node (name,values,[]) in
      branches := branch :: !branches
   in
   let end_element_handler name =
      (* takes the current node from the stack and adds it to the children of the parent *)
      let curr = List.hd !branches in
      let parent = List.hd (List.tl !branches) in
      let rest = List.tl (List.tl !branches) in
      match parent with
         Node (name,values,childs) -> 
	       let childs = List.rev (curr :: (List.rev childs)) in
	       branches := (Node (name,values,childs)) :: rest
	| _ -> failwith "Parent is Data instead of Node"
   in
   let char_data_handler value =
      (* creates a cdata value branch.
	  This type of branch needs no processing and
	  can directly be added to parent*)
      let cdata = Value value in
      let parent = List.hd !branches in
      let rest = List.tl !branches in
      match parent with
         Node (name,values,childs) -> 
	       let childs = List.rev (cdata :: (List.rev childs)) in
	       branches := (Node (name,values,childs)) :: rest
	| _ -> failwith "Parent is Data instead of Node"
   in
   let parser = Expat.parser_create ~encoding:None in
   Expat.set_start_element_handler parser start_element_handler;
   Expat.set_end_element_handler parser end_element_handler;
   Expat.set_character_data_handler parser char_data_handler;
   Expat.parse parser xml;
   Expat.final parser;
   List.hd !branches
   
let is_node branch =
   match branch with
      Node _ -> true
   | _ -> false
   
let get_node_name branch =
   match branch with
      Node (name,_,_) -> name
   |   _ -> failwith "get_node_name called on a value"
   
let get_value branch =
   match branch with
      Node _ -> failwith "get_value called on a node"
   |  Value v ->  v

let match_specifier spec branch =
   match spec with
      Name name -> is_node branch && 
                               let bname = get_node_name branch in
                               (compare bname name == 0)
    | AnyNode -> is_node branch
    | AnyVal -> not (is_node branch)
   
let rec find_all path tree =
   match path with
      [] -> [tree]
   |  spec :: rest ->
				begin
					match tree with
						Node (_,_,childs) -> 
							let matched = List.filter (match_specifier spec) childs in
							List.concat (List.map (find_all rest) matched)
					| Value  _ -> []
				end

exception No_Value

let extract_value valueList =
	match valueList with
		value :: rest -> get_value value
	| [] -> raise No_Value
	