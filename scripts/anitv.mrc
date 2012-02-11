;-- AniTV mIRC Script by prinny
;-- Last Modified: 2012-01-11
ON *:TEXT:.anitv*:#: {
  if ($2) {
    var %url = http://anitv.foolz.us/json.php?controller=search&query= $+ $json.enccomponent($1-) $+ &_timestamp= $+ $ctime
    var %idx = results
  }
  else {
    var %url = http://anitv.foolz.us/json.php?controller=schedule&total=5&nowplaying=false&_timestamp= $+ $ctime
    var %idx = programs
  }

  var %count = $json(%url, %idx).count

  if (%count == 0 && $json(%url, %idx, 0, error) != NULL) {
    msg $chan Error: $json(%url, %idx, 0, error)
  }

  if (%count > 10) {
    var %count = 10
  }

  var %row = 0
  while (%row < %count) {
    var %output = 7 $+ $json(%url,%idx,%row,title)  episode 7 $chr(35) $+ $json(%url,%idx,%row,episode)  airs on7 $json(%url,%idx,%row,station) at7 $asctime($ctime($json(%url,%idx,%row,airtime)),ddd HH:nn:ss) JST.  $chr(91) $+  $+ $replace($duration($calc($json(%url,%idx,%row,unixtime) - $ctime)),secs,s,mins,m,hrs,h,days,d) $+  $+ $chr(93)

    if ($json(%url,%idx,%row,anidb) > 0) {
      var %output = %output 0- 12 $+ http://anidb.net/a $+ $json(%url,%idx,%row,anidb)
    }

    msg $chan %output

    inc %row
  }
}


;-- DO NOT EDIT BELOW, THE $json ADDON IS REQUIRED FOR JSON OUTPUT
;-- $json by Timi
alias json {
  if ($isid) {
    var %c = jsonidentifier,%x = 2,%str,%p,%v,%addr

    if ($isfile($1)) { %addr = $qt($replace($1,\,\\,;,\u003b,",\u0022)) }
    else { %addr = $qt($replace($1,;,\u003b,",\u0022)) }

    json.comcheck
    if (!$timer(jsonclearcache)) { .timerjsonclearcache -o 0 300 jsonclearcache }

    while (%x <= $0) {
      %p = $($+($,%x),2)
      if (%p == $null) { noop }
      elseif (%p isnum || $qt($noqt(%p)) == %p) { %str = $+(%str,[,%p,]) }
      else { %str = $+(%str,[",%p,"]) }
      inc %x
    }
    if ($prop == count) { %str = %str $+ .length }

    if ($isfile($1)) {
      if ($com(%c,eval,1,bstr,$+(str2json,$chr(40),filejson,$chr(40),%addr,$chr(41),$chr(41),%str))) { return $com(%c).result }
    }
    elseif (http://* iswm $1 || https://* iswm $1) {
      if ($com(%c,eval,1,bstr,$+(str2json,$chr(40),urlcache[,%addr,],$chr(41),%str))) { return $com(%c).result }
      elseif ($com(%c,eval,1,bstr,$+(urlcache[,%addr,]) = $+(httpjson,$chr(40),$qt($1),$chr(41)))) {
        if ($com(%c,eval,1,bstr,$+(str2json,$chr(40),urlcache[,%addr,],$chr(41),%str))) { return $com(%c).result }
      }
    }
    elseif ($com(%c,eval,1,bstr,$+(x=,%addr,;,x,%str,;))) { return $com(%c).result }
  }
}
alias jsonclearcache {
  if ($com(jsonidentifier)) {
    if (!$1) { noop $com(jsonidentifier,executestatement,1,bstr,urlcache = {}) }
    else { echo -a $com(jsonidentifier,executestatement,1,bstr,urlcache[" $+ $1 $+ "] = "") }
  }
}
alias json.enc {
  json.comcheck
  if ($com(jsonidentifier,eval,1,bstr,encodeURI(" $+ $1- $+ "))) { return $com(jsonidentifier).result }
}
alias json.enccomponent {
  json.comcheck
  if ($com(jsonidentifier,eval,1,bstr,encodeURIComponent(" $+ $1- $+ "))) { return $com(jsonidentifier).result }
}
alias -l json.comcheck {
  var %c = jsonidentifier
  if (!$com(%c)) {
    .comopen %c MSScriptControl.ScriptControl
    noop $com(%c,language,4,bstr,jscript) $com(%c,addcode,1,bstr,function httpjson(url) $({,0) y=new ActiveXObject("Microsoft.XMLHTTP");y.open("GET",url,false);y.send();return y.responseText; $(},0))
    noop $com(%c,addcode,1,bstr,function filejson (file) $({,0) x = new ActiveXObject("Scripting.FileSystemObject"); txt1 = x.OpenTextFile(file,1); txt2 = txt1.ReadAll(); txt1.Close(); return txt2; $(},0))
    noop $com(%c,addcode,1,bstr,function str2json (json) $({,0) return !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(json.replace(/"(\\.|[^"\\])*"/g, ''))) && eval('(' + json + ')'); $(},0))
    noop $com(%c,addcode,1,bstr,urlcache = {})
  }
}