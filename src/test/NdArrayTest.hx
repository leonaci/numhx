package test;
import numhx.backend.BackendKind;
import numhx.io.Complex;
import numhx.NdArray;
import numhx.NdArraySession;

/**
 * ...
 * @author leonaci
 */
class NdArrayTest
{
	static function main() 
	{
		numhx.NdArraySession.setBackend(BackendKind.Cpu);
		var a = numhx.NdArray.array([
			[
				[0,Complex.j,2,3,4],
				[5, 6, 7, 8, 9]
			],
				
			[
				[10, 11, 12, 13, 14],
				[15, 16, 17, 18, 19]
			]
		]);
		
		trace(a.size, a.ndim, a.shape, a.dtype);
		trace(a);
		
		var b = numhx.NdArray.diag([Complex.j, 2, 1, 1.5]);
		trace(b);
		
		trace(
			numhx.NdArray.blockDiag([
				numhx.NdArray.diag([1, 2, 3, 4, 5]),
				numhx.NdArray.arange(1, 1 + 10*10).reshape([10, 10]),
				numhx.NdArray.arange(1, 1 + 7*7).reshape([7, 7]),
			])
		);
	}
}