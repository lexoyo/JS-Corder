import flash.external.ExternalInterface;
import flash.display.LoaderInfo;
import flash.Lib;

class ExternalInterfaceManager
{
	public var jsCorder:JSCorder;
	public var flashVars:Dynamic;

	public function new(jsCorder:JSCorder) 
	{
		this.jsCorder = jsCorder;
		
		initWithFlashVars();
		
		ExternalInterface.addCallback("isJSCorderOK", isJSCorderOK);
		ExternalInterface.addCallback("connect", connect);
		ExternalInterface.addCallback("play", play);
		ExternalInterface.addCallback("pause", pause);
		ExternalInterface.addCallback("resume", resume);
		ExternalInterface.addCallback("togglePause", togglePause);
		ExternalInterface.addCallback("stop", stop);
		ExternalInterface.addCallback("record", record);
		ExternalInterface.addCallback("live", live);
		ExternalInterface.addCallback("append", append);
		ExternalInterface.addCallback("seek", seek);


		ExternalInterface.addCallback("getTime", getTime);
	}
	public function isJSCorderOK():Bool
	{
		trace("isJSCorderOK returns true");
		return true;
	}
	public function sendEventToJS(event:Dynamic):Void
	{
		//trace("onJSRecorderEvent " +event);
		ExternalInterface.call("onJSRecorderEvent", event.info);
	}
	public function initWithFlashVars():Void
	{
		flashVars = Lib.current.loaderInfo.parameters;
		jsCorder.fileName = flashVars.fileName;
		jsCorder.serverURL = flashVars.serverURL;
		jsCorder.applicationName = flashVars.applicationName;
		jsCorder.instanceName = flashVars.instanceName;
	}
	public function connect():Void
	{
		jsCorder.connect();
	}
	public function play():Void
	{
		jsCorder.play();
	}
	public function pause():Void
	{
		jsCorder.pause();
	}
	public function togglePause():Void
	{
		jsCorder.togglePause();
	}
	public function resume():Void
	{
		jsCorder.resume();
	}
	public function stop():Void
	{
		jsCorder.stop();
	}
	public function record():Void
	{
		jsCorder.record();
	}
	public function live():Void
	{
		jsCorder.live();
	}
	public function append():Void
	{
		jsCorder.append();
	}
	public function seek(t:Float):Void
	{
		jsCorder.seek(t);
	}
	public function getTime():Float
	{
		return jsCorder.getTime();
	}
}