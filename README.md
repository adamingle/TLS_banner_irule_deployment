# README

#### Modified from DevCentral, the All Mighty Jason Rahm : https://devcentral.f5.com/articles/rapid-irule-removal-via-tmsh-script

## PURPOSE
The purpose of these TCL scripts is to deploy/remove an irule "WS_TLS_banner_irule" from many, many F5 virtual-servers in one swoop.  Because iRules do not have the normal "add, delete, none, replace-all-with" options, the operation can be tricky.  It is necessary to read the virtual-server value to determine if there are any existing iRules or not.  If yes, preserve the existing and only modify the specified in the scripts.  This can be achieved by using the TCL: List Handling Commands - https://devcentral.f5.com/articles/irules-101-15-tcl-list-handling-commands
By creating a list and appending or removing specified iRule, the list can be re-applied using TMSH commands from the TCL script.

## REQUIREMENTS
Currently the code has very little error handling.  As such, any conflicting/existing profiles configured will cause the current script to bork and throw an error.  To eliminate this condition, I have sanitized my virtual-servers ahead of time.  No virtual servers have a stream or httpcompression profile.

Know VI.  If you don't, print this out and keep it handy: http://www.lagmonster.org/docs/vi.html

iRule desired to work with is already on the box in the proper partition.

## USAGE
1. Insert the scripts to the desired partition using the TMSH commands "edit cli script goforward_script.tcl" and "edit cli script backout_script.tcl"  Insert in the "proc script::run {}" section.  Do not remove the other sections or it will not save properly. (These commands are wrapped vi commands.  There is no other editior option like nano, etc.)
2. Run the command using "run cli script goforward_script.tcl"
3. If it bombs or you need to back-out run the back-out script using "run cli script backout_script.tcl"

Enjoy.
