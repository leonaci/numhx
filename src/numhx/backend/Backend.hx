package numhx.backend;
import numhx.buffer.NdArrayBuffer;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * @author leonaci
 */
interface Backend 
{
	function run(ops:Array<NdArrayOperation>):Void;
	function createBuffer():NdArrayBuffer;
	
	function assign(a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function assignScalar(a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	
	function add(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function addScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function sub(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function subScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function mul(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function mulScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function div(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function divScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function dot(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	
	function abs(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function min(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function minScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function max(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function maxScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function sin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function cos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function tan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function asin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function acos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function atan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function exp(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function log(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function pow(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function powScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation;
	function sqrt(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function round(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function floor(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
	function ceil(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation;
}