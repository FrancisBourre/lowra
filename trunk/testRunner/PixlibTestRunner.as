import flexunit.framework.TestSuite;

import com.bourre.commands.*;
import com.bourre.collection.*;
import com.bourre.core.*;
import com.bourre.events.*;
import com.bourre.load.*;
import com.bourre.load.strategy.*;
import com.bourre.log.*;
import com.bourre.plugin.*;
import com.bourre.utils.*;
import com.bourre.structures.*;
import com.bourre.transitions.*;

private function onCreationComplete():void
{
	Logger.getInstance().setLevel( LogLevel.ALL );
	Logger.getInstance().addLogListener( FlashInspectorLayout.getInstance(), PixlibDebug.CHANNEL );
	Logger.getInstance().addLogListener( SosLayout.getInstance(), PixlibDebug.CHANNEL );
	
	testRunner.test = createSuite();
	testRunner.startTest();	
}

private function createSuite() : TestSuite
{
	var ts:TestSuite = new TestSuite();
	
	// com.bourre.collection
	ts.addTestSuite( HashMapTest );
	ts.addTestSuite( WeakCollectionTest );
	ts.addTestSuite( TypedArrayTest );
	ts.addTestSuite( QueueTest );
	ts.addTestSuite( StackTest );
	
	// com.bourre.commands
	ts.addTestSuite( DelegateTest );
	ts.addTestSuite( BatchTest );
	ts.addTestSuite( AbstractSyncCommandTest );
	ts.addTestSuite( ASyncCommandSequencerTest );
	ts.addTestSuite( FrontControlerTest );
	ts.addTestSuite( CommandMSTest );
	ts.addTestSuite( CommandFPSTest );
	
	// com.bourre.core
	ts.addTestSuite( AccessorTest );
	
	// com.bourre.events
	ts.addTestSuite( ChannelBroadcasterTest );
	ts.addTestSuite( EventBroadcasterTest );
	ts.addTestSuite( EventChannelTest );
	
	// com.bourre.load
	
	ts.addTestSuite( AbstractLoaderTest );
	ts.addTestSuite( LoaderStrategyTest );
	//ts.addTestSuite( GraphicLoaderTest );
	ts.addTestSuite( XMLLoaderTest );
	
	// com.bourre.log
	ts.addTestSuite( BasicStringifierTest );
	ts.addTestSuite( LogEventTest );
	ts.addTestSuite( LoggerTest );
	ts.addTestSuite( LogLevelTest );
	
	// com.bourre.plugin
	//ts.addTestSuite( PixlibDebugTest );	
	ts.addTestSuite( NullPluginTest );

	
	// com.bourre.utils
	ts.addTestSuite( FlashInspectorLayoutTest );
	ts.addTestSuite( SosLayoutTest );
	
	// com.bourre.structures
	ts.addTestSuite( PointTest );
	ts.addTestSuite( RectangleTest );
	ts.addTestSuite( RangeTest );
	ts.addTestSuite( GridTest );
	
	// com.bourre.transitions
	ts.addTestSuite( AbstractTweenTest );
	ts.addTestSuite( AbstractMultiTweenTest );
	ts.addTestSuite( TweenMSTest );
	ts.addTestSuite( MultiTweenMSTest );
	
	return ts;
}
