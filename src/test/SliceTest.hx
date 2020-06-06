package test;
import numhx.NdArray;
import numhx.backend.BackendKind;
import numhx.NdArraySession;

/**
 * ...
 * @author leonaci
 */
class SliceTest
{

	static function main() 
	{
		numhx.NdArraySession.setBackend(BackendKind.Cpu);
		var a = NdArray.arange(1, 51);
		trace(a);
		trace(a['9']);
		trace(a['9:40:5']);
		trace(a['::-5']);
		
		a = NdArray.arange(3 * 3 * 3).reshape([3, 3, 3]);
		trace(a);
		trace(a['...,2']);
		trace(a['0,1,2,None']);
		
		a = NdArray.arange(2*3*4*5*6).reshape([2,3,4,5,6]);
		trace(a['...,2,None,3::-1,None,2::2,4']);
		
		var a = NdArray.arange(60).reshape([2,3,10]);
		var b = NdArray.arange(30).reshape([10, 3]);
		trace(a.shape);
		trace(b.shape);
		trace(NdArray.dot(a,b).shape);
	}
	
}