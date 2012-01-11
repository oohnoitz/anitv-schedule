function clockLocal() { return new Date(); }
function clock() { document.getElementById("clock").innerHTML = eval(timeLocal); setTimeout("clock()", 1000); }
function tN()  { return new Date(); }
function tZ(x) { return (x > 9) ? x : '0' + x; }
function tE(x) { if (x == 1 || x == 21 || x == 31) { return 'st'; } if (x == 2 || x == 22) { return 'nd'; } if (x == 3 || x == 23) { return 'rd'; } return 'th'; }
function tY(x) { return (x < 500) ? x + 1900 : x; }
var dName = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
var mName = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
var timeLocal = 'dName[clockLocal().getDay()] + " " + mName[clockLocal().getMonth()] + " " + clockLocal().getDate() + tE(clockLocal().getDate()) + ", " + tY(clockLocal().getYear()) + " " + tZ(clockLocal().getHours()) + ":" + tZ(clockLocal().getMinutes()) + ":" + tZ(clockLocal().getSeconds())';

if (!document.all) { window.onload = clock; } else { clock(); }