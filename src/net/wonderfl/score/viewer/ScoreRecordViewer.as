package net.wonderfl.score.viewer 
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import net.wonderfl.score.manager.*;
	
	/**
	 * The base class for score ranking view. If this
	 * is added to the stage, manager automatically
	 * fetches the score record from the API. If
	 * successful, the callback 'onComplete'
	 * is called to construct the ranking table view.
	 * 
	 * @author kobayashi-taro
	 * @see #onComplete()
	 */
	public class ScoreRecordViewer extends Sprite
	{
		/**
		 * The score API manager
		 * 
		 * @see net.wonderfl.score.manager.ScoreManager
		 */
		protected var _manager:ScoreManager;
		
		
		/**
		 * This value is used when getting records from the api.
		 * The max count of the score records.
		 * 
		 * @see #getScore()
		 */
		protected var _limit:int;
		
		/**
		 * This value is used when getting records from the api.
		 * If this flag is set true, the record is sorted by 
		 * descending order, otherwise, the record is sorted by ascending order.
		 * 
		 * @see #getScore()
		 */
		protected var _descend:Boolean;
		
		/**
		 * This property is used only when you are accessing the api outside from wonderfl.net
		 * 
		 * @see net.wonderfl.score.manager.ScoreManager
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 */
		protected var _app_id:String;
		
		/**
		 * This property is used only when you are accessing the api outside from wonderfl.net
		 * 
		 * @see net.wonderfl.score.manager.ScoreManager
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 */
		protected var _api_key:String;
		
		/**
		 * Constructor.
		 * 
		 * @param	$limit The max count of the score records.
		 * @param	$descend If this flag is set true, the record is sorted by 
		 * descending order, otherwise, the record is sorted by ascending order.
		 * @param	$app_id If you want to access the api outside from wonderfl.net, set this parameter.
		 * @param	$api_key If you want to access the api outside from wonderfl.net, set this parameter.
		 * 
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		public function ScoreRecordViewer($limit:int = 20, $descend:Boolean = true, $app_id:String = '', $api_key:String = '') 
		{
			_limit = $limit;
			_descend = $descend;
			_app_id = $app_id;
			_api_key = $api_key;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * The callback called when the instance of this class is added to the 
		 * display list. By default, score getting api is called at this time,
		 * but you can change this behavior by overriding this method.
		 * 
		 * @param	$event
		 */
		protected function init($event:Event):void 
		{
			_manager = new ScoreManager(this, _app_id, _api_key);
			_manager.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			_manager.addEventListener(IOErrorEvent.IO_ERROR, _onIOError, false, 0, true);
			_manager.addEventListener(ErrorEvent.ERROR, _onError, false, 0, true);
			
			getScore();
		}
		
		private function _onError($event:ErrorEvent):void 
		{
			onError($event.text);
		}
		
		/**
		 * This method is automatically called when this instance is added to the stage.
		 * You can change this behavior by overriding init method.
		 * 
		 * @param	$limit The max count to fetch data.
		 * @throws Error If this method is called before this instance is added to the stage.
		 * @see net.wonderfl.score.viewer.ScoreRecordViewer.init
		 */
		public function getScore():void {
			if (_manager) {
				_manager.getScore(_limit, _descend);
			} else {
				throw new Error('This method should be called after this instance is added to the stage.');
			}
		}
		
		private function _onIOError($event:IOErrorEvent):void 
		{
			onIOError();
		}
		
		private function _onComplete($event:Event):void 
		{
			onComplete(_manager.score);
		}
		
		/**
		 * Abstruct method called when getting score record is
		 * completed successfully
		 * 
		 * @param	$data The score record
		 */
		protected function onComplete($data:Array):void { }
		
		/**
		 * Abstruct method called when getting score record is
		 * failed
		 */
		protected function onIOError():void { }
		
		/**
		 * Abstruct method called when the response of the 
		 * api contains error messages.
		 * 
		 * @param	$errorMessage The error message returned from the api.
		 */
		protected function onError($errorMessage:String):void { }
		
	}

}