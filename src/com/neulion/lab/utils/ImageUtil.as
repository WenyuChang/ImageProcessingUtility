package com.neulion.lab.utils
{
	import com.neulion.lab.image.ImageColor;
	
	public class ImageUtil
	{
		public function ImageUtil()
		{
		}
		
		public static function getImageColor(colorValue : uint) : ImageColor
		{
			var alpha:uint = (colorValue >> 24) & 0xFF; // Isolate the Alpha channel
			var red:uint = (colorValue >> 16) & 0xFF; // Isolate the Red channel
			var green:uint = (colorValue >> 8) & 0xFF; // Isolate the Green channel
			var blue:uint = colorValue & 0xFF; // Isolate the Blue channel
			
			return new ImageColor(alpha, red, green, blue);
		}

	}
}