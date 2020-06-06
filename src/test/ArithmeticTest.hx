package test;
import numhx.NdArrayDataType;
import numhx.NdArraySession;
import numhx.NdArray;
import numhx.backend.BackendKind;
import numhx.io.Complex;

/**
 * ...
 * @author leonaci
 */
class ArithmeticTest
{
	static function main() 
	{
		NdArraySession.setBackend(BackendKind.Cpu);
		var a:NdArray = NdArray.arange(100).reshape([10, 10]);
		var b:NdArray = NdArray.arange(-50, 50).reshape([10, 10]);
		var c:NdArray = NdArray.array([for(i in 0...100) 50*(2*Math.random()-1)]).reshape([10, 10]);
		var d:NdArray = NdArray.array([for(i in 0...100) Complex.fromPolar(Math.random(), 2*Math.PI*Math.random())]).reshape([10, 10]);
		var e:NdArray = NdArray.array([for(i in 0...100) 50*Math.random()]).reshape([10, 10]);
		var f:NdArray = NdArray.array([for(i in 0...100) 2*Math.random()-1]).reshape([10, 10]);
		
		trace(NdArray.add(a, b));
		trace(NdArray.addScalar(a, 10));
		trace(NdArray.sub(a, b));
		trace(NdArray.subScalar(a, 10));
		trace(NdArray.mul(a, b));
		trace(NdArray.mulScalar(a, 10));
		trace(NdArray.div(a, c));
		trace(NdArray.divScalar(a, 10));
		trace(NdArray.dot(c, e));
		trace(NdArray.abs(d));
		trace(NdArray.min(c, e));
		trace(NdArray.minScalar(c, 20));
		trace(NdArray.max(c, e));
		trace(NdArray.maxScalar(c, 20));
		trace(NdArray.sin(d));
		trace(NdArray.cos(d));
		trace(NdArray.tan(d));
		trace(NdArray.asin(f));
		trace(NdArray.acos(f));
		trace(NdArray.atan(c));
		trace(NdArray.exp(d));
		trace(NdArray.log(e));
		trace(NdArray.pow(e, c));
		trace(NdArray.powScalar(e, 2));
		trace(NdArray.sqrt(e));
		trace(NdArray.round(c));
		trace(NdArray.floor(c));
		trace(NdArray.ceil(c));
	}
	
}