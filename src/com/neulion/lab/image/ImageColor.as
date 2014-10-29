package com.neulion.lab.image
{
	public class ImageColor
	{
		public var alpha : uint = 0xFF;
		public var red : uint = 0;
		public var green : uint = 0;
		public var blue : uint = 0;
		
		public function ImageColor(alpha : uint = 0xFF, red : uint = 0, grean : uint = 0, blue : uint = 0)
		{
			this.alpha = alpha;
			this.red = red;
			this.green = grean;
			this.blue = blue;
		}
		
		public function toString() : String
		{
			return "alpha : " + alpha + " red : " + red + " green : " + green + " blue : " + blue + ".";
		}

	}
}