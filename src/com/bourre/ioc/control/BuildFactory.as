/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
	 
package com.bourre.ioc.control
{
	import com.bourre.collection.HashMap;
	import com.bourre.commands.Command;
	import com.bourre.error.PrivateConstructorException;
	import com.bourre.events.ValueObjectEvent;
	import com.bourre.ioc.assembler.constructor.Constructor;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.parser.ContextTypeList;
	import com.bourre.log.PixlibStringifier;	
	
	/**
	 * The BuildFactory class store command to build objects of different 
	 * types.
	 * 
	 * <p>Each command is associated with targeted object type to build.<br />
	 * When an object with type definition is find, check if a command exist, 
	 * if yes, command is executed to build correct object instance.</p>
	 * 
	 * <p>Defaults commands are already implemented in LowRA core, take a look 
	 * at <a href="com/bourre/ioc/control/package-detail.html">com.bourre.ioc.control</a> 
	 * package.</p>
	 * 
	 * @author Francis Bourre
	 * 
	 * @see com.bourre.ioc.control LowRA builder commands
	 */
	public class BuildFactory
	{
		private static var _oI : BuildFactory = null;

		/**
		 * Returns singleton instance of BuildFactory.
		 * 
		 * @return The singleton instance of BuildFactory
		 */
		public static function getInstance() : BuildFactory 
		{
			if ( _oI == null ) _oI = new BuildFactory( new PrivateConstructorAccess() );
			return _oI;
		}

		private var _m : HashMap;
		
		/**
		 * @private
		 */
		public function BuildFactory( access : PrivateConstructorAccess )
		{
			if ( !(access is PrivateConstructorAccess) ) throw new PrivateConstructorException();
			
			init();
		}
		
		/**
		 * Inits builder hashmap with default builder instances defined 
		 * in LowRA core.
		 * 
		 * @see com.bourre.ioc.control LowRA builder commands
		 */
		public function init() : void
		{
			_m = new HashMap();
			
			addType( ContextTypeList.ARRAY, new BuildArray() );
			addType( ContextTypeList.BOOLEAN, new BuildBoolean() );
			addType( ContextTypeList.INSTANCE, new BuildInstance() );
			addType( ContextTypeList.INT, new BuildInt() );
			addType( ContextTypeList.NULL, new BuildNull() );
			addType( ContextTypeList.NUMBER, new BuildNumber() );
			addType( ContextTypeList.OBJECT, new BuildObject() );
			addType( ContextTypeList.STRING, new BuildString() );
			addType( ContextTypeList.UINT, new BuildUint() );
			addType( ContextTypeList.DEFAULT, new BuildString() );
			addType( ContextTypeList.DICTIONARY, new BuildDictionary() );
			addType( ContextTypeList.CLASS, new BuildClass() );
			addType( ContextTypeList.XML, new BuildXML() );
			addType( ContextTypeList.FUNCTION, new BuildFunction() );
		}
		
		/**
		 * Adds new builder command for passed-in type of object.
		 * 
		 * @param	type	Type of object to monitor
		 * @param	build	Command to execute to build object of passed-in type 
		 */
		protected function addType( type : String, build : Command ) : void
		{
			_m.put( type, build );
		}
		
		/**
		 * Builds object using passed-in Constructor definition.
		 * 
		 * @param	contructor	Contructor definition to build correct instance
		 * @param	id			(optional) if not <code>null</code>, built object 
		 * 						is registered in the BeanFactory store.
		 * 						
		 * 	@return Built object
		 */
		public function build( constructor : Constructor, id : String = null ) : *
		{
			var type : String = constructor.type;
			var cmd : Command = ( _m.containsKey( type ) ) ? _m.get( type ) as Command : _m.get( ContextTypeList.INSTANCE ) as Command;
			cmd.execute( new ValueObjectEvent( type, this, constructor ) );

			if ( id ) BeanFactory.getInstance().register( id, constructor.result );

			return constructor.result;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class PrivateConstructorAccess{}