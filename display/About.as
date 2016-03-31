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
			
			textContainer.htmlText=
				"His name is <font color='#FFFFFF'>Jérôme De Smedt</font> born in 1988 and " +
				"based near Brussels he began learning about computer graphics at a very early age. " +
				"Diplomed of a 'C.E.S.S.' in informatic sciences and obtained a second " +
				"diplome CG Company Chief at EFPME where he has had the opportunity " +
				"to do a work experience at <font color='#FFFFFF'><a href='http://www.mymediaisrich.com' target='_blank'>MyMediaIsRich</a></font>" +
				" company as flash developper for six months.\nHe past two " +
				"others years to study at Computer Graphics school Albert Jacquard." +
				"\n\n\nHis main skill is flash development using tools like Flash Professional, " +
				"Flash Builder (Flex), Flash Cataclyst and he possesses a great mastery about ActionScript 3."+
				"\nHe has a large knowledge of Graphic softwares like Photoshop" +
				", Illustrator, Painter, Alchemy, AfterEffect and InDesign but he also learned bases of 3D softwares like 3Ds Max, Maya," +
				" ZBrush, Mudbox, MotionBuilder, Cinema 4D, Realflow." +
				"\nTo contribute of a great performance in the web development he's learned by himself some basic notions of HTML, XML, MXML, PHP, JavaScript and Visual Basic.";
			
			addChild(textContainer);
			
		}
		
		private function initScrollbar():void
		{
			
		}
	}
}
