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
if { [tmsh::get_field_value $vip "rules" rules] != 0 } {
set addrule [concat $rules $rulename ]
tmsh::modify /ltm virtual [tmsh::get_name $vip] rules "{ $addrule }" profiles add "{" /Common/stream { } /Common/httpcompression { } "}"
lappend vips_in_play $vip
}
else {
tmsh::modify /ltm virtual [tmsh::get_name $vip] rules { WS_TLS_banner_irule } profiles add "{" /Common/stream { } /Common/httpcompression { } "}"
lappend vips_in_play $vip
}
}
}
tmsh::commit_transaction
puts "The $rulename iRule was added to the following virtuals: "
foreach x $vips_in_play {
puts "\t[tmsh::get_name $x]"
}
}
