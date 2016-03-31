/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package display
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Gallery extends Sprite
	{
		public var xmlData			:XML;
		public var imgArray			:Array;
		public var mainContainer		:Sprite;
		public var projectHolder		:Sprite;
		
		private var xmlLoader			:URLLoader;
		private var progressBar			:ProgressBar;
		private var imgLoader			:Loader;
		private var percent			:Number;
		
		private var countThumb			:Number=0;
		private var countProject		:Number=0;
		private var tempShape			:TempShape;
		
		private var draggedObject		:Sprite;
		private var moveStatement		:String;
		private var offsetX			:Number;
		private var offsetY			:Number;
		private var startDragX			:Number;
		private var startDragY			:Number;
		
		public function Gallery()
		{
			addEventListener(Event.ADDED_TO_STAGE, initGallery);
		}
		
		private function initGallery(event:Event=null):void
		{
			mainContainer = new Sprite();
			addChild(mainContainer);
			
			parseXML();
			newProject();
		}
		
		private function parseXML():void
		{
			imgArray	= new Array();
			
			var source:String = "xml/site.xml";
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, processXML);
			xmlLoader.load(new URLRequest(source));
		}
		
		private function processXML(event:Event):void 
		{
			xmlData = new XML(event.target.data);
			
			for (var i:Number=0; i < xmlData.home.gallery.project.length(); i++)
			{
				var xmlPath:XML = xmlData.home.gallery.project[i];
				imgArray["project_"+i] = 
					{
						title:XML(xmlPath.title),
						details:XML(xmlPath.details),
						thumb:XMLList(xmlPath.pictures.img.thumb),
						large:XMLList(xmlPath.pictures.img.large)
					};
			}
			imgArray.length = xmlData.home.gallery.project.length();
			
			loadThumb(countProject, countThumb);
		}
		
		private function loadThumb(cP:Number, cT:Number):void
		{
			//trace("Loading IMG :"+cT+" @ Project "+cP);
			imgLoader=new Loader();
			imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressEventHandler);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSiteLoadError);
			imgLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSiteLoadError);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			imgLoader.load(new URLRequest(imgArray["project_"+cP].thumb[cT]));
			imgLoader.x = 140*cT;	
		}
		
		private function onProgressEventHandler(event:ProgressEvent):void
		{
			percent += (event.bytesLoaded/event.bytesTotal);
			TweenMax.to(progressBar, 1.5, {width:percent*(stage.stageWidth/9), ease:Strong.easeOut});
		}
		
		private function onSiteLoadError(event:Event):void
		{
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onSiteLoadError);
			imgLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSiteLoadError);	
		}
		
		private function onLoadCompleteHandler(event:Event):void
		{	
			//(imgLoader.content as Bitmap).smoothing=true;
			projectHolder.addChild(imgLoader);
			
			if(countThumb == imgArray["project_"+countProject].thumb.length()-1)
			{
				mainContainer.addChild(projectHolder);
				onStageResizeHandler();
				var objectTemp : Sprite= progressBar;
				//TweenMax.to(objectTemp, 0.8, {width:0, ease:Quart.easeInOut});
				//TweenMax.to(objectTemp, 0.8, {x:stage.stageWidth, ease:Quart.easeInOut, onComplete:removeProgressBar});
				TweenMax.to(objectTemp, 1, {alpha:0, ease:Linear.easeInOut, onComplete:removeProgressBar});
				function removeProgressBar():void
				{
					removeChild(objectTemp);	
				}
			}
			
			countThumb++;
			if(countThumb < imgArray["project_"+countProject].thumb.length())
			{
				loadThumb(countProject, countThumb);
			}
			else if(countProject < imgArray.length-1)
			{
				countProject++;
				loadThumb(countProject, countThumb=0);
				newProject();
			}
		}
		
		private function newProject():void
		{
			projectHolder = new Sprite();
			projectHolder.name = "project_"+countProject;
			projectHolder.buttonMode = true;
			projectHolder.y = 93*countProject;
			TweenMax.to(projectHolder, 0, {colorMatrixFilter:{saturation:0}});
			//projectHolder.blendMode= BlendMode.HARDLIGHT;
			
			addChild(progressBar = new ProgressBar());
			progressBar.y = projectHolder.y;	
			percent = 0;
			
			projectHolder.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler); 
			projectHolder.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler,false, 0, false);
			projectHolder.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			this.parent.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
		}
		
		private function onMouseOverHandler(event:MouseEvent):void
		{
			TweenMax.to(event.target.parent, 0, {colorMatrixFilter:{saturation:1}});
			//event.target.parent.blendMode= BlendMode.HARDLIGHT;
		}
		
		private function onMouseOutHandler(event:MouseEvent):void
		{
			TweenMax.to(event.target.parent, 0, {colorMatrixFilter:{saturation:0}});
		}
		
		private function onDownHandler(event:MouseEvent):void
		{
			draggedObject = event.target.parent;
			startDragX = mouseX;
			startDragY = mouseY;
			offsetX = mouseX - event.target.parent.x;
			offsetY = mouseY - mainContainer.y;			
			moveStatement = "clicked";
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		private function onMouseMoveHandler(event:MouseEvent):void
		{
			if((((mouseX-startDragX) > 15) || ((mouseX-startDragX) < -15))&&(((stage.stageWidth-Daelysid.home.width)<draggedObject.width)||(stage!=null)))
			{
				moveStatement="x";
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
			else if((((mouseY-startDragY) > 15) || ((mouseY-startDragY) < -15)) && (stage.stageHeight< mainContainer.height))
			{
				moveStatement="y";
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}
		
		private function onEnterFrameHandler(event:Event):void
		{
			if(moveStatement=="x")
			{
				var displaceX:Number;
				if(mouseX-offsetX > 0)
				{
					displaceX = 0;
				}else if((mouseX-offsetX)<(stage.stageWidth-draggedObject.width-Daelysid.home.backgroundShapes.width))
				{
					displaceX = stage.stageWidth-draggedObject.width-Daelysid.home.backgroundShapes.width;
				}else{
					displaceX = mouseX-offsetX;				
				}
				TweenMax.killTweensOf(draggedObject);
				TweenMax.to(draggedObject, .5,{x:displaceX, ease:Cubic.easeOut});
			}
			else if(moveStatement=="y")
			{
				var displaceY:Number;
				if(mouseY-offsetY > 0)
				{
					displaceY = 0;	
				}else if((mouseY-offsetY)<(stage.stageHeight-mainContainer.height))
				{
					displaceY = stage.stageHeight-mainContainer.height;
				}else{
					displaceY = mouseY-offsetY;					
				}
				TweenMax.killTweensOf(mainContainer);
				TweenMax.to(mainContainer, .5,{y:displaceY, ease:Cubic.easeOut});
			}
		}
		
		private function onUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
/*			
			if(moveStatement=="clicked")
			{
				if((draggedObject.scaleY>1)||(draggedObject.scaleX > 1))
				{
					for(var i:int = 0; i < xmlData.home.gallery.project.length(); i++)
					{
						if(mainContainer.getChildByName("project_"+i).y > startDragY)
						{
							TweenMax.to(mainContainer.getChildByName("project_"+i), .8,{y:93*i, ease:Cubic.easeOut});
						}
					}
					TweenMax.to(draggedObject, .8,{scaleX:1, scaleY:1, ease:Cubic.easeOut});
				}
				else
				{
					for(var i:int = 0; i < xmlData.home.gallery.project.length(); i++)
					{
						if(mainContainer.getChildByName("project_"+i).y > startDragY)
						{
							//TweenMax.to(mainContainer.getChildByName("project_"+i), .8,{y:mainContainer.getChildByName("project_"+i).y+(93*3), ease:Cubic.easeOut});
						}
					}
					TweenMax.to(draggedObject, .8,{scaleX:4, scaleY:4, ease:Cubic.easeOut});
				}
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}*/
		}
		
		public function onStageResizeHandler():void
		{
			for(var i:int=0; i< mainContainer.numChildren;i++)
			{
				if(((mainContainer.getChildByName("project_"+i).x)<(stage.stageWidth-mainContainer.getChildByName("project_"+i).width-(Daelysid.home.backgroundShapes.width)))&&((mainContainer.getChildByName("project_"+i).width+(Daelysid.home.backgroundShapes.width))>=stage.stageWidth))
				{
					mainContainer.getChildByName("project_"+i).x = (stage.stageWidth-mainContainer.getChildByName("project_"+i).width-(Daelysid.home.backgroundShapes.width));
				}
				else if((mainContainer.getChildByName("project_"+i).x+mainContainer.getChildByName("project_"+i).width+(Daelysid.home.backgroundShapes.width))<stage.stageWidth)
				{
					while((mainContainer.getChildByName("project_"+i).x+mainContainer.getChildByName("project_"+i).width+(Daelysid.home.backgroundShapes.width))<stage.stageWidth)
					{
						(mainContainer.getChildByName("project_"+i)as Sprite).addChild(tempShape = new TempShape(mainContainer.getChildByName("project_"+i).width));
					}
				}
				else if((mainContainer.getChildByName("project_"+i).x+(mainContainer.getChildByName("project_"+i).width)-140+(Daelysid.home.backgroundShapes.width))>(stage.stageWidth)&&((mainContainer.getChildByName("project_"+i).width)>(140*imgArray["project_"+i].thumb.length())))
				{
					while((((mainContainer.getChildByName("project_"+i).width))>(140*imgArray["project_"+i].thumb.length()))&&((mainContainer.getChildByName("project_"+i).width-140+(Daelysid.home.backgroundShapes.width))>(stage.stageWidth)))
					{
						(mainContainer.getChildByName("project_"+i)as Sprite).removeChildAt((((mainContainer.getChildByName("project_"+i)as Sprite).numChildren)-1));	
					}
				}
			}
			
			if(((mainContainer.y)<(stage.stageHeight-mainContainer.height))&&((mainContainer.height)>=stage.stageHeight))
			{
				mainContainer.y = (stage.stageHeight-mainContainer.height);
			}
			else if((mainContainer.height)<(stage.stageHeight))
			{
				mainContainer.y = 0;
			}
		}
	}
}

import flash.display.Graphics;
import flash.display.Sprite;

class ProgressBar extends Sprite
{
	public function ProgressBar()
	{
		graphics.beginFill(0x2A2F30, 1);
		graphics.drawRect(0, 0, 0.1, 93);
		graphics.endFill();
	}
}

class TempShape extends Sprite
{
	public function TempShape(pX:Number)
	{
		if(!((pX/140)%2))
			graphics.beginFill(0x2A2F30, 1);
		else
			graphics.beginFill(0x211E21, 1);
		
		graphics.drawRect(pX, 0, 140, 93);
		graphics.endFill();
	}
}
