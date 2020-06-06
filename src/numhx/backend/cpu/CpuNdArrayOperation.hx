package numhx.backend.cpu;
import numhx.buffer.NdArrayBufferView;
import numhx.backend.NdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */
class CpuNdArrayOperation implements NdArrayOperation
{
	private var backend:CpuBackend;
	public var inputs(default, null):Array<NdArrayBufferViewData>;
	public var outputs(default, null):Array<NdArrayBufferViewData>;
	

	public function new(backend:CpuBackend, inputs:Array<NdArrayBufferViewData>, outputs:Array<NdArrayBufferViewData>) {
		this.backend = backend;
		this.inputs = inputs;
		this.outputs = outputs;
	}
	
	public function run():Void throw 'error: not implemented.';
}