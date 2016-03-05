module utils;

import std.stdio, std.array, std.file, core.thread, core.exception, std.datetime, std.conv;

const bool debugMessagesEnabled = true;
const bool dbmfe = true;

__gshared string dbmlog = "";

private void appendDbg(string app) {
    thread_enterCriticalRegion();
    dbmlog ~= app;
    thread_exitCriticalRegion();
}

void dbmclose() {
    if(!dbmfe) return;
    auto ff = File("dbg", "w");
    ff.write(dbmlog);
    ff.close();
}

void dbm(string msg) {
    if(debugMessagesEnabled) writeln("[debug]" ~ msg);
    if(dbmfe) appendDbg(msg ~ "\n");
}

string tzr(int inpt) {
    auto r = inpt.to!string;
    if(inpt > -1 && inpt < 10) return ("0" ~ r);
    else return r;
}

string vktime(SysTime ct, long ut) {
    auto t = SysTime(unixTimeToStdTime(ut));
    return (t.dayOfGregorianCal == ct.dayOfGregorianCal) ? (tzr(t.hour) ~ ":" ~ tzr(t.minute)) : (tzr(t.day) ~ "." ~ tzr(t.month));
}

string longpollReplaces(string inp) {
    return inp
        .replace("<br>", "\n")
        .replace("&quot;", "\"")
        .replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&amp;", "&");
}

T[] slice(T)(ref T[] src, int count, int offset) {
    try {
        return src[offset..(offset+count)]; //.map!(d => &d).array;
    } catch (RangeError e) {
        dbm("utils slice count: " ~ count.to!string ~ ", offset: " ~ offset.to!string);
        dbm("catched slice ex: " ~ e.msg);
        return [];
    }
}