package numhx.backend;
import numhx.buffer.NdArrayBufferView;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * @author leonaci
 */
interface NdArrayOperation 
{
	var inputs(default, null):Array<NdArrayBufferViewData>;
	var outputs(default, null):Array<NdArrayBufferViewData>;
	
	function run():Void;
}