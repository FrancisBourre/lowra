package com.bourre.core
{
	import com.bourre.log.PixlibDebug;
	
	import flash.utils.getDefinitionByName;	

	/**
	 * A factory for object creation. 
	 * 
	 * <p>The <code>CoreFactory</code> can build any object of any type.<br>
	 * The <code>CoreFactory</code> is intensively used in 
	 * the IoC assembler of LowRA.
	 * 
	 * @author	Francis Bourre
	 */
	public class CoreFactory
	{
		/**
		 * Builds an instance of the passed-in class with the specified arguments
		 * passed to the class constructor. The function can also work with singleton
		 * factory and factory methods.
		 * <p>
		 * When trying to create an object, the function will work as below :
		 * </p><ol>
		 * <li>The function try to retreive a reference to te specified class, if
		 * the class cannot be found in the current application domain the function
		 * will fail with an exception.</li>
		 * <li>Then the function will look to a factory method, if one have been
		 * specified, if the <code>singletonAccess</code> is also specified, the
		 * function retreive a reference to the singleton instance and then call
		 * the factory method on it. If there is no singleton access, the function
		 * call the factory method directly on the class.</li>
		 * <li>If <code>singletonAccess</code> is specified and <code>factoryMethod</code>
		 * parameter is null, this method will try to return an instance using singleton
		 * access parameter as static method name of the class passed.</li>
		 * <li>If there is neither a factory method nor a singleton accessor, the
		 * function will instantiate the class using its constructor.</li>
		 * </ol><p>
		 * In AS3, the <code>constructor</code> property of a class is not a function
		 * but an object, resulting that it is not possible to use the <code>apply</code>
		 * or <code>call</code> method on the constructor of a class. The workaround
		 * we use is to create wrapping methods which correspond each to a specific call
		 * to a class constructor with a specific number of arguments, in that way, we can
		 * select the right method to use according to the number of arguments specified
		 * in the <code>buildInstance</code> call. However, there's a limitation, we decided
		 * to limit the number of arguments to <code>30</code> values.
		 * </p>
		 * 
		 * @param	qualifiedClassName	the full classname of the class to create as returned
		 * 								by the <code>getQualifiedClassName</code> function
		 * @param	args				array of arguments to transmit into the constructor
		 * @param	factoryMethod		the name of a factory method provided by the class
		 * 								to use in place of the constructor
		 * @param	singletonAccess		the name of the singleton accessor method if the
		 * 								factory method is a member of the singleton instance
		 * @return	an instance of the specified class, or <code>null</code>
		 * @throws 	<code>ReferenceError</code> — The specified classname cannot be found
		 * 			in the current application domain 
		 * @example Creating a <code>Point</code> instance using the <code>CoreFactory</code> class : 
		 * <listing>CoreFactory.buildInstance( "flash.geom::Point", [ 50, 50 ] );</listing>
		 * 
		 * Using the factory method <code>createObject</code> of the class to create the instance : 
		 * <listing>CoreFactory.buildInstance( "com.package::SomeClass", ["someParam"], "createObject" );</listing>
		 */
		static public function buildInstance( qualifiedClassName : String, args : Array = null, factoryMethod : String = null, singletonAccess : String = null ) : Object
		{
			var msg : String;
			var clazz : Class;

			try
			{
				clazz = getDefinitionByName( qualifiedClassName ) as Class;

			} 
			catch ( e : Error )
			{
				msg = clazz + "' class is not available in current domain";
				PixlibDebug.FATAL( msg );
				throw( e );
			}

			var o : Object;
	
			if ( factoryMethod )
			{
				if ( singletonAccess )
				{
					var i : Object;
					
					try
					{
						i = clazz[ singletonAccess ].call();

					} catch ( eFirst : Error ) 
					{
						msg = qualifiedClassName + "." + singletonAccess + "()' singleton access failed.";
						PixlibDebug.FATAL( msg );
						return null;
					}
					
					try
					{
						o = i[factoryMethod].apply( i, args );

					} catch ( eSecond : Error ) 
					{
						msg = qualifiedClassName + "." + singletonAccess + "()." + factoryMethod + "()' factory method call failed.";
						PixlibDebug.FATAL( msg );
						return null;
					}

				} else
				{
					try
					{
						o = clazz[factoryMethod].apply( clazz, args );

					} catch( eThird : Error )
					{
						msg = qualifiedClassName + "." + factoryMethod + "()' factory method call failed.";
						PixlibDebug.FATAL( msg );
						return null;
					}

				}

			} else if ( singletonAccess )
			{
				try
				{
					o = clazz[ singletonAccess ].call();

				} catch ( eFourth : Error ) 
				{
					msg = qualifiedClassName + "." + singletonAccess + "()' singleton call failed.";
					PixlibDebug.FATAL( msg );
					return null;
				}
				
			} else
			{
				o = _buildInstance( clazz, args );
			}

			return o;
		}
		
		/**
		 * A map between number of arguments and build function
		 * @private
		 */
		static private var _A : Array = [	_build0,_build1,_build2,_build3,_build4,_build5,_build6,_build7,_build8,_build9,
											_build10,_build11,_build12,_build13,_build14,_build15,_build16,_build17,_build18,_build19,
											_build20,_build21,_build22,_build23,_build24,_build25,_build26,_build27,_build28,_build29,
											_build30];
			
		/**
		 * Wrapping method which select which build method use
		 * according to the argument count.
		 * @private
		 */
		static private function _buildInstance( clazz : Class, args : Array = null ) : Object
		{
			var f : Function = _A[ args ? args.length : 0 ];
			var _args : Array = [clazz];
			if ( args ) _args = _args.concat( args );
			return f.apply( null, _args );
		}
		
		static private function _build0( clazz : Class ) : Object{ return new clazz(); }
		static private function _build1( clazz : Class ,a1:* ) : Object{ return new clazz( a1 ); }
		static private function _build2( clazz : Class ,a1:*,a2:* ) : Object{ return new clazz( a1,a2 ); }
		static private function _build3( clazz : Class ,a1:*,a2:*,a3:* ) : Object{ return new clazz( a1,a2,a3 ); }
		static private function _build4( clazz : Class ,a1:*,a2:*,a3:*,a4:* ) : Object{ return new clazz( a1,a2,a3,a4 ); }
		static private function _build5( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:* ) : Object{ return new clazz( a1,a2,a3,a4,a5 ); }
		static private function _build6( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6 ); }
		static private function _build7( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7 ); }
		static private function _build8( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8 ); }
		static private function _build9( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9 ); }
		static private function _build10( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10 ); }
		static private function _build11( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11 ); }
		static private function _build12( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12 ); }
		static private function _build13( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13 ); }
		static private function _build14( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14 ); }
		static private function _build15( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15 ); }
		static private function _build16( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16 ); }
		static private function _build17( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17 ); }
		static private function _build18( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18 ); }
		static private function _build19( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19 ); }
		static private function _build20( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20 ); }
		static private function _build21( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21 ); }
		static private function _build22( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22 ); }
		static private function _build23( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23 ); }
		static private function _build24( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24 ); }
		static private function _build25( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25 ); }
		static private function _build26( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26 ); }
		static private function _build27( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27 ); }
		static private function _build28( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28 ); }
		static private function _build29( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29 ); }
		static private function _build30( clazz : Class ,a1:*,a2:*,a3:*,a4:*,a5:*,a6:*,a7:*,a8:*,a9:*,a10:*,a11:*,a12:*,a13:*,a14:*,a15:*,a16:*,a17:*,a18:*,a19:*,a20:*,a21:*,a22:*,a23:*,a24:*,a25:*,a26:*,a27:*,a28:*,a29:*,a30:* ) : Object{ return new clazz( a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30 ); }
	}
}