package net.wonderfl.score.basic 
{
	import com.bit101.components.Component;
	import com.bit101.components.Style;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * Implementation of this class consist almost entirely of com.bit101.components.InputText.
	 * The difference is only background fills
	 * 
	 * @see http://code.google.com/p/minimalcomps/
	 */
	public class UserNameField extends Component
	{
		private var _back:Sprite;
		private var _password:Boolean = false;
		private var _text:String = "";
		private var _tf:TextField;
		private var _drawBackground:Boolean = true;
		
		/**
		 * Constructor
		 * @param $parent The parent DisplayObjectContainer on which to add this InputText.
		 * @param $xpos The x position to place this component.
		 * @param $ypos The y position to place this component.
		 * @param $text The string containing the initial text of this component.
		 * @param $defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function UserNameField($parent:DisplayObjectContainer = null, $xpos:Number = 0, $ypos:Number =  0, $text:String = "", $defaultHandler:Function = null)
		{
			_text = $text;
			super($parent, $xpos, $ypos);
			if($defaultHandler != null)
			{
				addEventListener(Event.CHANGE, $defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(100, 16);
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.defaultTextFormat = new TextFormat("PF Ronda Seven", 8, Style.INPUT_TEXT);
			addChild(_tf);
			_tf.addEventListener(Event.CHANGE, onChange);
			
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_back.graphics.clear();
			
			if (_drawBackground) {
				_back.graphics.beginFill(Style.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
			}
			
			_tf.displayAsPassword = _password;
			
			_tf.text = _text;
			_tf.width = _width - 4;
			if(_tf.text == "")
			{
				_tf.text = "X";
				_tf.height = Math.min(_tf.textHeight + 4, _height);
				_tf.text = "";
			}
			else
			{
				_tf.height = Math.min(_tf.textHeight + 4, _height);
			}
			_tf.x = 2;
			_tf.y = Math.round(_height / 2 - _tf.height / 2);
		}
		
		
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text shown in this InputText.
		 */
		public function set text(t:String):void
		{
			_text = t;
			invalidate();
		}
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		/**
		 * Gets / sets the list of characters that are allowed in this TextInput.
		 */
		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}
		public function get restrict():String
		{
			return _tf.restrict;
		}
		
		/**
		 * Gets / sets the maximum number of characters that can be shown in this InputText.
		 */
		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}
		public function get maxChars():int
		{
			return _tf.maxChars;
		}
		
		/**
		 * Gets / sets whether or not this input text will show up as password (asterisks).
		 */
		public function set password(b:Boolean):void
		{
			_password = b;
			invalidate();
		}
		public function get password():Boolean
		{
			return _password;
		}
		
		/**
		 * Gets / sets whether or not draw the background.
		 */
		public function set drawBackground(value:Boolean):void 
		{
			var b:Boolean = _drawBackground;
			
			_drawBackground = value;
			
			if (b != _drawBackground) {
				draw();
			}
		}
		public function get drawBackground():Boolean
		{
			return _drawBackground;
		}
	}
}