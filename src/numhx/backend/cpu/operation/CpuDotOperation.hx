package numhx.backend.cpu.operation;
import numhx.backend.cpu.CpuBackend;
import numhx.backend.cpu.CpuNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.MathUtil;

/**
 * ...
 * @author leonaci
 */
class CpuDotOperation extends CpuNdArrayOperation
{
	private var a:NdArrayBufferViewData;
	private var b:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:CpuBackend, a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [a,b], [dst]);
		this.a = a;
		this.b = b;
		this.dst = dst;
	}
	
	override public function run():Void {
		var nonTargetLhsStrides = [];
		var c = 1;
		nonTargetLhsStrides.unshift(c);
		for (i in 0...a.ndim-1) {
			c *= a.shape[a.ndim-i-2];
			nonTargetLhsStrides.unshift(c);
		}
		var nonTargetLhsSize = nonTargetLhsStrides.shift();
		
		var nonTargetRhsStrides = [];
		var c = 1;
		nonTargetRhsStrides.unshift(c);
		for (i in 1...b.ndim) {
			c *= b.shape[b.ndim-i];
			nonTargetRhsStrides.unshift(c);
		}
		var nonTargetRhsSize = nonTargetRhsStrides.shift();
		
		if (Std.int(a.size / nonTargetLhsSize) != Std.int(b.size / nonTargetRhsSize)) throw '!?';
		var targetSize = Std.int(a.size / nonTargetLhsSize);
		
		for (k in 0...nonTargetLhsSize) for (l in 0...nonTargetRhsSize) {
			var j = k;
			var k = [];
			for (s in nonTargetLhsStrides) {
				k.push(Std.int(j / s));
				j %= s;
			}
			
			var j = l;
			var l = [];
			for (s in nonTargetRhsStrides) {
				l.push(Std.int(j / s));
				j %= s;
			}
			
			var v:Dynamic = 0;
			for (m in 0...targetSize) {
				var aIndices = k;
				aIndices.push(m);
				var aIdx = 0;
				for (i in 0...a.ndim) aIdx += a.strides[i] * aIndices[i];
				aIndices.pop();
				
				var bIndices = l;
				bIndices.unshift(m);
				var bIdx = 0;
				for (i in 0...b.ndim) bIdx += b.strides[i] * bIndices[i];
				bIndices.shift();
				
				v = MathUtil.add(v, MathUtil.mul(a.buffer.get(aIdx), b.buffer.get(bIdx)));
			}
			
			var dstIndices = k.concat(l);
			var dstIdx = 0;
			for (i in 0...dst.ndim) dstIdx += dst.strides[i] * dstIndices[i];
			
			dst.buffer.set(dstIdx, v);
		}
	}
}