package com.bourre.ioc.parser
{
	import com.bourre.ioc.assembler.ApplicationAssembler;
	import com.bourre.ioc.assembler.DepthManager;
	import com.bourre.plugin.PluginDebug;
	import com.bourre.ioc.error.NullIDException;
	import com.bourre.ioc.core.IDExpert;
	import com.bourre.commands.ReversedBatch;

	public class DisplayObjectParser
		extends AbstractParser
	{
		public function DisplayObjectParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}

		public override function parse( xml : * ) : void
		{
			xml = xml[ ContextNodeNameList.ROOT ];
			for each ( var node : XML in xml.* ) _parseNode( node, ContextNodeNameList.ROOT );
		}
		
		private function _parseNode( xml : XML, parentID : String = null ) : void
		{
			var msg : String;
			
			// Filter reserved nodes
			if ( ContextNodeNameList.getInstance().nodeNameIsReserved( xml.name() ) ) return;
			
			// Debug missing ids.
			var id : String = ContextAttributeList.getID( xml );
			if ( !id )
			{
				msg = this + " encounters parsing error with '" + xml.name() + "' node. You must set an id attribute.";
				PluginDebug.getInstance().fatal( msg );
				throw( new NullIDException( msg ) );
			}

			IDExpert.getInstance().register( id );

			if ( parentID )
			{
				var url : String = ContextAttributeList.getURL( xml );
				var visible : String = ContextAttributeList.getVisible( xml );
				var isVisible : Boolean = visible ? (visible == "true") : true;
				var type : String = ContextAttributeList.getDisplayType( xml );
				
				if ( url.length > 0 )
				{
					// If we need to load a swf file.
					getAssembler().buildDisplayObject( id, parentID, url, isVisible, type );
					
				} else
				{
					// If we need to build an empty MovieClip.
					getAssembler().buildEmptyDisplayObject( id, parentID, isVisible, type );
				}
			}
			
			// Build property.
			for each ( var property : XML in xml[ ContextNodeNameList.PROPERTY ] )
			{
				getAssembler().buildProperty( 	id, 
												ContextAttributeList.getName( property ),
												ContextAttributeList.getValue( property ),
												ContextAttributeList.getType( property ),
												ContextAttributeList.getRef( property ),
												ContextAttributeList.getMethod( property ) );
			}

			// Build method call.
			for each ( var method : XML in xml[ ContextNodeNameList.METHOD_CALL ] )
			{
				getAssembler().buildMethodCall( id, 
												ContextAttributeList.getName( method ),
												getArguments( method ) );
			}
			
			// recursivity
			/*var b : ReversedBatch = new ReversedBatch();
			for ( var p : String in nodeContent )
			b.addCommand( new Delegate( this, _parseDisplayNode, p, nodeContent[p], id) );
			b.execute();*/

			// recursivity
			for each ( var node : XML in xml.* ) _parseNode( node, id );
		}
	}
}