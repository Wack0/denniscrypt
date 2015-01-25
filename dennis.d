// Dennis Publishing Browser v4.0 (May 2001) cdid/cdparas en/decrypter.
// Recoded in dlang because why not. ~ slipstream

import std.stdio;
import std.array;
import std.file;
import std.string;
import std.path;

ubyte[] getKey(string cdid) {
	// generate the key string
	string key = cdid~"Twas brillig and the sli";
	if (key.length < 61) key ~= "thy toves";
	if (key.length < 61) key ~= " nin gyre";
	if (key.length < 61) key ~= " andgimble";
	if (key.length < 61) key ~= " in blethe";
	if (key.length < 61) key ~= " wabe";
	if (key.length > 61) key = key[0..61];
	// use the key string to generate the xorpad
	ubyte xortemp = 0x56;
	for (int i = 0; i < key.length; i++)
		xortemp ^= cast(ubyte)(key[i]);
	auto buffer = appender!(ubyte[])();
	buffer.put(xortemp);
	for (int i = 0; i < key.length; i++) {
		xortemp ^= cast(ubyte)(key[i]);
		buffer.put(xortemp);
	}
	return buffer.data;
}

void main(string[] args) {
	writeln("Dennis Publishing Browser v4.0 (May 2001) cdid/cdparas en/decrypter - xors on top of xors, again.");
	if (args.length < 3) {
		writeln("Usage: "~args[0]~" <cdparas.txt> <out.txt>\nwhere cdparas.txt is the path to your cdparas.txt and out.txt is where the en/decrypted file should be saved");
		return;
	}
	string cdidpath = dirName(args[1])~dirSeparator~"cdid.txt";
	if (!exists(cdidpath)) {
		writeln("ERROR: Cannot find file: "~cdidpath);
		return;
	}
	ubyte[] key = getKey(strip(readText(cdidpath)));
	ubyte[] cdparas = cast(ubyte[])(read(args[1]));
	for (int i = 0; i < cdparas.length; i++) {
		cdparas[i] ^= key[i % key.length];
	}
	std.file.write(args[2],cdparas);
	writeln("Done!");
}