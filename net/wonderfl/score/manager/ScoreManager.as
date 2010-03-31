package net.wonderfl.score.manager 
{
	import com.adobe.serialization.json.JSON;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	/**
	 * Dispatched when sending/fetching score record is completed successfully.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = 'complete', type = 'flash.events.Event')]
	
	/**
	 * Dispathced when io error occurred while sending/fetching score.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name = 'ioError', type = 'flash.events.IOErrorEvent')]
	
	/**
	 * Dispatched when the api response contains an error message.
	 * 
	 * @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name = 'error', type = 'flash.events.ErrorEvent')]

	/**
	 * The score API for wonderfl
	 * 
	 * @author kobayashi-taro
	 */
	public class ScoreManager extends EventDispatcher
	{
		private static const PATH:String = 'http://api.wonderfl.net/score';
		
		private var _score:Array = [];
		private var _appID:String;
		private var _api_key:String;
		
		/**
		 * The 2nd and 3rd argument is needed only when you are accessing the api outside from wonderfl.net
		 * 
		 * @param	$displayObject Any display object which is listed under
		 * display tree.
		 * @param	$app_id If you want to access the api outside from wonderfl.net, set this parameter.
		 * @param	$api_key If you want to access the api outside from wonderfl.net, set this parameter.
		 * 
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		public function ScoreManager($displayObject:DisplayObject, $app_id:String = '', $api_key:String = '') 
		{
			// set up variables by the flashvars
			var flashVars:Object = $displayObject.loaderInfo.parameters;
			if (flashVars) { // wonderfl
				_appID = $app_id || flashVars.appId;
				_api_key = $api_key || flashVars.open_api_key;
			} else { // external
				_appID = $app_id;
				_api_key = $api_key;
			}
		}
		
		/**
		 * Score sending API
		 * 
		 * @param	$userName Name for the record.
		 * @param	$score    Score for the record.
		 */
		public function sendScore($userName:String, $score:int):void {
			loadAPI(
				PATH + '/' + _appID,
				{
					api_key : _api_key,
					name : $userName.slice(0, 255),
					score : $score
				},
				URLRequestMethod.POST,
				_onSendComplete
			);
		}
		
		/**
		 * The score getting api.
		 * 
		 * @param	$limit The max count of the score records.
		 * @param	$descend If this flag is set true, the record is sorted by 
		 * descending order, otherwise, the record is sorted by ascending order.
		 */
		public function getScore($limit:int = 20, $descend:Boolean = true):void {
			loadAPI(
				PATH + '/' + _appID,
				{
					api_key : _api_key,
					limit : $limit,
					descend : $descend ? 1 : 0
				},
				URLRequestMethod.GET,
				_onGetComplete
			);
		}
		
		private function loadAPI($url:String, $variables:Object, $method:String, $completeHandler:Function):void {
			var data:URLVariables = new URLVariables;
			for (var propName:String in $variables) data[propName] = $variables[propName];
			
			var req:URLRequest = new URLRequest;
			req.method = $method;
			req.data = data;
			req.url = $url;
			
			var ldr:URLLoader = new URLLoader;
			ldr.addEventListener(Event.COMPLETE, $completeHandler, false, 0, true);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent, false, 0, true);
			ldr.load(req);
		}
		
		/**
		 * The callback for sending score api response
		 * 
		 * @param	$event
		 * @see http://wonderfl.net/apis/methods#method_scorepost
		 */
		protected function _onSendComplete($event:Event):void 
		{
			var result:*;
			
			try {
				result = JSON.decode($event.target.data);
			} catch (e:Error) {
				result = { };
			} finally {
				if (result.stat == 'ok') {
					dispatchEvent($event);
				} else {
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, result.message));
				}
			}
		}
		
		/**
		 * The callback for getting score api response.
		 * 
		 * @param	$event
		 * @see http://wonderfl.net/apis/methods#method_scoreget
		 */
		protected function _onGetComplete($event:Event):void 
		{
			var result:*;
			
			try {
				result = JSON.decode($event.target.data);
			} catch (e:Error) {
				result = { };
			} finally {
				if (result.stat == 'ok') {
					setScore(result.scores);
					dispatchEvent($event);
				} else {
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, result.message));
				}
			}
		}
		
		private function setScore($value:Array):void {
			if ($value == null) {
				_score = [];
				return;
			}
			
			var len:int = $value.length;
			var s:Object;
			var rank:int = 1;
			var score:int;
			for (var i:int = 0; i < len; ++i) 
			{
				s = $value[i];
				if (i > 0 && score != s.score)
					++rank;
				s.rank = rank;
				score = s.score;
			}
			_score = $value;
		}
		
		/**
		 * The score record fetched by the API. You can access this value after
		 * <code>Event.COMPLETE</code> is dispatched.
		 */
		public function get score():Array { return _score; }
	}
}
