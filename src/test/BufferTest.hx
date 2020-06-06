package test;
import numhx.io.BoolArray;
import numhx.io.Complex;
import numhx.io.Complex32Array;

/**
 * ...
 * @author leonaci
 */
class BufferTest
{

	static function main() 
	{
		var as1 = [for(i in 0...24) Math.random()>=0.5? true : false];
		trace(as1);
		var as2 = BoolArray.fromArray(as1);
		trace([for(i in 0...as2.length) as2[i]]);
		
		trace('');
		
		var bs1 = [for(i in 0...8) Complex.fromComponents(Math.random(), Math.random())];
		trace([for(i in 0...bs1.length) bs1[i].toString()]);
		
		var bs2 = Complex32Array.fromArray(bs1);
		trace([for(i in 0...bs2.length) bs2[i].toString()]);
		bs2.set(0, 0);
		trace(bs2.get(0));
	}
	
}