package com.bourre.request
{
	import flexunit.framework.TestCase;
	import com.bourre.request.AbstractDataRequest
	import com.bourre.commands.AbstractSyncCommand
	import com.bourre.request.DataRequestEvent
	import com.bourre.request.*
		
	public class AbstractDataRequestTest extends TestCase
	{
		private var _absDR :MockRequest
		
		override public function setUp() : void
		{
			_absDR  = new MockRequest()
		}
		
		public function testConstruct() : void
		{
			assertNotNull("failed to construct AbstractDataRequest", _absDR)
			assertTrue("not type of AbstractDataRequest", _absDR is AbstractDataRequest)
			assertTrue("not type of AbstractSyncCommand", _absDR is AbstractSyncCommand)
		}
		
		public function testGetResult() : void
		{
			
			assertNull("failed to getResult as null befor first call", _absDR.getResult())
			
			var drl : MockDataRequestListener = new MockDataRequestListener()
			_absDR.addListener(drl)
			
			var dre : DataRequestEvent = new DataRequestEvent( DataRequestEvent.onDataResultEVENT, _absDR )
			assertNotNull("failed to create a new DataRequestEvent",dre)
			
			_absDR.fireEvent(dre)
			
			assertNotNull("fail to broadcast event from AbstractDataRequest on DataRequestListener", drl.evt)
			assertEquals("fail to get the good DataRequestEvent", dre, drl.evt)
			
		}
		
	}


}
	import com.bourre.request.AbstractDataRequest;
	import com.bourre.request.DataRequestListener;
	import com.bourre.request.DataRequestEvent;
	import flash.events.Event;
	
internal class MockRequest extends AbstractDataRequest
{
	public function  MockRequest()
	{
		super()
	}
	
	override public function setURL( url : String ) : void
	{
		
	}
	
	override public function setArguments(...args) : void
	{
		
	}
	
	override public function execute( e : Event = null ) : void
	{
		
	}
	
}

internal class MockDataRequestListener implements DataRequestListener
{
	public var evt : DataRequestEvent
	
	public function onDataResult(event : DataRequestEvent) : void
	{
		evt = event
	}

	public function onDataError(event : DataRequestEvent) : void
	{
		
	}
}