/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package display
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class About extends Sprite
	{
		private var textFormat:TextFormat;
		private var textContainer:TextField;
		
		public function About()
		{
			initAbout();
		}
		
		private function initAbout():void
		{
			initTextfield();
			initScrollbar();
		}
		
		private function initTextfield():void
		{
			textFormat = new TextFormat();
			textFormat.align = "left";
			textFormat.font = "Verdana";
			textFormat.size = 12;
			
			textContainer = new TextField();
			textContainer.defaultTextFormat = textFormat;
			textContainer.type = TextFieldType.DYNAMIC;
			
			textContainer.y = 0;
			textContainer.width = 250;
			textContainer.autoSize = TextFieldAutoSize.LEFT;
			
			textContainer.multiline = textContainer.wordWrap = true;
			
			textContainer.textColor = 0x73796F;
			textContainer.background = false;
			textContainer.selectable = false;
			
			textContainer.htmlText=""
			addChild(textContainer);
		}
		
		private function initScrollbar():void
		{
			
		}
	}
}
