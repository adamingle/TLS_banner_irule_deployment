proc script::run {} {
if { $tmsh::argc != 2 } {
puts "A single rule name must be provided"
exit
}
set rulename [lindex $tmsh::argv 1]
set rules ""
set vips [tmsh::get_config /ltm virtual]
set vips_in_play ""
tmsh::begin_transaction
foreach vip $vips {
if { [tmsh::get_name $vip] contains "BGP" }{
if { [tmsh::get_field_value $vip "rules" rules] == 0 } {
continue
}
if { [lsearch -exact $rules $rulename] == -1 } {
continue
}
if { [llength $rules] < 2 } {
tmsh::modify /ltm virtual [tmsh::get_name $vip] rules none profiles delete "{" /Common/stream { } /Common/httpcompression { } "}"
lappend vips_in_play $vip
} else {
set id [lsearch -exact $rules $rulename]
set keepers [lreplace $rules $id $id]
tmsh::modify /ltm virtual [tmsh::get_name $vip] rules "{ $keepers }" profiles delete "{" /Common/stream { } /Common/httpcompression { } "}"
lappend vips_in_play $vip
}
}
}
tmsh::commit_transaction
puts "The $rulename iRule was removed from the following virtuals: "
foreach x $vips_in_play {
puts "\t[tmsh::get_name $x]"
}
}
