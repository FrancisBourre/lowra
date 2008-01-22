package com.bourre.utils 
{
	import com.bourre.commands.AbstractCommand;	
	import com.bourre.commands.ASyncCommand;
	import com.bourre.commands.Command;
	
	import flexunit.framework.TestCase;
	
	import com.bourre.commands.Runnable;		

	/**
	 * @author Cedric Nehemie
	 */
	public class ClassUtilsTest extends TestCase 
	{
		public function ClassUtilsTest (methodName : String = null)
		{
			super( methodName );
		}
		
		public function testInherit () : void
		{
			assertTrue( "ClassUtils.inherit() don't return true for MockChild -> MockInterface", 
						ClassUtils.inherit( MockFailChild, MockInterface ) );
						
			assertTrue( "ClassUtils.inherit() don't return true for MockChild -> MockParent", 
						ClassUtils.inherit( MockFailChild, MockParent ) );
						
			assertFalse( "ClassUtils.inherit() don't return false for Runnable -> MockChild", 
						 ClassUtils.inherit( Runnable, MockFailChild ) );
		}
		
		public function testIsImplemented () : void
		{
			var o1 : MockParent = new MockParent();
			var o2 : MockChild = new MockChild();
			var o3 : MockChildChild = new MockChildChild();
			var o4 : MockFailChild = new MockFailChild();
			
			assertFalse ( "ClassUtils.isImplemented() don't return false with the parent class", 
						 ClassUtils.isImplemented( o1, "com.bourre.utils::MockParent", "foo" ) );
			
			assertTrue ( "ClassUtils.isImplemented() don't return true with the valid child class", 
						 ClassUtils.isImplemented( o2, "com.bourre.utils::MockParent", "foo" ) );
						 
			assertTrue ( "ClassUtils.isImplemented() don't return true with the valid child class child", 
						 ClassUtils.isImplemented( o3, "com.bourre.utils::MockParent", "foo" ) );			 
						 
			assertFalse ( "ClassUtils.isImplemented() don't return false with the invalid child class", 
						 ClassUtils.isImplemented( o4, "com.bourre.utils::MockParent", "foo" ) );
		}
		
		public function testIsImplementedAll () : void
		{
			var o1 : MockParent = new MockParent();
			var o2 : MockChild = new MockChild();			var o3 : MockChildChild = new MockChildChild();
			var o4 : MockFailChild = new MockFailChild();
			
			assertFalse ( "ClassUtils.isImplementedAll() don't return false with the parent class", 
						 ClassUtils.isImplementedAll( o1, "com.bourre.utils::MockParent", "foo", "oof" ) );
			
			assertTrue ( "ClassUtils.isImplementedAll() don't return true with the valid child class", 
						 ClassUtils.isImplementedAll( o2, "com.bourre.utils::MockParent", "foo", "oof" ) );
						 
			assertTrue ( "ClassUtils.isImplementedAll() don't return true with the valid child class child", 
						 ClassUtils.isImplementedAll( o3, "com.bourre.utils::MockParent", "foo", "oof" ) );
						 			 
			assertFalse ( "ClassUtils.isImplementedAll() don't return false with the invalid child class", 
						 ClassUtils.isImplementedAll( o4, "com.bourre.utils::MockParent", "foo", "oof" ) );
		}
	}
}
