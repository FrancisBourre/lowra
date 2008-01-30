package com.bourre.utils 
{
	import flexunit.framework.TestCase;
	
	/**
	 * @author Cédric Néhémie
	 */
	public class CookieTest extends TestCase 
	{
		public function CookieTest (methodName : String = null)
		{
			super( methodName );
		}
		
		static private const COOKIE_CHANNEL : String = "COOKIE_CHANNEL";
		private var cookie : Cookie;

		override public function setUp(): void
		{
			cookie = new Cookie( COOKIE_CHANNEL );
		}
		
		override public function tearDown(): void
		{
			cookie.clear();
		}
		
		public function testSimpleReadWrite () : void
		{
			var b : Boolean;
			
			b = false;
			try
			{
				cookie.someProperty = "Hello world";
			}	
			catch( e : Error )
			{
				b = true;
			}		
			assertFalse  ( cookie + ".someProperty failed when writing data", b );
			assertEquals ( cookie + ".someProperty failed to return the value while reading it", 
						   "Hello world", cookie.someProperty );
			
			b = false;
			try
			{
				cookie.someProperty = "Goodbye world";
			}	
			catch( e : Error )
			{
				b = true;
			}		
			assertFalse  ( cookie + ".someProperty failed when re-writing data", b );
			assertEquals ( cookie + ".someProperty failed to return the value while " +
						   "reading it a second time", 
						   "Goodbye world", cookie.someProperty );
		}
		
		public function testComplexReadWrite () : void
		{
			var b : Boolean;
			
			b = false;
			try
			{
				cookie.someContainer().someProperty = "Hello world";
			}	
			catch( e : Error )
			{
				b = true;
			}		
			assertFalse  ( cookie + ".someContainer().someProperty failed when writing data", b );
			assertEquals ( cookie + ".someContainer().someProperty failed to return the value " +
						   "while reading it", 
						   "Hello world", cookie.someContainer().someProperty );
			
			b = false;
			try
			{
				cookie.someContainer().someProperty = "Goodbye world";
			}	
			catch( e : Error )
			{
				b = true;
			}		
			assertFalse  ( cookie + ".someContainer().someProperty failed when re-writing data", b );
			assertEquals ( cookie + ".someContainer().someProperty failed to return the value while " +
						   "reading it a second time", 
						   "Goodbye world", cookie.someContainer().someProperty );
		}
		
		public function testClear() : void
		{
			var b : Boolean;
			
			b = false;
			try
			{
				cookie.someProperty = "Hello world";
			}	
			catch( e : Error )
			{
				b = true;
			}		
			assertFalse  ( cookie + ".someProperty failed when writing data", b );
			
			cookie.clear();
			
			assertNull( cookie + ".clear() failed to remove data stored in the cookie", 
						cookie.someProperty );
		}
		
		public function testRootSpaceChange () : void
		{
			cookie.someProperty = "Hello world";
			
			cookie.setRootSpace( "someContainer" );
			
			assertNull( cookie + ".setRootSpace() failed to change the root space of this cookie", 
						cookie.someProperty );	
			
			cookie.someProperty = "GoodBye world";
			
			cookie.setRootSpace();
			
			assertEquals( cookie + ".someProperty can't access property defined before root space change", 
						  "Hello world", cookie.someProperty );	
			
			assertEquals( cookie + ".someContainer().someProperty can't access to a value defined " + 
						  "with a custom root space", 
						  "GoodBye world", cookie.someContainer().someProperty );
		}
	
		public function testPartialRequest () : void
		{
			cookie.someUnusedContainerCall();
			
			cookie.someContainer().someProperty = "Hello world";
			
			assertNull ( cookie + ".someContainer().someProperty access to unavailable data " +
						   "while make an uncomplete access before",
						   cookie.someContainer().someProperty );
		}
	}
}
