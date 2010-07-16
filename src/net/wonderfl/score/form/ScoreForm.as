package net.wonderfl.score.form 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import flash.utils.describeType;
	import net.wonderfl.score.manager.*;
	
	/**
	 * Base class for score sending form. <br/>
	 * This class takes 4 arguments for the constructor.
	 * If you add an instance of this class to the stage,
	 * the default name is set to the text property of the 
	 * first argument $userNameField. The second argument
	 * $score is the score to record. <br/>
	 * The 3rd and 4th argument is needed only when you are accessing the api outside from wonderfl.net
	 * @author kobayashi-taro
	 * 
	 * @see net.wonderfl.score.manager.ScoreManager
	 * @see http://wonderfl.net/apis/methods#method_scorepost
	 */
	public class ScoreForm extends Sprite
	{
		private static const USER_NAME:String = 'viewer.displayName';
		
		/**
		 * The score api manager.
		 */
		protected var _manager:ScoreManager;
		
		/**
		 * The first argument of the constructor. The text property is set when the instance is added to stage.
		 */
		protected var _userNameField:*;
		
		/**
		 * The second argument of the constructor.
		 */
		protected var _score:int;
		
		/**
		 * This property is used only when you are accessing the api outside from wonderfl.net
		 * 
		 * @see net.wonderfl.score.manager.ScoreManager
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		protected var _app_id:String;
		
		/**
		 * This property is used only when you are accessing the api outside from wonderfl.net
		 * 
		 * @see net.wonderfl.score.manager.ScoreManager
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		protected var _api_key:String;
		
		/**
		 * @param	$userNameField An instance of a class that has read/write property named 'text' or
		 * 						   that is dynamic.
		 * @param	$score Score
		 * @param	$app_id If you want to access the api outside from wonderfl.net, set this parameter.
		 * @param	$api_key If you want to access the api outside from wonderfl.net, set this parameter.
		 * 
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		public function ScoreForm($userNameField:*, $score:int, $app_id:String = '', $api_key:String = '') 
		{
			if (!$userNameField) throw new Error('$userNameField should not be null');
			var type:XML = describeType($userNameField);
			if (!JSON.decode(type.@isDynamic) && type.accessor.(@name == 'text').@access != 'readwrite'
			&& type.variable.(@name == 'text').length() == 0)
				throw new Error(
					"$userNameField should be an instance of a class that has read/write property named 'text' or that is dynamic"
				);
				
			_userNameField = $userNameField;
			_score = $score;
			_app_id = $app_id;
			_api_key = $api_key;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			if (!_userNameField) throw new Error('$userNameField should not be null. ');
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var flashVars:Object = this.root.loaderInfo.parameters;
			_manager = new ScoreManager(this, _app_id, _api_key);
			_manager.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_manager.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
			_manager.addEventListener(ErrorEvent.ERROR, _onError, false, 0, true);
			
			if (!flashVars) return;
			var username:String = flashVars[USER_NAME];
			username ||= '';
			if (_userNameField) _userNameField.text = username;
		}
		
		private function _onError(e:ErrorEvent):void 
		{
			onError(e.text);
		}
		
		private function _onComplete(e:Event):void 
		{
			onComplete();
		}
		
		private function _onIOError(e:IOErrorEvent):void 
		{
			onIOError();
		}
		
		/**
		 * Abstract callback called when sending score is failed.
		 */
		protected function onIOError():void { }
		
		/**
		 * Abstract method called when sending score is completed
		 * successfully.
		 */
		protected function onComplete():void { }
		
		/**
		 * The name used for the record is the text property of _userNameField.
		 * The score used for the recored is the _score property.
		 * 
		 * @see net.wonderfl.score.form.ScoreForm._score
		 * @see net.wonderfl.score.form.ScoreForm._userNameField
		 */
		protected function sendScore():void {
			_manager.sendScore(_userNameField.text, _score);
		}
		
		/**
		 * Abstruct method called when the response of the api contains error messages.
		 * 
		 * @param	$errorMessage The error message returned from the api.
		 */
		protected function onError($errorMessage:String):void {	}
		
		/**
		 * the score
		 */
		public function get score():int { return _score; }
		
		/**
		 * the score
		 */
		public function set score(value:int):void 
		{
			_score = value;
		}
	}

}