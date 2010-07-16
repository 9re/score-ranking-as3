package net.wonderfl.score.basic 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import net.wonderfl.score.basic.Window;
	import net.wonderfl.score.form.ScoreForm;
	
	/**
	 * Simple implementation of ScoreForm<br/>
	 * The ui of this BasicScoreForm consists chiefly of MinimalComps v.0.9.2
	 * 
	 * @author kobayashi-taro
	 * @see http://code.google.com/p/minimalcomps/
	 */
	public class BasicScoreForm extends ScoreForm
	{
		/**
		 * The default width of this component
		 */
		public static const WIDTH:int = 280;
		/**
		 * The default height of this component
		 */
		public static const HEIGHT:int = 160;
		/**
		 * Reference to the window UI.
		 */
		protected var _window:Window;
		
		/**
		 * Referenece to the label 'YOUR SCORE'
		 */
		protected var _lblYourScore:Label;
		
		/**
		 * Reference to the label 'YOUR NAME'
		 */
		protected var _lblYourName:Label;
		
		/**
		 * Reference to the label for displaying score
		 */
		protected var _lblScore:Label;
		
		/**
		 * Reference to the TextFiled for displaying error messages
		 */
		protected var _tfErrorMessage:TextField;
		
		/**
		 * Reference to the 'SAVE' button
		 */
		protected var _btnSend:PushButton;
		
		/**
		 * The callback called when the user closes the window.
		 * 
		 * @default _onCloseClick
		 * @see #_onCloseClick
		 */
		protected var _m_onCloseClick:Function;
		
		private var _saveComplete:Boolean = false;
		
		/**
		 * Constructor
		 * 
		 * @param $parent The parent DisplayObjectContainer on which to add this BasicScoreForm.
		 * @param $xpos The x position to place this component.
		 * @param $ypos The y position to place this component.
		 * @param $score The game score
		 * @param $title The title of the window
		 * @param $onCloseClick The callback called when the user closes the window. This value is set to _m_onCloseClick.
		 * @param	$app_id If you want to access the api outside from wonderfl.net, set this parameter.
		 * @param	$api_key If you want to access the api outside from wonderfl.net, set this parameter.
		 * 
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		public function BasicScoreForm($parent:DisplayObjectContainer = null, $xpos:Number = 0, $ypos:Number = 0, $score:int = 0, $title:String = 'SAVE SCORE', $onCloseClick:Function = null, $app_id:String = '', $api_key:String = '') 
		{
			move($xpos, $ypos);
			
			_window = new Window(this, 0, 0, $title, __onCloseClick);
			_lblYourScore = new Label(_window, 50, 50, 'YOUR SCORE');
			_lblScore = new Label(_window, 132, 50, $score.toString());
			_lblYourName = new Label(_window, 50, 70, 'YOUR NAME');
			
			_m_onCloseClick = $onCloseClick || _onCloseClick;
			
			_tfErrorMessage = new TextField;
			_tfErrorMessage.height = 18;
			_tfErrorMessage.embedFonts = true;
			_tfErrorMessage.selectable = false;
			_tfErrorMessage.mouseEnabled = false;
			_tfErrorMessage.y = 130;
			_tfErrorMessage.defaultTextFormat = new TextFormat("PF Ronda Seven", 8, 0xff0000);
			
			var userNameField:UserNameField = new UserNameField(_window, 130, 70);
			_btnSend = new PushButton(_window, 90, 110, 'SAVE', onSendClick);
			_btnSend.toggle = true;
			
			_window.setSize(WIDTH, HEIGHT);
			
			// Calls constructor of the supper class at first
			// then adds this to parent display object
			super(userNameField, $score, $app_id, $api_key);
			
			if($parent != null)
			{
				$parent.addChild(this);
			}
		}
		
		private function __onCloseClick():void
		{
			if (_m_onCloseClick != null)
				_m_onCloseClick(_saveComplete);
		}
		
		
		/**
		 * This method is called when the user closes the window. The default behavior
		 * is as follows. You can change this by overriding this method directly
		 * or setting onCloseClick property.
		 * 
		 * @example
<listing version="3.0">
if (stage) parent.removeChild(this);
</listing>
		* @param	$didSendComplete The flag to know whether user has save the score. If the user
		 * has saved score and closed the window, true is passed to this method. Otherwise - if the user
		 * cancels or simply closed the window before saving the score -, false is passed to this method.
		 * @see #onCloseClick
		 * @see #_m_onCloseClick
		 */
		protected function _onCloseClick($didSendComplete:Boolean):void {
			if (stage) parent.removeChild(this);
		}
		
		/**
		 * Moves the component to the specified position.
		 * 
		 * @param $xpos the x position to move the component
		 * @param $ypos the y position to move the component
		 */
		public function move($xpos:Number, $ypos:Number):void
		{
			x = Math.round($xpos);
			y = Math.round($ypos);
		}
		
		/**
		 * The callback called when the user clicks the save button.
		 * 
		 * @param	$event
		 */
		protected function onSendClick($event:MouseEvent):void
		{
			_btnSend.label = 'SAVING...';
			_btnSend.mouseEnabled = false;
			UserNameField(_userNameField).drawBackground = false;
			var textField:TextField = UserNameField(_userNameField).textField;
			textField.type = TextFieldType.DYNAMIC;
			textField.selectable = false;
			var tfm:TextFormat = textField.getTextFormat();
			tfm.color = Style.LABEL_TEXT;
			textField.setTextFormat(tfm);
			sendScore();
		}
		
		/**
		 * Method called when sending score is completed successfully.
		 * You can change the default behavior by overriding this method.
		　*/
		override protected function onComplete():void 
		{
			_window.removeChild(_btnSend);
			_saveComplete = true;
			new PushButton(_window, 90, 110, 'COMPLETE', function():void {
				__onCloseClick();
			});
			
			_tfErrorMessage.text = '';
		}
		
		/**
		 * Method called when the response of the api contains error messages.
		 * 
		 * @param	$errorMessage The error message returned from the api.
		 */
		override protected function onError($errorMessage:String):void 
		{
			_tfErrorMessage.text = $errorMessage;
			_tfErrorMessage.width = _tfErrorMessage.textWidth + 4;
			_tfErrorMessage.height = _tfErrorMessage.textHeight + 4;
			_tfErrorMessage.x = (280 - _tfErrorMessage.width) >> 1;
			_window.addChild(_tfErrorMessage);
			
			UserNameField(_userNameField).drawBackground = true;
			var textField:TextField = UserNameField(_userNameField).textField;
			textField.type = TextFieldType.INPUT;
			textField.selectable = true;
			
			_btnSend.mouseEnabled = true;
			_btnSend.selected = false;
			_btnSend.label = 'SAVE';
		}
		
		/**
		 * The callback called when the user closes the window.
		 */
		public function get onCloseClick():Function { return _m_onCloseClick; }
		
		/**
		 * The callback called when the user closes the window.
		 */
		public function set onCloseClick($value:Function):void 
		{
			_m_onCloseClick = $value;
		}
		
		/**
		 * The flag that indicates saving score has completed successfully.
		 * This is set false, if the user cancels to save the score or something
		 * wrong happens while saving the score.
		 */
		public function get saveComplete():Boolean { return _saveComplete; }
	}
}