/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package
{
	import display.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(backgroundColor="#73796F", width="859", height="537")]
	public class Daelysid extends Sprite
	{
		public static var home			:Home;
		public static var gallery		:Gallery;		
		public static var about			:About;
		public static var contact		:Contact;
		public static var specialEvent		:SpecialEvent;
		
		public function Daelysid()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);	
		}
		
		private function onAddedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			buildPage();
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, false);
		}
		
		private function buildPage():void
		{
			specialEvent = new SpecialEvent();
			stage.addChildAt(gallery = new Gallery, 0);
			stage.addChildAt(home = new Home, 1);
			gallery.x = 300;
			
			gallery.tabChildren = false;
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			if(home!=null)
				home.onStageResize(stage.stageWidth, stage.stageHeight);
			if(gallery!=null)
				gallery.onStageResizeHandler();
		}
	}
}
