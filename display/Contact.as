/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.setTimeout;
	
	public class Contact extends Sprite
	{
		public var contactForm		:Sprite;
		
		private var inputArray			:Array;
		public var textFormat			:TextFormat;
		private var inputName			:TextField;
		private var inputEmail			:TextField;
		private var inputSubject		:TextField;
		private var inputMessage		:TextField;
		private var buttonSubmit		:TextField; 
		
		private var variables			:URLVariables;
		
		public function Contact()
		{
			initContact();
		}
		
		private function initContact():void
		{
			addChild(contactForm = new Sprite());
			
			createInputs();
			createButton();
		}
		
		private function createInputs():void
		{
			inputArray = new Array();
			textFormat = new TextFormat();
			textFormat.align = "left";
			textFormat.font = "Verdana";
			textFormat.size = 12;
			
			contactForm.addChild(setInput(inputName = new TextField(), "name ", 0, "Please Enter a Name"));
			contactForm.addChild(setInput(inputEmail = new TextField(), "e-mail ", 30, "Please Enter a Valid E-Mail"));
			contactForm.addChild(setInput(inputSubject = new TextField(), "subject ", 60, "Please Enter a Subject"));
			contactForm.addChild(setInput(inputMessage = new TextField(), "message ", 90, "Please Enter a Message"));
		}
		
		private function	setInput(input:TextField, focusOut:String, posY:Number, wCase:String):TextField
		{
			input.type = TextFieldType.INPUT;
			input.defaultTextFormat = textFormat;
			//input.embedFonts = true;
			if(input == inputMessage)
			{
				input.height	 = 160;
				input.multiline = true;
				input.wordWrap = true;
			}else{
				input.height = 20;
				input.multiline = false;
				input.wordWrap = false;
				input.maxChars = 30;
			}
			input.width=250;
			input.y = posY;
			
			input.textColor = 0x2A2F30;
			input.background = true;
			input.backgroundColor = 0x73796F;
			input.border=true;
			input.borderColor= 0x211E21;
			
			input.addEventListener(FocusEvent.FOCUS_IN, onFocusInTextHandler, false, 0, false);
			input.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutTextHandler, false, 0, false);
			
			input.text =	 input.name = focusOut;
			inputArray[input.name] = {emptyInput:focusOut, contentText:input.text, wrongCase: wCase};
			
			return input;
		}
		
		private function onFocusInTextHandler(event:FocusEvent):void
		{
			if((event.target.text==inputArray[event.target.name].emptyInput)|| (event.target.text==inputArray[event.target.name].wrongCase))
			{
				event.target.text="";	
			}else{
				setTimeout(event.target.setSelection, 0, 0, event.target.text.length);
			}
		}
		
		private function onFocusOutTextHandler(event:FocusEvent):void
		{
			if(event.target.text.length==0)
				event.target.text = inputArray[event.target.name].emptyInput;
		}
		
		private function createButton():void
		{
			contactForm.addChild(buttonSubmit = new TextField());
			buttonSubmit.type = TextFieldType.DYNAMIC;
			buttonSubmit.defaultTextFormat = textFormat;
			buttonSubmit.autoSize = TextFieldAutoSize.LEFT;
			buttonSubmit.wordWrap = buttonSubmit.multiline = false;
			buttonSubmit.textColor = 0x73796F;
			buttonSubmit.selectable = false;
			buttonSubmit.text = "> submit";
			buttonSubmit.x = 250-buttonSubmit.width;
			buttonSubmit.y = 255;
			buttonSubmit.addEventListener(MouseEvent.CLICK, onSubmitHandler);
		 	buttonSubmit.addEventListener(MouseEvent.MOUSE_OVER, onSubmitBtnOver);
		 	buttonSubmit.addEventListener(MouseEvent.MOUSE_OUT,	onSubmitBtnOut);
		}
		
		private function onSubmitBtnOver(event:MouseEvent):void
		{
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(event.target, 0.5, {tint:0xFFFFFF});
		}
		
		private function onSubmitBtnOut(event:MouseEvent):void
		{
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(event.target, 0.5, {tint:0x73796f});
		}
		
		private function onSubmitHandler(event:MouseEvent):void
		{
			if(inputName.text == inputArray["name "].emptyInput || inputSubject.text == inputArray["subject "].wrongCase)
			{
				inputName.text = inputArray["name "].wrongCase;
			}
			if(inputEmail.text == inputArray["e-mail "].emptyInput || inputSubject.text == inputArray["subject "].wrongCase)
			{
				inputEmail.text = inputArray["e-mail "].wrongCase;
			}
			if(inputSubject.text == inputArray["subject "].emptyInput || inputSubject.text == inputArray["subject "].wrongCase)
			{
				inputSubject.text = inputArray["subject "].wrongCase;
			}
			if(inputMessage.text == inputArray["message "].emptyInput || inputSubject.text == inputArray["subject "].wrongCase)
			{
				inputMessage.text = inputArray["message "].wrongCase;
			}else{
				inputArray["name "].contentText = inputName.text;
				inputArray["e-mail "].contentText = inputEmail.text;
				inputArray["subject "].contentText = inputSubject.text;
				inputArray["message "].contentText = inputMessage.text;
				
				inputName.text = "";
				inputEmail.text = "";
				inputSubject.text = "";
				inputMessage.text = "";
				
				
				variables = new URLVariables();
				variables.name 	= inputArray["name "].contentText;
				variables.mail 	= inputArray["e-mail "].contentText;
				variables.subject = inputArray["subject "].contentText;
				variables.message= inputArray["message "].contentText;
				
				var urlReq:URLRequest = new URLRequest("php/sendmail.php");
				urlReq.data = variables;
				urlReq.method = URLRequestMethod.POST;
				
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
				urlLoader.addEventListener(Event.COMPLETE, onUrlLoadCompleteHandler, false, 0, false);
				urlLoader.load(urlReq);
			}
		}
		
		private function onUrlLoadCompleteHandler(event:Event):void
		{
			var mail_status:String=new URLVariables(event.target.data).success;
			if(mail_status=="yes")
			{
				trace("mail successfully sent");
			}else{
				
			}
		}
	}
}
