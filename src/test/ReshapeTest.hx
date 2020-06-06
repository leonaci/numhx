package test;
import numhx.backend.BackendKind;
import numhx.NdArraySession;

/**
 * ...
 * @author leonaci
 */
class ReshapeTest
{

	static function main() 
	{
		numhx.NdArraySession.setBackend(BackendKind.Cpu);
		var a:NdArray = NdArray.arange(10 * 10 * 10).reshape([10, 10, 10]);
		
		trace(a);
		trace(a.T);
		
		var b:NdArray = NdArray.arange(3 * 3 * 3 * 3 * 3).reshape([3, 3, 3, 3, 3]);
		trace(b);
		
		var c:NdArray = b['::-1, :1:, 2:, ::, -1:'];
		trace(c.shape, c.strides);
		trace(c);
		
		a = NdArray.arange(6);
		b = a.reshape([2, 3]).T;
		c = b.reshape([2,3,1]);
		trace(a);
		trace(b);
		trace(c);
		
		b['2,::'] = NdArray.arange(2);
		
		trace(a);
		trace(b);
		trace(c);
	}
	
}