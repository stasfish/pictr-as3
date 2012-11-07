﻿/* * This file is part of the ImageManager package. * * @author (c) Tim Shelburne <tim@dontlookstudios.com> * * For the full copyright and license information, please view the LICENSE * file that was distributed with this source code. */package dls.imagemanager.cache {		import dls.debugger.Debug;	import dls.imagemanager.IImage;	import dls.imagemanager.cache.IImageCache;
		/*	 * A class to contain loaded images	 */	public class ImageCache implements IImageCache {				/*=========================================================*		 * PROPERTIES		 *=========================================================*/				private var _debugOptions:Object = { "source":"Image Manager" };				private var _list:Vector.<IImage>;				/*=========================================================*		 * FUNCTIONS		 *=========================================================*/				public function add(image:IImage):void {			_list.push(image);						Debug.out(image.url + " added to the cache...", Debug.DETAILS, _debugOptions);		}				public function remove(image:IImage):void {			_list.splice(_list.indexOf(image), 1);						Debug.out(image.url + " removed from the cache...", Debug.DETAILS, _debugOptions);		}				public function find(url:String):IImage {			Debug.out("Searching for " + url + " in the cache...", Debug.DEBUG, _debugOptions);						for each (var image:IImage in _list) {				if (image.url == url) {					return image;				}			}						return null;		}	}	}