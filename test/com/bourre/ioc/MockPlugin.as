package com.bourre.ioc 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import com.bourre.events.BasicEvent;
	import com.bourre.events.StringEvent;
	import com.bourre.model.AbstractModel;
	import com.bourre.plugin.AbstractPlugin;
	import com.bourre.view.AbstractView;	

	public class MockPlugin 
		extends AbstractPlugin
	{
		public var s : String;
		
		public var model : AbstractModel;
		public var view : AbstractView;

		public function MockPlugin( s : String, doc : DisplayObjectContainer = null ) 
		{
			this.s = s;
			getController().pushCommandClass( PrivateEventList.onOutputString, Output );
			
			model = new ModelTest( this, ModelList.modelTest );

			if ( doc != null )
			{
				view = new ViewTest( this );
				view.registerView( doc, ViewList.viewTest );
				view.show( );
				
				model.addListener( view );
			}
			
			firePublicEvent( new BasicEvent("echo") );
		}

		public function testPlugin() : void
		{
			firePrivateEvent( new StringEvent( PrivateEventList.onOutputString, this, s ) );			
			firePublicEvent( new StringEvent( PrivateEventList.onOutputString, this, s ) );
		}
		
		public function echo( e : Event ) : void
		{
			throw new Error( this + ".echo()" );
		}
	}
}

import flash.events.Event;

import com.bourre.commands.AbstractCommand;
import com.bourre.events.StringEvent;
import com.bourre.model.AbstractModel;
import com.bourre.plugin.Plugin;
import com.bourre.view.AbstractView;

internal class Output
	extends AbstractCommand
{
	override public function execute( e : Event = null ) : void
	{
		(getModelLocator().getModel( ModelList.modelTest ) as ModelTest).s = (e as StringEvent).getString();
	}
}

internal class PrivateEventList
{
	public static const onOutputString : String = "onOutputString";
}



internal class ModelTest 
	extends AbstractModel
{
	public var s : String;

	public function ModelTest( owner : Plugin, id : String ) 
	{
		super( owner, id );
	}
}

internal class ModelList
{
	public static const modelTest : String = "modelTest";
}

internal class ViewTest 
	extends AbstractView
{
	public var isInitialized : Boolean;

	public function ViewTest( owner : Plugin ) 
	{
		super( owner );
	}
	
	override protected function onInit() : void
	{
		isInitialized = true;
	}
}

internal class ViewList
{
	public static const viewTest : String = "viewTest";
}