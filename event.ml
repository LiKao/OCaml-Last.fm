(*implemented methods:
Event.getAttendees
Event.getInfo
Event.getShouts
*)

(* not implemented write methods:
Event.attend
Event.share
Event.shout
*)

open Base

type event_id = int

let event_id_to_param event_id = [("artist",string_of_int event_id)] 

let getXXX_xml yyy event_id connection =
	xxxgetyyy_xml "event" yyy event_id event_id_to_param connection
	
let getAttendees_xml event_id connection =
	getXXX_xml "Attendees" event_id connection
	
let getInfo event_id connection =
	getXXX_xml "Info" event_id connection 

let getShouts event_id connection =
	getXXX_xml "Shouts" event_id connection