import flash.net.NetConnection;
import flash.net.NetStream;

class EventsManager
{
	public var jsCorder:JSCorder;
	public var onConnect:Void->Void;
	public var onConnectError:Dynamic->Void;
	public var onEvent:Dynamic->Void;

	public function new(jsCorder:JSCorder) 
	{
		this.jsCorder = jsCorder;
	}
	public function onBWDone(a:String=""):Void
	{
		trace("bandwidth = " + a + " Kbps.");
	}
	public function onBWCheck():Int
	{
		return 0;
	} 
	public function netConnectionHandler(event:Dynamic):Void 
	{ 
		switch (event.info.code) 
		{ 
			case "NetConnection.Connect.Success": 
				// calls bandwidth detection code built in to the server 
				// no server-side code required 
				// trace("The connection was made successfully"); 
				if (onConnect != null) 
					onConnect();
				
				//nc.call("checkBandwidth", null); 
			case "NetConnection.Connect.Rejected": 
				// trace ("sorry, the connection was rejected"); 
				if (onConnectError != null) 
					onConnectError(event);

			case "NetConnection.Connect.Failed": 
				// trace("Failed to connect to server."); 
				if (onConnectError != null) 
					onConnectError(event);
		} 
		if (onEvent != null)
			onEvent(event);
	}
}