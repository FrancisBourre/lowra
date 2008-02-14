package com.bourre.events 
{
	import flexunit.framework.TestCase;				

	public class EventCallbackAdapterTest 
		 extends TestCase
	{
		private var _result : Object;
		private var _oEB : EventBroadcaster;
		private var _userVO : UserValueObject;

		override public function setUp() : void
		{
			_oEB = new EventBroadcaster( this );
			_result = undefined;
			
			_userVO = new UserValueObject( );
			_userVO.userName = "francis";
			_userVO.age = 37;
		}

		public function testBasicCallbackWithRedirection() : void
		{
			_oEB.addListener( new EventCallbackAdapter( StringCallbackFactoryTest, stringCallback ) );
			_oEB.broadcastEvent( new StringEvent( "fakeType", null, "TeSt" ) );

			assertEquals( "EventAdapter.handleEvent fails to convert StringEvent to String argument lowercased", "test", _result );
		}
		
		public function stringCallback( s : String ) : void
		{
			_result = s;
		}
		
		public function testCallbackWithValueObjectEvent() : void
		{
			_oEB.addListener( new EventCallbackAdapter( VOCallbackFactoryTest, this ) );
			_oEB.broadcastEvent( new ValueObjectEvent( "onVOCallback", null, _userVO ) );

			assertEquals( "EventAdapter.handleEvent fails to convert ValueObjectEvent to String argument", _userVO.userName, _result[ 0 ] );			assertEquals( "EventAdapter.handleEvent fails to convert ValueObjectEvent to int argument", _userVO.age, _result[ 1 ] );
		}

		public function onVOCallback( userName : String, age : int ) : void
		{
			_result = [userName, age];
		}
		
		public function testCallbackWithValueObjectEventAndRedirection() : void
		{
			_oEB.addListener(  new EventCallbackAdapter( NumberEventCallbackFactoryTest, onNumberEvent ) );
			_oEB.broadcastEvent( new ValueObjectEvent( "fakeType", null, _userVO ) );

			assertEquals( "EventAdapter.handleEvent fails to convert ValueObjectEvent to int argument", _userVO.age, _result );
		}
		
		public function onNumberEvent( e : NumberEvent ) : void
		{
			_result = e.getNumber();
		}	}}

import flash.events.Event;

import com.bourre.events.*;

internal class StringCallbackFactoryTest
	implements ArgumentCallbackFactory
{
	public function getArguments( e : Event ) : Array
	{
		return [ (e as StringEvent).getString().toLowerCase() ];
	}
}

internal class UserValueObject
	implements ValueObject
{
	public var userName : String;	public var age : int;
}

internal class VOCallbackFactoryTest
	implements ArgumentCallbackFactory
{
	public function getArguments( e : Event ) : Array
	{
		var userVO : UserValueObject = (e as ValueObjectEvent).getValueObject() as UserValueObject;
		return [ userVO.userName, userVO.age ];
	}
}

internal class NumberEventCallbackFactoryTest
	implements ArgumentCallbackFactory
{
	public function getArguments( e : Event ) : Array
	{
		var userVO : UserValueObject = (e as ValueObjectEvent).getValueObject() as UserValueObject;
		return [ new NumberEvent( e.type, null, userVO.age) ];
	}
}