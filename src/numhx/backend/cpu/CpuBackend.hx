package numhx.backend.cpu;
import numhx.backend.NdArrayOperation;
import numhx.buffer.NdArrayBufferView;
import numhx.backend.Backend;
import numhx.backend.cpu.CpuNdArrayOperation;
import numhx.backend.cpu.operation.CpuAbsOperation;
import numhx.backend.cpu.operation.CpuAcosOperation;
import numhx.backend.cpu.operation.CpuAddOperation;
import numhx.backend.cpu.operation.CpuAddScalarOperation;
import numhx.backend.cpu.operation.CpuAsinOperation;
import numhx.backend.cpu.operation.CpuAssignOperation;
import numhx.backend.cpu.operation.CpuAssignScalarOperation;
import numhx.backend.cpu.operation.CpuAtanOperation;
import numhx.backend.cpu.operation.CpuCeilOperation;
import numhx.backend.cpu.operation.CpuCosOperation;
import numhx.backend.cpu.operation.CpuDivOperation;
import numhx.backend.cpu.operation.CpuDivScalarOperation;
import numhx.backend.cpu.operation.CpuDotOperation;
import numhx.backend.cpu.operation.CpuExpOperation;
import numhx.backend.cpu.operation.CpuFloorOperation;
import numhx.backend.cpu.operation.CpuLogOperation;
import numhx.backend.cpu.operation.CpuMaxOperation;
import numhx.backend.cpu.operation.CpuMaxScalarOperation;
import numhx.backend.cpu.operation.CpuMinOperation;
import numhx.backend.cpu.operation.CpuMinScalarOperation;
import numhx.backend.cpu.operation.CpuMulOperation;
import numhx.backend.cpu.operation.CpuMulScalarOperation;
import numhx.backend.cpu.operation.CpuPowOperation;
import numhx.backend.cpu.operation.CpuPowScalarOperation;
import numhx.backend.cpu.operation.CpuRoundOperation;
import numhx.backend.cpu.operation.CpuSinOperation;
import numhx.backend.cpu.operation.CpuSqrtOperation;
import numhx.backend.cpu.operation.CpuSubOperation;
import numhx.backend.cpu.operation.CpuSubScalarOperation;
import numhx.backend.cpu.operation.CpuSubScalarOperation;
import numhx.backend.cpu.operation.CpuTanOperation;
import numhx.buffer.NdArrayBuffer;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */
class CpuBackend implements Backend
{

	public function new() 
	{
	}
	
	public function run(ops:Array<NdArrayOperation>):Void {
		for (op in ops) op.run();
	}
	
	public function createBuffer():NdArrayBuffer {
		return new CpuNdArrayBuffer();
	}
	
	public function assign(a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAssignOperation(this, a, dummyDst, dst);
	}
	
	public function assignScalar(a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAssignScalarOperation(this, a, dummyDst, dst);
	}
	
	public function add(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAddOperation(this, a, b, dst);
	}
	
	public function addScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAddScalarOperation(this, a, b, dst);
	}
	
	public function sub(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSubOperation(this, a, b, dst);
	}
	
	public function subScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSubScalarOperation(this, a, b, dst);
	}
	
	public function mul(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMulOperation(this, a, b, dst);
	}
	
	public function mulScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMulScalarOperation(this, a, b, dst);
	}
	
	public function div(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDivOperation(this, a, b, dst);
	}
	
	public function divScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDivScalarOperation(this, a, b, dst);
	}
	
	public function dot(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDotOperation(this, a, b, dst);
	}
	
	// function
	
	public function abs(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAbsOperation(this, a, dst);
	}
	
	public function min(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMinOperation(this, a, b, dst);
	}
	
	public function minScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMinScalarOperation(this, a, b, dst);
	}
	
	public function max(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMaxOperation(this, a, b, dst);
	}
	
	public function maxScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMaxScalarOperation(this, a, b, dst);
	}
	
	public function sin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSinOperation(this, a, dst);
	}

	public function cos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuCosOperation(this, a, dst);
	}
	
	public function tan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuTanOperation(this, a, dst);
	}
	
	public function asin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAsinOperation(this, a, dst);
	}
	
	public function acos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAcosOperation(this, a, dst);
	}
	
	public function atan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAtanOperation(this, a, dst);
	}
	
	public function exp(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuExpOperation(this, a, dst);
	}
	
	public function log(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuLogOperation(this, a, dst);
	}
	
	public function pow(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuPowOperation(this, a, b, dst);
	}
	
	public function powScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuPowScalarOperation(this, a, b, dst);
	}
	
	public function sqrt(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSqrtOperation(this, a, dst);
	}
	
	public function round(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuRoundOperation(this, a, dst);
	}
	
	public function floor(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuFloorOperation(this, a, dst);
	}
	
	public function ceil(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuCeilOperation(this, a, dst);
	}
}