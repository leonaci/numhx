package numhx.backend.cpu.operation;
import numhx.backend.cpu.CpuBackend;
import numhx.backend.cpu.CpuNdArrayOperation;
import numhx.buffer.NdArrayBufferView;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.MathUtil;

/**
 * ...
 * @author leonaci
 */
class CpuMinScalarOperation extends CpuNdArrayOperation
{
	private var a:NdArrayBufferViewData;
	private var b:Dynamic;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:CpuBackend, a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData) {
		super(backend, [a], [dst]);
		this.a = a;
		this.b = b;
		this.dst = dst;
	}
	
	override public function run():Void {
		var v = if (a.naive) a.buffer.getValue();
		else {
			var ndim = a.ndim;
			var shape = a.shape;
			var size = a.size;
			var strides = a.strides;
			
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			[for (i in 0...size) {
				var j = i;
				var idx = 0;
				for (i in 0...ndim) {
					idx += strides[i] * Std.int(j / targetStrides[i]);
					j %= targetStrides[i];
				}
				a.buffer.get(idx);
			}];
		}
		
		if (dst.naive) dst.buffer.setValue([for (i in 0...dst.size) MathUtil.min(v[i], b)]);
		else {
			var ndim = dst.ndim;
			var shape = dst.shape;
			var size = dst.size;
			var strides = dst.strides;
			
			var targetStrides = [];
			var c = 1;
			targetStrides.unshift(c);
			for (i in 1...ndim) {
				c *= shape[ndim-i];
				targetStrides.unshift(c);
			}
			
			for (i in 0...size) {
				var j = i;
				var idx = 0;
				for (i in 0...ndim) {
					idx += strides[i] * Std.int(j / targetStrides[i]);
					j %= targetStrides[i];
				}
				
				dst.buffer.set(idx, MathUtil.min(v[i], b));
			}
		}
	}
}