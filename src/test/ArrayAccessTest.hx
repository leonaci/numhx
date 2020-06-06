package test;
import numhx.backend.BackendKind;
import numhx.NdArraySession;

/**
 * ...
 * @author leonaci
 */
class ArrayAccessTest
{

	static function main() 
	{
		numhx.NdArraySession.setBackend(BackendKind.Cpu);
		var a = NdArray.arange(5*6).reshape([5, 6]);
		trace(a);
		
		a['0:4, 1::3'] = NdArray.array([
			[100, 200],
			[300, 400],
			[500, 600],
			[700, 800]
		]);
		
		trace(a);
		
		a['1::3, 0:4'] = NdArray.array([
			[1000, 2000],
			[3000, 4000],
			[5000, 6000],
			[7000, 8000]
		]).T;
		
		trace(a);
		
		trace(a['::-1']);
		trace(a.T);
		
		//for(i in 0...a.shape[0]) for(j in 0...a.shape[1]) trace(a[[i, j]]);
	}
	
}