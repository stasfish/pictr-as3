﻿/* * This file is part of the ImageManager package. * * @author (c) Tim Shelburne <tim@dontlookstudios.com> * * For the full copyright and license information, please view the LICENSE * file that was distributed with this source code. */package dls.imagemanager {		import dls.debugger.Debug;	import dls.imagemanager.IImage;	import dls.imagemanager.IImageManager;	import dls.imagemanager.Image;	import dls.imagemanager.cache.IImageCache;	import dls.imagemanager.loaders.IImageLoader;		import flash.display.Bitmap;	import flash.display.Sprite;	import flash.utils.Dictionary;		import org.osflash.signals.events.GenericEvent;
		/*	 * A class to manage loading images to a specific destination.	 */	public class ImageManager implements IImageManager {				/*=========================================================*		 * PROPERTIES		 *=========================================================*/				private var _debugOptions:Object = { "source":"Image Manager" };		 		private var _pendingImages:Dictionary = new Dictionary(); // each key is an IImage, and value is a Vector.<Sprite> of destinations		private var _cache:IImageCache;		private var _loaders:Vector.<IImageLoader>;				/*=========================================================*		 * FUNCTIONS		 *=========================================================*/		public function ImageManager(loaders:Vector.<IImageLoader>, cache:IImageCache) {			_loaders = loaders;			_cache = cache;		}				/**		 * load the requested url into the given destination Sprite		 *		 * @param - the destination sprite of the image		 * @param - the remote url of the image		 * @param - a list of options to determine which loader can handle the load		 */		public function load(destination:Sprite, url:String, options:Object = null):void {			Debug.out("Loading " + url + " into " + destination.name + "...", Debug.ACTIONS, _debugOptions);						var cachedImage:IImage = _cache.find(url);			var pendingImage:IImage = pendingImage(url);						// check for the image in the cache, and if so, add the bitmap to the destination			if (cachedImage != null) {				addBitmap(destination, cachedImage.bitmap);			}			// check if the url is pending, and if so, add the destination to the pending dictionary			else if (pendingImage != null){				_pendingImages[pendingImage].push(destination);			}			// load the image from the web			else {				var image:Image = new Image(url);				image.bitmapSet.addOnce(imageLoaded);				_pendingImages[image] = new <Sprite>[ destination ];								options = options == null ? {} : options;				for each (var loader:IImageLoader in _loaders) {					if (loader.canHandle(options)) {						loader.load(image, options);					}				}			}		}				/**		 * react to the image being loaded		 */		private function imageLoaded(e:GenericEvent):void {			var image:IImage = e.target as IImage;			for each (var destination:Sprite in _pendingImages[image]) {				addBitmap(destination, image.bitmap);			}						delete _pendingImages[image];		}				/**		 * check whether an image is pending, and if so return the image		 */		private function pendingImage(url:String):IImage {			for (var image:Object in _pendingImages) {				if (image.url == url) {					return image as IImage;				}			}						return null;		}				/**		 * add the loaded bitmap to the given destination		 */		private function addBitmap(destination:Sprite, bitmap:Bitmap):void {			var tempBitmap:Bitmap = new Bitmap();			tempBitmap.bitmapData = bitmap.bitmapData;						destination.addChild(tempBitmap);						Debug.out("Image added to " + destination.name, Debug.ACTIONS, _debugOptions);		}	}}