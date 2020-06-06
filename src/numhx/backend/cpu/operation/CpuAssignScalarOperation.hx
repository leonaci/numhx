package numhx.backend.cpu.operation;
import numhx.buffer.NdArrayBufferView;
import numhx.backend.cpu.CpuBackend;
import numhx.backend.cpu.CpuNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.TypeValidator;

/**
 * ...
 * @author leonaci
 */
class CpuAssignScalarOperation extends CpuNdArrayOperation
{
	private var a:Dynamic;
	private var dummyDst:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:CpuBackend, a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [], [dummyDst]);
		this.a = a;
		this.dummyDst = dummyDst;
		this.dst = dst;
	}
	
	override public function run():Void {
		if (dst.naive) dst.buffer.setValue([for(i in 0...dst.size) TypeValidator.cast_(a, dst.buffer.dtype)]);
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
				
				dst.buffer.set(idx, TypeValidator.cast_(a, dst.buffer.dtype));
			}
		}
	}
}