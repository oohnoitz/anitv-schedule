# -----------------------------------------------------------
# AniTV Eggdrop/TCL Script
# Version : 0.2.0
# Updated : 2011.01.11
# -- Description --------------------------------------------
# Utilizes the AniTV API to display program listings on IRC.
# -- Usage --------------------------------------------------
#  .anitv
#  .anitv <query>
# -- Dependancies -------------------------------------------
#  + DICT - http://www.tcl.tk/man/tcl/TclCmd/dict.htm
#  + HTTP - http://tmml.sourceforge.net/doc/tcl/http.html
#  + JSON - http://tcllib.sourceforge.net/doc/json.html
# -- Change Log ---------------------------------------------
#  @rev 0.2.0  [2012.01.11]
#    Updated API Calls for AniTV Schedule 0.2.0
#  @rev 0.1.0  [2011.12.03]
#    Initial Release
# -----------------------------------------------------------

# Required Packages
package require dict;
package require http;
package require json;

# Channel Flag
setudef flag anitv;

namespace eval septicore {
	namespace eval anitv {
		variable version "septicore-anitv-v0.1";
		
		bind	pub	-|-	".anitv"	septicore::anitv::display;
		bind	msg -|-	".anitv"	septicore::anitv::private;
		
		proc display { nick host hand chan text } {
			if { [lsearch -exact [channel info $chan] +anitv] == 1 } { return }
			
			foreach result [api [join [lrange [split $text] 0 end]]] {
				output $chan $result;
			}
		}

		proc private { nick host hand text } {
			foreach result [api [join [lrange [split $text] 0 end]]] {
				output $nick $result;
			}
		}
		
		proc api { search } {
			set data [list];
			if { $search == "" } {
				set url "http://anitv.foolz.us/json.php?controller=schedule&total=5&nowplaying=false";
			} else {
				set urlEncodeArg [http::formatQuery query $search];
				set url "http://anitv.foolz.us/json.php?controller=search&$urlEncodeArg&total=5";
			}
			
			set data [http::data [http::geturl $url]];
			set json_data [::json::json2dict $data];
			
			if { $json_data == "null" } {	return $data; }
			
			if { $search != "" } {
				dict with json_data {
					foreach result $results {
						if { [dict keys $result "error"] != "" } {
							dict with result {
								return [list "Error: $error"];
							}
						}
						
						dict with result {
							set display "\002\00307$title\003\002  episode \00307#<episode>\003  airs on \00307<station>\003 at \00307<airtime> JST\003. \[\002<eta>\002\]";
							
							if { $anidb > 0 } {
								append display " - \037\00312http://anidb.info/a<anidb>\003\037";
							}

							regsub -- {<episode>} $display $episode display;
							regsub -- {<subtitle>} $display $subtitle display;
							regsub -- {<station>} $display $station display;
							regsub -- {<airtime>} $display $airtime display;
							regsub -- {<eta>} $display [duration [expr { $unixtime - [unixtime] }]] display;
							regsub -- {<duration>} $display $duration display;
							regsub -- {<anidb>} $display $anidb display;
										
							lappend data $display;
						}
					}
				}
			} else {
				dict with json_data {
					foreach result $programs {
						dict with result {
							set display "\002\00307$title\003\002  episode \00307#<episode>\003  airs on \00307<station>\003 at \00307<airtime> JST\003. \[\002<eta>\002\]";
										
							if { $anidb > 0 } {
								append display " - \037\00312http://anidb.info/a<anidb>\003\037";
							}

							regsub -- {<episode>} $display $episode display;
							regsub -- {<subtitle>} $display $subtitle display;
							regsub -- {<station>} $display $station display;
							regsub -- {<airtime>} $display $airtime display;
							regsub -- {<eta>} $display [duration [expr { $unixtime - [unixtime] }]] display;
							regsub -- {<duration>} $display $duration display;
							regsub -- {<anidb>} $display $anidb display;
										
							lappend data $display;
						}
					}
				}
			}
			
			return $data;
		}
		
		# Default Procs
		proc notice { dest text } { putquick "NOTICE $dest :$text";	}
		proc output { dest text } {
			if { [validchan $dest] && [string first c [lindex [split [getchanmode $dest]] 0]] != -1 } { set text [stripcodes bcruag $text]; }
			putquick "PRIVMSG $dest :$text";
		}
		proc duration { unixtime } {
			set yrs 0; set wks 0; set days 0; set hrs 0; set min 0; set sec 0; set time "";
			if { $unixtime < 60 } { return "$unixtime seconds ago" }
			while { $unixtime >= 31449600 } { incr yrs 1; incr unixtime -31449600 }
			while { $unixtime >= 604800 } { incr wks 1; incr unixtime -604800 }
			while { $unixtime >= 86400 } { incr days 1; incr unixtime -86400 }
			while { $unixtime >= 3600 } { incr hrs 1; incr unixtime -3600 }
			while { $unixtime >= 60 } { incr min 1; incr unixtime -60 }
			while { $unixtime > 0 } { incr sec 1; incr unixtime -1 }
			if { $yrs > 0 } { append time "$yrs\y "; }
			if { $wks > 0 } { append time "$wks\w "; }
			if { $days > 0 } { append time "$days\d "; }
			if { $hrs > 0 } { append time "$hrs\h "; }
			if { $min > 0 } { append time "$min\m "; }
			if { $sec > 0 } { append time "$sec\s"; }
			return $time;
		}
	}
}

putlog "> Script Loaded: $septicore::anitv::version by TEAM SEPTiCORE";
# EOF