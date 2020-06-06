package test;
import numhx.backend.BackendKind;
import numhx.NdArraySession;

/**
 * ...
 * @author leonaci
 */
class TransposeTest
{
	static function main() 
	{
		numhx.NdArraySession.setBackend(BackendKind.Cpu);
		var a:NdArray = NdArray.arange(2*3*4*5*6).reshape([2,3,4,5,6]);
		trace(a.shape, a.strides);
		var b:NdArray = a.transpose([0,3,1,2,4]);
		trace(b.shape, b.strides);
		trace(a);
		trace(b);
	}
}