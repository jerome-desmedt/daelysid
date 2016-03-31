package display
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import settings.*;

	[Embed(source="../assets/assets.swf", symbol="Home")]
	public class Home extends Sprite
	{
		public var logo							:MovieClip;
		public var linkBtns						:MovieClip;
		public var menuBtns					:MovieClip;
		
		public var backgroundShapes		:Sprite;
		public var rectShape0					:Shape;
		public var rectShape1					:Shape;

		private var pagesContainer		:Sprite;
		private var maskShape				:Shape;
		private var facebookBtn				:URLRequest;
		private var twitterBtn					:URLRequest;
		private var targetClick				:Object;

		public function Home()
		{
			createShapes();
			initBtns();
			initLinkBtn();

		}
		
		private function createShapes():void
		{
			backgroundShapes = new Sprite();
			this.addChildAt(backgroundShapes, 0);
			this.setChildIndex(backgroundShapes, 0);
			
			rectShape0 = new Shape();
			rectShape0.graphics.beginFill(0x2A2F30, 1);
			rectShape0.graphics.drawRect(0, 0, 300, 768);
			
			rectShape1 = new Shape();
			rectShape1.graphics.beginFill(0x211E21, 1);
			rectShape1.graphics.drawRect(50, 0, 250, 768);
			
			backgroundShapes.addChild(rectShape0);
			backgroundShapes.setChildIndex(rectShape0, 0);
			backgroundShapes.addChild(rectShape1);
			backgroundShapes.setChildIndex(rectShape1, 1);
			
			//this.addChildAt(Daelysid.specialEvent, 1);
			this.setChildIndex(menuBtns, 2);
			this.setChildIndex(linkBtns, 2);
			
		}
		
		private function initBtns():void
		{
			for each(var btn:MovieClip in menuBtns)
			{
				btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuBtnOver);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuBtnOut);
				btn.addEventListener(MouseEvent.CLICK, onMenuBtnClick);
			}
			addChild(pagesContainer = new Sprite());
		
			maskShape = new Shape();
			maskShape.graphics.beginFill(0x00FF00,1);
			maskShape.graphics.drawRect(300, 0, 350, rectShape0.height);
			maskShape.graphics.endFill();
			
			pagesContainer.mask = maskShape;
		}
		
		private function onMenuBtnOver(event:MouseEvent):void
		{
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(event.target.parent, 0.5, {tint:0xFFFFFF});
			
		}
		
		private function onMenuBtnOut(event:MouseEvent):void
		{
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(event.target.parent, 0.5, {tint:0x73796f});
		}
		
		private function onMenuBtnClick(event:MouseEvent):void
		{
			addPage();
			function addPage():void
			{
				if(rectShape0.width==300)
				{
					cleanPage();
					TweenLite.to(rectShape0, 1, {width:Settings.PAGES[event.target.parent.name].shapeWidth, ease:Quart.easeInOut});	
					TweenLite.to(pagesContainer, 1,{x:	Settings.PAGES[event.target.parent.name].contentX , ease:Quart.easeInOut});
					TweenLite.to(Daelysid.gallery, 1,{x:	Settings.PAGES[event.target.parent.name].shapeWidth , ease:Quart.easeInOut, onComplete: Daelysid.gallery.onStageResizeHandler});
					
					if(Settings.PAGES[event.target.parent.name].contentExist){
						pagesContainer.addChild(Settings.PAGES[event.target.parent.name].Class);	
					}
					pagesContainer.y = (rectShape0.height/2)-(pagesContainer.height/2);
					Daelysid.gallery.removeEventListener(Event.ENTER_FRAME, onGalleryEnterFrameHandler);
				}
				else
				{
					TweenLite.to(rectShape0, 1, {width:300, ease:Quart.easeInOut});
					TweenLite.to(Daelysid.gallery, 1,{x:300 , ease:Quart.easeInOut});
					TweenLite.to(pagesContainer, 1,{x:30, ease:Quart.easeInOut, onComplete: addPage});
					Daelysid.gallery.addEventListener(Event.ENTER_FRAME, onGalleryEnterFrameHandler);
				}
			}
		}
		
		private function onGalleryEnterFrameHandler(event:Event):void
		{
			Daelysid.gallery.onStageResizeHandler();
		}
		
		private function initLinkBtn():void
		{
			linkBtns.buttonMode = true;
			linkBtns.facebook.bubbleOver.scaleX = linkBtns.facebook.bubbleOver.scaleY = 0;
			linkBtns.twitter.bubbleOver.scaleX = linkBtns.twitter.bubbleOver.scaleY = 0;
			
			for each(var btn:MovieClip in linkBtns)
			{
				btn.addEventListener(MouseEvent.MOUSE_OVER, linkBtnsOver);
				btn.addEventListener(MouseEvent.MOUSE_OUT, linkBtnsOut);
				btn.addEventListener(MouseEvent.CLICK, linkBtnsClick);
			}
		}
		
		private function linkBtnsOver(event:MouseEvent):void
		{
			TweenLite.to(event.target.parent.bubbleOver, .8, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
		}
		
		private function linkBtnsOut(event:MouseEvent):void
		{
			TweenLite.to(event.target.parent.bubbleOver, .3, {scaleX:0, scaleY:0, ease:Quart.easeOut});
		}
		
		private function linkBtnsClick(event:MouseEvent):void
		{
			navigateToURL(Settings.URL[event.target.parent.name].adress, "_blank");
		}
		
		private function cleanPage():void
		{
			for(var i:Number=0; i < pagesContainer.numChildren; i++)
			{
				pagesContainer.removeChildAt(i);
			}
		}
		
		public function onStageResize(stageW:Number, stageH:Number):void
		{
			rectShape0.height = rectShape1.height = stageH;
			pagesContainer.y = (stageH/2)-(pagesContainer.height/2);
			
			linkBtns.y = stageH - 40;	
		}
	}
}
