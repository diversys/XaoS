global f
global tmpglobal
global cmdxaos

proc changecoloring { cmd a } {
global f
puts $f "($cmd $a)"
puts $a
flush $f
}

proc changefilter { type } {
global f
puts $f "(filter $type)"
flush $f
}

proc changeformula { type } {
global f
puts $f "(formula '$type)"
flush $f
}
proc byebye {  } {
global f
puts $f "(quit)"
flush $f
eval exec "/bin/rm -f /tmp/xaos[pid].txt"
after 100 {
exit }
}
proc sendcmd { cmd }  {
global f
puts $f "($cmd)"
flush $f
}
proc sendint { cmd entier}  {
global f
puts $f "($cmd $entier)"
flush $f
}
proc GetInt { var fr t }  {
global f
global tmpglobal
global cmdxaos
toplevel .getstr
global titreassist
global nb_ecran
#set tmpglobal ""
set tmpglobal $var
scale .getstr.s1 -variable entier -orient horizontal -from $fr -to $t
pack .getstr.s1
button .getstr.bok -text "Ok" -command {
		global f
		puts "($tmpglobal $entier)"
		puts $f "($tmpglobal $entier)"
		flush $f
                destroy .getstr }
button .getstr.bclose -text "Cancel" -command "destroy .getstr"
button .getstr.bhelp -text "Help" -command "destroy .getstr"
pack .getstr.bok .getstr.bclose .getstr.bhelp -side left

after 100 {
    grab .getstr }

}
proc GetStr { var }  {
global f
global tmpglobal
global cmdxaos
toplevel .getstr
global titreassist
global nb_ecran
set str ""
set tmpglobal $var
entry .getstr.e1 -textvariable str
pack .getstr.e1
button .getstr.bok -text "Ok" -command "destroy .getstr"
button .getstr.bclose -text "Cancel" -command "destroy .getstr"
button .getstr.bhelp -text "Help" -command "destroy .getstr"
pack .getstr.bok .getstr.bclose .getstr.bhelp -side left

after 100 {
    grab .getstr }

bind .getstr.e1  <Return> {
		global f
		puts "($tmpglobal \"$str\")"
		puts $f "($tmpglobal \"$str\")"
		flush $f
                destroy .getstr }
}
proc GetCommand { }  {
global f
global tmpglobal
global cmdxaos
toplevel .getstr
global titreassist
global nb_ecran
set str ""
entry .getstr.e1 -textvariable str
pack .getstr.e1
button .getstr.bok -text "Ok" -command "destroy .getstr"
button .getstr.bclose -text "Cancel" -command "destroy .getstr"
button .getstr.bhelp -text "Help" -command "destroy .getstr"
pack .getstr.bok .getstr.bclose .getstr.bhelp -side left

after 100 {
    grab .getstr }

bind .getstr.e1  <Return> {
		global f
		puts "($str)"
		puts $f "($str)"
		flush $f
                destroy .getstr }
}


proc fileselection { var cmd } {
global f
set $var [tk_getOpenFile -parent .]
puts $f "($cmd \"$var\")"
flush $f
}

wm title . "XaoS Menu"
wm iconname . "menu"


frame .menu -relief raised -bd 2
pack .menu -side top -fill x

label .msg  -justify left -text "Xaos Menu"
pack .msg -side top

frame .buttons
pack .buttons -side bottom -fill x -pady 2m
button .buttons.init -text "Init state" -command "sendcmd initstate "
button .buttons.load -text Load -command "fileselection loadpos loadpos "
button .buttons.save -text Save -command "fileselection save {} "
button .buttons.dismiss -text Exit -command "byebye"
pack .buttons.init .buttons.load .buttons.save  .buttons.dismiss  -side left -expand 1

canvas .thedisp -width 320 -height 200
pack .thedisp
set thewindowid [winfo id .thedisp]
update



set m .menu.file.m
menubutton .menu.file -text "File" -menu $m -underline 0
menu $m
$m add command -label "Load" -command "fileselection load loadpos "
$m add command -label "Save" -command "fileselection sauve savepos"
$m add command -label "Record {}" 
$m add command -label "Replay {} " 
$m add separator
$m add command -label "Save png" -command "fileselection sauvepng saveimg"
$m add command -label "Load random example "  -command "sendcmd loadexample"
$m add command -label "Save configuration "  -command "sendcmd  savecfg"
$m add separator
$m add command -label "Quit" -command "exit"

set m .menu.basic.m
menubutton .menu.basic -text "Fractal" -menu $m -underline 0
menu $m
$m add cascade -label "Formula" -menu $m.formula 

set m2 $m.formula
menu $m2
foreach i {{"Mandelbrot" "mandel"} {"Mandelbrot 3" "mandel3"}\
{"Mandelbrot 4" "mandel4"} {"Mandelbrot 5" "mandel5"}\
{"octo"  "octo"} {"Newton" "newton"}} {
$m2 add radio -label [lindex $i 0]  -variable formule -value [lindex $i 1] -command "changeformula [lindex $i 1]"
}

set nbmenuitem 0
$m add cascade -label "fractal Incoloring mode" -menu $m.incol
set m3 $m.incol
menu $m3
foreach i {{"maxiter" 0} {"zmag" 1} {"Decomposition-like" 2}  {"real/imag" 3}\
	{"abs(abs(c)-abs(r))" 4} {"cos(mag)" 5} {"mag*cos(real^2)" 6}\
	 {"sin(real^2-imag^2)" 7} {"atan(real*imag*creal*cimag)" 8}\
	{"squares" 9} {"True-color" 10}} {
	 $m3 add command -label [lindex $i 0] -command  "changecoloring incoloring [lindex $i 1]"
	}

$m add cascade -label "fractal Outcoloring mode" -menu $m.outcol
set m4 $m.outcol
menu $m4
foreach i {{"iter" 0} {"iter+real" 1} {"iter+imag" 2} {"iter+real/imag" 3}\
	{"iter+real+imag+real/imag" 4} {"binary decomposition" 5}\
	{ "biomorphs" 6 }\
	{ "potential" 7} {"color decomposition" 8}\
	{"smooth" 8 } {"True-color" 9}} {
	 $m4 add command -label [lindex $i 0] -command "changecoloring outcoloring [lindex $i 1]" }

$m  add command  -label "Plane" -command "GetInt plane 0 100"
$m  add command  -label "Range" -command "GetInt range 0 100"
$m  add command  -label "Iteration" -command "GetInt maxiter 1 1000"
foreach i {
 {Palette }
 {Mandelbrot mode}
 {Perturbation }
 {View }} {
    $m add command -label "$i" \
	    -command "puts {$i}"
}

set m .menu.filter.check
menubutton .menu.filter -text "Filter" -menu $m -underline 0
menu $m
$m add check -label "Edge Detection" -variable oil \
	-onvalue "edge #t" -offvalue "edge #f"  -command {changefilter $oil}
$m add check -label "Edge Detection 2" -variable trans\
	-onvalue "edge2 #t" -offvalue "edge2 #f"  -command {changefilter $trans}
$m add check -label "Emboss" -variable brakes\
	-onvalue "emboss #t" -offvalue "emboss #f"  -command {changefilter $brakes}
$m add check -label "Interlace filter" -variable lights
$m add check -label "Palette emulator" -variable pal\
	-onvalue "palette #t" -offvalue "palette #f"  -command {changefilter $pal}
$m add check -label "Starfield" -variable starfield\
	-onvalue "starfield #t" -offvalue "starfield #f"  -command {changefilter $starfield}
$m add check -label "Motionblur" -variable motionb\
	-onvalue "blur #t" -offvalue "blur #f"  -command {changefilter $motionb}
$m add separator
$m add command -label "Unset All" 

set m .menu.icon.m
menubutton .menu.icon -text "Misc" -menu $m -underline 0
menu $m
$m add command -label "Command" -command "GetCommand "
$m add command -label "Clear Screen" -command { puts $f "(clearscreen)" 
					flush $f
					}

$m add command -label "Display Fractal"  -command "sendcmd display"
$m add command -label "Init state"  -command "sendcmd initstate"
$m add command -label "Display Text"  -command "GetStr text"
$m add command -label "Vertical Text position" -command "GetStr command"
$m add command -label "Horizontal Text position" -command "GetStr command"

set m .menu.more.m
menubutton .menu.more -text "Ui" -menu $m -underline 0
menu $m
foreach i {{Autopilot autopilot}  {Recalculate recalculate } {"Fast julia mode"  ""} {"Status" status} {"Ministatus" ministatus}} {
    $m add command -label [lindex $i 0] -command {
		sendcmd [lindex $i 1]
		puts  [lindex $i 1] }
	}

$m add cascade -label "Rotation mode" -menu $m.rotmod
set m4 $m.rotmod
menu $m4
foreach i {{"Disable rotation" "norotate"} {"Continuous rotation" "controtate"} {"Rotate by mouse" "mouserotate"}} {
    $m4 add command -label [lindex $i 0] -command {
		sendcmd [lindex $i 1]
		puts [lindex $i 1]
		}
 }
set m .menu.help.m
menubutton .menu.help -text "Help" -menu $m -underline 0
menu $m
    $m add command -label "Tutorial" 
    $m add command -label "Help"

pack .menu.file .menu.basic .menu.filter .menu.icon .menu.more .menu.help\
	 -side left

# Launch the xaos 

set f [open /tmp/xaos[pid].txt w]
flush $f
set command "./xaos -shared -pipe /tmp/xaos[pid].txt -windowid $thewindowid &"
eval exec $command
