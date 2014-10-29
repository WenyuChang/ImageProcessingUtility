package Util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;
	
	public class ImageAlgorithm
	{
		public static var k:uint;
		public function ImageAlgorithm()
		{
			
		}
		
		public static function grayScale(source:BitmapData, illValue:Number):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width, source.height);
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					var gray:uint = (source.getPixel(i,j))>>16;
					var tmpGray:Number = gray;
					tmpGray+=illValue;
					if(tmpGray>255)
					{
						tmpGray=255;
					}
					if(tmpGray<0)
					{
						tmpGray=0;
					}
					gray = tmpGray;
					if(gray>=0 && gray<256)
						data.setPixel(i,j,(gray<<16)|(gray<<8)|gray);
				}
			}
			
			return data;
		}
		
		public static function getHisData(source:BitmapData):ArrayCollection
		{
			var histogramArray:ArrayCollection = new ArrayCollection();
			for(var j=0;j<256;j++)
			{
				var item:Object = new Object();
				item.colorCount = 0;
				histogramArray.addItem(item);
			}
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					var gray:uint = (source.getPixel(i,j))>>16;
					if(gray>=0 && gray<256)
						histogramArray.getItemAt(gray).colorCount++;
				}
			}
			return histogramArray;
		}
		
		public static function thresholdSegmentation(source : BitmapData, e:Number) : BitmapData
		{
			var zMax:uint = 0;
			var zMin:uint = uint.MAX_VALUE;
			var zAvgSum:uint = 0;
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					var gray:uint = (source.getPixel(i,j))>>16;
					zAvgSum += gray;
					if(zMax<gray)
						zMax = gray;
					if(zMin>gray)
						zMin = gray;
				}
			}
			zAvgSum = zAvgSum / (source.width*source.height)
			var t0:uint = 0;
			var t1:uint = (zMax+zMin)/2;
			//var t1:uint = zAvgSum;
			while(Math.abs(t0-t1)>e)
			{
				var count0:int = 0;
				var count1:int = 0;
				var sum0:uint = 0;
				var sum1:uint = 0;
				t0 = t1;
				for(var i:int=0;i<source.width;i++)
				{
					for(var j:int=0;j<source.height;j++)
					{
						var gray:uint = (source.getPixel(i,j))>>16;
						if(gray<t0)
						{
							sum0+=gray;
							count0++;
						}
						else
						{
							sum1+=gray;
							count1++;
						}
					}
				}
				t1 = (sum0/count0 + sum1/count1)/2;
			}
			
			k = t1;
			return binarization(source);
		}
		
		public static function binarization(source : BitmapData) : BitmapData
	   	{
	   		var data:BitmapData = new BitmapData(source.width, source.height);
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					var gray:uint = (source.getPixel(i,j))>>16;
					trace(gray);
					
					gray = gray > k ? 255 : 0;
					data.setPixel(i,j,(gray<<16)|(gray<<8)|gray);
				}
			}
			return data;
	   	}
	   	
	   	public static function histogram(source : BitmapData) : BitmapData
		{
			var count = new Array(256);
			var acum = new Array(256);
			var new_color = new Array(256);
		
			for (var m : uint = 0; m < count.length; m++)
			{
				count[m] = 0;
				acum[m] = 0;
				new_color[m] = 0;
			}
		
			var data:BitmapData = new BitmapData(source.width,source.height);
		
    		for(var i:Number=0;i<source.width;i++)
     		{
	    		for(var j:Number=0;j<source.height;j++)
	         	{
	         		var gray:uint = source.getPixel(i,j) >> 16;
      			
         			for(var k:uint = 0;k<256;k++)
         			{
	         			if(gray == k)
	         			{
		                	count[k]++;
		                	acum[k]++;
	           			}
	          		}
	         	}
	     	}
    		for(i=1;i<256;i++)
	    	{
	        	acum[i] += acum[i-1];
	     	}
     	
	    	for(i=1;i<256;i++)
		 	{
	       		j = acum[i] * 256 / (source.width*source.height);
	        	if(j>255)
				{
					j=255;
				}
	            new_color[i] = Math.round(j);
			}
		
	     	for(i=0;i<source.width;i++)
	     	{
	    		for(j=0;j<source.height;j++)
	         	{
	         		gray = source.getPixel(i,j) >> 16;
		    		data.setPixel(i,j,(new_color[gray]<<16)|(new_color[gray]<<8)|new_color[gray]);
	         	}
		    }
			return data;
		}
		
		public static function median(source:BitmapData):BitmapData
		{
			var operator = new Array(9);
			for (var m:int=0;m<operator.length;m++)
			{
				operator[m] = 0;
			}
			var data:BitmapData = new BitmapData(source.width,source.height);
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if(i==0	|| j==0 || i==source.width-1 || j==source.height-1)
				    {
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						// 1 2 3
						// 4 i 6
						// 7 8 9
						operator[0]=source.getPixel(i-1,j-1);
					  	operator[1]=source.getPixel(i,j-1)
					  	operator[2]=source.getPixel(i+1,j-1);
					  	operator[3]=source.getPixel(i-1,j);
					  	operator[4]=source.getPixel(i,j);
					  	operator[5]=source.getPixel(i+1,j);
					 	operator[6]=source.getPixel(i-1,j+1);
					 	operator[7]=source.getPixel(i,j+1);
					  	operator[8]=source.getPixel(i+1,j+1);

						for(m=0;m<9;m++)
						{
					    	for(var n:int=0;n<9;n++)
						 	{
							 	if(operator[n]>operator[n+1])
							 	{
									var t:int = operator[n];
									operator[n] = operator[n+1];
									operator[n+1] = t;
							 	}
						 	}
						}
						data.setPixel(i,j,operator[4]);
				 	}
				}
			}
			return data;
		}
		
		public static function mean(source:BitmapData):BitmapData
		{
			var operator = new Array(9);
			
			for (var m:int=0;m<operator.length;m++)
			{
				operator[m] = 0;
			}
			var data:BitmapData = new BitmapData(source.width,source.height);
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if(i==0	|| j==0 || i==source.width-1 || j==source.height-1)
					{
						data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						// 1 2 3
						// 4 i 6
						// 7 8 9
						var tmp:uint = 0;
						tmp += source.getPixel(i-1,j-1) >> 16;
						tmp += source.getPixel(i,j-1) >> 16;
						tmp += source.getPixel(i+1,j-1) >> 16;
						tmp += source.getPixel(i-1,j) >> 16;
						tmp += source.getPixel(i,j) >> 16;
						tmp += source.getPixel(i+1,j) >> 16;
						tmp += source.getPixel(i-1,j+1) >> 16;
						tmp += source.getPixel(i,j+1) >> 16;
						tmp += source.getPixel(i+1,j+1) >> 16;
						tmp = tmp/9;
						data.setPixel(i,j,(tmp<<16)|(tmp<<8)|tmp);
					}
				}
			}
			return data;
		}
		
		public static function otsu(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width, source.height);
			var thresholdValue:int = 1;
			var his:ArrayCollection = getHisData(source);
			var n:int = 0;
			var n1:int = 0;
			var n2:int = 0;
			var sum:Number = 0;
			var csum:Number = 0;
			var fMax:Number = 0;
			var m1:Number = 0;
			var m2:Number = 0;
			var sb:Number = 0;
			
			for(var i:int=0;i<256;i++)
			{
				sum += i*his.getItemAt(i).colorCount;
				n += his.getItemAt(i).colorCount;
			}
			
			fMax = -1.0;
			n1 = 0;
			
			for(i=0;i<256;i++)
			{
				n1 += his.getItemAt(i).colorCount;
				n2 = n-n1;
				csum += i*his.getItemAt(i).colorCount;
				m1 = csum/n1;
				m2 = (sum-csum)/n2;
				
				sb = n1*n2*(m1-m2)*(m1-m2);
				if(sb>fMax)
				{
					fMax = sb;
					thresholdValue = i;
				}
			}
			k = thresholdValue;
			return binarization(source);
		}
		
		public static function roberts(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<1 || j==source.width-1) && (i<1 || i==source.height-1))
					{
						data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs((source.getPixel(i,j)>>16)-(source.getPixel(i+1,j+1)>>16)) + Math.abs((source.getPixel(i+1,j)>>16)-(source.getPixel(i,j+1)>>16));
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			
			return data;
		}
		
		public static function prewitt(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<1 || j==source.width-1) && (i<1 || i==source.height-1))
					{
						data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( ((source.getPixel(i-1,j+1)>>16)+(source.getPixel(i,j+1)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+(source.getPixel(i,j-1)>>16)+(source.getPixel(i+1,j-1)>>16)) )
							+ Math.abs( ((source.getPixel(i+1,j-1)>>16)+(source.getPixel(i+1,j)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+(source.getPixel(i-1,j)>>16)+(source.getPixel(i-1,j+1)>>16)) );
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			
			return data;
		}
		
		public static function sobel(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<2 || j==source.width-1 || j==source.width-2) && (i<2 || i==source.height-1 || i==source.height-2))
					{
						data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( ((source.getPixel(i+1,j-1)>>16)+2*(source.getPixel(i+1,j)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+2*(source.getPixel(i-1,j)>>16)+(source.getPixel(i-1,j+1)>>16)) )
							+ Math.abs( ((source.getPixel(i-1,j+1)>>16)+2*(source.getPixel(i,j+1)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+2*(source.getPixel(i,j-1)>>16)+(source.getPixel(i+1,j-1)>>16)) );
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			
			return data;
		}
		
		public static function laplace(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<2 || j>source.width-3) && (i<2 || i>source.height-3))
					{
						data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( 24*(source.getPixel(i,j)>>16)+8*( (source.getPixel(i,j-1)>>16)+(source.getPixel(i,j+1)>>16)+(source.getPixel(i-1,j)>>16)+(source.getPixel(i+1,j)>>16) )
							-4*( (source.getPixel(i-2,j-1)>>16)+(source.getPixel(i-2,j)>>16)+(source.getPixel(i-2,j+1)>>16)+(source.getPixel(i-1,j-2)>>16)+(source.getPixel(i-1,j+2)>>16)+(source.getPixel(i,j-2)>>16)
								+(source.getPixel(i,j+2)>>16)+(source.getPixel(i+1,j-2)>>16)+(source.getPixel(i+1,j+2)>>16)+(source.getPixel(i+2,j-1)>>16)+(source.getPixel(i+2,j)>>16)+(source.getPixel(i+2,j+1)>>16) )
							-2*( (source.getPixel(i-2,j-2)>>16)+(source.getPixel(i-2,j+2)>>16)+(source.getPixel(i+2,j-2)>>16)+(source.getPixel(i+2,j+2)>>16) )
						); 
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			
			return data;
		}
	}
}