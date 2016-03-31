/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package settings
{
	import display.*;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;

	public class Settings
	{
		public static const PAGES:Array = new Array();
			PAGES['btn_0']		={contentExist:false, shapeWidth:300, contentX:0};
			PAGES['btn_1'] 		= {contentExist:true, Class:new About(), shapeWidth:580, contentX:315};
			PAGES['btn_2'] 		= {contentExist:true ,Class:new Contact(), shapeWidth:580, contentX:315};
		
		public static const URL:Array = new Array();
			URL['facebook']		= {adress:new URLRequest('http://www.facebook.com')};
			URL['twitter']			= {adress:new URLRequest('http://www.twitter.com/daelysid')};
		
		[Embed(source="C:/Windows/Fonts/verdana.ttf", fontFamily="Verdana")]
		public var verdana:String;
		
	}
}
